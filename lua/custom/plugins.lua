local plugins = {
  {
    "lervag/vimtex",
    init = function()
      -- Use init for configuration, don't use the more common "config".
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy"
  },
  {
    "github/copilot.vim",
    event = "VeryLazy"
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end
  },
  {
    'MunifTanjim/prettier.nvim',
    config = require "custom.configs.prettier"
  },
  { 'windwp/nvim-autopairs' },
  {
    'windwp/nvim-ts-autotag',
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html"
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      opts = require "plugins.configs.treesitter"
      opts.ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "cpp",
        "css",
      }

      return opts
    end
  },
  {
    'lervag/vimtex'
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
      vim.keymap.set("n", "<C-_>", function() require('Comment.api').toggle.linewise.current() end,
        { noremap = true, silent = true })
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependicies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependicies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    }
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
        "prettierd",
        "eslint-lsp",
        "typescript-language-server",
      }
    }
  },
  -- For OneDark theming --
  {
    'navarasu/onedark.nvim'
  }
}

return plugins
