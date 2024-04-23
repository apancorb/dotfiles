return {
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
          -- Open floating windown with diagnostics for current line.
          map('r', vim.diagnostic.open_float)
          -- Go to the next diagnostic in the current file.
          map('R', vim.diagnostic.goto_next)
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
      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP Specification.
      -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      -- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers.
      local servers = {}

      -- Ensure the servers and tools above are installed
      -- To check the current status of installed tools and/or manually install
      -- other tools, run :Mason
      --
      -- You can press `g?` for help in this menu.
      require('mason').setup()

      -- Add other tools here that for Mason to install,
      -- so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {})
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
  {
    'nvim-java/nvim-java',
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      }
    },
    config = function()
      local jdtls = {
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-1.8',
                  path = vim.fn.glob('/usr/local/sdkman/candidates/java/8*'),
                  -- This field is required in order for jdtls to work with Java 8 projects.
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
      }
      require('java').setup()
      require('lspconfig').jdtls.setup(jdtls)
    end
  }
}
