# home-manager module for plan.
#
#   inputs.plan.url = "github:oschrenk/plan.swift";
#   imports = [ inputs.plan.homeModules.plan ];
#
#   programs.plan = {
#     enable = true;
#     iconize = [
#       { field = "title.label"; regex = "Yoga"; icon = "🪷"; }
#     ];
#     hooks = [
#       {
#         path = lib.getExe pkgs.sketchybar;
#         args = [ "--trigger" "calendar_changed" ];
#       }
#     ];
#   };
#
# Generates $XDG_CONFIG_HOME/plan/config.json, the only path
# Sources/Loader.swift looks at.
self:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.plan;

  jsonFormat = pkgs.formats.json { };

  # Sources/Config.swift, `struct Rule`.
  ruleType = types.submodule {
    options = {
      field = mkOption {
        type = types.str;
        example = "title.label";
        description = "Event field the regex is matched against.";
      };

      regex = mkOption {
        type = types.str;
        example = "Yoga";
        description = "Pattern the field has to match for the icon to apply.";
      };

      icon = mkOption {
        type = types.str;
        example = "🪷";
        description = "Icon prepended to matching events.";
      };
    };
  };

  # Sources/Config.swift, `struct Hook`.
  hookType = types.submodule {
    options = {
      path = mkOption {
        type = types.str;
        example = literalExpression "lib.getExe pkgs.sketchybar";
        description = ''
          Executable to run when events change. `Hook.trigger()` hands this
          straight to {manpage}`Process(3)` without any environment expansion,
          so it has to be an absolute path.
        '';
      };

      args = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExpression ''[ "--trigger" "calendar_changed" ]'';
        description = "Arguments passed to {option}`path`.";
      };
    };
  };

  settings = {
    inherit (cfg) iconize hooks;
  };
in
{
  options.programs.plan = {
    enable = mkEnableOption "plan, a Calendar.app companion CLI";

    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.plan;
      defaultText = literalExpression "plan.packages.\${system}.plan";
      description = "The plan package to install.";
    };

    iconize = mkOption {
      type = types.listOf ruleType;
      default = [ ];
      example = literalExpression ''
        [
          { field = "title.label"; regex = "Yoga"; icon = "🪷"; }
          { field = "title.label"; regex = "1:1";  icon = "🤝"; }
        ]
      '';
      description = ''
        Rules that prepend an icon to events whose field matches the regex.
        Applied by `plan hours`, `next`, `on` and `today`.
      '';
    };

    hooks = mkOption {
      type = types.listOf hookType;
      default = [ ];
      example = literalExpression ''
        [
          {
            path = lib.getExe pkgs.sketchybar;
            args = [ "--trigger" "calendar_changed" ];
          }
        ]
      '';
      description = "Commands fired by `plan watch` when events change.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Written unconditionally, even when both lists are empty. Loader.readConfig
    # reports a missing file on *stdout*, which corrupts the JSON that
    # `plan today`/`next`/`on`/`hours` emit — an absent config.json is not a
    # neutral default.
    xdg.configFile."plan/config.json".source = jsonFormat.generate "plan-config.json" settings;
  };
}
