{ pkgs, ...}:
{
  # =====================================================================
  # CONFIGURATION GIT + METEOR - Conventional Commits
  # =====================================================================

  plugins = {
    # =================================================================
    # GITSIGNS - Juste les icônes personnalisées (style LazyVim)
    # =================================================================
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
          untracked = { text = "▎"; };
        };
        signs_staged = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
        };
      };
    };

    # =================================================================
    # AUTRES PLUGINS - Configuration minimale (défauts excellents)
    # =================================================================
    fugitive.enable = true;
    diffview.enable = true;
    # git-conflict.enable = true;
  };

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>g"; group = "Git"; }
  ];

  # =====================================================================
  # PACKAGES ESSENTIELS + METEOR
  # =====================================================================
  extraPackages = with pkgs; [
    git
    lazygit
    meteor-git  # ← CLI pour conventional commits
  ];

  keymaps = [
    # ===== GIT GROUP - <leader>g =====
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<cr>";
      options.desc = "Lazygit";
    }
    
    # METEOR COMMITS - Remplace git commit classique
    {
      mode = "n";
      key = "<leader>gc";
      action.__raw = ''
        function()
          require("snacks").terminal.open("meteor", {
            title = "Meteor - Conventional Commits",
            size = { width = 0.8, height = 0.6 },
            -- Terminal interactif qui se ferme après commit
            on_exit = function()
              require("snacks").notify("Commit created! 🚀", { 
                title = "Meteor",
                icon = "󰊢"
              })
            end
          })
        end
      '';
      options.desc = "Commit (Meteor)";
    }
    
    # Git commit classique en backup
    {
      mode = "n";
      key = "<leader>gC";
      action = "<cmd>Git commit<cr>";
      options.desc = "Git Commit (Classic)";
    }
    
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>Git push<cr>";
      options.desc = "Git Push";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Git blame<cr>";
      options.desc = "Git Blame";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action.__raw = ''function() require("snacks").picker.git_diff() end'';
      options.desc = "Git Diff (hunks)";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action.__raw = ''function() require("snacks").picker.git_status() end'';
      options.desc = "Git Status";
    }

    # Git hunks (gitsigns intégré automatiquement par Nixvim)
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage Hunk";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset Hunk";
    }

    # =====================================================================
    # NAVIGATION - g, [, ], z prefixes - Nixvim configure automatiquement
    # =====================================================================
    {
      mode = "n";
      key = "]h";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end
      '';
      options.desc = "Next Hunk";
    }
    {
      mode = "n";
      key = "[h";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end
      '';
      options.desc = "Prev Hunk";
    }
  ];

  # =====================================================================
  # CONFIGURATION SUPPLÉMENTAIRE - Meteor + Git
  # =====================================================================
  extraConfigLua = ''
    -- Diffview : configuration ultra-simple (défauts excellents)
    require("diffview").setup({
      enhanced_diff_hl = false,
      view = {
        default = { disable_diagnostics = true },
        merge_tool = { disable_diagnostics = true },
      },
    })
    
    -- Git-conflict : défauts parfaits, juste activer
    -- require("git-conflict").setup()
    
    -- Commandes utiles simplifiées
    vim.api.nvim_create_user_command("GitStageFile", function()
      require("gitsigns").stage_buffer()
      require("snacks").notify("File staged", { title = "Git" })
    end, { desc = "Stage current file" })
    
    vim.api.nvim_create_user_command("GitUnstageFile", function()
      require("gitsigns").reset_buffer()
      require("snacks").notify("File unstaged", { title = "Git" })
    end, { desc = "Unstage current file" })
    
    -- METEOR : Commandes utiles pour conventional commits
    vim.api.nvim_create_user_command("MeteorCommit", function()
      require("snacks").terminal.open("meteor", {
        title = "Meteor - Conventional Commits",
        size = { width = 0.8, height = 0.6 }
      })
    end, { desc = "Open Meteor for conventional commits" })
    
    -- Fonction pour créer .meteor.json dans le projet
    vim.api.nvim_create_user_command("MeteorConfig", function()
      local config = {
        boards = {
          { name = "FEAT" },
          { name = "FIX" },
          { name = "DOCS" },
          { name = "NONE" }
        },
        prefixes = {
          { type = "feat", description = "a new feature" },
          { type = "fix", description = "a bug fix" },
          { type = "docs", description = "documentation only changes" },
          { type = "style", description = "changes that do not affect the meaning of the code" },
          { type = "refactor", description = "a code change that neither fixes a bug nor adds a feature" },
          { type = "perf", description = "a code change that improves performance" },
          { type = "test", description = "adding missing tests or correcting existing tests" },
          { type = "chore", description = "changes to the build process or auxiliary tools" }
        },
        commitTitleCharLimit = 72,
        commitBodyCharLimit = 72,
        commitBodyLineLength = 72,
        showIntro = false
      }
      
      local json_content = vim.fn.json_encode(config)
      local file = io.open(".meteor.json", "w")
      if file then
        file:write(json_content)
        file:close()
        require("snacks").notify("Created .meteor.json configuration", { 
          title = "Meteor",
          icon = "󰊢"
        })
      else
        require("snacks").notify("Failed to create .meteor.json", { 
          level = "error", 
          title = "Meteor" 
        })
      end
    end, { desc = "Create .meteor.json config file" })
  '';
}
