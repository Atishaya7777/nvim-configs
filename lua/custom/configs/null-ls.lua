local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

local root_has_file = function(files)
  return function(utils)
    return utils.root_has_file(files)
  end
end

local eslint_root_files = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }
local stylua_root_files = { "stylua.toml", ".stylua.toml" }

local eslint_formatting = {
  condition = function(utils)
    local has_eslint = root_has_file(eslint_root_files)(utils)
    local has_prettier = root_has_file(prettier_root_files)(utils)
    return has_eslint and not has_prettier
  end,
}
local eslint_diagnostics = {
  condition = root_has_file(eslint_root_files),
}
local prettier_formatting = {
  condition = root_has_file(prettier_root_files),
}
local stylua_formatting = {
  condition = root_has_file(stylua_root_files),
}



local opts = {
  sources = {
    null_ls.builtins.formatting.stylua.with(stylua_formatting),
    null_ls.builtins.formatting.clang_format.with({
      filetypes = { "c", "cpp", "objc", "objcpp" },
    }),
    null_ls.builtins.formatting.prettierd.with(prettier_formatting),
    null_ls.builtins.diagnostics.eslint.with(eslint_diagnostics),
    null_ls.builtins.code_actions.eslint_d.with(eslint_diagnostics),
  },

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      })
    end
  end,
}

-- local opts = {
--   sources = {
--     null_ls.builtins.formatting.stylua,
--     null_ls.builtins.formatting.clang_format,
--     null_ls.builtins.diagnostics.fish,
--     null_ls.builtins.formatting.prettierd,
--   },
--   on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--       vim.api.nvim_clear_autocmds({
--         group = augroup,
--         buffer = bufnr,
--       })
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         buffer = bufnr,
--         callback = function()
--           vim.lsp.buf.format({ bufnr = bufnr })
--         end
--       })
--     end
--   end
-- }

return opts
