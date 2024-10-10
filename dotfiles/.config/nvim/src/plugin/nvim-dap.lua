Load.later(function()
    local dap, dapui = require("dap"), require("dapui")
    local widgets = require('dap.ui.widgets')
    dapui.setup()
    -- dap.listeners.before.attach.dapui_config = function()
    --     dapui.open()
    -- end
    -- dap.listeners.before.launch.dapui_config = function()
    --     dapui.open()
    -- end
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --     dapui.close()
    -- end
    Load.now(function()
        require('dap-go').setup()
    end)

    Load.now(function()
        require('dap-python').setup(PYTHON_PATH) -- PYTHON_PATH set by nix
    end)

    local nmap = Keymap.nmap
    nmap("<leader>db", dap.toggle_breakpoint, "toggle [b]reakpoint")
    nmap("<leader>dc", dap.continue, "[c]ontinue")
    nmap("<leader>di", dap.step_into, "step [i]nto")
    nmap("<leader>do", dap.step_over, "step [o]ver")
    nmap("<leader>dO", dap.step_out, "step [O]ut")
    nmap("<leader>dr", dap.repl.open, "open [r]epl")
    nmap("<leader>dl", dap.run_last, "run [l]ast")
    nmap("<leader>dh", widgets.hover, "show [h]over")
    nmap("<leader>dp", widgets.preview, "show [p]review")
    nmap("<leader>df", function() widgets.centered_float(widgets.frames) end, "[f]rames")
    nmap("<leader>ds", function() widgets.centered_float(widgets.scopes) end, "[s]copes")
    nmap("<leader>du", dapui.toggle, "toggle [u]i")
end)
