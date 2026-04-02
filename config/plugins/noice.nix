{
  # =====================================================================
  # NOICE.NVIM - Configuration minimaliste (95% de code en moins !)
  # =====================================================================

  plugins = {
    noice = {
      enable = true;

      settings = {
        # ===== PRESETS ESSENTIELS =====
        # Les presets font 90% du travail !
        presets = {
          bottom_search = true; # Recherche en bas (style classique)
          command_palette = true; # Cmdline + popupmenu ensemble  
          long_message_to_split = true; # Messages longs en split
          lsp_doc_border = true;
        };

        # ===== LSP OVERRIDE ESSENTIELS =====
        # Seulement les overrides critiques pour LSP + blink.cmp
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true; # Compatible blink.cmp
          };
        };

        # ===== ROUTES MINIMALISTES =====  
        # Juste les filtres essentiels pour réduire le spam
        routes = [
          # Messages de sauvegarde vers mini
          {
            filter = {
              event = "msg_show";
              any = [
                { find = "%d+L, %d+B"; }
                { find = "; after #%d+"; }
                { find = "; before #%d+"; }
                { find = "written"; }
              ];
            };
            view = "mini";
          }
          
          # Filtrer spam LSP 
          {
            filter = {
              event = "notify";
              find = "No information available";
            };
            opts = { skip = true; };
          }
        ];

        # ===== NOTIFICATIONS DÉSACTIVÉES =====
        # NOTE : Snacks.notifier gère tout
        notify = {
          enabled = false;
        };

        # SUPPRIMÉ : 200+ lignes de vues, cmdline, messages, popupmenu, 
        # smart_move, format, throttle, etc.
        # → Les défauts de noice + presets font tout le travail !
      };
    };

    # Dépendance requise
    nui = {
      enable = true;
    };
  };

  # =====================================================================
  # SUPPRIMÉ : tout l'extraConfigLua superflu
  # - Highlights : gruvbox + noice se configurent automatiquement  
  # - Intégrations telescope : automatiques
  # - Commandes personnalisées : les commandes natives suffisent
  # =====================================================================
}
