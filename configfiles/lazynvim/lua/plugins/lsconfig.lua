return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
