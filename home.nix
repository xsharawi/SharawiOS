{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStrings;
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
      (pkgs.writeShellScriptBin "fih" ''
        ${lib.getExe pkgs.fish}
      '')

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
    ./wallpaper-random.nix
  ];

  wayland.windowManager.hyprland = {
    systemd.enable = true;
    xwayland.enable = true;
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

  programs = {
    starship = {
      enableNushellIntegration = true;
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
          fish_style_pwd_dir_length = 3;
          # truncation_length = 0;
          truncate_to_repo = false;
          truncation_symbol = "";
        };

        shell = {
          disabled = false;
          fish_indicator = "🐟";
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

    fish = {
      enable = true;
      shellAbbrs = {
        gc = {
          position = "command";
          setCursor = "%";
          expansion = "git commit -am \"%\"";
        };
        gp = {
          expansion = "git push";
          position = "command";
        };
      };
    };

    nushell = {
      enable = true;
      # for editing directly to config.nu
      extraConfig = ''
        # Common ls aliases and sort them by type and then name
        # Inspired by https://github.com/nushell/nushell/issues/7190
        def lla [...args] { ls -la ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def la  [...args] { ls -a  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def ll  [...args] { ls -l  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def l   [...args] { ls     ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        source ${./extra/.zoxide.nu}

        # Completions
        # mainly pieced together from https://www.nushell.sh/cookbook/external_completers.html

        # carapace completions https://www.nushell.sh/cookbook/external_completers.html#carapace-completer
        # + fix https://www.nushell.sh/cookbook/external_completers.html#err-unknown-shorthand-flag-using-carapace
        # enable the package and integration bellow
        let carapace_completer = {|spans: list<string>|
          carapace $spans.0 nushell ...$spans
          | from json
          | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
        }
        # some completions are only available through a bridge
        # eg. tailscale
        # https://carapace-sh.github.io/carapace-bin/setup.html#nushell
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

        # fish completions https://www.nushell.sh/cookbook/external_completers.html#fish-completer
        let fish_completer = {|spans|
          ${lib.getExe pkgs.fish} --command $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
        }

        # zoxide completions https://www.nushell.sh/cookbook/external_completers.html#zoxide-completer
        let zoxide_completer = {|spans|
            $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
        }

        # multiple completions
        # the default will be carapace, but you can also switch to fish
        # https://www.nushell.sh/cookbook/external_completers.html#alias-completions
        let multiple_completers = {|spans|
          ## alias fixer start https://www.nushell.sh/cookbook/external_completers.html#alias-completions
          let expanded_alias = scope aliases
          | where name == $spans.0
          | get -o 0.expansion

          let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
          } else {
            $spans
          }
          ## alias fixer end

          match $spans.0 {
            __zoxide_z | __zoxide_zi => $zoxide_completer
            _ => $carapace_completer
          } | do $in $spans
        }

        $env.config = {
          edit_mode: 'vi'
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true           # set to false to prevent auto-selecting completions
            partial: true         # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $multiple_completers
            }
          }
        }
        $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/xsharawi/.apps |
          append /usr/bin/env
        )
      '';
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };
    };

    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    zoxide.enableNushellIntegration = true;
    zoxide.enable = true;

    kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;

        dynamic_background_opacity = false;

        scroll_back = -1;
        mouse_hide_wait = 2.0;
        font_family = "JetBrainsMono Nerd Font";
        font_size = 13;
        enable_audio_bell = true;
        cursor_trail = 3;
        remember_window_size = "yes";
        allow_hyperlinks = "yes";
        shell_integration = "enabled";
      };
      shellIntegration.enableFishIntegration = true;
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
