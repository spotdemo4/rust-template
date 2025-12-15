{
  description = "rust template";

  nixConfig = {
    extra-substituters = [
      "https://cache.trev.zip/nur"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nur:70xGHUW1+1b8FqBchldaunN//pZNVo6FKuPL4U/n844="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trev = {
      url = "github:spotdemo4/nur";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    semgrep-rules = {
      url = "github:semgrep/semgrep-rules";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      fenix,
      trev,
      semgrep-rules,
      ...
    }:
    trev.libs.mkFlake (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            fenix.overlays.default
            trev.overlays.packages
            trev.overlays.libs
          ];
        };

        rustToolchain = pkgs.fenix.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-sqSWJDUxc+zaz1nBWMAJKTAGBuGWP25GCftIOlCEAtA=";
        };
      in
      rec {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # rust
              rustToolchain
              cargo-zigbuild

              # util
              bumper

              # nix
              nixfmt

              # actions
              prettier
            ];
            shellHook = pkgs.shellhook.ref;
          };

          update = pkgs.mkShell {
            packages = with pkgs; [
              renovate

              # rust
              cargo
            ];
          };

          vulnerable = pkgs.mkShell {
            packages = with pkgs; [
              # rust
              cargo-audit

              # nix
              flake-checker

              # actions
              octoscan
            ];
          };
        };

        checks = pkgs.lib.mkChecks {
          rust = {
            src = packages.default;
            deps = with pkgs; [
              rustfmt
              clippy
              opengrep
            ];
            script = ''
              cargo fmt --check
              cargo test --offline
              cargo clippy --offline -- -D warnings
              opengrep scan \
                --quiet \
                --error \
                --use-git-ignore \
                --config="${semgrep-rules}/rust"
            '';
          };

          nix = {
            src = ./.;
            deps = with pkgs; [
              nixfmt-tree
            ];
            script = ''
              treefmt --ci
            '';
          };

          actions = {
            src = ./.;
            deps = with pkgs; [
              prettier
              action-validator
              octoscan
              renovate
            ];
            script = ''
              prettier --check "**/*.json" "**/*.yaml"
              action-validator .github/**/*.yaml
              octoscan scan .github
              renovate-config-validator .github/renovate.json
            '';
          };
        };

        apps = pkgs.lib.mkApps {
          dev.script = "cargo run";
        };

        packages =
          let
            # Parse the rust target into a platform
            rustTargetToPlatform =
              rustTarget:
              pkgs.lib.systems.elaborate {
                config = rustTarget;
              };

            # Get all platforms from rust-toolchain.toml
            platforms =
              builtins.map (target: rustTargetToPlatform target)
                (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml)).toolchain.targets;

            rustPlatform = pkgs.makeRustPlatform {
              cargo = rustToolchain;
              rustc = rustToolchain;
            };

            # supported targets https://doc.rust-lang.org/nightly/rustc/platform-support.html
            mkRustPackage =
              targetPlatform:
              rustPlatform.buildRustPackage (finalAttrs: {
                pname = "rust-template";
                version = "0.2.1";

                src = builtins.path {
                  name = "root";
                  path = ./.;
                };

                cargoLock.lockFile = builtins.path {
                  name = "Cargo.lock";
                  path = ./Cargo.lock;
                };

                nativeBuildInputs = with pkgs; [
                  cargo-zigbuild
                  jq
                ];

                # fix for https://github.com/rust-cross/cargo-zigbuild/issues/162
                auditable = false;

                doCheck = false;

                buildPhase = ''
                  build_dir="''${TMPDIR:-/tmp}/rust"
                  mkdir -p $build_dir

                  export HOME=$(mktemp -d)
                ''
                + (
                  if targetPlatform.system == system then
                    "cargo build --release --target-dir $build_dir"
                  else
                    "cargo zigbuild --release --target-dir $build_dir --target ${targetPlatform.rust.rustcTarget}"
                );

                installPhase = ''
                  package_name=$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].name')
                  release=$(find $build_dir -type f -executable -name "''${package_name}*")
                  release_name=$(basename $release)

                  mkdir -p $out/bin
                  mv $release $out/bin/$release_name
                '';

                meta = {
                  description = "template for rust projects";
                  mainProgram = if targetPlatform.isWindows then "rust-template.exe" else "rust-template";
                  homepage = "https://github.com/spotdemo4/rust-template";
                  changelog = "https://github.com/spotdemo4/rust-template/releases/tag/v${finalAttrs.version}";
                  license = pkgs.lib.licenses.mit;
                  platforms = pkgs.lib.platforms.all;
                };
              });

            mkImage =
              targetPlatform: drv:
              pkgs.dockerTools.buildLayeredImage {
                name = drv.pname;
                tag = "${drv.version}-${targetPlatform.go.GOARCH}";

                contents = with pkgs; [
                  dockerTools.caCertificates
                  drv
                ];

                architecture = targetPlatform.go.GOARCH;
                created = "now";
                meta = drv.meta;

                config.Cmd = [
                  "${pkgs.lib.meta.getExe drv}"
                ];
              };

            binaries = pkgs.lib.genAttrs' platforms (
              platform: pkgs.lib.nameValuePair platform.system (mkRustPackage platform)
            );

            images = pkgs.lib.genAttrs' (builtins.filter (platform: platform.isLinux) platforms) (
              platform:
              pkgs.lib.nameValuePair (platform.system + "-docker") (
                mkImage platform packages."${platform.system}"
              )
            );
          in
          binaries
          // images
          // {
            default = packages."${system}";
          };

        formatter = pkgs.nixfmt-tree;
      }
    );
}
