{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION DES LANGAGES - Version avec grammarPackages
  # =====================================================================

  imports = [
    ./bash.nix
    ./c.nix
    ./nix.nix
    ./haskell.nix
    ./markdown.nix
    ./python.nix
    ./rust.nix
  ];

  plugins = {
    # =====================================================================
    # LSP DE BASE
    # =====================================================================
    lsp.enable = true;

    # =====================================================================
    # TREESITTER - Configuration complète RESTAURÉE
    # =====================================================================
    treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        # Langages de base
        lua
        luadoc
        luap
        vim
        vimdoc
        query
        regex
        printf

        # Shell
        bash
        fish

        # Git
        diff
        git_config
        git_rebase
        gitcommit
        gitignore

        # Configuration et données
        json
        yaml
        toml
        xml
      ];

      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };

        indent = {
          enable = true;
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = "<C-s>";
            node_decremental = "<M-space>";
          };
        };
      };
    };

    # Plugin additionnel pour le contexte
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 0;
        line_numbers = true;
        trim_scope = "outer";
        mode = "cursor";
      };
    };


    # NOTE: Bug actuellement sur nixpkgs 25.11+, à réactiver par la suite (voir issue #4108)
    # Text objects utiles  
    # treesitter-textobjects = {
    #   enable = true;
    #   settings = {
    #     select = {
    #       enable = true;
    #       lookahead = true;
    #       keymaps = {
    #         "af" = "@function.outer";
    #         "if" = "@function.inner";
    #         "ac" = "@class.outer";
    #         "ic" = "@class.inner";
    #       };
    #     };
    #   };
    # };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 1000;
          lsp_fallback = true; # Fallback vers LSP si conform n'a pas de formatter
        };
      };
    };

    lint = {
      enable = true;
      autoCmd = {
        callback.__raw = ''
          function()
            require('lint').try_lint()
          end
        '';
        event = [ "BufEnter" "BufWritePost" "InsertLeave" "TextChanged" ];
      };
    };
  };

  # keymaps = [
  #   {
  #     mode = "n";
  #     key = "[C"; # [c est pris par mini.bracketed (comments)
  #     action.__raw = ''function() require("treesitter-context").go_to_context(vim.v.count1) end'';
  #     options = { silent = true; desc = "Go to context"; };
  #   }
  # ];

  diagnostic.settings = {
    virtual_lines.current_line = true;
    virtual_text = false;
    #   spacing = 4;
    #   prefix = "●";
    #   format.__raw = ''
    #     function(diagnostic)
    #       local message = diagnostic.message
    #       if #message > 60 then
    #         message = message:sub(1, 57) .. "..."
    #       end
    #       local source = diagnostic.source
    #       if source and source ~= "" then
    #         return string.format("[%s] %s", source, message)
    #       end
    #       return message
    #     end
    #   '';
    # };

    float = {
      focusable = false;
      style = "minimal";
      source = "always";
      header = "";
      prefix = "";
      suffix = "";
      format.__raw = ''
        function(diagnostic)
          local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
          local source = diagnostic.source and string.format(" (%s)", diagnostic.source) or ""
          return string.format("%s%s%s", diagnostic.message, code, source)
        end
      '';
    };

    signs = {
      text.__raw = ''
        {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰌵 ",
        }
      '';
    };

    underline = true;
    update_in_insert = true;
    severity_sort = true;

    # Neovim 0.11 : ouvre automatiquement le float lors de la navigation [d/]d
    jump = {
      float = false;
    };
  };

  # Relance lint après auto-save (noautocmd = true empêche BufWritePost)
  autoCmd = [
    {
      event = [ "User" ];
      pattern = [ "AutoSaveWritePost" ];
      callback.__raw = ''
        function()
          require('lint').try_lint()
        end
      '';
    }
  ];
}
