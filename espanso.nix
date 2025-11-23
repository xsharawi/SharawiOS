{
  pkgs,
  lib,
  ...
}: {
  services.espanso.enable = true;
  services.espanso.package = pkgs.espanso-wayland;
  # security.wrappers.espanso = {
  #   owner = "root";
  #   group = "root";
  #   capabilities = "cap_dac_override+ep";
  #   source = lib.mkForce "${pkgs.espanso-wayland}/bin/espanso";
  # };
}
