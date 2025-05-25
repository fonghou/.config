local M = {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6",
    lazy = false,
    cond = function()
      return vim.fn.filereadable("hls.json") ~= 0 and true
    end,
    init = function()
      vim.g.haskell_tools = {
        tools = {
          codeLens = { autoRefresh = true },
          hover = { enable = false },
        },
      }
    end,
    keys = {
      {
        "<leader>ch",
        function()
          require("haskell-tools").hoogle.hoogle_signature()
        end,
        desc = "Hoogle Search",
      },
    },
  },
  {
    "mrcjkb/haskell-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip" },
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
      local haskell_snippets = require("haskell-snippets").all
      require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
    end,
  },
  {
    "luc-tielen/telescope_hoogle",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension("hoogle")
      end
    end,
  },
  {
    "fonghou/fzf-hoogle.vim",
    ft = "haskell",
    dependencies = {
      { "junegunn/fzf", build = "./install --all" },
      "junegunn/fzf.vim",
      "mrcjkb/haskell-snippets.nvim",
      {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = function(_, opts)
          opts.sources = {
            require("plugins.haskell").ghcid(),
            require("plugins.haskell").hlint(),
          }
        end,
      },
    },
    config = function()
      vim.g["hoogle_open_link"] = "open"
      if vim.fn.filereadable("./static-ls") ~= 0 then
        require "lspconfig".hls.setup {
          cmd = { "./static-ls" },
          root_dir = function()
            return vim.fs.root(0, ".hiedb")
          end,
        }
      end
    end,
  },
}

function M.ghcid()
  local null_ls = require("null-ls")
  local helpers = require("null-ls.helpers")
  return {
    name = "ghcid",
    meta = { url = "https://github.com/ndmitchell/ghcid" },
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "haskell" },
    cwd = helpers.cache.by_bufnr(function()
      return vim.fs.root(0, "ghcid.txt")
    end),
    generator = helpers.generator_factory({
      command = "bash",
      args = {
        "-c",
        [[ sleep 2 && [ -f ghcid.txt ] && cat ghcid.txt \
          | grep -A2 -E '.*[^>]: (error|warning):' \
          | grep -v '\--' \
          | paste -s -d'\0\t\n' - \
          | tr -s '\t' ' '
      ]],
      },
      format = "line",
      multiple_files = true,
      on_output = function(line, _)
        local filename, row, end_row, col, end_col, severity, message =
          line:match("([^:]+):%(?(%d+)[-,]?(%d*)%)?[:-]%(?(%d+)[-,]?(%d*)%)?:%s*(%w+):%s*(.+)")

        if end_col == nil or end_col == "" then
          end_col = col
        end

        if end_row == nil or end_row == "" then
          end_row = row
        else
          end_row, col = col, end_row
        end

        return {
          filename = filename,
          row = row,
          end_row = end_row,
          col = col,
          end_col = end_col + 1,
          severity = helpers.diagnostics.severities[severity],
          message = message,
        }
      end,
    }),
  }
end

function M.hlint()
  local null_ls = require("null-ls")
  local helpers = require("null-ls.helpers")
  return {
    name = "hlint",
    meta = { url = "https://github.com/ndmitchell/hlint" },
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "haskell" },
    generator = helpers.generator_factory({
      command = "hlint",
      args = { "--json", "$FILENAME" },
      format = "json",
      check_exit_code = { 1 },
      ignore_stderr = true,
      on_output = function(params)
        local diagnostics = {}
        local severities = {
          Warning = 3,
          Suggestion = 4,
        }
        for _, o in ipairs(params.output) do
          table.insert(diagnostics, {
            row = o.startLine,
            end_row = o.endLine,
            col = o.startColumn,
            end_col = o.endColumn,
            message = o.hint,
            severity = severities[o.severity],
          })
        end
        return diagnostics
      end,
    }),
  }
end

return M
