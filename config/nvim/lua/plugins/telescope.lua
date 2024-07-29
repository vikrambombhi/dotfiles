return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		function vim.getVisualSelection()
			vim.cmd('noau normal! "vy"')
			local text = vim.fn.getreg('v')
			vim.fn.setreg('v', {})

			text = string.gsub(text, "\n", "")
			if #text > 0 then
				return text
			else
				return ''
			end
		end


		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<Leader>F', builtin.find_files, {})
		vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
		vim.keymap.set('v', '<C-f>', function()
			local text = vim.getVisualSelection()
			builtin.live_grep({ default_text = text })
		end, {})
	end,
}
