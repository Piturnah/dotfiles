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
  use "https://github.com/nvim-lua/plenary.nvim"
  use "neovim/nvim-lspconfig"
  --use { "ms-jpq/coq_nvim", event = "VimEnter", config = "vim.cmd[[COQnow]]" }
  --use { "ms-jpq/coq.artifacts", branch = "artifacts" }
  use "gruvbox-community/gruvbox"
  use "https://github.com/vim-airline/vim-airline"
  use { "https://github.com/nvim-telescope/telescope.nvim", branch = "0.1.x" }
  use "https://github.com/RRethy/nvim-align"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "simrat39/rust-tools.nvim"
  
  -- Completion framework:
  use 'hrsh7th/nvim-cmp' 
  -- LSP completion source:
  use 'hrsh7th/cmp-nvim-lsp'
  -- Useful completion sources:
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'                             
  use 'hrsh7th/cmp-path'                              
  use 'hrsh7th/cmp-buffer'                            
  use 'hrsh7th/vim-vsnip'                             

  use "windwp/nvim-ts-autotag"

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
