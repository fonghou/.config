local M = {
  {
    "fonghou/fzf-hoogle.vim",
    ft = "haskell",
    dependencies = {
      "junegunn/fzf",
      "mrcjkb/haskell-snippets.nvim",
      "nvimtools/none-ls.nvim",
    },
  },
  {
    "mrcjkb/haskell-tools.nvim",
    cond = function()
      return vim.fn.filereadable("hls.json") ~= 0 and true
    end,
  },
}

function M.ghcid()
  local helpers = require("null-ls.helpers")
  local methods = require("null-ls.methods")
  local utils = require("null-ls.utils")
  return {
    name = "ghcid",
    meta = { url = "https://github.com/ndmitchell/ghcid" },
    method = methods.internal.DIAGNOSTICS_ON_SAVE,
    filetypes = { "haskell" },
    generator = helpers.generator_factory({
      command = "bash",
      args = {
        "-c",
        [[ sleep 1 && [ -f ghcid.log ] && cat ghcid.log \
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
          line:match("([^:]+):%(?(%d+)[-,]?(%d*)%)?[:-]%(?(%d+)[-,]?(%d*)%)?:%s*(%w+):%s*(.*)")

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
    cwd = helpers.cache.by_bufnr(function(params)
      return utils.root_pattern("ghcid.log")(params.bufname)
    end),
  }
end

function M.hlint()
  local helpers = require("null-ls.helpers")
  local methods = require("null-ls.methods")
  return {
    name = "hlint",
    meta = { url = "https://github.com/ndmitchell/hlint" },
    method = methods.internal.DIAGNOSTICS_ON_SAVE,
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
