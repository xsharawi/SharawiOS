{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkAfter;
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
