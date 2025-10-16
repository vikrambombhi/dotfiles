return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function () 
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "html",
        "python",
        "hcl",
        "terraform",
        "go",
        "gomod",
        "gowork",
        "gosum",
      },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },  
		})
	end
}
