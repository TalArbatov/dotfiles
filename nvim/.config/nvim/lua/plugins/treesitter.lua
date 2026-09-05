return {
  {
    "nvim-treesitter/nvim-treesitter",

    -- The current Treesitter rewrite explicitly does not support lazy loading.
    lazy = false,

    -- Keep installed parsers compatible when updating the plugin.
    build = ":TSUpdate",

    config = function()
      local treesitter = require("nvim-treesitter")

      local parsers = {
        -- Your main stack
        "javascript",
        "typescript",
        "tsx",

        -- Web
        "html",
        "css",
        "json",

        -- Config / tooling
        "lua",
        "bash",
        "yaml",
        "toml",

        -- Common repo files
        "markdown",
        "markdown_inline",
      }

      -- Installs missing parsers. Existing ones are left alone.
      treesitter.install(parsers)

      -- Enable Treesitter highlighting for these Neovim filetypes.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "html",
          "css",
          "json",
          "lua",
          "bash",
          "yaml",
          "toml",
          "markdown",
        },

        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
