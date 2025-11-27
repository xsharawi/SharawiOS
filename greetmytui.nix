{
  services.greetd = {
    enable = true;
    settings = {
      # Session on first login which would use auto-login
      initial_session = {
        user = "xsharawi";
        command = "hyprland";
      };
      # All other sessions
      default_session = {
        command = "tuigreet --cmd hyprland";
        user = "greeter";
      };
    };
  };
}
