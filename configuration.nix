{
  config,
  pkgs,
  inputs,
  nvf,
  lib,
  ...
}: let
  retroarchWithCores = (
    pkgs.retroarch.withCores (
      cores:
        with cores; [
          bsnes
          mgba
          quicknes
        ]
    )
  );
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./fih.nix
    ./espanso.nix
    ./wireshark.nix
    ./greetmytui.nix
  ];
  programs.nvf.enable = true;
  programs.nvf.settings = import ./nvf.nix;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.initrd.luks.devices."luks-695f8df6-9ca9-45ab-a495-ce49f4675b37".device = "/dev/disk/by-uuid/695f8df6-9ca9-45ab-a495-ce49f4675b37";
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  services.dbus.implementation = "broker";

  networking.hostName = "vim"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nh
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  # Set your time zone.
  time.timeZone = "Asia/Hebron";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.enableAllFirmware = true;

  hardware.firmware = [
    pkgs.linux-firmware
  ];

  hardware.nvidia.open = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # gui
  services.displayManager.defaultSession = "hyprland";
  services.envfs.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.options = "caps:swapescape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
      };
    };
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # gaming stuff
  programs.gamemode.enable = true;
  programs.steam.gamescopeSession.enable = true; # gamescope
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xsharawi = {
    isNormalUser = true;
    description = "xsharawi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "libvirtd"
      "docker"
      "samba"
      "syncthing"
      "input"
      "wireshark"
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "xsharawi" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    keepassxc
    xclip
    linux-firmware
    gparted
    grub2
    clang
    rustup
    cargo
    gcc
    fzf
    fd
    fzf-zsh
    ripgrep
    gnumake
    unzip
    curl
    zsh
    openssl
    tmux
    python3
    font-awesome_5
    rxvt-unicode
    alsa-utils
    nodejs_22
    libnotify
    gtk3
    gtk4
    gtk3-x11
    pkg-config
    kdePackages.kde-gtk-config
    kdePackages.xdg-desktop-portal-kde
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    nixd
    nixdoc
    nixfmt-rfc-style
    fastfetch
    zoxide
    zsh-powerlevel10k
    vlc
    nmap
    protonup-qt
    ksnip

    clangStdenv
    llvmPackages.libcxxClang
    cppcheck
    libllvm
    valgrind
    libcxx
    glm
    SDL2
    SDL2_gfx
    binutils
    glibc
    cmake
    devenv

    winetricks
    gst_all_1.gstreamer
    qbittorrent

    yt-dlp
    protonup-ng
    dxvk
    filezilla

    go
    air
    htmx-lsp
    obs-studio
    veracrypt
    tree
    tokei
    docker-compose
    retroarchWithCores
    retroarch-assets
    retroarch-joypad-autoconfig
    onlyoffice-desktopeditors
    graphite-cli
    screenkey
    zig
    zls
    networkmanagerapplet
    swaylock
    swaylock-effects
    kdePackages.krfb
    kdePackages.krdc
    pipes
    libsForQt5.qt5ct
    stdmanpages
    man-pages
    man-pages-posix
    clang-manpages
    unrar
    zip
    openjdk8
    jre8
    jdk8
    xorg.libXext
    xorg.libXxf86vm
    yazi
    obsidian
    emacs
    coreutils
    gimp
    jq
    wl-clipboard-x11
    pulseaudioFull
    postman
    pcsx2
    cbonsai
    ruby
    rubyPackages.solargraph
    rubyPackages.rexml
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.ghostty.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.dark-text.packages.${pkgs.stdenv.hostPlatform.system}.default
    elixir
    elixir-ls
    ocaml
    mangohud
    kdePackages.kdenetwork-filesharing
    fuse
    alsa-lib
    atk
    cairo
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    nspr
    nss
    stdenv.cc.cc
    zlib
    libuuid
    wezterm
    p7zip
    solaar
    logitech-udev-rules
    logiops
    godot
    gopls
    kdePackages.qtwebsockets
    libsForQt5.qt5.qtwebsockets
    playerctl
    pavucontrol
    sshfs
    entr
    libretro.gpsp
    osu-lazer-bin
    pamixer
    libinput
    eza
    nemo-with-extensions
    file
    odin
    quickshell
    bolt-launcher
    espanso-wayland
    busybox
    kdePackages.qt6ct
    tuigreet
    swayimg
    hyprpolkitagent
    tmuxPlugins.catppuccin
    kdePackages.ark
    font-awesome
    kdePackages.gwenview
    net-tools
    noto-fonts
    kdePackages.okular
    openvpn
    heroic

    #newpackage

    wineWowPackages.stable
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        winetricks
      ];
    })
    kdePackages.kwallet-pam
    waybar
    egl-wayland
    swaynotificationcenter
    cliphist
    wl-clip-persist
    wl-clipboard
    hyprcursor
    brightnessctl
    grimblast
    (vesktop.overrideAttrs (
      finalAttrs: previousAttrs: {
        desktopItems = [
          ((builtins.elemAt previousAttrs.desktopItems 0).override {icon = "discord";})
        ];
      }
    ))
    swww
  ];
  security.pam.services.swaylock = {};

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.kdeconnect.enable = true;

  services.openssh.allowSFTP = true;
  programs.ssh.askPassword = "";
  services.samba.enable = true;
  services.samba.usershares.enable = true;

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  xdg = {
    menus.enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
  };

  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "sudo"
          "terraform"
          "systemadmin"
          "vi-mode"
        ];
      };
    };
  };

  users.defaultUserShell = pkgs.fish;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    xorg.libXext
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXxf86vm
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXScrnSaver
    xwayland
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/xsharawi/.steam/root/compatibilitytools.d";
  };

  # por que maria???
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # direnv
  programs.direnv.enable = true;

  # vms
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.docker.enable = true;

  # stylix
  stylix.enable = true;
  stylix.base16Scheme = ./catppuccin-mocha.yaml;
  stylix.polarity = "dark";
  stylix.fonts.sizes.applications = 10;
  stylix.fonts.sizes.desktop = 8;

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  qt = {
    enable = true;
    style = lib.mkForce "breeze";
    platformTheme = lib.mkForce "kde";
  };
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  # flat
  services.flatpak.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  nix.package = pkgs.nixVersions.latest;

  fonts = {
    packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      defaultFonts = {
        serif = ["JetBrains Mono"];
        sansSerif = ["JetBrains Mono"];
        monospace = ["JetBrains Mono"];
      };
    };
  };
  environment.etc."/xdg/menus/plasma-applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  documentation.man.generateCaches = false;
  # FUCK YOUR ACCESSIBLITY MY SYSTEM IS ALREADY ACCESSIBLE ENOUGH
  services.speechd.enable = lib.mkForce false;
  services.orca.enable = lib.mkForce false;
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_17;

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
