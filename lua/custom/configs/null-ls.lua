local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local eslint_root_files = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }
local stylua_root_files = { "stylua.toml", ".stylua.toml" }

local eslint_formatting = {
  condition = function(utils)
    local has_eslint = utils.root_has_file(eslint_root_files)
    local has_prettier = utils.root_has_file(prettier_root_files)
    return has_eslint and not has_prettier
  end,
}
local eslint_diagnostics = {
  condition = function(utils)
    local has_eslint = utils.root_has_file(eslint_root_files)
    return has_eslint
  end,
}
local prettier_formatting = {
  condition = function(utils)
    local has_prettier = utils.root_has_file(prettier_root_files)
    return has_prettier
  end,
}
local stylua_formatting = {
  condition = function(utils)
    local has_stylua = utils.root_has_file(stylua_root_files)
    return has_stylua
  end,
}

local opts = {
  sources = {
    null_ls.builtins.formatting.eslint_d.with(eslint_formatting),
    null_ls.builtins.formatting.stylua.with(stylua_formatting),
    null_ls.builtins.formatting.clang_format.with {
      filetypes = { "c", "cpp", "objc", "objcpp" },
    },
    null_ls.builtins.formatting.prettierd.with {
      -- use prettier only with prettierrc present
      condition = function()
        return require("null-ls.utils").root_pattern(
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.toml",
          "prettier.config.js",
          "prettier.config.cjs"
        )(vim.api.nvim_buf_get_name(0)) ~= nil
      end,
    },
    null_ls.builtins.diagnostics.eslint_d.with {
      filetypes = { "javascript", "typescript", "vue", "html", "css" },
      condition = function()
        return null_ls.utils.root_pattern(
          "eslint.config.js",
          -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "package.json"
        )(vim.api.nvim_buf_get_name(0)) ~= nil
      end,
    },
    null_ls.builtins.code_actions.eslint_d.with(eslint_diagnostics),
  },

  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}

return opts
