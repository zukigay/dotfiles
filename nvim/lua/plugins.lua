local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local detail = false
require("lazy").setup({
    "tanvirtin/monokai.nvim",
    "https://github.com/gentoo/gentoo-syntax",
    "nvim-telescope/telescope.nvim", tag='0.1.8',
    -- "https://github.com/tpope/vim-fugitive",
    -- "https://github.com/preservim/nerdtree",
    "https://github.com/Xuyuanp/nerdtree-git-plugin",
    "https://github.com/ThePrimeagen/vim-be-good",
    {
      "CRAG666/betterTerm.nvim",
      opts = {
        position = "bot",
        size = 15,
      },
    },
    {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    }
    },
    {
        "S1M0N38/love2d.nvim",
        cmd = "LoveRun",
        opts = { },
        keys = {
          { "<leader>v", ft = "lua", desc = "LÖVE" },
          { "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
          { "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
        },
    },
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {
      
        keymaps = {["<leader>w"] = "actions.select", ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },}
      },
      -- Optional dependencies
      dependencies = { { "echasnovski/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
    },
    {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
    "echasnovski/mini.pick",         -- optional
  },
  config = true
}
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

--require("oil.actions").refresh = false
--require("oil.actions").select = false

-- propably don't need to make it a function but fuck it.
vim.keymap.set('n', '<leader>a', function()
    require("oil").toggle_float()end)

-- this is a handy keymap since it doubles as a go up a folder 
-- keybind
--
-- note <leader>w goes though a folder
vim.keymap.set('n', '<leader>q', '<cmd>Oil<CR>')

local betterTerm = require('betterTerm')
-- toggle firts term
-- vim.keymap.set({"n", "t"}, "<C-;>", betterTerm.open, { desc = "Open terminal"})
vim.keymap.set({"n", "t"}, "<leader>t", betterTerm.open, { desc = "Open terminal"})


