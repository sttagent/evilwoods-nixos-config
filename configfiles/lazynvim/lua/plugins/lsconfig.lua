return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {
          mason = false,
        },
        nixd = {
          mason = false,
        },
        hls = {
          mason = false,
        },
      }
    }
  }
}
