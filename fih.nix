{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (lib) concatStrings mkAfter;
in {
  environment.systemPackages = with pkgs; [
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    starship
  ];

  programs.starship = {
    enable = true;
    settings = {
      format = concatStrings [
        "$directory "
        "$nix_shell "
        "$golang$nodejs$python$rust "
        "$git_branch$git_status "
        "$fill"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      add_newline = false;

      username = {
        style_user = "fg:#89b4fa";
        show_always = true;
      };

      hostname = {
        style = "fg:#b4befe";
        ssh_only = false;
      };

      directory = {
        style = "fg:#f5c2e7";
        format = "[](fg:#f5c2e7)[ $path](fg:#11111b bg:#f5c2e7)[](fg:#f5c2e7)";
        truncation_length = 10;
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
        format = "[$symbol$name]($style)";
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
      };

      line_break = {
        disabled = false;
      };

      command_timeout = 1000;
      scan_timeout = 50;
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
      zoxide init fish --cmd cd | source
      fish_add_path /usr/local/sbin /usr/local/bin /usr/bin
      fish_add_path ~/.cargo/bin ~/.local/bin ~/.bun/bin ~/bin
      set -gx BUN_INSTALL ~/.bun
      set -gx FZF_DEFAULT_COMMAND 'fd --exclude node_modules --hidden --exclude .git --exclude .svn --exclude .hg'
      set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
      set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git --exclude .svn --exclude .hg'

      direnv hook fish | source



    '';
    interactiveShellInit = mkAfter ''
      function starship_transient_prompt_func
        starship module character
      end

      bind -M insert ctrl-y accept-autosuggestion

      alias ls='eza --icons --git'
      alias cdd='cd -'
      alias grep='grep --color=auto'
      alias nd='nix develop -c $SHELL'
      alias nr='nix run .'
      alias ping='ping -O'
      alias dcup='docker compose up'
      alias dc='docker compose'
      alias fastfetch='fastfetch --logo ~/nixos.png --logo-height 20 --logo-width 40'

      function ydl
        yt-dlp -o '/Sync/%(title)s.%(ext)s' -f 'ba' -x --audio-format mp3 $argv
      end

      function ydlp
        yt-dlp -o '/Sync/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' -f 'bv*[height=1080]+ba' $argv
      end

      # Edit current command in vim with Ctrl+E
      bind ctrl-e 'commandline -e nvim'

      set -gx FZF_DEFAULT_OPTS '--cycle --height 40% --border --reverse'

    '';
  };
}
