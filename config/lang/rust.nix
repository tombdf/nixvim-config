{ pkgs, ... }:
{
  # =====================================================================
  # CONFIGURATION RUST - Avec keymaps locaux
  # =====================================================================

  plugins = {
    # =====================================================================
    # RUSTACEANVIM - Gère rust-analyzer automatiquement (ne pas utiliser
    # lsp.servers.rust_analyzer en parallèle, cela crée des conflits !)
    # =====================================================================
    rustaceanvim = {
      enable = true;
      # Défauts excellents - zéro configuration nécessaire
    };

    # =====================================================================
    # CRATES.NVIM - Gestion des dépendances Cargo.toml
    # =====================================================================
    crates = {
      enable = true;
      settings = {
        completion.crates.enabled = true;
        lsp = {
          enabled = true;
          actions = true;
          completion = true;
          hover = true;
        };
      };
    };

    treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      rust
      toml
    ];

    # LSP TOML (Cargo.toml, etc.)
    lsp.servers.taplo.enable = true;

    conform-nvim.settings.formatters_by_ft = {
      rust = [ "rustfmt" ];
      toml = [ "taplo" ];
    };

    # Pas de lint séparé : clippy est intégré via rust-analyzer checkOnSave
  };

  # =====================================================================
  # PACKAGES ESSENTIELS
  # =====================================================================
  extraPackages = with pkgs; [
    rust-analyzer
    rustfmt
    clippy
    taplo
  ];

  # =====================================================================
  # AUTOCOMMANDS AVEC KEYMAPS LOCAUX
  # =====================================================================
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "rust" ];
      callback.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()

          -- Options d'indentation
          vim.bo.tabstop = 4
          vim.bo.shiftwidth = 4
          vim.bo.expandtab = true
          vim.bo.commentstring = "// %s"

          -- KEYMAPS LOCAUX - Seulement pour les buffers Rust !
          local opts = { buffer = bufnr, desc = "" }

          -- Override K : hover actions rustaceanvim (plus riche que le défaut LSP)
          opts.desc = "Hover Actions"
          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, opts)

          -- Runnables (cargo run, tests, exemples...)
          opts.desc = "Runnables"
          vim.keymap.set("n", "<leader>Rr", function()
            vim.cmd.RustLsp("runnables")
          end, opts)

          -- Debuggables (intégration dap-lldb)
          opts.desc = "Debuggables"
          vim.keymap.set("n", "<leader>Rd", function()
            vim.cmd.RustLsp("debuggables")
          end, opts)

          -- Expand macro
          opts.desc = "Expand Macro"
          vim.keymap.set("n", "<leader>Re", function()
            vim.cmd.RustLsp("expandMacro")
          end, opts)

          -- Ouvrir Cargo.toml
          opts.desc = "Open Cargo.toml"
          vim.keymap.set("n", "<leader>Rc", function()
            vim.cmd.RustLsp("openCargo")
          end, opts)

          -- Module parent
          opts.desc = "Parent Module"
          vim.keymap.set("n", "<leader>Rp", function()
            vim.cmd.RustLsp("parentModule")
          end, opts)

          -- Join lines (spécifique Rust)
          opts.desc = "Join Lines"
          vim.keymap.set("n", "<leader>Rj", function()
            vim.cmd.RustLsp("joinLines")
          end, opts)

          -- Configuration which-key pour ce buffer seulement
          vim.defer_fn(function()
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>R", group = "Rust", icon = { icon = "󱘗", color = "orange" }, buffer = bufnr },
              })
            end
          end, 100)
        end
      '';
    }
  ];
}
