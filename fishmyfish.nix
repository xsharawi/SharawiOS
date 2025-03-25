{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) concatStrings mkAfter;
in
{

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
        # begin left format
        "$username"
        "$hostname"
        "$directory[](1234) "
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        # end left format
        "$fill"
        # begin right format
        # "[](${dir_bg})"
        # "[ ](${accent_style})"
        "$time"
        # end right format
        "$line_break"
        "$character"
      ];
      add_newline = false;
      line_break = {
        disabled = false;
      };
      command_timeout = 1300;
      scan_timeout = 50;
      character = {
        #success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };

  };

  programs.fish = {
    # fix starship prompt to only have newlines after the first command
    # https://github.com/starship/starship/issues/560#issuecomment-1465630645
    shellInit = # fish
      ''
        # shut up welcome message
        set fish_greeting

        function prompt_newline --on-event fish_postexec
          echo ""
        end
        zoxide init fish --cmd cd | source
      '';
    interactiveShellInit =
      # fish
      mkAfter ''
        function starship_transient_prompt_func
          starship module character
        end
      '';
    enable = true;
  };

}
