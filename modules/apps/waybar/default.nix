{
  config,
  pkgs,
  lib,
  ...
}: let
  waybarSettings = builtins.fromJSON (builtins.readFile ./settings.json);
  audio-select = pkgs.writeShellApplication {
    name = "audio-select";
    runtimeInputs = with pkgs; [
      gawk
      libnotify
      rofi
      wireplumber
    ];
    text = ''
      device_type="$({ printf '%s\n' "Output" "Microphone"; } | rofi -dmenu -i -p "Audio device")"

      case "$device_type" in
        Output)
          section="Sinks:"
          next_section="Sink endpoints:"
          prompt="Output"
          ;;
        Microphone)
          section="Sources:"
          next_section="Source endpoints:"
          prompt="Microphone"
          ;;
        *)
          exit 0
          ;;
      esac

      devices="$(wpctl status | awk -v section="$section" -v next_section="$next_section" '
        index($0, section) { in_section = 1; next }
        in_section && index($0, next_section) { exit }
        in_section && match($0, /[0-9]+\./) {
          id = substr($0, RSTART, RLENGTH - 1)
          description = substr($0, RSTART + RLENGTH)
          sub(/[[:space:]]+\[vol:.*/, "", description)
          printf "%s\t%s\n", description, id
        }
      ')"

      if [[ -z "$devices" ]]; then
        notify-send "Audio selector" "No ''${prompt,,} devices found"
        exit 0
      fi

      selection="$(printf '%s\n' "$devices" | rofi -dmenu -i -p "$prompt" -display-columns 1)"
      [[ -n "$selection" ]] || exit 0

      wpctl set-default "''${selection##*$'\t'}"
    '';
  };
in {
  home.packages = [audio-select];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./styles.css;
    settings = waybarSettings;
  };
}
