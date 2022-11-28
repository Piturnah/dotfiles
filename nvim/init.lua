-- NOTE: This config has a dependency on 
-- `python3-venv` and `sqlite3 from the COQ 
-- plugin.
--
-- Then run :COQdeps after initial restart.
require "pit.options"
require "pit.keymaps"
require "pit.plugins"
vim.cmd "colorscheme gruvbox"
require "lspconfig".rust_analyzer.setup{}
require "lspconfig".hls.setup{}
require "lspconfig".clangd.setup{}

vim.api.nvim_create_autocmd(
    {"BufRead", "BufNewFile" },
    { pattern = "*.rk" ,
     command = "set filetype=rack" }
)
