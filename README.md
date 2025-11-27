# Install:
probably just install nixos normally and add flakes with 
`nix.settings.experimental-features = [ "nix-command" "flakes" ];`
then just simply do the same thing in updating.

# Updating:
`sudo nix flake update` -> `up` (or `sudo nixos-rebuild switch --flake /etc/nixos#vim`)

# current setup:
this setup includes flakes, home-manager, stylix, some i3wm and hyprland configs, zsh and auto updates!

# shoutouts

- (Vimjoyer: the goat himself who got me into nix)[https://github.com/vimjoyer/]
- (Iynaix: unlimited help)[https://github.com/iynaix/]
- (Raf: owner of Raf Inc, Founder of Rafware and creator of nvf)[https://github.com/NotAShelf/]
- (Jet: goated config filled with sauce)[https://github.com/Michael-C-Buckley/]
