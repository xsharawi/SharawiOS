let
  cmd = "start-hyprland";
in {
  services.greetd = {
    enable = true;
    settings = {
      # Session on first login which would use auto-login
      initial_session = {
        user = "xsharawi";
        command = cmd;
      };
      # All other sessions
      default_session = {
        command = "tuigreet --cmd ${cmd}";
        user = "greeter";
      };
    };
  };
}
