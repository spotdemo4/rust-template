#!/usr/bin/env bash
set -e

detect_platform() {
    local filepath="$1"
    local file_output=$(file -b "$filepath")
    
    # detect os
    if [[ "$file_output" =~ "ELF" ]]; then
        os="linux"
    elif [[ "$file_output" =~ "Mach-O" ]]; then
        os="darwin"
    elif [[ "$file_output" =~ "PE32" ]] || [[ "$file_output" =~ "MS Windows" ]]; then
        os="windows"
    else
        os="unknown"
    fi
    
    # detect architecture
    if [[ "$file_output" =~ "x86-64" ]] || [[ "$file_output" =~ "x86_64" ]]; then
        arch="amd64"
    elif [[ "$file_output" =~ "Intel 80386" ]] || [[ "$file_output" =~ "i386" ]]; then
        arch="386"
    elif [[ "$file_output" =~ "ARM aarch64" ]] || [[ "$file_output" =~ "arm64" ]]; then
        arch="arm64"
    elif [[ "$file_output" =~ "ARM" ]]; then
        arch="arm"
    elif [[ "$file_output" =~ "MIPS" ]]; then
        arch="mips"
    else
        arch="unknown"
    fi
    
    echo "${os}-${arch}"
}

if [[ -n $GITHUB_TOKEN && -n $GITHUB_ACTOR ]]; then
    echo "logging into ghcr.io"
    echo "${GITHUB_TOKEN}" | docker login ghcr.io -u "$GITHUB_ACTOR" --password-stdin
fi

BUILD_DIR=$(mktemp -d)
NIX_SYSTEM=$(nix eval --impure --raw --expr "builtins.currentSystem")
readarray -t PACKAGES < <(nix flake show --json 2> /dev/null | jq -r --arg system "$NIX_SYSTEM" '.packages[$system] | keys[]')

STORE_PATHS=()
DOCKER_IMAGES=()
for PACKAGE in "${PACKAGES[@]}"; do
    echo
    echo "$PACKAGE: evaluating" 

    STORE_PATH=$(nix eval --raw ".#${PACKAGE}")
    if [[ ${STORE_PATHS[@]} =~ $STORE_PATH ]]; then
        echo "$PACKAGE: already built, skipping"
        continue
    else
        STORE_PATHS+=("$STORE_PATH")
    fi

    NAME=$(nix eval --raw ".#${PACKAGE}.name")

    echo "$PACKAGE: building '$NAME'"
    nix build ".#${PACKAGE}" --no-link --quiet

    echo "$PACKAGE: probing '$NAME'"
    IMAGE_NAME=$(nix eval --raw ".#${PACKAGE}.imageName" 2> /dev/null || echo "")
    IMAGE_TAG=$(nix eval --raw ".#${PACKAGE}.imageTag" 2> /dev/null || echo "")
    EXE=$(nix eval --raw --impure ".#${PACKAGE}" --apply "(import <nixpkgs> {}).lib.meta.getExe" 2> /dev/null || echo "")
    PLATFORM=$(detect_platform "$EXE" 2> /dev/null || echo "unknown-unknown")

    if [[ -f "$STORE_PATH" && -n $IMAGE_NAME && -n $IMAGE_TAG ]]; then
        echo "$PACKAGE: detected as docker image"

        echo "$PACKAGE: loading to '$IMAGE_NAME:$IMAGE_TAG'"
        docker load -i "$STORE_PATH" &> /dev/null

        if [[ -n $GITHUB_TOKEN && -n $GITHUB_ACTOR && -n $GITHUB_REPOSITORY ]]; then
            REGISTRY="ghcr.io/${GITHUB_REPOSITORY}:$IMAGE_TAG"
            echo "$PACKAGE: uploading to registry '${REGISTRY}'"

            docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REGISTRY" &> /dev/null
            docker push "$REGISTRY" &> /dev/null
            DOCKER_IMAGES+=("$REGISTRY")
        fi

    elif [[ -d "$STORE_PATH" && -f "$EXE" && "$PLATFORM" != "unknown-unknown" ]]; then
        echo "$PACKAGE: detected as executable '$(basename "$EXE")' for '$PLATFORM'"

        if [[ "$PLATFORM" == "windows"* ]]; then
            ARCHIVE="${BUILD_DIR}/${NAME}-${PLATFORM}.zip"
            echo "$PACKAGE: zipping to '$(basename "${ARCHIVE}")'"

            zip -qr "${ARCHIVE}" "${STORE_PATH}"
        else
            ARCHIVE="${BUILD_DIR}/${NAME}-${PLATFORM}.tar.xz"
            echo "$PACKAGE: tarring to '$(basename "${ARCHIVE}")'"

            tar -cJhf "${ARCHIVE}" "${STORE_PATH}" &> /dev/null
        fi

        if [[ -n $GITHUB_TOKEN && -n $GITHUB_REF_NAME && $GITHUB_REF_TYPE == "tag" ]]; then
            echo "$PACKAGE: uploading to GitHub release '${GITHUB_REF_NAME}'"

            gh release upload "$GITHUB_REF_NAME" "$ARCHIVE" --clobber &> /dev/null
        fi
    else
        echo "$PACKAGE: unknown package type"
    fi

    echo "$PACKAGE: done"
done

echo

if [[ ${#DOCKER_IMAGES[@]} -gt 0 && -n $GITHUB_TOKEN && -n $GITHUB_ACTOR && -n $GITHUB_REPOSITORY && -n $GITHUB_REF_NAME && $GITHUB_REF_TYPE == "tag" ]]; then
    echo "creating docker manifest for tag '${GITHUB_REF_NAME}'"

    NEXT="ghcr.io/${GITHUB_REPOSITORY}:${GITHUB_REF_NAME#v}"
    LATEST="ghcr.io/${GITHUB_REPOSITORY}:latest"

    for IMAGE in "${DOCKER_IMAGES[@]}"; do
        docker manifest create --amend "${NEXT}" "${IMAGE}" &> /dev/null
        docker manifest create --amend "${LATEST}" "${IMAGE}" &> /dev/null
    done

    echo "pushing docker manifests"
    docker manifest push "${NEXT}" &> /dev/null
    docker manifest push "${LATEST}" &> /dev/null
fi
