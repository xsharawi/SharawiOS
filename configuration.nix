# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.xremap-flake.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vim"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  hardware.enableAllFirmware = true;

  hardware.firmware = [
    pkgs.firmwareLinuxNonfree
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.package = pkgs.bluez;
  services.blueman.enable = true;
  # systemd.user.services.mpris-proxy = {
  #     description = "Mpris proxy";
  #     after = [ "network.target" "sound.target" ];
  #     wantedBy = [ "default.target" ];
  #     serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Hebron";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        extraPlugins = {
          vim-tmux-navigator = {
            package = pkgs.vimPlugins.vim-tmux-navigator;
          };
        };

        viAlias = true;
        vimAlias = true;
        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };

        undoFile.enable = true;

        navigation.harpoon = {
          enable = true;

          mappings = {
            file1 = "<leader>j";
            file2 = "<leader>k";
            file3 = "<leader>l";
            file4 = "<leader>;";
            listMarks = "<leader>hh";
            markFile = "<leader>ha";
          };

          setupOpts = {
            defaults = {
              save_on_toggle = true;
              sync_on_ui_close = true;
            };
          };
        };

        options = {
          shiftwidth = 4;
          tabstop = 4;
          mouse = "a";
          softtabstop = 4;
          expandtab = true;
          autoindent = true;
          smartindent = true;
          breakindent = true;
          hlsearch = true;
          incsearch = true;
          ignorecase = true;
          smartcase = true;
        };

        autocomplete = {
          blink-cmp = {
            enable = true;
            setupOpts = {
              signature.enabled = true;
              sources = {
                default = [
                  "snippets"
                  "lsp"
                  "path"
                  "buffer"
                ];
              };
              completion = {
                documentation = {
                  auto_show = true;
                  auto_show_delay_ms = 0;
                };
              };
            };
            mappings = {
              confirm = "<C-y>";
              next = "<C-n>";
              previous = "<C-p>";
            };
          };
        };

        git = {
          enable = true;
          gitsigns = {
            enable = true;
          };
        };

        statusline = {
          lualine = {
            enable = true;
            # theme = lib.mkForce "onedark";
            theme = lib.mkForce "catppuccin";
          };
        };

        telescope = {
          enable = true;

          mappings = {
            buffers = "<leader><leader>";
            findFiles = "<leader>sf";
            liveGrep = "<leader>sg";
            lspDefinitions = "<leader>d";
            lspImplementations = "<leader>di";
            lspReferences = "<leader>gr";
            helpTags = "<leader>sh";
            resume = "<leader>sr";
          };

          setupOpts.defaults.file_ignore_patterns = [
            "node_modules"
            ".git/"
          ];
        };

        lsp = {
          enable = true;
          null-ls.enable = true;
          formatOnSave = true;
          lightbulb.enable = false;
          lspconfig.enable = true;
          nvim-docs-view.enable = true;

          trouble = {
            enable = true;
            mappings = {
              symbols = null;
              quickfix = null;
              locList = null;
            };
          };

          otter-nvim.enable = true;
          mappings = {
            codeAction = "<leader>ca";
            goToDefinition = "gd";
            previousDiagnostic = "[d";
            nextDiagnostic = "]d";
          };
        };

        theme = {
          enable = true;
          name = lib.mkForce "catppuccin";
          style = "mocha";
        };

        treesitter = {
          enable = true;
          indent.disable = ["nix" "clang"];
        };

        binds = {
          whichKey.enable = true;
        };
        notify = {
          nvim-notify.enable = true;
        };

        languages = {
          enableDAP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          assembly.enable = true;
          #tailwind.enable = true;

          go = {
            enable = true;
            dap.enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          bash.enable = true;
          css.enable = true;
          elixir.enable = true;

          # this breaks shit
          # hcl.enable = true;

          ocaml.enable = true;
          php.enable = true;
          python.enable = true;
          ruby.enable = true;
          terraform.enable = true;
          yaml.enable = true;
          rust.enable = true;
          rust.crates.enable = true;
          nix.enable = true;
          sql.enable = true;
          clang.enable = true;
          ts.enable = true;
          zig.enable = true;
          markdown.enable = true;
          lua.enable = true;

          html = {
            enable = true;
            treesitter.autotagHtml = true;
          };
        };

        keymaps = [
          {
            key = "jk";
            mode = ["i"];
            action = "<ESC>";
            desc = "Exit insert mode";
          }
          {
            key = "jj";
            mode = ["i"];
            action = "<ESC>";
            desc = "Exit insert mode";
          }
          {
            key = "kk";
            mode = ["i"];
            action = "<ESC>";
            desc = "Exit insert mode";
          }
          {
            key = "kj";
            mode = ["i"];
            action = "<ESC>";
            desc = "Exit insert mode";
          }

          {
            key = "0";
            mode = ["n"];
            action = "_";
          }

          {
            key = "<C-h>";
            mode = ["n"];
            action = "<CMD>TmuxNavigateLeft<CR>";
          }

          {
            key = "<C-j>";
            mode = ["n"];
            action = "<CMD>TmuxNavigateDown<CR>";
          }

          {
            key = "<C-k>";
            mode = ["n"];
            action = "<CMD>TmuxNavigateUp<CR>";
          }

          {
            key = "<C-l>";
            mode = ["n"];
            action = "<CMD>TmuxNavigateRight<CR>";
          }

          {
            key = "<leader>y";
            mode = ["n" "v"];
            action = "\"+y";
          }

          {
            key = "<leader>x";
            mode = ["n"];
            action = ":bd<CR>";
          }

          {
            key = "j";
            mode = ["n"];
            action = "gj";
          }
          {
            key = "k";
            mode = ["n"];
            action = "gk";
          }

          {
            key = "<ESC>";
            mode = ["n"];
            action = ":nohl<CR><ESC>";
            desc = "no higlight esc";
          }
        ];

        diagnostics.nvim-lint.enable = true;

        spellcheck = {
          enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          indent-blankline.enable = true;
        };

        snippets.luasnip.enable = true;

        treesitter.context.enable = true;

        projects = {
          project-nvim.enable = true;
        };

        utility = {
          diffview-nvim.enable = true;
          icon-picker.enable = true;
          surround.enable = true;
          leetcode-nvim.enable = true;

          motion = {
            hop.enable = true;
            leap.enable = true;
            #precognition.enable = true;
          };
        };

        notes = {
          mind-nvim.enable = true;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          colorizer.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          fastaction.enable = true;
        };

        session = {
          nvim-session-manager.enable = true;
        };

        comments = {
          comment-nvim.enable = true;
        };

        presence = {
          neocord.enable = true;
        };
      };
    };
  };

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
  #sound.enable = true;
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
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.modesetting.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xsharawi = {
    isNormalUser = true;
    description = "xsharawi";
    extraGroups = ["networkmanager" "wheel" "gamemode" "libvirtd" "docker"];
    packages = with pkgs; [
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    keepassxc
    xclip
    firmwareLinuxNonfree
    gparted
    os-prober
    grub2
    git
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
    neovide
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
    gtk2-x11
    gtk3-x11
    discord
    pkg-config
    dotnet-sdk_8
    kdePackages.kde-gtk-config
    kdePackages.kdeplasma-addons
    kdePackages.breeze-gtk
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    nixd
    nixdoc
    fastfetch
    zoxide
    #nerdfonts
    zsh-powerlevel10k
    vlc
    zoom-us
    nmap
    lutris
    ksnip
    #minecraft
    jdk17
    javaPackages.openjfx17

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

    winetricks
    gst_all_1.gstreamer
    qbittorrent

    yt-dlp
    bottles
    protonup
    dxvk
    filezilla

    go
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
    pcsx2
    cbonsai
    ruby
    rubyPackages.solargraph
    rubyPackages.rexml
    google-chrome
    inputs.zen-browser.packages."${system}".default
    inputs.swww.packages.${pkgs.system}.swww
    # ELIXIR MENTIONED
    elixir
    elixir-ls
    # OCAML MENTIONED
    ocaml

    ntfs3g
    ntfsprogs
    nerd-fonts.hack
    syncthing
    ghostty

    #newpackage
    wineWowPackages.stable

    # hyprland
    vesktop
    kdePackages.kwallet-pam
    waybar
    wofi
    hyprpicker
    swaynotificationcenter
    notion-app-enhanced
    cliphist
    wl-clip-persist
    wl-clipboard
    hyprshot
    hyprpicker
    shotman
    slurp
    brightnessctl
    grim
    grimblast
  ];
  security.pam.services.swaylock = {};

  # programs.neovim.defaultEditor = true;
  # programs.neovim.enable = true;
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
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
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

  programs.fish.enable = true;
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

    xwayland
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/xsharawi/.steam/root/compatibilitytools.d";
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
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
  #services.openssh.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L" # print build logs
  #   ];
  #   dates = "daily";
  #   randomizedDelaySec = "45min";
  # };

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

  # find out why is this needed
  # something about .gtkrc
  #home-manager.backupFileExtension = "ffs just work";

  # xremap
  services.xremap = {
    withWlroots = true;
    watch = true;
    userName = "xsharawi";
    config = {
      modmap = [
        {
          name = "caps unlimited caps but no caps";
          remap = {
            "CapsLock" = {
              "held" = "leftctrl";
              "alone" = "esc";
              "alone_timeout_millis" = 200;
            };
          };
        }
      ];
    };
  };

  qt.enable = true;
  qt.style = "breeze";
  qt.platformTheme = "kde";
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
