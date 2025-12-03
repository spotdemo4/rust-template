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
        rust = pkgs.fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ];
      in
      rec {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # rust
              rust

              # util
              bumper

              # nix
              nixfmt

              # actions
              prettier
            ];
            shellHook = pkgs.shellhook.ref;
          };

          bump = pkgs.mkShell {
            packages = with pkgs; [
              nix-update
            ];
          };

          release = pkgs.mkShell {
            packages = with pkgs; [
              skopeo
            ];
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
              cargo test --offline
              cargo fmt --check
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
              prettier --check .
              action-validator .github/**/*.yaml
              octoscan scan .github
              renovate-config-validator .github/renovate.json
            '';
          };
        };

        apps = pkgs.lib.mkApps {
          dev.script = "cargo run";
        };

        packages.default = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
          pname = "rust-template";
          version = "0.1.0";

          src = builtins.path {
            name = "root";
            path = ./.;
          };
          cargoLock.lockFile = finalAttrs.src + "Cargo.lock";

          meta = {
            description = "rust template";
            mainProgram = "rust-template";
            homepage = "https://github.com/spotdemo4/rust-template";
            changelog = "https://github.com/spotdemo4/rust-template/releases/tag/v${finalAttrs.version}";
            license = pkgs.lib.licenses.mit;
            platforms = pkgs.lib.platforms.all;
          };
        });

        formatter = pkgs.nixfmt-tree;
      }
    );
}
