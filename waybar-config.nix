{
  mainBar = {
    layer = "top";
    position = "top";
    height = 12;

    modules-left = ["hyprland/workspaces"];
    modules-center = ["custom/music"];
    modules-right = [
      "pulseaudio"
      "memory"
      "cpu"
      "clock"
      "custom/capslock"
      "tray"
      "custom/lock"
      "custom/power"
    ];

    "hyprland/workspaces" = {
      format = "{name} {icon}";
      format-icons = {
        active = "";
        default = "";
      };
      on-scroll-up = "hyprctl dispatch workspace e-1";
      on-scroll-down = "hyprctl dispatch workspace e+1";
      separate-outputs = true;
    };

    tray = {
      icon-size = 21;
      spacing = 10;
    };

    "custom/music" = {
      format = "🎵  {}";
      escape = true;
      interval = 5;
      tooltip = false;
      exec = "playerctl metadata --format='{{ title }}'";
      on-click = "playerctl play-pause";
      max-length = 50;
    };

    "custom/capslock" = {
      exec = "${./extra/capslockstatus.sh}";
      interval = 1;
      tooltip = "Caps Lock";
      return-type = "json";
    };

    clock = {
      timezone = "Asia/Hebron";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format = "⏲ {:%I:%M %p 🗓 %d-%m}";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon}";
      format-charging = "";
      format-plugged = "";
      format-alt = "{icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "🔇";
      format-icons.default = ["" "" " "];
      on-click = "pavucontrol";
    };

    "custom/lock" = {
      tooltip = false;
      on-click = "sh -c '(sleep 0.5s; swaylock --color 000000)' & disown";
      format = "";
    };

    "custom/power" = {
      tooltip = false;
      on-click = "shutdown now";
      format = "⏻";
    };
  };
}
