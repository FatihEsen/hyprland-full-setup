-- ========================================
-- NEOVIM - LAZY.NVIM + GRUVBOX (2025)
-- ========================================

-- === 1. LAZY.NVIM BOOTSTRAP ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- === 2. PLUGINLER ===
require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = false,
        italic = { comments = true },
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
})

-- === 3. TEMEL AYARLAR ===
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.background = "dark"
vim.opt.showmode = false

-- TÜRKÇE KLAVYE - DÜZELTİLDİ!
--vim.opt.langmap = "çÇ,ğĞ,ıİ,öÖ,şŞ,üÜ,;cC,gG,iI,oO,sS,uU"

vim.opt.laststatus = 2
vim.opt.statusline = [[ %f %m %= %l:%c  %p%% ]]

-- === 4. KEYMAPS ===
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { silent = true })
vim.keymap.set({"n", "v"}, "H", "^", { silent = true })
vim.keymap.set({"n", "v"}, "L", "$", { silent = true })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { silent = true })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { silent = true })
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", { silent = true })
vim.keymap.set("n", "<leader>x", ":tabclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { silent = true })

-- Ctrl+C ile Kopyalama Kaosuna Son (Görsel Modda)
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
