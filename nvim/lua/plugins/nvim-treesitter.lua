return {
  "nvim-treesitter/nvim-treesitter",
  lazy=false,
  build = ":TSUpdate",
  opts = {
    indent = { enable = true }, ---@type lazyvim.TSFeat
    highlight = { enable = true }, ---@type lazyvim.TSFeat
    folds = { enable = true }, ---@type lazyvim.TSFeat
    ensure_installed = {
      "bash",
      "diff",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "go",
      "proto",
      "kotlin",
    }
  }
}
	-- config = function () 
	-- 	local configs = require("nvim-treesitter.configs")

	-- 	configs.setup({
	-- 		ensure_installed = {
  --       -- "lua",
  --       -- "vim",
  --       -- "vimdoc",
  --       -- "javascript",
  --       -- "html",
  --       -- "python",
  --       -- "hcl",
  --       -- "terraform",
  --       "go",
  --       -- "gomod",
  --       -- "gowork",
  --       -- "gosum",
  --       "proto",
  --       "kotlin",
  --     },
	-- 		sync_install = false,
	-- 		highlight = { enable = true },
	-- 		indent = { enable = true },  
	-- 	})
	-- end
