return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format({details = true}),
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()


      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "»",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })


      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})

        -- Additional keymaps for diagnostics
        local opts = {buffer = bufnr}
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      end)

      require('mason-lspconfig').setup({
        -- ensure_installed = {'pyright', 'ts_ls', 'gopls'},
        ensure_installed = {
          -- 'kotlin_lsp',
          'ty',
          -- 'kotlin-language-server',
          'protols'
        },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            vim.lsp.config(server_name, {})
            vim.lsp.enable(server_name)
          end,
          ['yamlls'] = function()
            vim.lsp.config('yamlls', {
              settings = {
                yaml = {
                  schemas = {
                    -- The token in these urls expire. Go to these urls to get the new token
                    -- https://github.com/dialoguemd/charts/raw/master/app/schema.json
                    -- https://github.com/dialoguemd/charts/raw/master/job/schema.json
                    ["/Users/vikram/dev/charts/app/schema.json"] = "app.yaml",
                    ["/Users/vikram/dev/charts/app/schema.json"] = "app.yml",
                    ["/Users/vikram/dev/charts/job/schema.json"] = "job.yaml",
                    ["/Users/vikram/dev/charts/job/schema.json"] = "job.yml",
                  },
                },
              }
            })
            vim.lsp.enable('yamlls')
          end
        }
      })
    end
  }
}
