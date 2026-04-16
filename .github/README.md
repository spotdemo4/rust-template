# rust template

[![check](https://img.shields.io/github/actions/workflow/status/spotdemo4/rust-template/check.yaml?branch=main&logo=github&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://github.com/spotdemo4/rust-template/actions/workflows/check.yaml/)
[![vulnerable](https://img.shields.io/github/actions/workflow/status/spotdemo4/rust-template/vulnerable.yaml?branch=main&logo=github&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://github.com/spotdemo4/rust-template/actions/workflows/vulnerable.yaml)
[![nix](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Frust-template%2Frefs%2Fheads%2Fmain%2Fflake.lock&query=%24.nodes.nixpkgs.original.ref&logo=nixos&logoColor=%23bac2de&label=channel&labelColor=%23313244&color=%234d6fb7)](https://nixos.org/)

template for starting [rust](https://rust-lang.org/) projects

part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## requirements

- [nix](https://nixos.org/)
- [direnv](https://direnv.net/) (optional)

## getting started

initialize direnv:

```elm
ln -s .envrc.project .envrc &&
direnv allow
```

or manually enter the development environment:

```elm
nix develop
```

### run

```elm
nix run #dev
```

### build

```elm
nix build
```

### check

```elm
nix flake check
```

### release

releases are created automatically for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes

to manually create a version bump:

```elm
bumper action.yaml .github/README.md
```

## use

### download

| OS      | Architecture | Download                                                                                                                                           |
| ------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux   | amd64        | [rust-template_0.4.6_linux_amd64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.6/rust-template_0.4.6_linux_amd64.xz)       |
| Linux   | arm64        | [rust-template_0.4.6_linux_arm64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.6/rust-template_0.4.6_linux_arm64.xz)       |
| Linux   | arm          | [rust-template_0.4.6_linux_arm.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.6/rust-template_0.4.6_linux_arm.xz)           |
| MacOS   | arm64        | [rust-template_0.4.6_darwin_arm64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.6/rust-template_0.4.6_darwin_arm64.xz)     |
| Windows | amd64        | [rust-template_0.4.6_windows_amd64.zip](https://github.com/spotdemo4/rust-template/releases/download/v0.4.6/rust-template_0.4.6_windows_amd64.zip) |

### docker

```elm
docker run ghcr.io/spotdemo4/rust-template:0.4.6
```

### action

```yaml
- name: rust template
  uses: spotdemo4/rust-template@v0.4.6
```

### nix

```elm
nix run github:spotdemo4/rust-template
```
