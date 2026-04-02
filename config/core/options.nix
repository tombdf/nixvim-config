{
  # =====================================================================
  # OPTIONS NEOVIM
  # =====================================================================

  globals.mapleader = " ";

  opts = {
    # Performance
    updatetime = 200;
    timeoutlen = 300;

    # Interface
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;

    # Recherche
    ignorecase = true;
    smartcase = true;
    hlsearch = true;

    # Édition
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;
    autoindent = true;

    # Splits
    splitbelow = true;
    splitright = true;

    # Autre
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    mouse = "a";
    clipboard = "unnamedplus";

    # Sauvegarde et undo
    undofile = true;
    swapfile = false;
    backup = false;

    # Interface terminale
    termguicolors = true;

    # Bordures des fenêtres flottantes
    winborder = "rounded";
  };

  # Modifie le padding kitty en entrant et en quittant nvim
  autoCmd = [
    {
      event = "VimEnter";
      callback.__raw = ''
        function()
          local socket = os.getenv("KITTY_LISTEN_ON")
          local win_id = os.getenv("KITTY_WINDOW_ID")
          if socket and socket ~= "" and win_id then
            vim.fn.jobstart({
              "kitten", "@", "--to=" .. socket,
              "set-spacing", "--match", "id:" .. win_id, "padding-left=0"
            })
          end
        end
      '';
    }
    {
      event = "VimLeavePre";
      callback.__raw = ''
        function()
          local socket = os.getenv("KITTY_LISTEN_ON")
          local win_id = os.getenv("KITTY_WINDOW_ID")
          if socket and socket ~= "" and win_id then
            vim.fn.system({
              "kitten", "@", "--to=" .. socket,
              "set-spacing", "--match", "id:" .. win_id, "padding-left=5"
            })
          end
        end
      '';
    }
  ];
}
