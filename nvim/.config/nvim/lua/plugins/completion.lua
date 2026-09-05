return {
  {
    "saghen/blink.cmp",

    -- Stay on stable v1.
    version = "1.*",

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    opts = {
      -- Similar to VS Code:
      -- Tab selects/accepts completions.
      keymap = {
        preset = "super-tab",
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },

        ghost_text = {
          enabled = true,
        },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },

      signature = {
        enabled = true,
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },

    opts_extend = {
      "sources.default",
    },
  },
}
