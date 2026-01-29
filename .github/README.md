# rust template

[![check](https://github.com/spotdemo4/rust-template/actions/workflows/check.yaml/badge.svg?branch=main)](https://github.com/spotdemo4/rust-template/actions/workflows/check.yaml/)
[![vulnerable](https://github.com/spotdemo4/rust-template/actions/workflows/vulnerable.yaml/badge.svg?branch=main)](https://github.com/spotdemo4/rust-template/actions/workflows/vulnerable.yaml)

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
| Linux   | amd64        | [rust-template_0.4.0_linux_amd64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.0/rust-template_0.4.0_linux_amd64.xz)       |
| Linux   | arm64        | [rust-template_0.4.0_linux_arm64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.0/rust-template_0.4.0_linux_arm64.xz)       |
| Linux   | arm          | [rust-template_0.4.0_linux_arm.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.0/rust-template_0.4.0_linux_arm.xz)           |
| MacOS   | arm64        | [rust-template_0.4.0_darwin_arm64.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.4.0/rust-template_0.4.0_darwin_arm64.xz)     |
| Windows | amd64        | [rust-template_0.4.0_windows_amd64.zip](https://github.com/spotdemo4/rust-template/releases/download/v0.4.0/rust-template_0.4.0_windows_amd64.zip) |

### Docker

```elm
docker run ghcr.io/spotdemo4/rust-template:0.4.0
```

### Action

```yaml
- name: rust template
  uses: spotdemo4/rust-template@v0.4.0
```

### Nix

```elm
nix run github:spotdemo4/rust-template
```
