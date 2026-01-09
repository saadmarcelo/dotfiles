-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- center line on C-d
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "center the cursor" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "center the cursor" })

-- Dismiss Noice Message
keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })

-- View Noice message
keymap.set("n", "<leader>nm", ":Noice<CR>", { desc = "View noice messages" })

-- Mapeamentos básicos de LSP
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Mostra documentação" })
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "diagnostic prev " })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "diagnostic next " })
keymap.set("n", "<leader>D", vim.diagnostic.open_float, { desc = "Open Float Diagnostic" })

-- Adicionando seus keybinds personalizados
keymap.set("n", "<leader>ld", vim.lsp.buf.type_definition, { desc = "go to definition" })
keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "go to definition" })
keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "go to definition" })
keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "go to definition" })
keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "go to definition" })
-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Stay in indent mode
keymap.set("v", "<", "<gv", { desc = "Ident left" })
keymap.set("v", ">", ">gv", { desc = "Ident right" })

-- Keep last yanked when pasting
keymap.set("v", "p", '"_dP', { desc = "keep de last yanked when pasting" })
