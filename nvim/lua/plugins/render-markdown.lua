require('render-markdown').setup({
  -- Render in normal, command, terminal and visual modes. Insert mode ('i') is
  -- intentionally left out, so the raw markdown is only revealed while editing.
  render_modes = { 'n', 'c', 't', 'v', 'V', '\22' },
  -- Don't un-render the line under the cursor or the visual selection; combined
  -- with render_modes above this means raw text shows up only in insert mode.
  anti_conceal = { enabled = false },
})
