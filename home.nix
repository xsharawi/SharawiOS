{
  config,
  lib,
  pkgs,
  ...
}: {
  home = {
    username = "xsharawi";
    homeDirectory = "/home/xsharawi";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [
      (pkgs.writeShellScriptBin "nsh" ''
        nh os switch /etc/nixos && dark-text --death --text "Nixos Rebuilt" --duration 1000
      '')

      (pkgs.writeShellScriptBin "up" ''
        nh os switch /etc/nixos --update && dark-text --death --text "Nixos Rebuilt" --duration 1000
      '')

      (pkgs.writeShellScriptBin "fih" ''
        ${lib.getExe pkgs.fish}
      '')

      (pkgs.writeShellScriptBin "screenshot" ''
        #!/usr/bin/env bash
        FILE=$(mktemp /tmp/hypr-freeze-XXXX.png)
        grimblast save output "$FILE"
        swayimg -f "$FILE"
        [ -f "$FILE" ] && rm "$FILE"
      '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/xsharawi/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      # EDITOR = "emacs";
      EDITOR = "nvim";
    };

    #stylix.cursor.name = "Banana";

    # forceing because stylix is dumb
    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      package = lib.mkForce pkgs.banana-cursor;
      size = lib.mkForce 40;
      name = lib.mkForce "Banana";
    };
  };
  imports = [
    ./xdgmime.nix
    ./waybar-style.nix
    ./wallpaper-random.nix
  ];

  wayland.windowManager.hyprland = {
    systemd.enable = true;

    xwayland.enable = true;
    enable = true;

    settings = {
      # Autostart.

      ecosystem = {
        no_update_news = true;
      };

      debug = {
        disable_logs = true;
      };

      exec-once = [
        # "wl-clip-persist --clipboard both"
        "xrandr --output \"DP-1\" --primary"
        "nm-applet --indicator &"
        "kdeconnect-indicator &"
        "waybar &"
        "swww-daemon &"
        "keepassxc"
        "[workspace 1 silent] obsidian"
        "[workspace 2 silent] $TERMINAL"
        "[workspace 3 silent] zen-beta"
        # https://github.com/jmanc3/hyprselect/ and make a flake and 'make'
        "hyprctl plugin load /etc/nixos/extra/hyprselect.so"
        "systemctl --user start hyprpolkitagent"
      ];

      input = {
        kb_layout = "us";
        numlock_by_default = true;
        follow_mouse = 2;
        sensitivity = 0;
        touchpad = {
          natural_scroll = "yes";
        };
      };

      general = {
        "$mainMod" = "SUPER";
        "$TERMINAL" = "kitty";
        layout = "dwindle";
        allow_tearing = true;
        gaps_in = 2;
        gaps_out = 6;
        border_size = 2;
        env = [
          "HYPRCURSOR_THEME,Banana"
          "HYPRCURSOR_SIZE,40"
          "XCURSOR_SIZE,40"
          "XDG_SESSION_TYPE,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_SESSION_DESKTOP,Hyprland "
          "XDG_CURRENT_DESKTOP,Hyprland"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        focus_on_activate = true;
        font_family = "JetBrainsMono Nerd Font";
      };

      decoration = {
        rounding = 15;
        active_opacity = 1;
        inactive_opacity = 0.90;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          ignore_opacity = true;
        };
      };

      animations = {
        enabled = false;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];

        animation = [
          # Windows
          "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
          "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
          "windowsMove, 1, 0.01, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "borderangle, 1, 30, fluent_decel, loop" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces, 1, 4, easeOutCubic, slide" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };

      bind = [
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT , Q, exec, hyprctl dispatch exit"
        "$mainMod, W, exec, swaylock --color 000000"
        "$mainMod SHIFT, Space, togglefloating"
        "$mainMod, F, exec, hyprctl dispatch fullscreen"
        "$mainMod, Space, exec, pkill rofi || rofi -show drun -show-icons"

        "$mainMod, M, exec, pamixer --toggle-mute"
        "$mainMod , U, movecurrentworkspacetomonitor, +1"

        "$mainMod, S, exec, pkill -SIGUSR1 waybar"

        "$mainMod, PRINT, exec, hyprshot -m region"
        ", PRINT, exec, grimblast --freeze copysave area ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).png"
        "$mainMod, page_down , exec, grimblast --freeze copysave area ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).png"

        # switch workspace
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod, Z, exec, screenshot"
      ];

      windowrule = [
        "workspace 3, class:^zen-beta$"
        # JetBrains Studio – Android / emulator windows (title starts with win)
        "nofocus, noanim, noinitialfocus, rounding 0, class:^jetbrains-studio$, title:^win.*$"

        # JetBrains Studio – floating non-emulator dialogs
        "dimaround, center, class:^jetbrains-studio$, floating:1"

        # JetBrains Studio – general behavior
        "focusonactivate on, class:^jetbrains-studio$"
        # Center all floating windows on the focused monitor
        "center, floating:1"
        "center, floating:1, class:^jetbrains-studio$"
      ];

      # binds that can be repeated
      binde = [
        # terminal open
        "$mainMod, Return, exec, $TERMINAL"

        # switch focus
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # window control
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # resize windows
        "$mainMod CTRL, l,resizeactive,10 0"
        "$mainMod CTRL, h,resizeactive,-10 0"
        "$mainMod CTRL, k,resizeactive,0 -10"
        "$mainMod CTRL, j,resizeactive,0 10 "

        # sound and brightness control
        "$mainMod, F2, exec, brightnessctl s 5%-"
        "$mainMod, F3, exec, brightnessctl s +5%"
        "$mainMod, up, exec, pamixer -i 5"
        "$mainMod, down, exec, pamixer -d 5"

        # same as above, but switch to the workspace
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1" # movetoworkspacesilent
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        "$mainMod, N, workspace, +1"
        "$mainMod, P, workspace, -1"
      ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };

    extraConfig = "
        monitor=DP-1,1920x1080@180,1920x0,1,bitdepth,10
        monitor=HDMI-A-1,1920x1080@100,0x0,1,bitdepth,10
        workspace=2, monitor:DP-1
        workspace=3, monitor:DP-1
       xwayland {
         force_zero_scaling = true
       }
    ";
  };

  #also virt
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    # disable dconf first use warning
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
    # set dark theme for gtk 4
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/interface" = {
      toolkit-accessibility = false;
    };
  };
  stylix = {
    enable = true;
    targets = {
      kitty.enable = true;
      kitty.variant256Colors = true;
      waybar.enable = false;

      swaylock.enable = true;
      sway.enable = true;
      kde.enable = true;
      swaync.enable = true;
      gtk.enable = true;
      qt.enable = true;
      qt.platform = "kde";
      rofi.enable = false;
    };
    base16Scheme = ./catppuccin-mocha.yaml;
  };
  programs = {
    kitty = {
      enable = true;
      settings = {
        scroll_back = -1;
        mouse_hide_wait = 2.0;
        font_family = "JetBrainsMono Nerd Font";
        font_size = 11;
        enable_audio_bell = true;
        cursor_trail = 3;
        remember_window_size = "yes";
        allow_hyperlinks = "yes";
        shell_integration = "enabled";
      };
    };

    rofi.enable = true;
    rofi.theme = "${pkgs.rofi}/share/rofi/themes/purple";
    waybar.enable = true;
    waybar.settings = import ./waybar-config.nix;
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  xdg.desktopEntries = {
    # Example for a custom launcher
    runescape-launcher = {
      name = "runescape";
      exec = "${pkgs.bolt-launcher}/bin/bolt-launcher";
      icon = "bolt-launcher";
      categories = ["Game"];
      terminal = false;
    };
  };

  xdg.configFile."mimeapps.list".force = true;
}
