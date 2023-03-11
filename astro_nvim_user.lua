return {
  colorscheme = "catppuccin",
  lsp = {
    -- Automatic formatting on save
    formatting = {
      format_on_save = {
        enabled = true,      -- enable format on save
        ignore_filetypes = { -- disable format on save for specified filetypes
          "c",
          "cpp",
        }
      },
    },
    -- add lsp servers local installed
    servers = {
      "clangd",            -- C/C++(paru)
      "marksman",          -- Markdown(cargo)
      "hls",               -- Haskell(official)
      "ocamllsp",          -- OCaml(official)
      "pyright",           -- Python(pip)
      "racket_langserver", -- Racket(official)
      "rust_analyzer",     -- Rust(rustup)
      "texlab",            -- Latex(cargo)
      -- "taplo",             -- Toml(cargo)
    },
    -- skip default setup for lsp servers with extension
    -- skip_setup = { "clangd", "rust_analyzer" }, -- skip lsp setup because rust-tools will do it itself
    -- config lsp server settings
    config = {
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
  plugins = {
    -- catppuccin colorscheme
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
    },

    -- vscode colorscheme
    { "Mofiqul/vscode.nvim" },

    -- sonokai colorscheme
    { "sainnhe/sonokai" },

    -- gruvbox colorscheme
    { "ellisonleao/gruvbox.nvim" },

    -- clangd extensions
    {
      "p00f/clangd_extensions.nvim",
      event = "User AstroLspSetup",
      opts = function() return { server = require("astronvim.utils.lsp").config "clangd" } end,
    },

    -- cmake tools
    {
      "Civitasv/cmake-tools.nvim",
      keys = {
        { "<leader>mg", "<cmd>CMakeGenerate<cr>",           desc = "Generate" },
        { "<leader>mx", "<cmd>CMakeGenerate!<cr>",          desc = "Clean and Generate" },
        { "<leader>mb", "<cmd>CMakeBuild<cr>",              desc = "Build" },
        { "<leader>mr", "<cmd>CMakeRun<cr>",                desc = "Run" },
        { "<leader>md", "<cmd>CMakeDebug<cr>",              desc = "Debug" },
        { "<leader>my", "<cmd>CMakeSelectBuildType<cr>",    desc = "Select Build Type" },
        { "<leader>mt", "<cmd>CMakeSelectBuildTarget<cr>",  desc = "Select Build Target" },
        { "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select Launch Target" },
        { "<leader>mo", "<cmd>CMakeOpen<cr>",               desc = "Open CMake Console" },
        { "<leader>mc", "<cmd>CMakeClose<cr>",              desc = "Close CMake Console" },
        { "<leader>mi", "<cmd>CMakeInstall<cr>",            desc = "Intall CMake target" },
        { "<leader>mn", "<cmd>CMakeClean<cr>",              desc = "Clean CMake target" },
        { "<leader>ms", "<cmd>CMakeStop<cr>",               desc = "Stop CMake Process" },
        { "<leader>mp", "<cmd>cd %:p:h<cr> ",               desc = "Change pwd to current file" }
      },
      opts = function()
        require("cmake-tools").setup({
          cmake_command = "cmake",
          cmake_build_directory = "",
          cmake_build_directory_prefix = "build/",
          cmake_build_type = "Debug",
          cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
          cmake_build_options = {},
          cmake_console_size = 10,       -- cmake output window height
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
      event = "User AstroLspSetup",
      keys = {
        {
          "<leader>ri",
          "<cmd>lua require('rust-tools').inlay_hints.enable()<cr>",
          desc =
          "Enable inlay hints"
        },
        {
          "<leader>rI",
          "<cmd>lua require('rust-tools').inlay_hints.disable()<cr>",
          desc =
          "Disable inlay hints"
        },
        {
          "<leader>rl",
          "<cmd>lua require('rust-tools').runnables.runnables()<cr>",
          desc =
          "Toggle all rust runnables"
        },
        {
          "<leader>re",
          "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>",
          desc =
          "Expand macros"
        },
        {
          "<leader>rh",
          "<cmd>lua require('rust-tools').hover_actions.hover_actions()<cr>",
          desc =
          "Toggle hover actions"
        },
        {
          "<leader>ro",
          "<cmd>lua require('rust-tools').open_cargo_toml.open_cargo_toml()<cr>",
          desc =
          "Open Cargo.toml"
        },
        {
          "<leader>rt",
          "<cmd>lua require('crates').toggle()<cr>",
          desc =
          "Toggle extra information"
        },
        {
          "<leader>rr",
          "<cmd>lua require('crates').reload()<cr>",
          desc =
          "Reload information"
        },
        {
          "<leader>ru",
          "<cmd>lua require('crates').upgrade_crate()<cr>",
          desc =
          "Upgrade a crate"
        },
        {
          "<leader>rU",
          "<cmd>lua require('crates').upgrade_crates()<cr>",
          desc =
          "Upgrade selected crates"
        },
        {
          "<leader>rA",
          "<cmd>lua require('crates').upgrade_all_crates()<cr>",
          desc =
          "Upgrade all crates"
        },
      },
      opts = function() return { server = require("astronvim.utils.lsp").config "rust_analyzer" } end
    },

    -- rust crates
    {
      "Saecki/crates.nvim",
    },

    -- make sure the necessary language installed
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
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
      }
    },
    -- make sure the necessary lsp servers installed before configuring servers' extension

    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "bashls",   -- Bash
          "cmake",    -- CMake
          "elixirls", -- Elixir
          "jsonls",   -- Json
          -- "yamlls", -- Yaml
          "lua_ls",   -- Lua
        },
      },
    },
  },
}
--   ["which-key"] = {
--     register = {
--       n = {
--         ["<leader>"] = {
--           -- Rust mappings
--           r = {
--             name = "Rust",
--             -- Rust tools mappings:
--           },
--
--         },
--       },
--     },
--   },
-- }
