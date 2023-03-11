return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "clangd",
        "cmake-language-server",
        "haskell-language-server",
        "lua-language-server",
        "json-lsp",
        "texlab",
        "marksman",
        "ocaml-lsp",
        "pyright",
        "taplo",
        "rust-analyzer",
        "yaml-language-server",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
