local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer, close and reopen neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Reload neovim on saving plugins.lua
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Protected call so no error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("packer couldn't be required")
  return
end

return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "neovim/nvim-lspconfig"
  use { "ms-jpq/coq_nvim", event = "VimEnter", config = "vim.cmd[[COQnow]]" }
  use { "ms-jpq/coq.artifacts", branch = "artifacts" }
  use "jiangmiao/auto-pairs"
  use "gruvbox-community/gruvbox"
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", cmd = "MarkdownPreview" }
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
