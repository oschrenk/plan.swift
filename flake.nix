{
  description = "plan - macOS terminal tool to fetch calendar events from Calendar.app";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # Offer prebuilt binaries from the Cachix cache so `nix profile install`
  # downloads instead of re-fetching and unpacking. Consumers are prompted to
  # trust these.
  nixConfig = {
    extra-substituters = [ "https://oschrenk.cachix.org" ];
    extra-trusted-public-keys = [
      "oschrenk.cachix.org-1:3JOMfkq2vFiLw4UsCVwzu8kWFBkuS/3DD5AojcO9pks="
    ];
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      # Single source of truth for the version: ./VERSION is a dotenv file
      # (taskfile.yml reads it through `dotenv:`) holding APP_VERSION=v0.13.1.
      # Strip the key and the "v" to get the bare semver the release artifact is
      # named after.
      version = lib.head (lib.match "APP_VERSION=v(.*)" (lib.fileContents ./VERSION));

      # aarch64-darwin only: plan talks to EventKit, so linux is out, and
      # `task tar` only ever produces a darwin-arm64 artifact.
      systems = [
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        # plan is *not* built from source here. nixpkgs ships Swift 5.10.1 and
        # its swiftpm is compiled without CompilerPluginSupport, so evaluating
        # the swift-case-paths manifest (a transitive dep of swift-parsing)
        # fails outright. Until nixpkgs carries a macro-capable Swift 6, the
        # release artifact produced by `task release` is what gets packaged.
        plan = pkgs.stdenvNoCC.mkDerivation {
          pname = "plan";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/oschrenk/plan.swift/releases/download/v${version}/plan-${version}.tar.gz";
            # Regenerate after a release with `task nix-hash`.
            hash = "sha256-NXjN+44SIXHbmGliMOzKgWAV0Ieu1X8pbxcnX7GR9aA=";
          };

          # The tarball holds its files at the archive root, not under a
          # versioned directory.
          sourceRoot = ".";

          dontConfigure = true;
          dontBuild = true;

          # The binary is ad-hoc (linker) signed by Xcode and links only against
          # /usr/lib and system frameworks, so it has no nix store references to
          # patch. Letting fixup strip or rewrite it would invalidate that
          # signature for no gain.
          dontFixup = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 plan-darwin-arm64 $out/bin/plan
            runHook postInstall
          '';

          # No shell completions: the root command in Sources/Main.swift sets no
          # `commandName`, so ArgumentParser derives "main" and
          # `--generate-completion-script` emits completions bound to `main`
          # rather than `plan`.

          meta = {
            description = "Unofficial Calendar.app companion CLI to view today's events in various forms";
            homepage = "https://github.com/oschrenk/plan.swift";
            mainProgram = "plan";
            platforms = lib.platforms.darwin;
          };
        };
        default = plan;
      });

      apps = forAllSystems (pkgs: rec {
        plan = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.plan}/bin/plan";
        };
        default = plan;
      });

      homeModules = rec {
        plan = import ./nix/home-manager.nix self;
        default = plan;
      };

      devShells = forAllSystems (pkgs: {
        # mkShellNoCC, not mkShell: everything below is a prebuilt binary, and a
        # cc-wrapper in scope exports SDKROOT/DEVELOPER_DIR pointing at nixpkgs'
        # apple-sdk. Xcode's swiftc refuses that SDK outright ("this SDK is not
        # supported by the compiler ... the SDK is built with Apple Swift
        # version 5.10"), which breaks `task build`/`test`/`install`.
        default = pkgs.mkShellNoCC {
          # No swift or sourcekit-lsp from nixpkgs on purpose: both are 5.10.1
          # and would shadow the Xcode 6.x toolchain that actually compiles this
          # package. `swift build` keeps using /usr/bin/swift.
          packages = with pkgs; [
            swiftformat # swift, formatter
            swiftlint # swift, linter
            go-task # task runner, drives taskfile.yml
            jq # used by `task nix-hash`
            cachix # push/pull the binary cache
          ];

          # mkShellNoCC already blanks SDKROOT and DEVELOPER_DIR but still
          # exports MACOSX_DEPLOYMENT_TARGET from the nixpkgs SDK, which drags
          # SwiftPM down to -target arm64-apple-macosx14.0 even though
          # Package.swift asks for .macOS(.v15). Hand the whole SDK question
          # back to Xcode.
          shellHook = ''
            unset SDKROOT DEVELOPER_DIR MACOSX_DEPLOYMENT_TARGET
          '';
        };
      });
    };
}
