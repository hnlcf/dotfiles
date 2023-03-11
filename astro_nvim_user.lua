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
  colorscheme = "gruvbox", -- sonokai, gruvbox, vscode, default_theme

  --
  -- Add highlight groups in any theme
  --
  highlights = {
    gruvbox = {
      StatusLine = { fg = "#ebdbb2", bg = "#504945" },
    },
  },

  --
  -- Default theme configuration
  --
  -- default_theme = { },

  --
  -- Basic Options
  --
  options = {
    opt = {
      -- background = dark,
    },
    g = {
      sonokai_style = "default" -- default, atlantis, andromeda, shusia, maia
    }
  },

  --
  -- Diagnostics
  --
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  --
  -- LSP Config
  --
  lsp = {
    -- Automatic formatting on save
    formatting = {
      format_on_save = {
        enabled = true, -- enable format on save
        ignore_filetypes = { -- disable format on save for specified filetypes
          "c",
          "cpp",
        }
      },
    },

    -- add lsp servers local installed
    servers = {
      "clangd", -- C/C++(paru)
      "marksman", -- Markdown(cargo)
      "hls", -- Haskell(official)
      "ocamllsp", -- OCaml(official)
      "pyright", -- Python(pip)
      "racket_langserver", -- Racket(official)
      "rust_analyzer", -- Rust(rustup)
      "texlab", -- Latex(cargo)
      -- "taplo", -- Toml(cargo)
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
            cargo = {
              allFeatures = true,
              buildScripts = {
                enable = true,
              },
            },
            check = {
              command = "clippy",
            },
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
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
  },

  --
  -- Plugin Installation and Config
  --
  plugins = {
    -- initialize lsp servers extension
    init = {
      -- vscode colorscheme
      { "Mofiqul/vscode.nvim" },

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

      -- cmake tools
      {
        "Civitasv/cmake-tools.nvim",
        after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
        config = function()
          require("cmake-tools").setup({
            cmake_command = "cmake",
            cmake_build_directory = "",
            cmake_build_directory_prefix = "build/",
            cmake_build_type = "Debug",
            cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
            cmake_build_options = {},
            cmake_console_size = 10, -- cmake output window height
            cmake_show_console = "always", -- "always", "only_on_error"
            cmake_variants_message = {
              short = { show = true },
              long = { show = true, max_length = 40 }
            },
            cmake_dap_configuration = {
              name = "cpp",
              type = "codelldb",
              request = "launch",
              stopOnEntry = false,
              runInTerminal = true,
              console = "integratedTerminal",
            }, -- dap configuration, optional
          })
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
        end,
      },

      -- markdown preview
      { "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
          vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        config = function()
          vim.cmd([[
          let g:mkdp_theme = 'light'
          let g:mkdp_auto_start=0
          let g:mkdp_auto_close=0
          let g:mkdp_refresh_slow=0
          let g:vim_markdown_fenced_languages = ['tsx=typescriptreact']
          let g:vim_markdown_no_default_key_mappings = 1
          let g:vim_markdown_folding_disabled = 1
          let g:vim_markdown_frontmatter = 1
          ]])
        end,
      },
    },

    -- make sure the necessary language installed
    treesitter = {
      ensure_installed = {
        "bash",
        "bibtex",
        "c",
        "comment",
        "cmake",
        "cpp",
        "css",
        "dockerfile",
        "diff",
        "elixir",
        "erlang",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gowork",
        "haskell",
        "html",
        "http",
        "javascript",
        "json",
        "latex",
        "lua",
        "make",
        "markdown",
        "nix",
        "ocaml",
        "ocaml_interface",
        "ocamllex",
        "proto",
        "python",
        "racket",
        "ruby",
        "rust",
        "scala",
        "scheme",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
        "zig",
      },
    },

    -- make sure the necessary lsp servers installed before configuring servers' extension
    ["mason-lspconfig"] = {
      ensure_installed = {
        "bashls", -- Bash
        "cmake", -- CMake
        "elixirls", -- Elixir
        "jsonls", -- Json
        -- "yamlls", -- Yaml
        "sumneko_lua", -- Lua
      },
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
  -- Modify which-key registration (Use this with mappings table in the above.)
  ["which-key"] = {
    register = {
      n = {
        ["<leader>"] = {
          -- Rust mappings
          r = {
            name = "Rust",

            -- Rust tools mappings:
            i = { ":lua require('rust-tools').inlay_hints.enable()<cr>", "Enable inlay hints" },
            I = { ":lua require('rust-tools').inlay_hints.disable()<cr>", "Disable inlay hints" },
            l = { ":lua require('rust-tools').runnables.runnables()<cr>", "Toggle all rust runnables" },
            e = { ":lua require('rust-tools').expand_macro.expand_macro()<cr>", "Expand macros" },
            h = { ":lua require('rust-tools').hover_actions.hover_actions()<cr>", "Toggle hover actions" },
            o = { ":lua require('rust-tools').open_cargo_toml.open_cargo_toml()<cr>", "Open Cargo.toml" },
            g = { ":lua require('rust-tools').crate_graph.view_crate_graph(backend, output)<cr>", "View crate graph" },

            -- Rust Crates mappings:
            t = { ":lua require('crates').toggle()<cr>", "Toggle extra information" },
            r = { ":lua require('crates').reload()<cr>", "Reload information" },
            u = { ":lua require('crates').upgrade_crate()<cr>", "Upgrade a crate" },
            U = { ":lua require('crates').upgrade_crates()<cr>", "Upgrade selected crates" },
            A = { ":lua require('crates').upgrade_all_crates()<cr>", "Upgrade all crates" },
          },
          -- CMake mappings
          C = {
            name = "CMake",

            g = { "<cmd>CMakeGenerate<cr>", "Generate" },
            x = { "<cmd>CMakeGenerate!<cr>", "Clean and Generate" },
            b = { "<cmd>CMakeBuild<cr>", "Build" },
            r = { "<cmd>CMakeRun<cr>", "Run" },
            d = { "<cmd>CMakeDebug<cr>", "Debug" },
            y = { "<cmd>CMakeSelectBuildType<cr>", "Select Build Type" },
            t = { "<cmd>CMakeSelectBuildTarget<cr>", "Select Build Target" },
            l = { "<cmd>CMakeSelectLaunchTarget<cr>", "Select Launch Target" },
            o = { "<cmd>CMakeOpen<cr>", "Open CMake Console" },
            c = { "<cmd>CMakeClose<cr>", "Close CMake Console" },
            i = { "<cmd>CMakeInstall<cr>", "Intall CMake target" },
            n = { "<cmd>CMakeClean<cr>", "Clean CMake target" },
            s = { "<cmd>CMakeStop<cr>", "Stop CMake Process" },
            p = { "<cmd>cd %:p:h<cr> ", "Change pwd to current file" }
          },
          -- MarkdownPreview mappings
          m = {
            name = "Markdown",

            p = { "<Plug>MarkdownPreview", "Preview Markdown" },
            s = { "<Plug>MarkdownPreviewStop", "Stop Preview Markdown" },
          },

        },
      },
    },
  },

}
