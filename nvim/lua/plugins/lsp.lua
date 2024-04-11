return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source.
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          if vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          --  See the README about individual language/framework/plugin snippets:
          --  https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      -- Adds other completion capabilities.
      -- nvim-cmp does not ship with all sources by default. They are split
      -- into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert {
          -- Select the next item.
          ['<c-j>'] = cmp.mapping.select_next_item(),
          -- Select the previous item.
          ['<c-k>'] = cmp.mapping.select_prev_item(),
          -- Accept the completion.
          -- This will auto-import if your LSP supports it.
          -- This will expand snippets if the LSP sent a snippet.
          ['<c-space>'] = cmp.mapping.confirm { select = true },
          -- Move to the next item of each of the expansion locations.
          ['<c-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          -- Move to the previous item of each of the expansion locations.
          ['<c-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup(
          'lsp-attach',
          { clear = true }
        ),
        callback = function(event)
          local map = function(keys, func)
            vim.keymap.set('n', keys, func, { buffer = event.buf })
          end
          -- Opens a popup that displays documentation about the word under the cursor.
          map('K', vim.lsp.buf.hover)
          -- Jump to the type of the word under the cursor.
          -- Useful when not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
          map('T', require('telescope.builtin').lsp_type_definitions)
          -- Fuzzy find all the symbols in the current buffer.
          -- Symbols are things like variables, functions, types, etc.
          map('S', require('telescope.builtin').lsp_document_symbols)
          -- List all diagnostics for the current buffer.
          map('R', require('telescope.builtin').diagnostics)
          -- Jump to the definition of the word under the cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions)
          -- WARN: This is not Goto Definition, this is Goto Declaration.
          -- For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration)
          -- Jump to the implementation of the word under the cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          map('gi', require('telescope.builtin').lsp_implementations)
          -- Find references for the word under the cursor.
          map('gr', require('telescope.builtin').lsp_references)
          -- Formats the code of the current.
          map('fo', function() vim.lsp.buf.format { async = true } end)
          -- Rename the variable under the cursor.
          -- Most Language Servers support renaming across files, etc.
          map('rn', vim.lsp.buf.rename)
          -- Execute a code action, usually the cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('ca', vim.lsp.buf.code_action)

          -- Highlight references of the word under the cursor when the cursor rests.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Set custom sign icons for diagnostics.
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP Specification.
      -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      -- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers.
      local servers = {
        jdtls = {
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = 'JavaSE-1.8',
                    path = vim.fn.glob('/usr/local/sdkman/candidates/java/8*'),
                    -- This field is required in order for jdtls to function with Java 8 projects.
                    default = true,
                  },
                  {
                    name = 'JavaSE-17',
                    path = vim.fn.glob('/usr/local/sdkman/candidates/java/17*'),
                  },
                },
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run :Mason
      --
      -- You can press `g?` for help in this menu.
      require('mason').setup()

      -- Add other tools here that you want Mason to install,
      -- so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver).
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
