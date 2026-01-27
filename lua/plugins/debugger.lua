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
      local dapui = require 'dapui'
      local mason_dap = require 'mason-nvim-dap'
      local dap_virtual_text = require 'nvim-dap-virtual-text'

      -- Setup the plugins...
      dapui.setup {
        icons = {
          collapsed = '+',
          current_frame = '*',
          expanded = '-',
        },
        expand_lines = true,
        controls = { enabled = false }, -- no extra play/step buttons
        floating = { border = 'rounded' },
        -- Set dapui window
        render = {
          max_type_length = 60,
          max_value_lines = 200,
        },
        -- Only one layout: just the "scopes" (variables) list at the bottom
        layouts = {
          {
            elements = {
              { id = 'repl', size = 0.5 }, -- 100% of this panel is scopes
              { id = 'console', size = 0.5 }, -- 100% of this panel is scopes
            },
            size = 10, -- height in lines (adjust to taste)
            position = 'bottom', -- "left", "right", "top", "bottom"
          },
          {
            elements = {
              { id = 'scopes' },
            },
            size = 50, -- height in lines (adjust to taste)
            position = 'left', -- "left", "right", "top", "bottom"
          },
        },
      }

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
            return vim.fn.input('Executable > ', vim.fn.getcwd() .. '/', 'file')
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

      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        desc = desc or ''
        vim.keymap.set(mode, keys, func, { desc = desc })
      end

      map('<leader>db', dap.toggle_breakpoint, '[D]ebugger [T]oggle breakpoint')

      -- Continues execution to the current cursor
      map('<leader>dc', dap.run_to_cursor, '[D]ebugger [C]ontinue')

      -- Open a floating window containing the result of evaluting an expression
      map('<leader>d?', function()
        dapui.eval(nil, { enter = true })
      end, '[D]ebugger [E]val')

      -- Resumes execution until the next breakpoint
      map('<F1>', dap.continue)

      -- go into the next function call and break there
      map('<F2>', dap.step_into, 'Enter function')

      -- Execute the next function and break afterwards
      map('<F3>', dap.step_over, 'Execute line')

      -- Finish the current function and break after it
      map('<F4>', dap.step_out, 'Exit function')

      -- Reverses execution to the previous instruction or line
      map('<F5>', dap.step_back, 'Go Back')

      -- Restart
      map('<F7>', dap.restart, 'Restart Debugger')

      Terminate
      map('<leader>de', function()
        dap.terminate()
        dapui.close()
        dap_virtual_text.toggle()
      end, '[D]ebugger [E]xit')

      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
