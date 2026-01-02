{
  pkgs,
  inputs,
  lib,
  ...
}: let
  retroarchWithCores = pkgs.retroarch.withCores (
    cores:
      with cores; [
        bsnes
        mgba
        quicknes
      ]
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
  programs = {
    nvf = {
      enable = true;
      settings = import ./nvf.nix;
    };

    # nh
    nh = {
      enable = true;
      flake = "/etc/nixos";
    };
    dconf.enable = true;

    # gaming stuff
    gamemode.enable = true;
    steam.gamescopeSession.enable = true;

    hyprland.enable = true;
    hyprland.xwayland.enable = true;
    kdeconnect.enable = true;
    ssh.askPassword = "";

    thunar.enable = true;
    xfconf.enable = true;
    thunar.plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];

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

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
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

    # direnv
    direnv.enable = true;
    virt-manager.enable = true;
  };
  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    initrd.luks.devices."luks-695f8df6-9ca9-45ab-a495-ce49f4675b37".device = "/dev/disk/by-uuid/695f8df6-9ca9-45ab-a495-ce49f4675b37";
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };
  services = {
    dbus.implementation = "broker";
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      xkb.layout = "us";
      xkb.options = "caps:swapescape";
      videoDrivers = ["nvidia"];
    };

    # gui
    displayManager.defaultSession = "hyprland";
    envfs.enable = true;

    # Enable CUPS to print documents.
    printing.enable = false;
    # Enable sound with pipewire.
    pipewire = {
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

    openssh.allowSFTP = true;
    samba.enable = true;
    samba.usershares.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;

    # por que maria???
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    # flat
    flatpak.enable = true;

    syncthing = {
      enable = true;
      openDefaultPorts = true;
    };

    # FUCK YOUR ACCESSIBLITY MY SYSTEM IS ALREADY ACCESSIBLE ENOUGH
    speechd.enable = lib.mkForce false;
    orca.enable = lib.mkForce false;
    postgresql.enable = true;
    postgresql.package = pkgs.postgresql_17;
  };
  networking = {
    hostName = "vim"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [8081 27031];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
  nix = {
    # flakes
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    optimise.automatic = true;
    settings.auto-optimise-store = true;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    package = pkgs.nixVersions.latest;

    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  # Set your time zone.
  time.timeZone = "Asia/Hebron";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  hardware = {
    enableAllFirmware = true;

    firmware = [
      pkgs.linux-firmware
    ];

    nvidia.open = false;
    nvidia.modesetting.enable = true;
    opentabletdriver.enable = true;
    opentabletdriver.daemon.enable = true;
  };
  security = {
    rtkit.enable = true;
    pam.services.swaylock = {};

    pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
  };

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
  nixpkgs.config.android_sdk.accept_license = true;

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
    android-studio
    android-studio-tools
    kubernetes
    zed-editor

    #newpackage

    wineWowPackages.stable
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.stable
        pkgs.winetricks
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
    vesktop
    swww
  ];

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

  users.defaultUserShell = pkgs.fish;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/xsharawi/.steam/root/compatibilitytools.d";
  };

  # vms
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  # stylix
  stylix = {
    enable = true;
    base16Scheme = ./catppuccin-mocha.yaml;
    polarity = "dark";
    fonts.sizes.applications = 10;
    fonts.sizes.desktop = 8;
  };

  qt = {
    enable = true;
    style = lib.mkForce "breeze";
    platformTheme = lib.mkForce "kde";
  };

  fonts = {
    packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      defaultFonts = {
        serif = ["JetBrainsMono Nerd Font"];
        sansSerif = ["JetBrainsMono Nerd Font"];
        monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };

  documentation.man.generateCaches = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
