# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
      #inputs.xremap-flake.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-695f8df6-9ca9-45ab-a495-ce49f4675b37".device = "/dev/disk/by-uuid/695f8df6-9ca9-45ab-a495-ce49f4675b37";
  networking.hostName = "vim"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Set your time zone.
  time.timeZone = "Asia/Hebron";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.enableAllFirmware = true;

  hardware.firmware = [
    pkgs.firmwareLinuxNonfree
  ];

  hardware.nvidia.open = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.envfs.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:swapescape";


    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
        nitrogen #background hehe
      ];
    };

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
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # gaming stuff
  programs.gamemode.enable = true;
  programs.steam.gamescopeSession.enable = true; # gamescope
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };
   services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia.modesetting.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xsharawi = {
    isNormalUser = true;
    description = "xsharawi";
    extraGroups = [ "networkmanager" "wheel" "gamemode" "libvirtd" "docker"  ];
    packages = with pkgs; [];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "xsharawi" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    keepassxc
    xclip
    firmwareLinuxNonfree
    gparted
    os-prober
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
    i3
    tmux
    chromium
    python3
    polybar
    rofi
    font-awesome_5
    rxvt-unicode
    alsa-utils
    mate.mate-power-manager
    nodejs_22
    picom
    pywal
    manrope
    libnotify
    gtk2
    gtk3
    gtk4
    gtkd
    gtk2-x11
    gtk3-x11
    discord
    pkg-config
    libsForQt5.kde-gtk-config
    libsForQt5.kdeplasma-addons
    libsForQt5.breeze-qt5
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-kde
    nixd
    nixdoc
    fastfetch
    zoxide
    zsh-powerlevel10k
    vlc
    zoom-us
    nmap
    lmms
    (lutris.override{
      extraPkgs = pkgs:[
        wineWowPackages.stable
        winetricks
      ];
    }
    )
    protonup-qt
    ksnip
    #minecraft
    # jdk17
    # javaPackages.openjfx17

    # cpp c stuff
    clangStdenv
    clang-tools_17
    clang_17
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

    winetricks
    gst_all_1.gstreamer
    qbittorrent
    jetbrains.rider

    yt-dlp
    bottles
    protonup
    dxvk
    filezilla

    go
    air
    htmx-lsp
    #gopls
    obs-studio
    bun
    veracrypt
    tree
    tokei
    docker-compose
    dolphin-emu
    retroarch
    retroarch-assets
    retroarch-joypad-autoconfig
    onlyoffice-bin
    graphite-cli
    screenkey
    zig
    networkmanagerapplet
    swaylock
    swaylock-effects
    pamixer
    kdePackages.krfb
    kdePackages.krdc
    pipes
    xfce.thunar
    xfce.thunar-archive-plugin
    libsForQt5.qt5ct
    #sweet-folders
    #candy-icons
    stdmanpages
    man-pages
    man-pages-posix
    clang-manpages
    unrar
    zip
    openjdk8
    openjfx
    jre8_headless
    jre8
    jdk8
    xorg.libXext
    xorg.libXxf86vm
    yazi
    obsidian
    firefox-bin
    emacs
    coreutils
    gimp
    jq
    wl-clipboard-x11
    pulseaudioFull
    postman
    rpcs3
    cbonsai
    ruby
    rubyPackages.solargraph
    rubyPackages.rexml
    google-chrome
    inputs.zen-browser.packages."${system}".default
    # ELIXIR MENTIONED
    elixir
    elixir-ls
    # OCAML MENTIONED
    ocaml
    mangohud
    pcsx2
    kdePackages.kdenetwork-filesharing
    samba4Full
    syncthing
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
    godot_4
    godot_4-mono
    gdtoolkit_4
    nerd-fonts.hack
    gopls
    kdePackages.qtwebsockets
    libsForQt5.qt5.qtwebsockets

    #newpackage
    wineWowPackages.stable

    # hyprland
    kdePackages.kwallet-pam
    waybar
    wofi
    hyprpicker
    swaynotificationcenter
    notion-app-enhanced
    cliphist
    wl-clip-persist
    wl-clipboard
    hyprcursor
    hyprshot
    hyprpicker
    shotman
    slurp
    brightnessctl
    grim
    grimblast
    (vesktop.overrideAttrs (finalAttrs: previousAttrs: {
      desktopItems = [
        ((builtins.elemAt previousAttrs.desktopItems 0).override { icon = "discord"; })
      ];
    }))
  ];
  security.pam.services.swaylock = { };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.kdeconnect.enable = true;

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };
  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      enable = true;
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  xdg = {
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

  users.defaultUserShell = pkgs.zsh;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };


  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    #add any missing dynamic libraries for unpackaged programs here not in enviroment.systempackages
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



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "daily";
    randomizedDelaySec = "45min";
  };

  # direnv
  programs.direnv.enable = true;
  # vms
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.docker.enable = true;

  # # # stylix
  stylix.enable = true;
  stylix.image = ./wallpapers/zoz.png;
  stylix.polarity = "dark";
  # stylix.cursor.package = pkgs.banana-cursor;
  # stylix.cursor.name = "banana-cursor";
  # stylix.cursor.size = 40;
  stylix.fonts.sizes.applications = 10;
  stylix.fonts.sizes.desktop = 8;

  #home-manager.backupFileExtension = "ffs just work";

  # # xremap
  # services.xremap = {
  #   withX11 = true;
  #   serviceMode = "user";
  #   watch = true;
  #   userName = "xsharawi";
  #   config = {
  #     modmap = [
  #       {
  #         name = "caps unlimited caps but no caps";
  #         remap = {
  #           "CapsLock" = { "held" = "leftctrl"; "alone" = "esc"; "alone_timeout_millis" = 200; };
  #         };
  #       }
  #     ];
  #   };
  # };

    services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "overload(control, esc)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
            esc = "esc"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
          };
          otherlayer = {};
        };
        extraConfig = ''
          # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part
        '';
      };
    };
  };


  qt.enable = true;
  qt.style = "breeze";
  qt.platformTheme = "qt5ct";
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  # flat
  services.flatpak.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
