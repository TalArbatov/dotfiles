return {
  {
    "lewis6991/gitsigns.nvim",

    opts = {
      current_line_blame = false,

      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
          })
        end

        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next Git hunk")

        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Previous Git hunk")

        map("n", "<leader>gp", gs.preview_hunk, "Preview Git hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage Git hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset Git hunk")

        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Git blame line")

        map("n", "<leader>gd", gs.diffthis, "Git diff")
      end,
    },
  },
}
