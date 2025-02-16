#!/bin/bash
# Dieses Skript reagiert nur, wenn sich die Orientierung ändert.
# Die swaymsg-Befehle wurden entfernt, da sie unter Hyprland nicht funktionieren.
# Falls du Eingabekalibrierung benötigst, musst du diese alternativ konfigurieren.

last_orientation=""

monitor-sensor | while read -r line; do
    # Verarbeite nur Zeilen, die "orientation changed:" enthalten
    if [[ "$line" == *"orientation changed:"* ]]; then
        # Extrahiere die Orientierung (z. B. "normal", "left-up", …)
        orientation=$(echo "$line" | awk -F": " '{print $2}')
        # Falls die Orientierung nicht wechselt, mache nichts
        if [ "$orientation" = "$last_orientation" ]; then
            continue
        fi
        last_orientation="$orientation"

        case "$orientation" in
            normal)
                echo "Normal orientation"
                hyprctl keyword monitor eDP-1,preferred,auto,1,transform,0 
                pkill -x waybar
                waybar &
                ;;
            left-up)
                echo "Left-up orientation"
                hyprctl keyword monitor eDP-1,preferred,auto,1,transform,1
                pkill -x waybar
                waybar -c ~/.config/waybar/config-vertical-left.jsonc &
                ;;
            right-up)
                echo "Right-up orientation"
                hyprctl keyword monitor eDP-1,preferred,auto,1,transform,3

                pkill -x waybar
                waybar -c ~/.config/waybar/config-vertical-left.jsonc &
                ;;
            bottom-up)
                echo "Bottom-up orientation"
                hyprctl keyword monitor eDP-1,preferred,auto,1,transform,2
                pkill -x waybar
                waybar &
                ;;
            *)
                echo "Unbekannte Orientierung: $orientation"
                ;;
        esac
    fi
done