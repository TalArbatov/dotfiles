return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,

    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      close_if_last_window = false,

      enable_git_status = true,
      enable_diagnostics = false,

      filesystem = {
        follow_current_file = {
          enabled = true,
        },

        use_libuv_file_watcher = true,

        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },

    keys = {
      {
        "<leader>e",
        "<cmd>Neotree filesystem reveal toggle left<CR>",
        desc = "Toggle file explorer",
      },
    },
  },
}
