local lsp_status, lsp = pcall(require, "lsp-zero")
if not lsp_status then
  return
end

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
  return
end

local cmp_select = {
  behavior = cmp.SelectBehavior.Select
}

local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
})

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>r", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<space>R", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "[r", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]r", vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
lsp.on_attach(function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>fo", function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
end)

lsp.preset("recommended")

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.setup()
