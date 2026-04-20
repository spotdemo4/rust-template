{
  description = "rust template";

  nixConfig = {
    extra-substituters = [
      "https://nix.trev.zip"
    ];
    extra-trusted-public-keys = [
      "trev:I39N/EsnHkvfmsbx8RUW+ia5dOzojTQNCTzKYij1chU="
    ];
  };

  inputs = {
    systems.url = "github:spotdemo4/systems";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    trev = {
      url = "github:spotdemo4/nur";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      trev,
      ...
    }:
    trev.libs.mkFlake (
      system: pkgs: {
        devShells = {
          default = pkgs.mkShell {
            shellHook = pkgs.shellhook.ref;
            packages = with pkgs; [
              # rust
              rustc
              cargo

              # lint
              clippy
              cargo-audit

              # format
              rustfmt
              nixfmt
              prettier
              tombi

              # util
              bumper
            ];
          };

          bump = pkgs.mkShell {
            packages = with pkgs; [
              bumper
            ];
          };

          release = pkgs.mkShell {
            packages = with pkgs; [
              flake-release
            ];
          };

          update = pkgs.mkShell {
            packages = with pkgs; [
              renovate
              cargo # rust
            ];
          };

          vulnerable = pkgs.mkShell {
            packages = with pkgs; [
              cargo-audit # rust
              flake-checker # flake
              octoscan # actions
            ];
          };
        };

        apps = pkgs.mkApps {
          default = "cargo run";
        };

        checks = pkgs.mkChecks {
          rust = {
            src = self.packages.${system}.default;
            packages = with pkgs; [
              rustfmt
              clippy
            ];
            script = ''
              cargo test --offline
              cargo fmt --check
              cargo clippy --offline -- -D warnings
            '';
          };

          nix = {
            root = ./.;
            filter = file: file.hasExt "nix";
            packages = with pkgs; [
              nixfmt
            ];
            forEach = ''
              nixfmt --check "$file"
            '';
          };

          renovate = {
            root = ./.github;
            fileset = ./.github/renovate.json;
            packages = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          actions = {
            root = ./.;
            files = [
              ./action.yaml
              ./.github/workflows
            ];
            packages = with pkgs; [
              action-validator
              octoscan
            ];
            forEach = ''
              action-validator "$file"
              octoscan scan "$file"
            '';
          };

          tombi = {
            root = ./.;
            filter = file: file.hasExt "toml";
            packages = with pkgs; [
              tombi
            ];
            forEach = ''
              tombi format --offline --check "$file"
              tombi lint --offline --error-on-warnings "$file"
            '';
          };

          prettier = {
            root = ./.;
            filter = file: file.hasExt "yaml" || file.hasExt "json" || file.hasExt "md";
            packages = with pkgs; [
              prettier
            ];
            forEach = ''
              prettier --check "$file"
            '';
          };
        };

        formatter = pkgs.treefmt.withConfig {
          configFile = ./treefmt.toml;
          runtimeInputs = with pkgs; [
            rustfmt
            nixfmt
            tombi
            prettier
          ];
        };

        packages.default = pkgs.rustPlatform.buildRustPackage (
          final: with pkgs.lib; {
            pname = "rust-template";
            version = "0.4.7";

            src = fileset.toSource {
              root = ./.;
              fileset = fileset.unions [
                ./Cargo.lock
                ./Cargo.toml
                (fileset.fileFilter (file: file.hasExt "rs") ./.)
              ];
            };
            cargoLock.lockFile = ./Cargo.lock;

            meta = {
              mainProgram = "rust-template";
              description = "Template for Rust projects";
              license = licenses.mit;
              platforms = platforms.all;
              homepage = "https://github.com/spotdemo4/rust-template";
              changelog = "https://github.com/spotdemo4/rust-template/releases/tag/v${final.version}";
              downloadPage = "https://github.com/spotdemo4/rust-template/releases/tag/v${final.version}";
            };
          }
        );

        images.default = pkgs.mkImage {
          src = self.packages.${system}.default;
          contents = with pkgs; [ dockerTools.caCertificates ];
        };

        schemas = trev.schemas;
      }
    );
}
