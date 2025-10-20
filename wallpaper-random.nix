{
  config,
  pkgs,
  ...
}: let
  randomWallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    WALLPAPER_DIR="/home/xsharawi/wallpapers"
    IMG=$(find "$WALLPAPER_DIR" -type f | shuf -n1)
    if [ -n "$IMG" ]; then
      ${pkgs.swww}/bin/swww img "$IMG"
    else
      echo "No wallpaper found in $WALLPAPER_DIR" >&2
    fi
  '';
in {
  systemd.user.services.random-wallpaper = {
    description = "Set a random wallpaper using swww (user service)";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${randomWallpaper}/bin/random-wallpaper";
    };
    wantedBy = ["default.target"];
  };

  systemd.user.timers.random-wallpaper = {
    description = "Change wallpaper periodically (user timer)";
    wants = ["random-wallpaper.service"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "30min";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };
}
