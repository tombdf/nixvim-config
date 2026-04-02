{ pkgs, ... }:
{
  # =====================================================================
  # PLUGINS LSP ENHANCEMENTS - Configuration minimaliste
  # =====================================================================

  plugins = {
    # =================================================================
    # GOTO-PREVIEW - Prévisualisation des définitions/références
    # =================================================================
    goto-preview = {
      enable = true;
      settings = {
        default_mappings = false; # On configure nos keymaps
      };
    };

    # =================================================================
    # INC-RENAME - Renommage interactif
    # =================================================================
    inc-rename = {
      enable = true;
      # Défauts parfaits, rien à configurer
    };

    # =================================================================
    # ACTIONS-PREVIEW - Prévisualisation des code actions
    # =================================================================
    actions-preview = {
      enable = true;
      # Défauts intelligents, rien à configurer
    };

    # =================================================================
    # NVIM-LIGHTBULB - Indicateur visuel des code actions
    # =================================================================
    nvim-lightbulb = {
      enable = true;
      settings = {
        autocmd = {
          enabled = true;
        };
        priority = 1000;
      };
    };
  };

  # =====================================================================
  # KEYMAPS - Juste l'essentiel
  # =====================================================================
  keymaps = [
    # Goto Preview
    {
      mode = "n";
      key = "gpd";
      action.__raw = ''function() require('goto-preview').goto_preview_definition() end'';
      options.desc = "Preview Definition";
    }
    {
      mode = "n";
      key = "gpt";
      action.__raw = ''function() require('goto-preview').goto_preview_type_definition() end'';
      options.desc = "Preview Type Definition";
    }
    {
      mode = "n";
      key = "gpi";
      action.__raw = ''function() require('goto-preview').goto_preview_implementation() end'';
      options.desc = "Preview Implementation";
    }
    {
      mode = "n";
      key = "gpr";
      action.__raw = ''function() require('goto-preview').goto_preview_references() end'';
      options.desc = "Preview References";
    }
    {
      mode = "n";
      key = "gP";
      action.__raw = ''function() require('goto-preview').close_all_win() end'';
      options.desc = "Close All Preview";
    }

    # Enhanced LSP actions (remplace les keymaps existants)
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ca";
      action.__raw = ''function() require("actions-preview").code_actions() end'';
      options.desc = "Code Actions (Preview)";
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = ":IncRename ";
      options = {
        desc = "Rename Symbol (Interactive)";
      };
    }
  ];
}
