-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local cmd = vim.cmd

opt.scrolloff = 5 -- Lines of context

cmd([[
  syntax sync minlines=200
  syntax sync maxlines=500
]])
