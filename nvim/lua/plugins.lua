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
    "https://github.com/tpope/vim-fugitive",
    -- "https://github.com/preservim/nerdtree",
    "https://github.com/Xuyuanp/nerdtree-git-plugin",
    "https://github.com/ThePrimeagen/vim-be-good",
    {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    }
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
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


-- propably don't need to make it a function but fuck it.
vim.keymap.set('n', '<leader>a', function()
    require("oil").toggle_float()end)

-- this is a handy keymap since it doubles as a go up a folder 
-- keybind
--
-- note <leader>w goes though a folder
vim.keymap.set('n', '<leader>q', '<cmd>Oil<CR>')


-- vim.keymap.set('n', '<leader>a', ':NERDTreeToggle<CR>', {desc = 'nerdtree sidebar toggle'})

-- require("lazy").setup({
    -- LSP manager
--	"williamboman/mason.nvim",
--	"williamboman/mason-lspconfig.nvim",
--	"neovim/nvim-lspconfig",
	-- Vscode-like pictograms
--	{
--		"onsails/lspkind.nvim",
--		event = { "VimEnter" },
--	},
	-- Auto-completion engine
--	{
--		"hrsh7th/nvim-cmp",
--		dependencies = {
--			"lspkind.nvim",
--			"hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
--			"hrsh7th/cmp-buffer", -- buffer auto-completion
--			"hrsh7th/cmp-path", -- path auto-completion
--			"hrsh7th/cmp-cmdline", -- cmdline auto-completion
--		},
--		config = function()
--			require("config.nvim-cmp")
--		end,
--	},
	-- Code snippet engine
--	{
--		"L3MON4D3/LuaSnip",
--		version = "v2.*",
--	},
  --  "tanvirtin/monokai.nvim",
--})
