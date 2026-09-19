{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStrings;
  myfont = "RobotoMono Nerd Font";
in {
  home = {
    username = "xsharawi";
    homeDirectory = "/home/xsharawi";

    # something something don't change unless new install something something
    stateVersion = "26.11";
    file.".tmux.conf".source = ./extra/.tmux.conf;

    packages = [
      (pkgs.writeShellScriptBin "nsh" ''
        nh os switch /etc/nixos && dark-text --death --text "Nixos Rebuilt" --duration 1000
      '')

      (pkgs.writeShellScriptBin "up" ''
        nh os switch /etc/nixos --update && dark-text --death --text "Nixos Rebuilt" --duration 1000
      '')
      # (pkgs.writeShellScriptBin "fih" ''
      #   ${lib.getExe pkgs.fish}
      # '')

      # prevent IFD, thanks @Michael-C-Buckley
      # goated get and iynaix as always
      (pkgs.writeShellScriptBin "ns" ''
        export FZF_DEFAULT_OPTS="--cycle --height 100% --border --reverse"

         ${pkgs.nix-search-tv.src}/nixpkgs.sh $@
      '')

      (pkgs.writeShellScriptBin "tmux-save-layout" ''
        set -euo pipefail

        state_dir="$HOME/.local/state/tmux"
        mkdir -p "$state_dir"

        tmux list-sessions -F "#{session_name} #{session_path}" 2>/dev/null | while read -r session_name session_path; do
            [[ -d "$session_path" ]] || continue

            window=$(tmux list-windows -t "$session_name" -F "#{window_index}" | head -n1)
            window_ref="$session_name:$window"

            pane_count=$(tmux list-panes -t "$window_ref" -F "#{pane_index}" | wc -l)

            cmds=""

            while read -r cmd; do
              case "$cmd" in
                nvim|vim)
                  cmds+="nvim;"
                  ;;
                *)
                  cmds+="shell;"
                  ;;
              esac
            done < <(tmux list-panes -t "$window_ref" -F "#{pane_current_command}")


        cmds=$(echo "$cmds" | sed 's/;$//')
            echo "$session_path|$pane_count|$cmds"
          done > "$state_dir/layout"
      '')

      (pkgs.writeShellScriptBin "tmux-restore-layout" ''
        set -euo pipefail

        state_dir="$HOME/.local/state/tmux"
        file="$state_dir/layout"

        [[ -f "$file" ]] || exit 0

        while IFS='|' read -r session_path pane_count cmds; do
          [[ -d "$session_path" ]] || continue

          session_name=$(basename "$session_path")

          tmux-sessionizer "$session_path"

          tmux has-session -t "$session_name" 2>/dev/null || continue

          window=$(tmux list-windows -t "$session_name" -F "#{window_index}" | head -n1)
          window_ref="$session_name:$window"

          IFS=';' read -ra cmd_array <<< "$cmds"

          current=$(tmux list-panes -t "$window_ref" -F "#{pane_index}" | wc -l)

          # ensure pane count
          while (( current < pane_count )); do
            tmux split-window -h -t "$window_ref" -c "$session_path"
            current=$((current + 1))
          done

          tmux select-layout -t "$window_ref" >/dev/null 2>&1 || true

          # restore commands per pane
          pane_idx=0
          for cmd in "$${cmd_array[@]}"; do
            target="$window_ref.$pane_idx"

            case "$cmd" in
              nvim)
                tmux send-keys -t "$target" "nvim ." C-m
                ;;
              *)
                # leave shell as-is
                ;;
            esac

            pane_idx=$((pane_idx + 1))
          done

        done < "$file"

        # kill default session "0"
        tmux has-session -t "0" 2>/dev/null && tmux kill-session -t "0"

      '')
    ];

    # plain files
    file = {
      # ".screenrc".source = dotfiles/screenrc;

      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    # forceing because stylix is dumb
    pointerCursor = {
      enable = true;

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
    # ./wallpaper-random.nix
  ];

  wayland.windowManager.hyprland = {
    systemd.enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    # enable = true;
  };

  home.file.".config/hypr/hyprland.lua".source = ./extra/hyprland.lua;

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

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = lib.mkForce [myfont];
        sansSerif = lib.mkForce [myfont];
        serif = lib.mkForce [myfont];
        emoji = lib.mkForce ["Noto Color Emoji"];
      };
    };
  };

  programs = {
    vesktop = {
      enable = true;
      vencord.extraQuickCss = ''
        @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-blue.theme.css");
        @import url("https://allpurposemat.codeberg.page/Disblock-Origin/DisblockOrigin.theme.css");
        :root {
          /* show the GIF picker button */
          --display-gif-button: unset;
          --display-sticker-button: unset;
          --display-messages-button: unset;
        }
      '';
      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        notifyAboutUpdates = true;

        plugins = {
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          ForceOwnerCrown.enabled = true;
          CommandsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          UserSettingsAPI.enabled = true;
          AnonymiseFileNames.enabled = true;
          BetterSessions.enabled = true;
          CallTimer.enabled = true;
          CharacterCounter.enabled = true;
          CopyStickerLinks.enabled = true;
          CrashHandler.enabled = true;
          FakeNitro = {
            enabled = true;
            FakeEenableStickerBypass = true;
            enableStreamQualityypass = true;
            enableEmojiBypass = true;
            transformEmojis = true;
            transformStickes = true;
          };
          IgnoreActivities.enabled = true;
          MemberCount = {
            enabled = true;
            memberList = true;
            toolTip = true;
            voiceActivity = true;
          };
          MessageClickActions.enabled = true;
          NoBlockedMessages.enabled = true;
          QuickReply.enabled = true;
          WebKeybinds = {
            enabled = true;
            showNavigationButtons = true;
            overrideCommonKeybinds = true;
          };
          BadgeAPI.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          DisableDeepLinks.enabled = true;
          NoticesAPI.enabled = true;
          YoutubeAdblock.enabled = true;
        };
      };
    };

    starship = {
      enable = true;
      settings = {
        format = concatStrings [
          "$directory "
          "$shell"
          "$git_branch$git_status"
          "$nix_shell "
          "$golang$nodejs$python$rust "
          "$cmd_duration"
          "$line_break"
          "~> $username@$hostname "
          "$character"
        ];

        add_newline = true;

        username = {
          style_user = "fg:#89b4fa";
          format = "[$user]($style)";
          show_always = true;
        };

        hostname = {
          style = "fg:#b4befe";
          format = "[$ssh_symbol$hostname]($style)";
          ssh_only = false;
        };

        directory = {
          style = "fg:#f5c2e7";
          format = "[](fg:#f5c2e7)[ $path](fg:#11111b bg:#f5c2e7)[](fg:#f5c2e7)";
          # fish_style_pwd_dir_length = 3;
          # truncation_length = 0;
          truncate_to_repo = false;
          truncation_symbol = "";
        };

        shell = {
          disabled = false;
          # fish_indicator = "🐟";
        };

        git_branch = {
          symbol = "  ";
          style = "fg:#a6e3a1";
          format = "[$symbol$branch]($style) ";
        };

        git_status = {
          style = "fg:#f38ba8";
          format = "([$all_status$ahead_behind]($style))";
          conflicted = "🏳️ ";
          ahead = "⇡$count ";
          behind = "⇣$count ";
          diverged = "⇕⇡$ahead_count⇣$behind_count ";
          untracked = "?$count ";
          stashed = "📦 ";
          modified = "!$count ";
          staged = "+$count ";
          renamed = "»$count ";
          deleted = "✘$count ";
        };

        nix_shell = {
          symbol = "❄️ ";
          style = "fg:#94e2d5";
          format = "[$symbol]($style)";
        };

        golang = {
          symbol = " ";
          style = "fg:#ffcc66";
          format = "[$symbol$version]($style)";
        };

        nodejs = {
          symbol = " ";
          style = "fg:#a6e3a1";
          format = "[$symbol$version]($style)";
        };

        python = {
          symbol = " ";
          style = "fg:#fab387";
          format = "[$symbol$version]($style)";
        };

        rust = {
          symbol = "🦀 ";
          style = "fg:#f7768e";
          format = "[$symbol$version]($style)";
        };

        cmd_duration = {
          min_time = 500;
          style = "fg:#f9e2af";
          format = "⏱ [$duration]($style)";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[✗](bold red)";
          vimcmd_symbol = "[❮](bold green)";
          vimcmd_replace_one_symbol = "[❮](bold purple)";
          vimcmd_replace_symbol = "[❮](bold purple)";
          vimcmd_visual_symbol = "[❮](bold yellow)";
        };

        line_break = {
          disabled = false;
        };

        command_timeout = 1000;
        scan_timeout = 50;
      };
    };

    # fish = {
    #   enable = true;
    #   shellAbbrs = {
    #     gc = {
    #       position = "command";
    #       setCursor = "%";
    #       expansion = "git commit -am \"%\"";
    #     };
    #     gp = {
    #       expansion = "git push";
    #       position = "command";
    #     };
    #   };
    # };

    zoxide.enable = true;
    zoxide.enableZshIntegration = true;

    kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;

        dynamic_background_opacity = false;

        scroll_back = -1;
        mouse_hide_wait = 2.0;
        font_family = myfont;
        font_size = 13;
        enable_audio_bell = true;
        cursor_trail = 3;
        remember_window_size = "yes";
        allow_hyperlinks = "yes";
        shell_integration = "enabled";
      };
      # shellIntegration.enableFishIntegration = true;
    };

    rofi.enable = true;
    rofi.theme = "${pkgs.rofi}/share/rofi/themes/purple";

    waybar.enable = true;
    waybar.settings = import ./waybar-config.nix;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  stylix = {
    enable = true;
    targets = {
      kitty.enable = true;
      kitty.variant256Colors = true;
      waybar.enable = false;
      vesktop.enable = false;

      swaylock.enable = true;
      sway.enable = true;
      kde.enable = true;
      gtk.enable = true;
      qt.enable = true;
      qt.platform = "kde";
      rofi.enable = false;
    };
    base16Scheme = ./catppuccin-mocha.yaml;
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
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
    st = {
      name = "st";
      exec = "${pkgs.st}/bin/st";
      icon = "st";
      # categories = ["terminal"];
      terminal = false;
    };
  };

  xdg.configFile."mimeapps.list".force = true;
}
