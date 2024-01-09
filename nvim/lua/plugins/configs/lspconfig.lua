dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"


local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
--require'lspconfig'.primsmals.setup{
require'lspconfig'.prismals.setup{
    cmd = { 'prisma-language-server', '--stdio' },
    filetypes = { 'prisma' },
    settings = {
        prisma = {
            prismaFmtBinPath = '',
        },
    },
    root_dir = require('lspconfig.util').root_pattern('.git', 'package.json'),
}

require'lspconfig'.bashls.setup {
  cmd = { 'bash-language-server', 'start' },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
  },
  filetypes = { 'sh' },
  root_dir = require('lspconfig.util').find_git_ancestor,
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  single_file_support = true,
}

require'lspconfig'.tsserver.setup {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(fname)
    return require('lspconfig.util').root_pattern('tsconfig.json')(fname)
      or require('lspconfig.util').root_pattern('package.json', 'jsconfig.json', '.git')(fname)
  end,
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  single_file_support = true,
}

-- require'lspconfig'.efm.setup {
--   init_options = { documentFormatting = true },
--     cmd = { "efm-langserver", "-c", "~/.config/efm-langserver/config.yaml" },
--   filetypes = { 'javascript', 'typescript', 'html', 'css', 'json', 'markdown' },
--   settings = {
--     rootMarkers = { ".git/" },
--     languages = {
--       javascript = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
--       typescript = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
--       html = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
--       css = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
--       json = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
--       markdown = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
--     }
--   }
-- }


-- require'lspconfig'.prettier.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.jedi_language_server.setup{}
require'lspconfig'.pyright.setup{}
-- require'lspconfig'.java_language_server.setup{}

require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

return M
