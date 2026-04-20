# rust template

[![check](https://img.shields.io/github/actions/workflow/status/spotdemo4/rust-template/check.yaml?branch=main&logo=github&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://github.com/spotdemo4/rust-template/actions/workflows/check.yaml/)
[![vulnerable](https://img.shields.io/github/actions/workflow/status/spotdemo4/rust-template/vulnerable.yaml?branch=main&logo=github&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://github.com/spotdemo4/rust-template/actions/workflows/vulnerable.yaml)
[![nix](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Frust-template%2Frefs%2Fheads%2Fmain%2Fflake.lock&query=%24.nodes.nixpkgs.original.ref&logo=nixos&logoColor=%23bac2de&label=channel&labelColor=%23313244&color=%234d6fb7)](https://nixos.org/)
[![flakehub](https://img.shields.io/endpoint?url=https://flakehub.com/f/spotdemo4/rust-template/badge&labelColor=%23313244)](https://flakehub.com/flake/spotdemo4/rust-template)

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
nix run
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
bumper "action.yaml" ".github/README.md"
```

releases are created automatically for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes

## use

### download

| OS      | Architecture | Download                                                                                                                                           |
| ------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux   | amd64        | [rust-template_0.4.7_linux_amd64](https://github.com/spotdemo4/rust-template/releases/download/v0.4.7/rust-template_0.4.7_linux_amd64)             |
| Linux   | arm64        | [rust-template_0.4.7_linux_arm64](https://github.com/spotdemo4/rust-template/releases/download/v0.4.7/rust-template_0.4.7_linux_arm64)             |
| Linux   | arm          | [rust-template_0.4.7_linux_arm](https://github.com/spotdemo4/rust-template/releases/download/v0.4.7/rust-template_0.4.7_linux_arm)                 |
| MacOS   | arm64        | [rust-template_0.4.7_darwin_arm64](https://github.com/spotdemo4/rust-template/releases/download/v0.4.7/rust-template_0.4.7_darwin_arm64)           |
| Windows | amd64        | [rust-template_0.4.7_windows_amd64.exe](https://github.com/spotdemo4/rust-template/releases/download/v0.4.7/rust-template_0.4.7_windows_amd64.exe) |

### docker

```elm
docker run ghcr.io/spotdemo4/rust-template:0.4.7
```

### nix

```elm
nix run github:spotdemo4/rust-template
```

### action

```yaml
- uses: spotdemo4/rust-template@v0.4.7
```
