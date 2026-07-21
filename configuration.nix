{
  pkgs,
  inputs,
  lib,
  ...
}: let
  retroarchWithCores = pkgs.retroarch.withCores (
    cores:
      with cores; [
        mesen
        bsnes
        sameboy
        gambatte
        mgba
        parallel-n64
        melonds
        citra
        dolphin
        genesis-plus-gx
        flycast
        beetle-psx
        pcsx2
        ppsspp
        beetle-vb
        gw
      ]
  );
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.mangowm.nixosModules.mango
    inputs.noctalia.nixosModules.default
    ./fih.nix
    ./greetmytui.nix
    ./espanso.nix
  ];
  programs = {
    git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "master";
        };
      };
    };
    mango.enable = true;
    nvf = {
      enable = true;
      settings = import ./nvf.nix;
    };

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
      libXext
      libX11
      libXrender
      libXtst
      libXi
      libXxf86vm
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXfixes
      libXrandr
      libXScrnSaver
      xwayland
    ];

    direnv.enable = true;
    virt-manager.enable = true;

    noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd.enable = true;
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = ["kvm-intel" "kvm-nvidia"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    initrd.luks.devices."luks-695f8df6-9ca9-45ab-a495-ce49f4675b37".device = "/dev/disk/by-uuid/695f8df6-9ca9-45ab-a495-ce49f4675b37";
    initrd.systemd.enable = true;
  };

  services = {
    elephant.enable = true;
    ratbagd.enable = true;

    power-profiles-daemon.enable = true;
    upower.enable = true;

    dbus.implementation = "broker";

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      xkb.layout = "us";
      xkb.options = "caps:swapescape";
      videoDrivers = ["nvidia"];
    };

    displayManager.defaultSession = "hyprland";
    envfs.enable = true;

    printing.enable = false;

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
    hostName = "vim";
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [8081 27031];
    firewall.trustedInterfaces = ["virbr0"];
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };

    optimise.automatic = true;
    settings.auto-optimise-store = true;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    package = pkgs.nixVersions.latest;
  };

  time.timeZone = "Asia/Hebron";

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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    keepassxc
    xclip
    linux-firmware
    gparted
    grub2
    clang
    clang-tools
    c-for-go
    rustup
    cargo
    gcc
    ccacheWrapper
    fzf
    fd
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
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    nixd
    nixdoc
    nixfmt
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
    networkmanagerapplet
    swaylock
    swaylock-effects
    pipes
    stdmanpages
    man-pages
    man-pages-posix
    clang-manpages
    unrar
    zip
    openjdk8
    jre8
    jdk8
    libXext
    libXxf86vm
    yazi
    obsidian
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
    beamPackages.elixir
    beamPackages.elixir-ls
    ocaml
    mangohud
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
    linux-wallpaperengine
    binaryninja-free
    st
    bun
    sqlite
    ghidra
    drawy
    dolphin-emu
    gopher64
    scrcpy
    woomer
    nix-search-tv
    nnd
    neovide
    terraform
    terraform-providers.dmacvicar_libvirt
    dnsmasq
    libvirt
    cdrkit
    gf
    dina-font
    ghostty
    jujutsu
    jj-fzf
    piper
    ddccontrol

    #newpackage

    wineWow64Packages.stable
    (lutris.override {
      buildFHSEnv = args:
        pkgs.buildFHSEnv (args
          // {
            multiPkgs = envPkgs: let
              # Fetch original package list
              originalPkgs = args.multiPkgs envPkgs;

              # Disable tests for openldap
              customLdap = envPkgs.openldap.overrideAttrs (_: {doCheck = false;});
            in
              # Replace broken openldap with the custom one
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [customLdap];
          });
      extraPkgs = pkgs: [
        pkgs.wineWow64Packages.stable
        pkgs.winetricks
      ];
    })
    waybar
    egl-wayland
    wl-clip-persist
    hyprcursor
    brightnessctl
    grimblast
    discord
    awww
    emacs
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

  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
      };
    };
  };

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

  documentation.man.cache.enable = false;

  # make a symlink of flake within the generation (e.g. /run/current-system/src)
  system.systemBuilderCommands = "ln -s ${inputs.self.sourceInfo.outPath} $out/src";

  # something something don't change unless new install something something
  system.stateVersion = "23.11";
}
