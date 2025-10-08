{pkgs, ...}: {
  services.espanso.enable = true;
  services.espanso.package = pkgs.espanso-wayland;
  security.wrappers.espanso = {
    owner = "root";
    group = "root";
    capabilities = "cap_dac_override+ep";
    source = "${pkgs.espanso-wayland}/bin/espanso";
  };
}
