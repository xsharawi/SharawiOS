let
  cmd = "dbus-launch --exit-with-session start-hyprland";
in {
  services.greetd = {
    enable = true;
    settings = {
      unitConfig = {
        After = ["graphical-session.target"];
      };
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
