{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION C/C++ - Avec keymaps locaux
  # =====================================================================

  # =====================================================================
  # CLANGD_EXTENSIONS.NVIM - Zero config, excellents défauts
  # =====================================================================
  plugins.clangd-extensions = {
    enable = true;
    # Tous les défauts sont parfaits
  };

  plugins = {
    # =====================================================================
    # CLANGD LSP - Nixvim a d'excellents défauts, juste l'essentiel
    # =====================================================================
    lsp.servers.clangd = {
      enable = true;
    };

    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      cpp
    ];

    conform-nvim.settings.formatters_by_ft = {
      c = [ "clang_format" ];
      cpp = [ "clang_format" ];
    };

    lint.lintersByFt = {
      c = [ "cppcheck" ];
      cpp = [ "cppcheck" "cpplint" ];
    };

    # =================================================================
    # DAP-LLDB - Plugin native nixvim (fait tout le travail)
    # =================================================================
    dap-lldb = {
      enable = true;
      # Défauts excellents pour C/C++/Rust - zéro configuration !
    };

    dap.configurations = {
      # Configuration GEF alternative (en plus des défauts dap-lldb LLDB)
      c = [
        {
          name = "Debug with GEF (GDB Enhanced)";
          type = "gdb";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
          '';
          cwd = "\${workspaceFolder}";
          stopAtBeginningOfMainSubprogram = false;
        }
      ];
    
      # Même config pour C++
      cpp = [
        {
          name = "Debug with GEF (GDB Enhanced)";
          type = "gdb";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
          '';
          cwd = "\${workspaceFolder}";
          stopAtBeginningOfMainSubprogram = false;
        }
      ];
    };
  };

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    # Essentiel : clang-tools inclut clangd, clang-format, clang-tidy
    clang-tools
    cppcheck
    cpplint

    # Utile : pour générer compile_commands.json
    bear

    lldb
    gef
    gdb
  ];

  # =====================================================================
  # AUTOCOMMANDS AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "c" "cpp" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Options d'indentation
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "// %s"
          
          -- KEYMAPS LOCAUX - Seulement pour les buffers C/C++ !
          local opts = { buffer = bufnr, desc = "" }
          
          -- Clangd AST
          opts.desc = "View AST"
          vim.keymap.set("n", "<leader>Ca", "<cmd>ClangdAST<cr>", opts)
          vim.keymap.set("v", "<leader>Ca", ":<C-u>ClangdAST<cr>", opts)
          
          -- Symbol Info
          opts.desc = "Symbol Info"
          vim.keymap.set("n", "<leader>Cs", "<cmd>ClangdSymbolInfo<cr>", opts)
          
          -- Type Hierarchy
          opts.desc = "Type Hierarchy"
          vim.keymap.set("n", "<leader>Ct", "<cmd>ClangdTypeHierarchy<cr>", opts)
          
          -- Memory Usage
          opts.desc = "Memory Usage"
          vim.keymap.set("n", "<leader>Cm", "<cmd>ClangdMemoryUsage<cr>", opts)
          
          -- Switch Header/Source
          opts.desc = "Switch Header/Source"
          vim.keymap.set("n", "<leader>Ch", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
          
          -- Generate compile_commands.json
          opts.desc = "Generate compile_commands.json"
          vim.keymap.set("n", "<leader>Cc", "<cmd>GenerateCompileCommands<cr>", opts)
          
          -- Create compile_flags.txt
          opts.desc = "Create compile_flags.txt"
          vim.keymap.set("n", "<leader>Cf", "<cmd>CreateCompileFlags<cr>", opts)

          -- Debug
          opts.desc = "Debug: Launch (LLDB)"
          vim.keymap.set("n", "<leader>Cd", function()
            -- Utilise les défauts dap-lldb (LLDB/CodeLLDB)
            require('dap').continue()
          end, opts)

          opts.desc = "Debug: Launch (GEF)"
          vim.keymap.set("n", "<leader>Cg", function()
            -- Force l'utilisation de GEF
            local configs = require('dap').configurations[vim.bo.filetype]
            if configs then
              for _, config in ipairs(configs) do
                if config.type == "gdb" then
                  require('dap').run(config)
                  return
                end
              end
            end
            require("snacks").notify("GEF configuration not found", { level = "warn" })
          end, opts)

          opts.desc = "Debug: Build & Debug"
          vim.keymap.set("n", "<leader>CD", function()
            -- Compile avec debug symbols
            local cwd = vim.fn.getcwd()
            local build_cmd
            
            if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
              build_cmd = "make CFLAGS='-g'"
            elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
              build_cmd = "cmake -DCMAKE_BUILD_TYPE=Debug -B build && cmake --build build"
            else
              local file = vim.api.nvim_buf_get_name(0)
              if file and file ~= "" then
                local exe = vim.fn.fnamemodify(file, ":r")
                build_cmd = "gcc -g -o " .. exe .. " " .. file
              end
            end
            
            if build_cmd then
              require("snacks").terminal.open(build_cmd, {
                title = "Build for Debug",
                on_exit = function(_, code)
                  if code == 0 then
                    vim.defer_fn(function() require('dap').continue() end, 500)
                  end
                end
              })
            end
          end, opts)
          
          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>C", group = "C/C++", icon = { icon = "󰙱", color = "blue" }, buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];

  # =====================================================================
  # COMMANDES UTILES SIMPLIFIÉES
  # =====================================================================
  extraConfigLua = ''
    -- Commande pour générer compile_commands.json
    vim.api.nvim_create_user_command("GenerateCompileCommands", function()
      local cwd = vim.fn.getcwd()
      
      if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        require("snacks").terminal.open("bear -- make clean && bear -- make")
      elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then  
        require("snacks").terminal.open("cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build && cp build/compile_commands.json .")
      else
        require("snacks").notify("No Makefile or CMakeLists.txt found", { level = "warn" })
      end
    end, { desc = "Generate compile_commands.json" })
    
    -- Commande pour créer compile_flags.txt (fallback simple)
    vim.api.nvim_create_user_command("CreateCompileFlags", function()
      local flags = {
        "-std=c++17",
        "-Wall",
        "-Wextra",
        "-I.",
        "-I./include",
        "-I/usr/include",
        "-I/usr/local/include"
      }
      
      local content = table.concat(flags, "\n") .. "\n"
      local file = io.open("compile_flags.txt", "w")
      if file then
        file:write(content)
        file:close()
        require("snacks").notify("Created compile_flags.txt", { title = "C/C++" })
      else
        require("snacks").notify("Failed to create compile_flags.txt", { level = "error" })
      end
    end, { desc = "Create compile_flags.txt" })
  '';
}
