{
  config,
  home,
  ...
}: {
  programs.waybar.style = ''
    @define-color rosewater #f5e0dc;
    @define-color flamingo #f2cdcd;
    @define-color pink #f5c2e7;
    @define-color mauve #cba6f7;
    @define-color red #f38ba8;
    @define-color maroon #eba0ac;
    @define-color peach #fab387;
    @define-color yellow #f9e2af;
    @define-color green #a6e3a1;
    @define-color teal #94e2d5;
    @define-color sky #89dceb;
    @define-color sapphire #74c7ec;
    @define-color blue #89b4fa;
    @define-color lavender #b4befe;
    @define-color text #cdd6f4;
    @define-color subtext1 #bac2de;
    @define-color subtext0 #a6adc8;
    @define-color overlay2 #9399b2;
    @define-color overlay1 #7f849c;
    @define-color overlay0 #6c7086;
    @define-color surface2 #585b70;
    @define-color surface1 #45475a;
    @define-color surface0 #313244;
    @define-color base #1e1e2e;
    @define-color mantle #181825;
    @define-color crust #11111b;
    * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 14px;
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 1rem;
        padding-right: 0.4rem;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 2rem;
        padding: 0.4rem;
        border-bottom: 3px solid transparent; /* Stylix underline base */
      }

      /* Keep the Stylix underline effect for active/focused workspaces */
      #workspaces button.active,
      #workspaces button.focused {
        border-bottom: 3px solid @text;
        color: @sky;
      }

      #workspaces button:hover {
        color: @sapphire;
        border-radius: 1rem;
      }

      #custom-music,
      #tray,
      #backlight,
      #clock,
      #cpu,
      #memory,
      #battery,
      #pulseaudio,
      #custom-lock,
      #custom-power {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }

      #clock {
        color: @blue;
        border-radius: 0px 1rem 1rem 0px;
        margin-right: 1rem;
      }

      #cpu {
        color: #5eead4;
      }

      #memory {
        color: #b9a3e3;
      }

      #battery {
        color: @green;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #backlight,
      #battery {
        border-radius: 0;
      }

      #pulseaudio {
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #custom-music {
        color: @mauve;
        border-radius: 1rem;
      }

      #custom-lock {
        border-radius: 1rem 0px 0px 1rem;
        color: @lavender;
      }

      #custom-power {
        margin-right: 1rem;
        border-radius: 0px 1rem 1rem 0px;
        color: @red;
      }

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
      }

      /* Add spacing between modules */
      .modules-left > *,
      .modules-center > *,
      .modules-right > * {
        margin: 0 6px;
      }
  '';
}
