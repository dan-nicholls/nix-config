{
  lib,
  pkgs,
  ...
}: let
  system-hw-laptop-closed = pkgs.writeShellApplication {
    name = "system-hw-laptop-closed";

    text = ''
      # Return 0 if lid is closed, otherwise non-zero
      grep -q closed /proc/acpi/button/lid/LID/state
    '';
  };

  system-lid-close = pkgs.writeShellApplication {
    name = "system-lid-close";
    runtimeInputs = [
      system-hw-laptop-closed
      system-hw-external-monitors
      system-lock
      system-hyprland-monitor-clamshell
    ];
    text = ''
        if system-hw-laptop-closed && ! system-hw-external-monitors; then
          system-lock >/dev/null 2>&1 || true
        fi
      system-hyprland-monitor-clamshell
    '';
  };

  system-hw-external-monitors = pkgs.writeShellApplication {
    name = "system-hw-external-monitors";

    runtimeInputs = [pkgs.jq pkgs.hyprland];
    text = ''
      hyprctl monitors -j | jq -e 'any(.[]; .name | test("^eDP-") | not)' >/dev/null
    '';
  };

  system-lock = pkgs.writeShellApplication {
    name = "system-lock";
    text = ''
      noctalia msg session lock
    '';
  };

  system-hyprland-monitor-internal = pkgs.writeShellApplication {
    name = "system-hyprland-monitor-internal";
    runtimeInputs = [pkgs.jq pkgs.hyprland];
    text = ''
      hyprctl monitors all -j | jq -r '.[] | select(.name | test("^eDP-")).name' | head -n 1
    '';
  };

  system-hyprland-monitor-external-active = pkgs.writeShellApplication {
    name = "system-hyprland-monitor-external-active";
    runtimeInputs = [pkgs.jq pkgs.hyprland];
    text = ''
      hyprctl monitors all -j | jq -e '.[] | select(.name | test("^eDP-") | not) | select(.disabled == false)' >/dev/null 2>&1
    '';
  };

  system-hyprland-monitor-clamshell = pkgs.writeShellApplication {
    name = "system-hyprland-monitor-clamshell";
    runtimeInputs = [
      pkgs.hyprland
      system-hyprland-monitor-internal
      system-hyprland-monitor-external-active
      system-hw-clamshell
    ];

    text = ''
      TOGGLES_DIR="$HOME/.local/state/my-config/hypr"
      CLAMSHELL_FLAG="$TOGGLES_DIR/internal-monitor-clamshell.lua"

      INTERNAL=$(system-hyprland-monitor-internal)

      enable_internal() {
          [[ -n "$INTERNAL" ]] || return 0

          if [[ -f $CLAMSHELL_FLAG ]]; then
            rm -f "$CLAMSHELL_FLAG"
            hyprctl reload >/dev/null 2>&1 || true
          fi

          hyprctl dispatch "hl.dsp.dpms({ action = \"enable\", monitor = \"$INTERNAL\" })" >/dev/null 2>&1 || true
      }

      disable_internal() {
        [[ -n $INTERNAL ]] || return 0

        mkdir -p "$TOGGLES_DIR"

        local monitor_config
          monitor_config=$(printf 'hl.monitor({ output = "%s", disabled = true })' "$INTERNAL")

          if [[ ! -f "$CLAMSHELL_FLAG" ]] || [[ $(<"$CLAMSHELL_FLAG") != "$monitor_config" ]]; then
            printf '%s\n' "$monitor_config" >"$CLAMSHELL_FLAG"
            hyprctl reload >/dev/null 2>&1 || true
          fi
      }

      if system-hw-clamshell && system-hyprland-monitor-external-active; then
        disable_internal
      else
        enable_internal
      fi
    '';
  };

  system-hw-clamshell = pkgs.writeShellApplication {
    name = "system-hw-clamshell";
    runtimeInputs = [
      system-hw-laptop-closed
      system-hw-external-monitors
    ];
    text = ''
      system-hw-laptop-closed && system-hw-external-monitors
    '';
  };

  system-hw-lid-event = pkgs.writeShellApplication {
    name = "system-hw-lid-event";
    runtimeInputs = [
      system-hw-laptop-closed
      system-hw-external-monitors
      system-lock
      system-hyprland-monitor-clamshell
    ];

    text = ''
      if system-hw-laptop-closed && ! system-hw-external-monitors; then
          system-lock
      fi

      system-hyprland-monitor-clamshell
    '';
  };
in {
  environment.systemPackages = [
    system-hw-laptop-closed
    system-hw-external-monitors
    system-hw-lid-event
    system-hw-clamshell

    system-hyprland-monitor-external-active
    system-hyprland-monitor-clamshell
    system-hyprland-monitor-internal

    system-lid-close
    system-lock
  ];
}
