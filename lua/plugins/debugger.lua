return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'
      local mason_dap = require 'mason-nvim-dap'
      local dap_virtual_text = require 'nvim-dap-virtual-text'

      ui.setup()
      dap_virtual_text.setup()

      mason_dap.setup {
        ensure_installed = { 'cppdbg' },
        automatic_installation = true,
        handlers = {
          function(config)
            require('mason-nvim-dap').default_setup(config)
          end,
        },
      }

      -- c/cpp configurations
      local c_cpp_config = {
        {
          name = 'Executable',
          type = 'cppdbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
          MIMode = 'gdb',
        },
      }

      dap.configurations = {
        cpp = c_cpp_config,
        c = c_cpp_config,
      }

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      -- Resumes execution until the next breakpoint
      vim.keymap.set('n', '<F1>', dap.continue)

      -- go into the next function call and break there
      vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Enter function' })

      -- Execute the next function and break afterwards
      vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Execute line' })

      -- Finish the current function and break after it
      vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Exit function' })

      -- Reverses execution to the previous instruction or line
      vim.keymap.set('n', '<F5>', dap.step_back)

      -- Restart
      vim.keymap.set('n', '<F13>', dap.restart)
      vim.keymap.set('n', '<leader>dq', function()
        require('dap').terminate()
        require('dapui').close()
        require('nvim-dap-virtual-text').toggle()
      end)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
