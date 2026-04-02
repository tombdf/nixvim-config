{
  # =====================================================================
  # MINI.NVIM - Configuration simplifiée
  # =====================================================================

  plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules = {
      # Icons de base
      icons = { };

      # Text objects améliorés
      ai = {
        n_lines = 500;
      };

      # Auto-pairing simple
      pairs = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
        # silent = true; # Évite les conflits avec noice
      };

      # Surround simple
      surround = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
        };
        # silent = true; # Évite les conflits avec noice
      };

      # Commentaires
      comment = {
        mappings = {
          comment = "gc";
          comment_line = "gcc";
          comment_visual = "gc";
        };
        # silent = true; # Évite les conflits avec noice
      };

      # Mise en évidence de patterns
      hipatterns = {
        highlighters = {
          hex_color = {
            __raw = ''require('mini.hipatterns').gen_highlighter.hex_color()'';
          };
          # Couleurs courtes (#rgb)
          shorthand = {
            pattern = "()#%x%x%x()%f[^%x%w]";
            group.__raw = ''
              function(_, _, data)
                local match = data.full_match
                local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                return require('mini.hipatterns').compute_hex_color_group("#" .. r .. r .. g .. g .. b .. b, "bg")
              end
            '';
          };
        };
      };

      # Déplacement de lignes/blocs amélioré
      move = {
        mappings = {
          # Déplacements avec Alt (cohérent avec vos keymaps existants)
          left = "<A-j>"; # Gauche (indent)
          right = "<A-m>"; # Droite (dedent)
          down = "<A-k>"; # Bas (garde cohérence)
          up = "<A-l>"; # Haut (garde cohérence)

          # En mode visual
          line_left = "<A-j>";
          line_right = "<A-m>";
          line_down = "<A-k>";
          line_up = "<A-l>";
        };
      };

      # Navigation f/F/t/T améliorée (complémentaire à spider)
      jump = {
        mappings = {
          forward = "f";
          backward = "F";
          forward_till = "t";
          backward_till = "T";
          repeat_jump = ";";
        };
      };

      # Split/join intelligent
      splitjoin = {
        mappings = {
          toggle = "gS"; # Split ↔ join arguments/listes
        };
      };

      # Navigation avec [ et ] pour différents objets
      bracketed = {

        # Désactive les mappings qui rentrent en conflit avec tes keymaps
        buffer = { suffix = ""; }; # Désactive [b ]b (tu as déjà ça)
        diagnostic = { suffix = ""; }; # Désactive [d ]d (tu as déjà ça)
        yank = { suffix = ""; }; # Désactive [y ]y (tu as yanky)
        location = { suffix = ""; }; # Désactive [l ]l (défaut neovim)  
        quickfix = { suffix = ""; }; # Désactive [q ]q (défaut neovim)

        # Active les autres mappings utiles (pas de conflit)
        comment = { suffix = "c"; }; # [c ]c pour les commentaires
        conflict = { suffix = "x"; }; # [x ]x pour les conflits git
        file = { suffix = "f"; }; # [f ]f pour les fichiers dans le directory
        indent = { suffix = "i"; }; # [i ]i pour les niveaux d'indentation
        jump = { suffix = "j"; }; # [j ]j pour la jump list
        oldfile = { suffix = "o"; }; # [o ]o pour les fichiers récents
        treesitter = { suffix = "n"; }; # [n ]n pour les nodes treesitter
        undo = { suffix = "u"; }; # [u ]u pour l'undo tree
        window = { suffix = "w"; }; # [w ]w pour les fenêtres
      };
    };
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "gs"; group = "Surround"; }
    { __unkeyed-1 = "gp"; group = "Peek/Preview"; }
  ];

}
