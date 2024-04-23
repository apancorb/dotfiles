return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    {
      '<leader>b',
      function()
        local dap = require('dap')
        dap.toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint'
    },
    {
      '<F1>',
      function()
        local dap = require('dap')
        dap.continue()
      end,
      desc = 'Debug: Start/Continue'
    },
    {
      '<F2>',
      function()
        local dap = require('dap')
        dap.step_over()
      end,
      desc = 'Debug: Step Over'
    },
    {
      '<F3>',
      function()
        local dap = require('dap')
        dap.step_into()
      end,
      desc = 'Debug: Step Into'
    },
    {
      '<F4>',
      function()
        local dap = require('dap')
        dap.step_out()
      end,
      desc = 'Debug: Step Out'
    },
    {
      '<F5>',
      function()
        local dapui = require('dapui')
        dapui.toggle()
      end,
      desc = 'Debug: See Last Session Result'
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dapui.setup({
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      layouts = {
        {
          elements = {
            'scopes',
            'breakpoints'
          },
          size = 60,
          position = 'left',
        },
        {
          elements = {
            'stacks'
          },
          size = 0.25,
          position = 'bottom'
        },
      },
      render = {
        indent = 2
      },
    })

    require('mason-nvim-dap').setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations.
      automatic_setup = true,
      -- You can provide additional configuration to the handlers.
      handlers = {},
      -- You'll need to check that you have the required things installed.
      ensure_installed = {},
    })

    -- Setup virtual text for dap scopes.
    require('nvim-dap-virtual-text').setup({})

    vim.api.nvim_call_function(
      'sign_define',
      { 'DapBreakpoint', { linehl = '', text = '', texthl = '', numhl = '' } }
    )
    vim.api.nvim_call_function(
      'sign_define',
      { 'DapBreakpointRejected', { linehl = '', text = '', texthl = '', numhl = '' } }
    )
  end,
}
