return {
  colorscheme = "vscode",
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
      "rust_analyzer",     -- Rust(manual)
      "texlab",            -- Latex(cargo)
      -- "bashls",            -- Bahs(npm)
      -- "taplo",             -- Toml(cargo)
    },
    -- skip default setup for lsp servers with extension
    skip_setup = { "clangd", "rust_analyzer" }, -- skip lsp setup because rust-tools will do it itself
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
    {
      "Mofiqul/vscode.nvim",
      as = "vscode",
      config = function()
        require("vscode").setup {
          -- Alternatively set style in setup
          style = 'light',

          -- Enable transparent background
          transparent = false,

          -- Enable italic comment
          italic_comments = true,

          -- Disable nvim-tree background color
          disable_nvimtree_bg = false,
        }
      end,
    },

    -- sonokai colorscheme
    { "sainnhe/sonokai" },

    -- gruvbox colorscheme
    {
      "ellisonleao/gruvbox.nvim",
      as = "gruvbox",
      config = function()
        require("gruvbox").setup {
          overrides = {
            StatusLine = { fg = "#ebdbb2", bg = "#504945" },
          },
        }
      end
    },

    -- onedark colorscheme
    {
      "navarasu/onedark.nvim",
      as = "onedark",
      config = function()
        require("onedark").setup {
          style = "darker"
        }
      end
    },

    {
      "lvimuser/lsp-inlayhints.nvim",
      branch = "anticonceal",
      opts = {},
      lazy = true,
      config = function(_, opts)
        require("lsp-inlayhints").setup(opts)
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr)
          end,
        })
      end,


    },

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
      opts = function()
        return {
          server = require("astronvim.utils.lsp").config "rust_analyzer",
          tools = {
            inlay_hints = {
              auto = false
            }
          }
        }
      end,
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
          "gopls",    -- Golang
          -- "yamlls", -- Yaml
          "lua_ls",   -- Lua
        },
      },
    },

    {
      "rebelot/heirline.nvim",
      event = "BufEnter",
      opts = function()
        local status = require "astronvim.utils.status"
        return {
          statusline = {
            -- statusline
            hl = { fg = "fg", bg = "bg" },
            status.component.mode { mode_text = { padding = { left = 1, right = 1 } }, hl = { bold = true } },
            status.component.git_branch(),
            status.component.file_info { filetype = {}, filename = false, file_modified = false },
            status.component.git_diff(),
            status.component.diagnostics(),
            status.component.fill(),
            status.component.cmd_info(),
            status.component.fill(),
            status.component.lsp(),
            status.component.treesitter(),
            status.component.nav(),
            status.component.mode { surround = { separator = "right" } },
          },
          winbar = {
            -- winbar
            init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
            fallthrough = false,
            {
              condition = function() return not status.condition.is_active() end,
              status.component.separated_path(),
              status.component.file_info {
                file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
                file_modified = false,
                file_read_only = false,
                hl = status.hl.get_attributes("winbarnc", true),
                surround = false,
                update = "BufEnter",
              },
            },
            status.component.breadcrumbs { hl = status.hl.get_attributes("winbar", true) },
          },
          tabline = { -- bufferline
            {
              -- file tree padding
              condition = function(self)
                self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
                return status.condition.buffer_matches(
                  { filetype = { "aerial", "dapui_.", "neo%-tree", "NvimTree" } },
                  vim.api.nvim_win_get_buf(self.winid)
                )
              end,
              provider = function(self) return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1) end,
              hl = { bg = "tabline_bg" },
            },
            status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
            status.component.fill { hl = { bg = "tabline_bg" } },               -- fill the rest of the tabline with background color
            {
              -- tab list
              condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
              status.heirline.make_tablist {                                        -- component for each tab
                provider = status.provider.tabnr(),
                hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
              },
              {
                -- close button for current tab
                provider = status.provider.close_button { kind = "TabClose", padding = { left = 1, right = 1 } },
                hl = status.hl.get_attributes("tab_close", true),
                on_click = {
                  callback = function() require("astronvim.utils.buffer").close_tab() end,
                  name = "heirline_tabline_close_tab_callback",
                },
              },
            },
          },
          statuscolumn = vim.fn.has "nvim-0.9" == 1 and {
            status.component.foldcolumn(),
            status.component.fill(),
            status.component.numbercolumn(),
            status.component.signcolumn(),
          } or nil,
        }
      end,
      config = require "plugins.configs.heirline",
    }

  },
}
