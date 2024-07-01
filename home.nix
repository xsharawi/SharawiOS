{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "xsharawi";
  home.homeDirectory = "/home/xsharawi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
     (pkgs.writeShellScriptBin "up" ''
       sudo nixos-rebuild switch --flake /etc/nixos#vim
     '')
  ];

  # home.file."bin/tmux-mem-cpp".source = ./tmux-mem-cpp;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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
  home.sessionVariables = {
    # EDITOR = "emacs";
  };


      # wayland.windowManager.hyprland = {
      #
      #   systemd.enable = true;
      #   xwayland.enable = true;
      #   enable = true;
      #   settings = {
      #     # Autostart.
      #     debug = {
      #       disable_logs = true;
      #     };
      #     exec-once = [
      #       "systemctl --user import-environment &"
      #       "hash dbus-update-activation-environment 2>/dev/null &"
      #       "dbus-update-activation-environment --systemd &"
      #       "wl-clip-persist --clipboard both"
      #       # add a wallpaper
      #       # "sleep 1 && swaylock"
      #       # "poweralertd &"
      #       # "waybar &"
      #       # "mako &"
      #     ];
      #
      #     input = {
      #       kb_layout = "us";
      #       kb_options = "caps:escape";
      #       repeat_delay = 200;
      #       repeat_rate = 30;
      #       #accel_profile = "flat";
      #       numlock_by_default = true;
      #       follow_mouse = 0;
      #       sensitivity = 1;
      #     };
      #
      #     general = {
      #       "$mainMod" = "SUPER";
      #       layout = "master";
      #       gaps_in = 10;
      #       gaps_out = 20;
      #       border_size = 2;
      #       border_part_of_window = true;
      #       no_border_on_floating = true;
      #       # find the default ones
      #       #col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      #       #col.inactive_border = "rgba(595959aa)";
      #     };
      #
      #     misc = {
      #       # disable_autoreload = true;
      #       disable_hyprland_logo = true;
      #       #   always_follow_on_dnd = true;
      #       #   layers_hog_keyboard_focus = true;
      #       animate_manual_resizes = true;
      #       enable_swallow = true;
      #       #   focus_on_activate = true;
      #     };
      #
      #     decoration = {
      #       rounding = 0;
      #       active_opacity = 1;
      #       inactive_opacity = 0.80;
      #       fullscreen_opacity = 1.0;
      #
      #       blur = {
      #         enabled = true;
      #         size = 1;
      #         passes = 1;
      #         # size = 4;
      #         # passes = 2;
      #         brightness = 1;
      #         contrast = 1.400;
      #         ignore_opacity = true;
      #         noise = 0;
      #         new_optimizations = true;
      #         xray = true;
      #       };
      #
      #       drop_shadow = true;
      #
      #       shadow_ignore_window = true;
      #       shadow_offset = "0 2";
      #       shadow_range = 20;
      #       shadow_render_power = 3;
      #       "col.shadow" = "rgba(00000055)";
      #     };
      #
      #     animations = {
      #       enabled = true;
      #
      #       bezier = [
      #         "fluent_decel, 0, 0.2, 0.4, 1"
      #         "easeOutCirc, 0, 0.55, 0.45, 1"
      #         "easeOutCubic, 0.33, 1, 0.68, 1"
      #         "easeinoutsine, 0.37, 0, 0.63, 1"
      #       ];
      #
      #       animation = [
      #         # Windows
      #         "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
      #         "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
      #         "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.
      #
      #         # Fade
      #         "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
      #         "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
      #         "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
      #         "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
      #         "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
      #         "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
      #         "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
      #         "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
      #       ];
      #     };
      #     # bindd = [
      #     #   "$mainMod, Q, Close active, killactive,"
      #     #   "$mainMod, SHIFT + Space, Toggle floating, togglefloating,"
      #     # ];
      #     bind = [
      #       # show keybinds list
      #       # "$mainMod, S, exec, show-keybinds"
      #
      #       "$mainMod, Q, killactive,"
      #       "$mainMod, SHIFT + Space, togglefloating,"
      #       # keybindings
      #       # TODO add these binds:
      #       # "$mainMod SHIFT, Escape, Hard kill, exec, shutdown-script"
      #
      #       "$mainMod, Return, exec, $TERMINAL"
      #       #"$mainMod, B, exec, hyprctl dispatch exec '[workspace 2 silent] librewolf'"
      #       "$mainMod, F, Fullscreen, fullscreen, 0"
      #       # "$mainMod SHIFT, F, fullscreen, 1"
      #       "$mainMod, Space, exec, pkill rofi || rofi --show drun"
      #       # "$mainMod SHIFT, D, exec, hyprctl dispatch exec '[workspace 4 silent] discord'"
      #       # "$mainMod SHIFT, S, exec, hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"
      #       # "$mainMod, Print, exec, ${pkgs.grim}/bin/grim -s \"$(${pkgs.slurp}/bin/slurp -w 0)\" -t png - | ${pkgs.wl-clipboard}/bin/wl-copy"
      #       "$mainMod, Print, exec, ${pkgs.grim}/bin/grim -s \"$(slurp -w 0)\" -t png - | ${pkgs.wl-clipboard}/bin/wl-copy"
      #       # "$mainMod, P, pseudo,"
      #       # "$mainMod, J, togglesplit,"
      #       "$mainMod, C ,exec, hyprpicker -a"
      #
      #       # screenshot
      #       # "$mainMod, Print, exec, grimblast --notify --cursor save area ~/Pictures/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
      #       # ",Print, exec, grimblast --notify --cursor  copy area"
      #
      #       # switch focus
      #       "$mainMod, H, movefocus, l"
      #       "$mainMod, L, movefocus, r"
      #       "$mainMod, K, movefocus, u"
      #       "$mainMod, J, movefocus, d"
      #
      #       # switch workspace
      #       "$mainMod, 1, workspace, 1"
      #       "$mainMod, 2, workspace, 2"
      #       "$mainMod, 3, workspace, 3"
      #       "$mainMod, 4, workspace, 4"
      #       "$mainMod, 5, workspace, 5"
      #       "$mainMod, 6, workspace, 6"
      #       "$mainMod, 7, workspace, 7"
      #       "$mainMod, 8, workspace, 8"
      #       "$mainMod, 9, workspace, 9"
      #       "$mainMod, 0, workspace, 10"
      #
      #       # same as above, but switch to the workspace
      #       "$mainMod SHIFT, 1, movetoworkspacesilent, 1" # movetoworkspacesilent
      #       "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      #       "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      #       "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      #       "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      #       "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      #       "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      #       "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      #       "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      #       "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      #       "$mainMod CTRL, c, movetoworkspace, empty"
      #
      #       # window control
      #       "$mainMod SHIFT, H, movewindow, l"
      #       "$mainMod SHIFT, L, movewindow, r"
      #       "$mainMod SHIFT, K, movewindow, u"
      #       "$mainMod SHIFT, J, movewindow, d"
      #       "$mainMod CTRL, H, resizeactive, -80 0"
      #       "$mainMod CTRL, L, resizeactive, 80 0"
      #       "$mainMod CTRL, K, resizeactive, 0 -80"
      #       "$mainMod CTRL, J, resizeactive, 0 80"
      #       "$mainMod ALT, H, moveactive,  -80 0"
      #       "$mainMod ALT, L, moveactive, 80 0"
      #       "$mainMod ALT, K, moveactive, 0 -80"
      #       "$mainMod ALT, J, moveactive, 0 80"
      #
      #       # media and volume controls
      #       # ",Equal,exec, pamixer -i 2"
      #       # ",Minus,exec, pamixer -d 2"
      #       # ",XF86AudioMute,exec, pamixer -t"
      #       # ",XF86AudioPlay,exec, playerctl play-pause"
      #       # ",XF86AudioNext,exec, playerctl next"
      #       # ",XF86AudioPrev,exec, playerctl previous"
      #       # ",XF86AudioStop, exec, playerctl stop"
      #       # "$mainMod, mouse_down, workspace, e-1"
      #       # "$mainMod, mouse_up, workspace, e+1"
      #
      #       # clipboard manager
      #       "$mainMod, V, exec, cliphist list | ${pkgs.rofi-wayland}/bin/rofi --dmenu | cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
      #     ];
      #
      #     # mouse binding
      #     bindm = [
      #       "$mainMod, mouse:272, movewindow"
      #       "$mainMod, mouse:273, resizewindow"
      #     ];
      #
      #     windowrulev2 = [
      #       # Hide border on unfocused windows
      #       "noborder, focus:0"
      #
      #       "suppressevent maximize, class:.*"
      #
      #       "float, title:^(Picture-in-Picture)$"
      #       "opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$"
      #       "pin, title:^(Picture-in-Picture)$"
      #       "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
      #       "opacity 1.0 override 1.0 override, title:^(.*mpv.*)$"
      #       "opacity 1.0 override 1.0 override, class:(Aseprite)"
      #       "opacity 1.0 override 1.0 override, class:(Unity)"
      #       "idleinhibit focus, class:^(mpv)$"
      #       "idleinhibit fullscreen, class:^(firefox)$"
      #       "float,class:^(pavucontrol)$"
      #       "float,class:^(SoundWireServer)$"
      #       "float,class:^(.sameboy-wrapped)$"
      #       "float,class:^(file_progress)$"
      #       "float,class:^(confirm)$"
      #       "float,class:^(dialog)$"
      #       "float,class:^(download)$"
      #       "float,class:^(notification)$"
      #       "float,class:^(error)$"
      #       "float,class:^(confirmreset)$"
      #       "float,title:^(Open File)$"
      #       "float,title:^(branchdialog)$"
      #       "float,title:^(Confirm to replace files)$"
      #       "float,title:^(File Operation Progress)$"
      #     ];
      #   };
      #
      #   extraConfig = "
      #      monitor=, highres@highrr, auto, 1
      #      xwayland {
      #        force_zero_scaling = true
      #      }
      #   ";
      # };

   #also virt
   dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
