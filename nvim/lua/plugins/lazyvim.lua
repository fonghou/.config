-- stylua: ignore

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  { "folke/noice.nvim", enabled = false },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  {
    "folke/which-key.nvim",
    opts = {
      -- delay = 500,
      preset = 'helix',
      win = { no_overlap = true }
    },
  },

  -- change surround mappings
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "clojure",
        "fennel",
        "haskell",
      })
    end,
  },

  {
    'saghen/blink.cmp',
    opts = {
      keymap = {
        preset = "default",
      },
      completion = {
        ghost_text = { enabled = false },
      },
      signature = { enabled = true }
    }
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false }
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "debugpy",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "ruff",
        "ruff-lsp",
        "shellcheck",
        "shfmt",
        "stylua",
        "taplo",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        haskell = { "stylishhaskell" },
      },
      formatters = {
        stylishhaskell = {
          command = "stylish-haskell",
          args = { "-i" },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "nvim-dap-ui",
        opts = {
          layouts = {
            {
              position = "top",
              size = 0.3,
              elements = {
                { id = "scopes", size = 0.6 },
                { id = "stacks", size = 0.4 },
              },
            },
            {
              position = "bottom",
              size = 0.3,
              elements = {
                { id = "repl", size = 0.6 },
                { id = "console", size = 0.4},
              },
            }
          },
        },
      },
    },
  },

}
