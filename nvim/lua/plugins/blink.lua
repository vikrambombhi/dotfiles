-- Completion engine. Replaces nvim-cmp + cmp-nvim-lsp + LuaSnip:
-- blink ships its own LSP, path, snippet and buffer sources.
require('blink.cmp').setup({
  -- 'default' preset: <C-space> open/toggle, <C-n>/<C-p> select,
  -- <C-y> accept, <C-e> hide, <C-k> signature.
  keymap = { preset = 'default' },

  appearance = { nerd_font_variant = 'mono' },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  -- Use the prebuilt Rust binary when present (from the pinned release tag),
  -- otherwise fall back to the pure-Lua matcher with a warning.
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
