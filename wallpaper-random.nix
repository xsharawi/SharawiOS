{
  config,
  pkgs,
  ...
}: let
  randomWallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    WALLPAPER_DIR="$HOME/wallpapers"
    IMG=$(find "$WALLPAPER_DIR" -type f | shuf -n1)
    if [ -n "$IMG" ]; then
      ${pkgs.swww}/bin/swww img "$IMG"
    else
      echo "No wallpaper found in $WALLPAPER_DIR" >&2
    fi
  '';
in {
  systemd.user.services.random-wallpaper = {
    Unit = {
      Description = "Set a random wallpaper using swww (user service)";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${randomWallpaper}/bin/random-wallpaper";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  systemd.user.timers.random-wallpaper = {
    Unit = {
      Description = "Change wallpaper periodically (user timer)";
    };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "30min";
      Persistent = true;
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
