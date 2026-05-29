# rust template

[![check](https://trev.zip/llc/rust/actions/workflows/check.yaml/badge.svg?branch=main&logo=forgejo&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://trev.zip/trev/stack/actions?workflow=check.yaml)
[![vulnerable](https://trev.zip/llc/rust/actions/workflows/vulnerable.yaml/badge.svg?branch=main&logo=forgejo&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://trev.zip/trev/stack/actions?workflow=vulnerable.yaml)
[![rust](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Frust-template%2Frefs%2Fheads%2Fmain%2FCargo.toml&query=%24.package.rust-version&logo=rust&logoColor=%23bac2de&label=version&labelColor=%23313244&color=%23D34516)](https://releases.rs/)

template for starting [rust](https://rust-lang.org/) projects

part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## requirements

- [nix](https://nixos.org/)

## getting started

```elm
nix develop
```

### run

```elm
nix run #dev
```

### format

```elm
nix fmt
```

### check

```elm
nix flake check
```

### build

```elm
nix build
```

### release

```elm
bumper "README.md"
```

releases are created automatically for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes

## use

### download

| OS      | Architecture | Download                                                                                                                                           |
| ------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux   | amd64        | [rust-template_0.6.2_linux_amd64](https://github.com/spotdemo4/rust-template/releases/download/v0.6.2/rust-template_0.6.2_linux_amd64)             |
| Linux   | arm64        | [rust-template_0.6.2_linux_arm64](https://github.com/spotdemo4/rust-template/releases/download/v0.6.2/rust-template_0.6.2_linux_arm64)             |
| Linux   | arm          | [rust-template_0.6.2_linux_arm](https://github.com/spotdemo4/rust-template/releases/download/v0.6.2/rust-template_0.6.2_linux_arm)                 |
| MacOS   | amd64        | [rust-template_0.6.2_darwin_amd64](https://github.com/spotdemo4/rust-template/releases/download/v0.6.2/rust-template_0.6.2_darwin_amd64)           |
| MacOS   | arm64        | [rust-template_0.6.2_darwin_arm64](https://github.com/spotdemo4/rust-template/releases/download/v0.6.2/rust-template_0.6.2_darwin_arm64)           |
| Windows | amd64        | [rust-template_0.6.2_windows_amd64.exe](https://github.com/spotdemo4/rust-template/releases/download/v0.6.2/rust-template_0.6.2_windows_amd64.exe) |

### docker

```elm
docker run ghcr.io/spotdemo4/rust-template:0.6.2
```

### nix

```elm
nix run github:spotdemo4/rust-template
```
