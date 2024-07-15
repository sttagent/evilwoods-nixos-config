return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "nix"
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          mason = false,
        },
      },
    }
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formaters_by_ft = {
        nix = { "nixfmt" }
      }
    }
  }
}
