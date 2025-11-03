-- Java LSP configuration for LazyVim
return {
  -- Import LazyVim's Java language extras
  { import = "lazyvim.plugins.extras.lang.java" },

  -- nvim-jdtls for enhanced Java support
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "folke/which-key.nvim",
      "williamboman/mason.nvim",
    },
  },

  -- Configure nvim-lspconfig with jdtls
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- jdtls will be automatically installed with mason and loaded with lspconfig
        jdtls = {},
      },
      setup = {
        jdtls = function()
          -- Return true to prevent lspconfig from setting up jdtls
          -- nvim-jdtls will handle the setup
          return true
        end,
      },
    },
  },

  -- Ensure Java-related tools are installed via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "jdtls", -- Java language server
        "java-debug-adapter", -- Java debugger
        "java-test", -- Java test runner
        "google-java-format", -- Java formatter (optional)
      })
    end,
  },

  -- Add Java to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "java",
      })
    end,
  },

  -- Optional: nvim-dap for Java debugging
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
          "java-debug-adapter",
          "java-test",
        })
      end,
    },
  },
}