# rust template

[![check](https://img.shields.io/github/actions/workflow/status/spotdemo4/rust-template/check.yaml?branch=main&logo=github&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://github.com/spotdemo4/rust-template/actions/workflows/check.yaml/)
[![vulnerable](https://img.shields.io/github/actions/workflow/status/spotdemo4/rust-template/vulnerable.yaml?branch=main&logo=github&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://github.com/spotdemo4/rust-template/actions/workflows/vulnerable.yaml)
[![nix](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Frust-template%2Frefs%2Fheads%2Fmain%2Fflake.lock&query=%24.nodes.nixpkgs.original.ref&logo=nixos&logoColor=%23bac2de&label=channel&labelColor=%23313244&color=%234d6fb7)](https://nixos.org/)
[![channel](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Frust-template%2Frefs%2Fheads%2Fmain%2Frust-toolchain.toml&query=%24.toolchain.channel&logo=rust&logoColor=%23bac2de&label=channel&labelColor=%23313244&color=%23D34516)](https://releases.rs/)

Template for starting [rust](https://rust-lang.org/) projects, part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## Requirements

- [nix](https://nixos.org/)
- [direnv](https://direnv.net/) (optional)

## Getting started

Initialize direnv:

```elm
ln -s .envrc.project .envrc &&
direnv allow
```

or manually enter the development environment:

```elm
nix develop
```

### Run

```elm
nix run #dev
```

### Build

```elm
nix build
```

### Check

```elm
nix flake check
```

### Release

Releases are created automatically for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes.

To manually create a version bump:

```elm
bumper action.yaml .github/README.md
```

## Use

### Download

| OS      | Architecture | Download                                                                                                                                           |
| ------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux   | amd64        | [rust-template_0.4.2_linux_amd64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.2/rust-template_0.4.2_linux_amd64.xz)       |
| Linux   | arm64        | [rust-template_0.4.2_linux_arm64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.2/rust-template_0.4.2_linux_arm64.xz)       |
| Linux   | arm          | [rust-template_0.4.2_linux_arm.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.2/rust-template_0.4.2_linux_arm.xz)           |
| MacOS   | arm64        | [rust-template_0.4.2_darwin_arm64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.2/rust-template_0.4.2_darwin_arm64.xz)     |
| Windows | amd64        | [rust-template_0.4.2_windows_amd64.zip](https://github.com/spotdemo4/rust-template/releases/download/v0.4.2/rust-template_0.4.2_windows_amd64.zip) |

### Docker

```elm
docker run ghcr.io/spotdemo4/rust-template:0.4.2
```

### Action

```yaml
- name: rust template
  uses: spotdemo4/rust-template@v0.4.2
```

### Nix

```elm
nix run github:spotdemo4/rust-template
```
