# rust template

[![check](https://trev.zip/template/rust/actions/workflows/check.yaml/badge.svg?branch=main&logo=forgejo&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://trev.zip/template/rust/actions?workflow=check.yaml)
[![vulnerable](https://trev.zip/template/rust/actions/workflows/vulnerable.yaml/badge.svg?branch=main&logo=forgejo&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://trev.zip/template/rust/actions?workflow=vulnerable.yaml)
[![nixpkgs](https://img.shields.io/endpoint?url=https%3A%2F%2Fnix-shield.trev.zip%2Fbadge%3Furl%3Dhttps%253A%252F%252Ftrev.zip%252Ftemplate%252Frust%252Fraw%252Fbranch%252Fmain%252Fflake.lock%26input%3Dnixpkgs&logoColor=%23bac2de&labelColor=%23313244&color=%235277C3)](https://nixos.org/)
[![rust](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Ftrev.zip%2Ftemplate%2Frust%2Fraw%2Fbranch%2Fmain%2FCargo.toml&query=%24.package.rust-version&logo=rust&logoColor=%23bac2de&label=version&labelColor=%23313244&color=%23D34516)](https://releases.rs/)

template for starting [rust](https://rust-lang.org/) projects

to initialize a new project, run:

```sh
./init.sh "Title" "Description"
```

part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## using

### cargo

```sh
cargo install rust-template \
  --index sparse+https://trev.zip/api/packages/template/cargo/
```

### docker

```sh
docker run trev.zip/template/rust:latest
```

### nix

```sh
nix run git+https://trev.zip/template/rust.git
```

### download

https://trev.zip/template/rust/releases

## contributing

see [CONTRIBUTING.md](CONTRIBUTING.md) for requirements and getting started
