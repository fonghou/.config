if vim.g.vscode then
  return
end

require "lspconfig".clojure_lsp.setup {}

local wk = require("which-key")
wk.add({
  { "<localleader>c", group = "connect" },
  { "<localleader>e", group = "eval" },
  { "<localleader>i", group = "inspect" },
  { "<localleader>l", group = "log" },
  { "<localleader>r", group = "reload" },
  { "<localleader>s", group = "session" },
  { "<localleader>t", group = "test" },
  { "<localleader>v", group = "view" },
  { "<localleader>x", group = "macroexpand" },
})

local function options(desc)
  return { buffer = true, noremap = true, silent = true, desc = desc }
end

local map = vim.keymap.set
map(
  "n",
  ",rr",
  ":<C-u>ConjureEval ((requiring-resolve 'clj-reload.core/reload))<CR>",
  options("reload changed namespaces")
)
map("n", ",ie", ":<C-u>ConjureEval ((requiring-resolve 'clj-commons.pretty.repl/pretty-pst))<CR>", options("pst"))
map("n", ",i1", ":ConjureEval (tap> *1)<CR>", options("tap *1"))
map("n", ",i2", ":ConjureEval (tap> *2)<CR>", options("tap *2"))
map("n", ",in", ":ConjureEval (tap> (-> *ns* (clojure.datafy/datafy) :publics))<CR>", options("tap *ns*"))
map("n", ",is", ":ConjureEval (tap> (eval `(sc.api/defsc ~(sc.api/last-ep-id))))<CR>", options("sc/defsc"))
map("n", ",iu", ":ConjureEval (eval `(sc.api/undefsc ~(sc.api/last-ep-id)))<CR>", options("sc/undefsc"))
map("n", ",ix", ":ConjureEval ((requiring-resolve 'sc.api/dispose-all!))<CR>", options("sc/dispose-all!"))

-- prepare portal
-- scope-capture data_readers.clj {sc/letsc user/read-letsc}
--[[
(in-ns 'user)
(defn read-letsc [form]
  `(sc.api/letsc ~((requiring-resolve 'sc.api/last-ep-id)) ~form))
--]]
map(
  "n",
  ",ip",
  [[:ConjureEval (do (in-ns 'user) (add-tap (requiring-resolve 'portal.api/submit)) (def portal ((requiring-resolve 'portal.api/open))) (defn read-letsc [form] `(sc.api/letsc ~((requiring-resolve 'sc.api/last-ep-id)) ~form)) (set! *data-readers* (assoc *data-readers* 'sc/letsc #'read-letsc)))<CR>]],
  options("portal")
)

map("v", ",e", 'y :<C-u>ConjureEval #sc/letsc <C-r>=@"<CR><CR>', options("letsc form"))

-- flow-storm-debugger
map("v", ",t", 'y :<C-u>ConjureEval (flow-storm.api/instrument* {} <C-r>=@"<CR>)<CR>', options("trace form"))
map("v", ",r", 'y :<C-u>ConjureEval (flow-storm.api/runi {} <C-r>=@"<CR>)<CR>', options("rtrace form"))

vim.cmd "inoremap <buffer> (  ("
vim.cmd "inoremap <buffer> '  '"
vim.cmd "inoremap <buffer> `  `"

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufEnter", {
  pattern = "*.clj",
  callback = function()
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "bb nrepl-server localhost:$port"
  end,
})

autocmd("BufEnter", {
  pattern = "*.cljs",
  callback = function()
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "npx nbb nrepl-server :port $port"
  end,
})
