# Install:
    probably just install nixos normally and add flakes with 
    `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
    then just simply do the same thing in updating.

# Updating:
`sudo nix flake update` -> `up` (or `sudo nixos-rebuild switch --flake /etc/nixos#vim`)

# current setup:
    this setup includes flakes, home-manager, stylix, some i3wm and hyprland configs, zsh and auto updates!

