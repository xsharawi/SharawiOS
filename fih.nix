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
      starship init fish | source
      enable_transience

      bind -M insert ctrl-y accept-autosuggestion

      alias ls='eza -a --icons --git'
      alias ll='eza -l -a --icons --git'
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
      function catall
       for file in *
          echo
          echo file: $file
          cat -n $file
              end
      end


      bind -M insert ctrl-f "tmux-sessionizer"


      set -gx FZF_DEFAULT_OPTS '--cycle --height 40% --border --reverse'
      set -g EDITOR nvim

      set -g fish_color_comment magenta
      set -g fish_color_command brgreen
      set -g fish_color_param cyan
      set -g fish_color_selection 'green'  '--bold'  '--background=brblack'
      set -g fish_color_valid_path --underline

      gsettings set org.gnome.desktop.interface toolkit-accessibility false
      clear; fastfetch
    '';
  };
}
