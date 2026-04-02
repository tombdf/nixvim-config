{
  # =====================================================================
  # DEBUG - Configuration minimaliste (défauts excellents)
  # =====================================================================

  plugins = {
    # =================================================================
    # DAP CORE - Zero config, défauts parfaits
    # =================================================================
    dap = {
      enable = true;
    };

    # =================================================================
    # DAP-UI - Défauts parfaits avec juste les bordures
    # =================================================================
    dap-ui = {
      enable = true;
    };

    # =================================================================
    # DAP-VIRTUAL-TEXT - Configuration minimale
    # =================================================================
    dap-virtual-text = {
      enable = true;
      settings.enabled = true; # Défaut mais explicite
    };
  };

  # =====================================================================
  # WHICH-KEY GROUPES
  # =====================================================================
  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>d"; group = "Debug"; }
  ];

  # =====================================================================
  # KEYMAPS ESSENTIELS SEULEMENT
  # =====================================================================
  keymaps = [
    # ===== DEBUG GROUP - <leader>d =====
    {
      mode = "n";
      key = "<leader>db";
      action.__raw = ''function() require("dap").toggle_breakpoint() end'';
      options.desc = "Toggle Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action.__raw = ''
        function() 
          require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end
      '';
      options.desc = "Conditional Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dc";
      action.__raw = ''function() require("dap").continue() end'';
      options.desc = "Continue";
    }
    {
      mode = "n";
      key = "<leader>dC";
      action.__raw = ''function() require("dap").run_to_cursor() end'';
      options.desc = "Run to Cursor";
    }
    {
      mode = "n";
      key = "<leader>ds";
      action.__raw = ''function() require("dap").step_over() end'';
      options.desc = "Step Over";
    }
    {
      mode = "n";
      key = "<leader>di";
      action.__raw = ''function() require("dap").step_into() end'';
      options.desc = "Step Into";
    }
    {
      mode = "n";
      key = "<leader>do";
      action.__raw = ''function() require("dap").step_out() end'';
      options.desc = "Step Out";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action.__raw = ''function() require("dap").repl.open() end'';
      options.desc = "Open REPL";
    }
    {
      mode = "n";
      key = "<leader>dl";
      action.__raw = ''function() require("dap").run_last() end'';
      options.desc = "Run Last";
    }
    {
      mode = "n";
      key = "<leader>dt";
      action.__raw = ''function() require("dap").terminate() end'';
      options.desc = "Terminate";
    }
    
    # ===== UI CONTROLS =====
    {
      mode = "n";
      key = "<leader>du";
      action.__raw = ''function() require("dapui").toggle() end'';
      options.desc = "Toggle Debug UI";
    }
    {
      mode = "n";
      key = "<leader>de";
      action.__raw = ''function() require("dapui").eval() end'';
      options.desc = "Evaluate Expression";
    }
    {
      mode = "v";
      key = "<leader>de";
      action.__raw = ''function() require("dapui").eval() end'';
      options.desc = "Evaluate Selection";
    }
  ];

  # =====================================================================
  # CONFIGURATION MINIMALE - Juste l'essentiel
  # =====================================================================
  extraConfigLua = ''
    local dap, dapui = require("dap"), require("dapui")
    
    -- Auto-ouverture UI (standard)
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
    
    -- Configuration GDB (support demandé en plus de LLDB)
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" }
    }
    
    -- Signes simples (cohérents avec tes diagnostics)
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
    vim.fn.sign_define('DapStopped', { text = "", texthl = "DiagnosticSignInfo", linehl = "Visual" })
  '';
}
