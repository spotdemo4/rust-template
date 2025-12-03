# rust template

![check](https://github.com/spotdemo4/rust-template/actions/workflows/check.yaml/badge.svg?branch=main)
![vulnerable](https://github.com/spotdemo4/rust-template/actions/workflows/vulnerable.yaml/badge.svg?branch=main)

Template for starting [rust](https://rust-lang.org/) projects, part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## Requirements

- [nix](https://nixos.org/)
- (optional) [direnv](https://direnv.net/)

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

## Run

```elm
nix run #dev
```

## Build

```elm
nix build
```

## Check

```elm
nix flake check
```

## Release

Releases are automatically created for significant changes.

To manually create a new release:

```elm
bumper
```

## Use

### Binary

| OS    | Architecture | Download                                                                                                                                                   |
| ----- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux | amd64        | [rust-template-0.1.1-x86_64-linux.tar.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.1.1/rust-template-0.1.1-x86_64-linux.tar.xz)     |
| Linux | arm64        | [rust-template-0.1.1-aarch64-linux.tar.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.1.1/rust-template-0.1.1-aarch64-linux.tar.xz)   |
| MacOS | arm64        | [rust-template-0.1.1-aarch64-darwin.tar.xz](https://github.com/spotdemo4/rust-template/releases/download/v0.1.1/rust-template-0.1.1-aarch64-darwin.tar.xz) |

### Docker

```elm
docker run ghcr.io/spotdemo4/rust-template:0.1.1
```

### Action

```yaml
- name: rust template
  uses: docker://ghcr.io/spotdemo4/rust-template:0.1.1
```

### Nix

```elm
nix run github:spotdemo4/rust-template
```
