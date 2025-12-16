{
  lib,
  pkgs,
  ...
}: {
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

    bell = "on";
    autocomplete = {
      enableSharedCmpSources = true;
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
      indent.disable = [
        "nix"
        "clang"
      ];
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
      tailwind.enable = true;

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

      ocaml.enable = true;
      php.enable = true;
      python.enable = true;
      ruby.enable = true;
      terraform.enable = true;
      yaml.enable = true;
      rust.enable = true;
      qml.enable = true;
      nix.enable = true;
      nix.lsp.servers = ["nil" "nixd"];
      sql.enable = true;
      clang.enable = true;
      ts.enable = true;
      # one day soonTM
      # ts.lsp.servers = ["ts_ls" "emmet-ls"];
      zig.enable = true;
      markdown.enable = true;
      markdown.format.enable = false;
      lua.enable = true;
      odin.enable = true;

      html = {
        enable = true;
        treesitter.autotagHtml = true;
        lsp.servers = [
          "superhtml"
          "emmet-ls"
        ];
      };
    };

    keymaps = [
      {
        key = "<F1>";
        mode = ["n" "i" "v"];
        action = "<Nop>";
      }
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
        key = "<leader>y";
        mode = [
          "n"
          "v"
        ];
        action = "\"+y";
      }

      {
        key = "<Tab>";
        mode = [
          "n"
          "v"
        ];
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
      {
        key = "<A-h>";
        mode = ["n"];
        action = "<C-w>h";
        desc = "Move to left split";
      }
      {
        key = "<A-j>";
        mode = ["n"];
        action = "<C-w>j";
        desc = "Move to lower split";
      }
      {
        key = "<A-k>";
        mode = ["n"];
        action = "<C-w>k";
        desc = "Move to upper split";
      }
      {
        key = "<A-l>";
        mode = ["n"];
        action = "<C-w>l";
        desc = "Move to right split";
      }
      {
        key = "<A-s>";
        mode = ["n"];
        action = "<C-w>s";
        desc = "Horizontal split";
      }
      {
        key = "<A-v>";
        mode = ["n"];
        action = "<C-w>v";
        desc = "Vertical split";
      }
      {
        key = "<A-q>";
        mode = ["n"];
        action = "<C-w>q";
        desc = "Close split";
      }
      {
        key = "<A-o>";
        mode = ["n"];
        action = "<C-w>o";
        desc = "Close other splits";
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
        leap.enable = true;
      };
      direnv.enable = true;
      mkdir.enable = true;
      nix-develop.enable = true;
      preview.markdownPreview.enable = true;
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

      vim.keymap.set('n', '<leader>,', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end , { desc = 'inlay hints toggle' })



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
      vim.keymap.set("n", "<leader>.", "mayyp`aj", { noremap = true, silent = true })
      vim.o.grepprg = "rg --vimgrep --hidden --smart-case --glob '!.env' --glob '!.env.*' --glob '!*.env'"
      vim.o.grepformat = "%f:%l:%c:%m"
      vim.keymap.set('t', '<ESC><ESC>', [[<C-\><C-n>]])
      vim.keymap.set('n', '<leader>f', "<cmd>e <cfile><CR><C-W>K<C-W>j<leader>x")
    '';
    autocmds = [
      {
        desc = "Preserve last editing position";
        event = ["BufReadPost"];
        pattern = ["*"];
        callback =
          lib.generators.mkLuaInline # lua
          
          ''function() if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then vim.cmd("normal! g'\"") end end'';
      }
    ];
  };
}
