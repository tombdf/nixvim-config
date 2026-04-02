{
  # =====================================================================
  # DROPBAR.NVIM - Configuration minimaliste (le plugin est "zero config")
  # =====================================================================

  plugins.dropbar = {
    enable = true;

    settings = {
      bar = {
        # Désactiver plus conservativement pour éviter conflits avec snacks
        enable = {
          __raw = ''
            function(buf, win, _)
              -- Ne pas activer si la fenêtre est trop petite
              if vim.api.nvim_win_get_height(win) < 10 then
                return false
              end
              
              -- Désactiver pour les filetypes problématiques
              local disabled_fts = { 
                'snacks_dashboard', 'snacks_terminal', 'snacks_picker',
                'lazy', 'mason', 'lspinfo', 'help', 'qf', 'quickfix'
              }
              
              if vim.tbl_contains(disabled_fts, vim.bo[buf].ft) then
                return false
              end
              
              -- Désactiver dans les fenêtres flottantes
              local config = vim.api.nvim_win_get_config(win)
              if config.relative ~= "" then
                return false
              end
              
              return true
            end
          '';
        };
      };

      # Juste les icônes UI pour cohérence avec le thème gruvbox
      icons = {
        ui = {
          bar = {
            separator = " › "; # Plus lisible que le défaut
          };
        };
      };

      # Bordures arrondies pour cohérence avec le reste de la config
      menu = {
        # Réduire la hauteur max pour éviter les conflits
        max_height = 15;
      };
    };
  };

  # =====================================================================
  # TELESCOPE FZF NATIVE - Optionnel pour fuzzy search amélioré dans dropbar
  # =====================================================================
  plugins.telescope = {
    extensions = {
      fzf-native = {
        enable = true;
      };
    };
  };
}
