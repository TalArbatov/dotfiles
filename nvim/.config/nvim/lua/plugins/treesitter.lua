local linux_compat = vim.fn.has("linux") == 1

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = linux_compat and "master" or nil,

    -- The current Treesitter rewrite explicitly does not support lazy loading.
    lazy = false,

    -- Keep installed parsers compatible when updating the plugin.
    build = ":TSUpdate",

    config = function()


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
      if linux_compat then
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then
          vim.notify(
            "Run :Lazy update nvim-treesitter, then restart Neovim.",
            vim.log.levels.WARN
          )
          return
        end

        configs.setup({
          ensure_installed = parsers,
          auto_install = false,
          highlight = { enable = true },
        })
        return
      end

      local treesitter = require("nvim-treesitter")
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
