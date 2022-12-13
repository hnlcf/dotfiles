return {
  --
  -- My Dashboard Header
  --
  header = {
    "Road there, go ahead!"
  },

  --
  -- Theme/Colorscheme
  --
  colorscheme = "gruvbox", -- sonokai, gruvbox

  -- 
  -- Add highlight groups in any theme
  --
  highlights = { 
    init = { -- this table overrides highlights in all themes
      -- set the transparency for all of these highlight groups
      Normal = { bg = "NONE", ctermbg = "NONE" },
      NormalNC = { bg = "NONE", ctermbg = "NONE" },
      CursorColumn = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
      CursorLine = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
      CursorLineNr = { cterm = {}, ctermbg = "NONE", ctermfg = "NONE" },
      LineNr = {},
      SignColumn = {},
      StatusLine = {},
      NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
      NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
    },
    gruvbox = {
      StatusLine = { fg = "#ebdbb2", bg = "#504945" },
    },
  },
  
  --
  -- Default theme configuration
  --
  -- default_theme = { },
  -- default_theme = {
  --   highlights = function(hi)
  --     local C = require "default_theme.colors"
  --     hi.Normal = {bg = C.none, ctermbg = C.none}
  --     hi.CursorColumn = {cterm = {}, ctermbg = C.none, ctermfg = C.none}
  --     hi.CursorLine = {cterm = {}, ctermbg = C.none, ctermfg = C.none}
  --     hi.CursorLineNr = {cterm = {}, ctermbg = C.none, ctermfg = C.none}
  --     hi.LineNr = {}
  --     hi.SignColumn = {}
  --     hi.StatusLine = {}
  --     hi.NeoTreeNormal = {bg = C.none, ctermbg = C.none}
  --     hi.NeoTreeNormalNC = {bg = C.none, ctermbg = C.none}
  --     return hi
  --   end,
  -- },

  --
  -- Basic Options
  --
  options = {
    opt = {
      background = dark,
    },
    g = {
      sonokai_style = "espresso"
    }
  },

  --
  -- LSP Config
  --
  lsp = {
    -- Automatic formatting on save
    formatting = {
      format_on_save = true,
    },

    -- add lsp servers local installed
    servers = {
      "pyright", -- Python
      "clangd", -- C/C++
      "rust_analyzer", -- Rust
      "marksman", -- markdown
      "texlab", -- latex
    },

    -- skip default setup for lsp servers with extension
    skip_setup = { "clangd", "rust_analyzer" }, -- skip lsp setup because rust-tools will do it itself

    -- config lsp server settings
    ["server-settings"] = {
      -- C/C++
      clangd = {
        capabilities = {
          offsetEncoding = "utf-8",
        },
      },
      -- Rust
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
            },
            cargo = { allFeatures = true },
            checkOnSave = {
              command = "clippy",
              allTargets = false,
            },
          }
        },
      },
      -- LaTex
      texlab = {
        settings = {
          texlab = {
            build = { onSave = true },
            forwardSearch = {
              executable = "zathura",
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
          },
        },
      }
    },
  },

  --
  -- Keymap
  --
  mappings = {
    n = {
      ["<leader>lk"] = { "<cmd>RustRunnable<cr>", desc = "Execute rust unit runnables" },
    },
  },

  --
  -- Plugin Installation and Config
  --
  plugins = {
    -- initialize lsp servers extension
    init = {
      -- sonokai colorscheme
      { "sainnhe/sonokai" },

      -- gruvbox colorscheme
      { "ellisonleao/gruvbox.nvim" },

      -- clangd extensions
      {
        "p00f/clangd_extensions.nvim",
        after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
        config = function()
          require("clangd_extensions").setup {
            server = astronvim.lsp.server_settings "clangd",
          }
        end,
      },

      -- rust tools
      {
        "simrat39/rust-tools.nvim",
        after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
        config = function()
          local opts = {
            server = astronvim.lsp.server_settings "rust_analyzer", -- get the server settings and built in capabilities/on_attach
          }

          require("rust-tools").setup(opts)
        end,
      },

      -- rust crates
      {
        "Saecki/crates.nvim",
        after = "nvim-cmp",
        config = function()
          require("crates").setup()
          astronvim.add_cmp_source { name = "crates", priority = 1100 }

          -- Crates mappings:
          local map = vim.api.nvim_set_keymap
          map("n", "<leader>Ct", ":lua require('crates').toggle()<cr>", { desc = "Toggle extra crates.io information" })
          map("n", "<leader>Cr", ":lua require('crates').reload()<cr>", { desc = "Reload information from crates.io" })
          map("n", "<leader>CU", ":lua require('crates').upgrade_crate()<cr>", { desc = "Upgrade a crate" })
          map("v", "<leader>CU", ":lua require('crates').upgrade_crates()<cr>", { desc = "Upgrade selected crates" })
          map("n", "<leader>CA", ":lua require('crates').upgrade_all_crates()<cr>", { desc = "Upgrade all crates" })
        end,
      },
    },

    -- make sure the necessary lsp servers installed before configuring servers' extension
    ["mason-lspconfig"] = {
      -- ensure_installed = { "clangd", "rust_analyzer" }, -- install rust_analyzer
    },

    -- modify neovim status line config
    heirline = function(config)
      -- the first element of the default configuration table is the statusline
      config[1] = {
        -- set the fg/bg of the statusline
        hl = { fg = "fg", bg = "bg" },
        -- when adding the mode component, enable the mode text with padding to the left/right of it
        astronvim.status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
        -- add all the other components for the statusline
        astronvim.status.component.git_branch(),
        astronvim.status.component.file_info(),
        astronvim.status.component.git_diff(),
        astronvim.status.component.diagnostics(),
        astronvim.status.component.fill(),
        astronvim.status.component.macro_recording(),
        astronvim.status.component.fill(),
        astronvim.status.component.lsp(),
        astronvim.status.component.treesitter(),
        astronvim.status.component.nav(),
      }
      -- return the final configuration table
      return config
    end,
  },
}
