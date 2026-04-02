{
  # =====================================================================
  # KEYMAPS COMPLETS - Configuration JKLM et organisation par groupes
  # VERSION NETTOYÉE - Nixvim gère le LSP automatiquement
  # =====================================================================

  keymaps = [
    # ===== MOUVEMENT CUSTOM (JKLM au lieu de HJKL) =====
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "j";
      action = "h";
      options.desc = "Move left";
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "k";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "Move down";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "l";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Move up";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "Move up";
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "m";
      action = "l";
      options.desc = "Move right";
    }

    # Remap mark key
    {
      mode = "n";
      key = "§";
      action = "m";
      options.desc = "Set mark";
    }

    # ===== NAVIGATION FENÊTRES (adapté pour JKLM) =====
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>j";
      options.desc = "Go to lower window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>k";
      options.desc = "Go to upper window";
    }
    {
      mode = "n";
      key = "<C-m>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }

    # ===== AMÉLIORATIONS DE BASE =====
    {
      mode = "n";
      key = "n";
      action = "nzz";
      options.desc = "Next search result (centered)";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzz";
      options.desc = "Previous search result (centered)";
    }
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear search highlight";
    }

    # ===== MODE INSERTION =====
    {
      mode = "i";
      key = "jj";
      action = "<ESC>";
      options.desc = "Exit insert mode";
    }
    {
      mode = "i";
      key = "<C-d>";
      action = "<ESC>ddi";
      options.desc = "Delete line";
    }
    {
      mode = "i";
      key = "<C-b>";
      action = "<ESC>^i";
      options.desc = "Beginning of line";
    }
    {
      mode = "i";
      key = "<C-e>";
      action = "<End>";
      options.desc = "End of line";
    }

    {
      mode = "i";
      key = "<A-;>";
      action.__raw = ''
        function()
          local line = vim.api.nvim_get_current_line()
          local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
          local after_cursor = line:sub(cursor_col + 1)
      
          -- Si déjà un ; à la fin, ne rien faire
          if line:match(";%s*$") then
            return
          end
      
          -- Patterns qui ne veulent PAS de ;
          local no_semicolon_patterns = {
            "^%s*#",           -- Macros C (#define, #include)
            "^%s*if%s*%(.*%)%s*$",     -- if (...) 
            "^%s*while%s*%(.*%)%s*$",  -- while (...)
            "^%s*for%s*%(.*%)%s*$",    -- for (...)
            "^%s*else%s*$",            -- else
            "^%s*{%s*$",               -- { (début de bloc)
            "^%s*.*{%s*$",             -- tout ce qui finit par {
          }
      
          -- Vérifier si on est dans un cas qui ne veut pas de ;
          for _, pattern in ipairs(no_semicolon_patterns) do
            if line:match(pattern) then
              return
            end
          end
      
          -- Ajouter ; à la fin de la ligne
          vim.cmd("normal! A;")
        end
      '';
      options.desc = "Smart semicolon";
    }
    {
      mode = "i";
      key = "<A-,>";
      action.__raw = ''
        function()
          local line = vim.api.nvim_get_current_line()
          if not line:match(",%s*$") then
            vim.cmd("normal! A,")
          end
        end
      '';
      options.desc = "Smart comma";
    }

    # ===== NAVIGATION BUFFERS =====
    {
      mode = "n";
      key = "<S-TAB>";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<TAB>";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }

    # ===== TERMINAL =====
    {
      mode = "t";
      key = "<C-x>";
      action = "<C-\\><C-N>";
      options.desc = "Exit terminal mode";
    }

    # ===== SAUVEGARDE ET QUITTER =====
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>w<cr>";
      options.desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options.desc = "Quit";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>qa!<cr>";
      options.desc = "Quit all (force)";
    }

    # ===== INDENTATION =====
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Decrease indent";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Increase indent";
    }

    # ===== SÉLECTION =====
    {
      mode = "n";
      key = "<C-a>";
      action = "ggVG";
      options.desc = "Select all";
    }

    # ===== REDIMENSIONNEMENT FENÊTRES =====
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options.desc = "Increase window height";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options.desc = "Decrease window height";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options.desc = "Decrease window width";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options.desc = "Increase window width";
    }

    # =====================================================================
    # LEADER MAPPINGS - Organisés par fonctionnalité - VERSION SIMPLIFIÉE
    # =====================================================================

    # ===== DROPBAR  =====
    {
      mode = "n";
      key = "<leader><tab>";
      action.__raw = ''
        function()
          require('dropbar.api').pick()
        end
      '';
      options.desc = "Pick Symbol (Interactive)";
    }

    # ===== CODE GROUP - <leader>c =====
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<cr>";
      options.desc = "Format";
    }
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      options.desc = "Line Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>cD";
      action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      options.desc = "Buffer Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action.__raw = ''
        function()
          vim.lsp.codelens.run()
        end
      '';
      options.desc = "Run Code Lens";
    }
    {
      mode = "n";
      key = "<leader>cL";
      action.__raw = ''
        function()
          vim.lsp.codelens.refresh()
        end
      '';
      options.desc = "Refresh Code Lens";
    }

    # ===== DIAGNOSTICS GROUP - <leader>x =====
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>copen<cr>";
      options.desc = "Quickfix List";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options.desc = "Location List";
    }
    # Diagnostics (le plus utile - toujours des résultats)
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    # Diagnostics buffer courant (toujours utile)
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    # Symboles LSP (utile avec LSP)
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle<cr>";
      options.desc = "Symbols (Trouble)";
    }

    # =====================================================================
    # NAVIGATION - g, [, ], z prefixes - Nixvim configure automatiquement
    # =====================================================================

    # Navigation diagnostics
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.jump({ count = -1 })<cr>";
      options.desc = "Previous Diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.jump({ count = 1 })<cr>";
      options.desc = "Next Diagnostic";
    }

    # Navigation buffers
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options.desc = "Prev Buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
    }

  ];
}
