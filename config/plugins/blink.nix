{
  # =====================================================================
  # BLINK.CMP + FRIENDLY-SNIPPETS - Configuration VÉRIFIÉE qui marche
  # =====================================================================

  plugins = {
    # =====================================================================
    # BLINK.CMP - Configuration simplifiée
    # =====================================================================
    blink-cmp = {
      enable = true;

      settings = {
        # =====================================================================
        # KEYMAPS
        # =====================================================================
        keymap = {
          preset = "none";

          # Navigation principale avec TAB
          "<Tab>" = [ "select_next" "fallback" ];
          "<S-Tab>" = [ "select_prev" "fallback" ];

          # Accepter la complétion
          "<CR>" = [ "accept" "fallback" ];
          "<C-y>" = [ "accept" ];

          # Navigation alternative
          "<C-n>" = [ "select_next" ];
          "<C-p>" = [ "select_prev" ];
          "<Down>" = [ "select_next" ];
          "<Up>" = [ "select_prev" ];

          # Contrôle du menu
          "<C-e>" = [ "hide" "fallback" ];
          "<C-space>" = [ "show" ];

          # Documentation
          "<C-d>" = [ "scroll_documentation_down" "fallback" ];
          "<C-u>" = [ "scroll_documentation_up" "fallback" ];

          # Navigation snippets
          "<C-l>" = [ "snippet_forward" "fallback" ];
          "<C-h>" = [ "snippet_backward" "fallback" ];
        };

        # =====================================================================
        # SOURCES - CONFIGURATION MINIMALE (blink détecte automatiquement)
        # =====================================================================
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];
        };

        # =====================================================================
        # APPARENCE
        # =====================================================================
        appearance = {
          use_nvim_cmp_as_default = false;
          nerd_font_variant = "normal";
        };

        # =====================================================================
        # COMPLÉTION
        # =====================================================================
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
            };
          };

          documentation = {
            auto_show = true;
          };

          ghost_text = {
            enabled = true;
          };
        };

        # =====================================================================
        # SIGNATURE HELP
        # =====================================================================
        signature = {
          enabled = true;
        };
      };
    };

    # =====================================================================
    # FRIENDLY-SNIPPETS - Plugin natif Nixvim
    # =====================================================================
    friendly-snippets = {
      enable = true;
    };
  };
}
