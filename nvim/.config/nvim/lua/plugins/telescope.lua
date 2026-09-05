return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",

    dependencies = {
      "nvim-lua/plenary.nvim",

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },

      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          vimgrep_arguments = {'rg', '--hidden'},
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })

      pcall(telescope.load_extension, "fzf")

      vim.keymap.set(
        "n",
        "<leader>ff",
        builtin.find_files,
        { desc = "Find files" }
      )

      vim.keymap.set(
        "n",
        "<leader>fg",
        builtin.live_grep,
        { desc = "Find text" }
      )

      vim.keymap.set(
        "n",
        "<leader>fb",
        builtin.buffers,
        { desc = "Find buffers" }
      )

      vim.keymap.set(
        "n",
        "<leader>fh",
        builtin.help_tags,
        { desc = "Find help" }
      )

      vim.keymap.set(
        "n",
        "<leader>fr",
        builtin.oldfiles,
        { desc = "Recent files" }
      )
    end,
  },
}
