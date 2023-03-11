return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      {
        "<leader>cs",
        "<esc><cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
        desc = "Search symbols",
      },
    },
  },
}
