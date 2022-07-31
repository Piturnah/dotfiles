-- NOTE: This config has a dependency on `python3-venv` from
-- the COQ plugin.
-- Then run :COQdeps after initial restart.
require "pit.options"
require "pit.keymaps"
require "pit.plugins"
vim.cmd "colorscheme gruvbox"
require "lspconfig".rust_analyzer.setup{}
