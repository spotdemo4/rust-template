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
  };

  outputs =
    {
      nixpkgs,
      fenix,
      trev,
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
        fs = pkgs.lib.fileset;
        rustToolchain = pkgs.fenix.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-vra6TkHITpwRyA5oBKAHSX0Mi6CBDNQD+ryPSpxFsfg=";
        };
      in
      rec {
        devShells = {
          default = pkgs.mkShell {
            name = "dev";
            shellHook = pkgs.shellhook.ref;
            packages = with pkgs; [
              # rust
              rustToolchain

              # formatters
              nixfmt
              prettier

              # util
              bumper
              nix-flake-release
            ];
          };

          bump = pkgs.mkShell {
            name = "bump";
            packages = with pkgs; [
              bumper
              rustToolchain
            ];
          };

          check = pkgs.mkShell {
            name = "check";
            packages = [
              rustToolchain
            ];
          };

          release = pkgs.mkShell {
            name = "release";
            packages = with pkgs; [
              nix-flake-release
              rustToolchain
            ];
          };

          update = pkgs.mkShell {
            name = "update";
            packages = with pkgs; [
              renovate

              # rust
              cargo
            ];
          };

          vulnerable = pkgs.mkShell {
            name = "vulnerable";
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
            deps = [ rustToolchain ];
            script = ''
              cargo fmt --check
              cargo test --offline
              cargo clippy --offline -- -D warnings
            '';
          };

          nix = {
            src = fs.toSource {
              root = ./.;
              fileset = fs.fileFilter (file: file.hasExt "nix") ./.;
            };
            deps = with pkgs; [
              nixfmt-tree
            ];
            script = ''
              treefmt --ci
            '';
          };

          renovate = {
            src = fs.toSource {
              root = ./.github;
              fileset = ./.github/renovate.json;
            };
            deps = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          actions = {
            src = fs.toSource {
              root = ./.;
              fileset = fs.unions [
                ./.github/workflows
              ];
            };
            deps = with pkgs; [
              action-validator
              octoscan
            ];
            script = ''
              action-validator **/*.yaml
              octoscan scan .
            '';
          };

          prettier = {
            src = fs.toSource {
              root = ./.;
              fileset = fs.fileFilter (file: file.hasExt "yaml" || file.hasExt "json" || file.hasExt "md") ./.;
            };
            deps = with pkgs; [
              prettier
            ];
            script = ''
              prettier --check .
            '';
          };
        };

        apps = pkgs.lib.mkApps {
          dev.script = "cargo run";
        };

        packages =
          with pkgs.lib;
          let
            rustPlatform = pkgs.makeRustPlatform {
              cargo = rustToolchain;
              rustc = rustToolchain;
            };

            package = rustPlatform.buildRustPackage (finalAttrs: {
              pname = "rust-template";
              version = "0.4.1";

              src = fs.toSource {
                root = ./.;
                fileset = fs.unions [
                  ./Cargo.lock
                  ./Cargo.toml
                  ./rust-toolchain.toml
                  (fs.fileFilter (file: file.hasExt "rs") ./.)
                ];
              };

              cargoLock.lockFile = ./Cargo.lock;

              meta = {
                description = "template for rust projects";
                mainProgram = "rust-template";
                homepage = "https://github.com/spotdemo4/rust-template";
                changelog = "https://github.com/spotdemo4/rust-template/releases/tag/v${finalAttrs.version}";
                license = pkgs.lib.licenses.mit;
                platforms = pkgs.lib.platforms.all;
              };
            });

            image = makeOverridable pkgs.dockerTools.buildLayeredImage {
              name = package.pname;
              tag = package.version;

              contents = with pkgs; [
                dockerTools.caCertificates
              ];

              created = "now";
              meta = package.meta;

              config = {
                Entrypoint = [ "${meta.getExe package}" ];
                Labels = {
                  "org.opencontainers.image.title" = package.pname;
                  "org.opencontainers.image.description" = package.meta.description;
                  "org.opencontainers.image.version" = package.version;
                  "org.opencontainers.image.source" = package.meta.homepage;
                  "org.opencontainers.image.licenses" = package.meta.license.spdxId;
                };
              };
            };
          in
          rec {
            default = rust.compile {
              inherit package;
            };

            # cross compilation
            linux-amd64 = rust.compile {
              inherit package;
              target = "x86_64-unknown-linux-gnu";
            };
            linux-arm64 = rust.compile {
              inherit package;
              target = "aarch64-unknown-linux-gnu";
            };
            linux-arm = rust.compile {
              inherit package;
              target = "armv7-unknown-linux-gnueabihf";
            };
            darwin-arm64 = rust.compile {
              inherit package;
              target = "aarch64-apple-darwin";
            };
            windows-amd64 = rust.compile {
              inherit package;
              target = "x86_64-pc-windows-gnu";
            };

            # images
            linux-amd64-image = image.override (prev: {
              architecture = "amd64";
              config = prev.config // {
                Cmd = [ "${meta.getExe linux-amd64}" ];
              };
            });
            linux-arm64-image = image.override (prev: {
              architecture = "arm64";
              config = prev.config // {
                Cmd = [ "${meta.getExe linux-arm64}" ];
              };
            });
            linux-arm-image = image.override (prev: {
              architecture = "arm";
              config = prev.config // {
                Cmd = [ "${meta.getExe linux-arm}" ];
              };
            });
          };

        formatter = pkgs.nixfmt-tree;
      }
    );
}
