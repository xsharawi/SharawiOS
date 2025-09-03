# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    #inputs.xremap-flake.nixosModules.default
    ./fishmyfish.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-695f8df6-9ca9-45ab-a495-ce49f4675b37".device = "/dev/disk/by-uuid/695f8df6-9ca9-45ab-a495-ce49f4675b37";
  networking.hostName = "vim"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    pkgs.firmwareLinuxNonfree
  ];

  hardware.nvidia.open = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        extraPlugins = {
          undotree = {
            package = pkgs.vimPlugins.undotree;
          };
          vim-tmux-navigator = {
            package = pkgs.vimPlugins.vim-tmux-navigator;
          };
          cloak-nvim = {
            package = pkgs.vimPlugins.cloak-nvim;
            setup = ''
                require('cloak').setup {
                enabled = true,
                cloak_character = '*',
                highlight_group = 'Comment',
                cloak_length = nil,
                try_all_patterns = true,
                patterns = {
                  {
                    file_pattern = '.env*',
                    cloak_pattern = '=.+',
                    replace = nil,
                  },
                },
              }

            '';
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
            file1 = "<leader>n";
            file2 = "<leader>e";
            file3 = "<leader>i";
            file4 = "<leader>o";
            listMarks = "<leader>mm";
            markFile = "<leader>ma";
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
                  "cmdline"
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
            friendly-snippets.enable = true;
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
            buffers = "<leader>/";
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

          inlayHints.enable = true;

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
          transparent = lib.mkForce true;
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
          tailwind.enable = false;

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
          markdown.format.enable = false;
          lua.enable = true;
          odin.enable = true;

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

          # {
          #   key = "<C-h>";
          #   mode = ["n"];
          #   action = "<CMD>TmuxNavigateLeft<CR>";
          # }
          #
          # {
          #   key = "<C-j>";
          #   mode = ["n"];
          #   action = "<CMD>TmuxNavigateDown<CR>";
          # }
          #
          # {
          #   key = "<C-k>";
          #   mode = ["n"];
          #   action = "<CMD>TmuxNavigateUp<CR>";
          # }
          #
          # {
          #   key = "<C-l>";
          #   mode = ["n"];
          #   action = "<CMD>TmuxNavigateRight<CR>";
          # }

          {
            key = "<leader>y";
            mode = ["n" "v"];
            action = "\"+y";
          }

          {
            key = "<Tab>";
            mode = ["n" "v"];
            action = "%";
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
            key = "<C-p>";
            mode = ["n"];
            action = "<cmd>cprev<CR>zz";
          }

          {
            key = "<C-n>";
            mode = ["n"];
            action = "<cmd>cnext<CR>zz";
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
        luaConfigPost = ''
          vim.g.undotree_WindowLayout = 3
          vim.g.undotree_SplitWidth = 50
          vim.g.undotree_SetFocusWhenToggle = 1
          vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
          -- Define a function to run the current Go file
          local function run_go_file()
            vim.cmd 'write' -- Save the current file
            vim.cmd('split | terminal go run ' .. vim.fn.expand '%') -- Run Go file in a split terminal
            vim.cmd 'startinsert'
          end

          -- Create an autocommand group for Go file mappings
          vim.api.nvim_create_augroup('GoFileMappings', { clear = true })
          vim.api.nvim_create_autocmd('FileType', {
            group = 'GoFileMappings',
            pattern = 'go',
            callback = function()
              vim.keymap.set('n', '<leader>rr', run_go_file, { buffer = true })
            end,
          })
          vim.opt.numberwidth = 4
          vim.o.scrolloff = 4
          vim.o.scrolloff = 4
          vim.keymap.set('n', '<leader>go', 'oif err != nil {<CR>}<ESC>Oreturn err<Esc>')
          vim.keymap.set('n', 'J', 'mzJ`z')
          vim.keymap.set('n','<leader>rn', vim.lsp.buf.rename)
          local builtin = require 'telescope.builtin'
          vim.keymap.set('n','gr', require('telescope.builtin').lsp_references)
          vim.keymap.set('n', '<leader>qf', '<cmd>copen<CR>', { desc = '[f] quick fix' })
          vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

          vim.keymap.set('n', '<leader>sW', function()
            local word = vim.fn.expand '<cWORD>'
            require('telescope.builtin').grep_string { search = word }
          end, { desc = '[S]earch current [W]ORD' })

          local harpoon = require 'harpoon'
          harpoon:setup({})

          vim.keymap.set('n', '<leader>k', function()
            harpoon:list():next()
          end)
          vim.keymap.set('n', '<leader>j', function()
            harpoon:list():prev()
          end)
          vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
          vim.opt.inccommand = 'split'

          vim.api.nvim_create_autocmd('TextYankPost', {
            desc = 'Highlight when yanking (copying) text',
            group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
            callback = function()
              vim.highlight.on_yank()
            end,
          })

          vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
          vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

          -- Put this in your init.lua (or a file sourced during startup)
          vim.api.nvim_create_autocmd("VimEnter", {
            once = true,
            callback = function()
              local argv = vim.fn.argv()
              if #argv == 0 then return end

              local path = vim.fn.expand(argv[1])
              local is_dir  = vim.fn.isdirectory(path) == 1
              local is_file = vim.fn.filereadable(path) == 1

              if is_file then
                -- Open after plugins have loaded so LSP/Treesitter can attach
                vim.schedule(function()
                  vim.cmd("edit " .. vim.fn.fnameescape(path))
                end)
              elseif is_dir then
                -- Jump to your Harpoon entry after startup
                vim.schedule(function()
                  -- protect in case list is empty
                  pcall(function() require("harpoon"):list():select(1) end)

                  -- Re-edit the *current* buffer by name to fire BufRead* hooks
                  local cur = vim.api.nvim_buf_get_name(0)
                  if cur ~= "" then
                    vim.cmd("edit " .. vim.fn.fnameescape(cur))
                  end
                end)
              end
            end,
          })



        '';
      };
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.desktopManager.plasma6.enable = true;
  services.envfs.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
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
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
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
    ];
    packages = with pkgs; [];
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
    firmwareLinuxNonfree
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
    i3
    tmux
    chromium
    python3
    polybar
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
    kdePackages.kde-gtk-config
    kdePackages.kdeplasma-addons
    kdePackages.xdg-desktop-portal-kde
    kdePackages.plasma-workspace
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    nixd
    nixdoc
    nixfmt-rfc-style
    fastfetch
    zoxide
    zsh-powerlevel10k
    vlc
    zoom-us
    nmap
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        winetricks
      ];
    })
    protonup-qt
    ksnip

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
    cmake
    ccls
    devenv

    winetricks
    gst_all_1.gstreamer
    qbittorrent

    yt-dlp
    protonup
    dxvk
    filezilla

    go
    air
    htmx-lsp
    obs-studio
    bun
    veracrypt
    tree
    tokei
    docker-compose
    dolphin-emu
    retroarchWithCores
    retroarch-assets
    retroarch-joypad-autoconfig
    onlyoffice-bin
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
    xfce.thunar-archive-plugin
    libsForQt5.qt5ct
    stdmanpages
    man-pages
    man-pages-posix
    clang-manpages
    unrar
    zip
    openjdk8
    openjfx
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
    inputs.ghostty.packages."${system}".default
    elixir
    elixir-ls
    ocaml
    mangohud
    pcsx2
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
    nerd-fonts.hack
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    gopls
    kdePackages.qtwebsockets
    libsForQt5.qt5.qtwebsockets
    playerctl
    pavucontrol
    sshfs
    entr
    libretro.gpsp
    osu-lazer-bin
    aseprite
    rofi-wayland
    pamixer
    libinput
    eza
    xfce.thunar
    nemo-with-extensions
    file
    odin

    #newpackage

    wineWowPackages.stable
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

  # # # stylix
  stylix.enable = true;
  #stylix.image = ./wallpapers/zoz.png;
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
  networking.firewall.allowedTCPPorts = [8081 27031];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.etc."/xdg/menus/plasma-applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
