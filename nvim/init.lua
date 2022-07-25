require "pit.options"
require "pit.keymaps"
require "pit.plugins"
vim.cmd "colorscheme gruvbox"
require "lspconfig".rust_analyzer.setup{}
