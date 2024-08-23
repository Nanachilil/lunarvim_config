-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
local home = os.getenv("HOME")
package.path = home .. "/.config/lvim/?.lua" -- $HOME/.config/lvim/*.lua
package.path = home .. "/.config/lvim/plugins/?.lua" -- 添加专用插件文件到检索路径




-- ==================== 基础设置 ====================
-- -- 设置 <leader> 键为空格键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.backup = false -- 创建配置文件
vim.opt.clipboard = "unnamedplus" -- 允许属于unnamedplus插件，共享系统剪贴板
vim.opt.cmdheight = 2 -- 更多的空间展示neovim的信息（默认：1）
vim.opt.fileencoding = "utf-8" -- 设置UTF-8编码
vim.opt.number = true -- 设置行表
vim.opt.relativenumber = true -- 设置相对行标
vim.opt.scrolloff = 8 -- 设置光标发生滚动的距离值
vim.opt.sidescrolloff = 8 -- 设置光标和边距发生滚动的距离值
vim.opt.clipboard = "unnamedplus" -- 统一系统和vim的剪贴板
-- lvim.transparent_window = true -- 窗口透明


-- 映射按键
-- 基础vim操作
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'H', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'L', '$', { noremap = true, silent = true })
-----------------------------------------------------------------




-- ===================== 缓冲区快捷键 ====================
-- 在 Normal 模式下，设置 <leader>1 到 <leader>9 为跳转到对应编号的缓冲区
-- for i = 1, 9 do
--     vim.keymap.set('n', '<leader>' .. i, function()
--         local buffers = vim.api.nvim_list_bufs()
--         if i <= #buffers then
--             vim.cmd('buffer ' .. buffers[i])
--         else
--             print("Buffer " .. i .. " does not exist.")
--         end
--     end, { noremap = true, silent = true, desc = "Go to buffer " .. i })
-- end
-- -- 删除当前标签页
-- function close_buffer_and_move_to_next()
--     -- 获取当前缓冲区编号
--     local current_buf = vim.api.nvim_get_current_buf()

--     -- 检查是否有其他缓冲区可以切换
--     local buffers = vim.api.nvim_list_bufs()
--     local next_buf = nil
--     for _, buf in ipairs(buffers) do
--         if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
--             next_buf = buf
--             break
--         end
--     end

--     -- 如果有其他缓冲区，切换到下一个缓冲区
--     if next_buf then
--         vim.api.nvim_set_current_buf(next_buf)
--     else
--         -- 如果没有其他缓冲区，打开一个新的空白缓冲区
--         vim.cmd('enew')
--     end

--     -- 删除原来的缓冲区
--     vim.api.nvim_buf_delete(current_buf, { force = true })
-- end
-- -- 设置快捷键 close_buffer_and_move_to_next
-- vim.keymap.set('n', '<leader>d', close_buffer_and_move_to_next, { noremap = true, silent = true, desc = "Close current buffer and move to next" })
-----------------------------------------------------------------


-- ===================== 代码运行键 ====================
-- 设置快捷键运行代码
-- vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:terminal python3 %<CR>', { noremap = true, silent = true })
-- Example keybindings for LSP functions
lvim.lsp.buffer_mappings.normal_mode["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" }
lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover Documentation" }
lvim.lsp.buffer_mappings.normal_mode["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Go to References" }


-- 使用外部系统命令打开文件
local os_open_cmd = ""
if vim.fn.has("mac") == 1 then
    os_open_cmd = "open"
elseif vim.fn.has("unix") == 1 then
    os_open_cmd = "xdg-open"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    os_open_cmd = "start"
end

vim.keymap.set('n', '<leader>o', function()
    local file = vim.fn.expand('%:p')  -- 获取当前文件的完整路径
    if file ~= "" then
        vim.cmd('! ' .. os_open_cmd .. ' ' .. vim.fn.shellescape(file))
    else
        print("No file associated with current buffer.")
    end
end, { noremap = true, silent = true, desc = "Open current file with default OS application" })

-- 在 Normal 模式下，使用 <leader> + t 打开底部终端
vim.keymap.set('n', '<leader>t', ':10split | terminal<CR>', { noremap = true, silent = true })
-- 自动化终端
local function run_code()
    local filetype = vim.bo.filetype
    local cmd = ""

    if filetype == "python" then
        cmd = "python " .. vim.fn.expand('%')
    elseif filetype == "javascript" then
        cmd = "node " .. vim.fn.expand('%')
    elseif filetype == "c" then
        cmd = "gcc " .. vim.fn.expand('%') .. " -o output && ./output"
    elseif filetype == "cpp" then
        cmd = "g++ " .. vim.fn.expand('%') .. " -o output && ./output"
    elseif filetype == "lua" then
        cmd = "lua " .. vim.fn.expand('%')
    end

    if cmd ~= "" then
        vim.cmd('10split | terminal')
        vim.cmd('terminal ' .. cmd)
    else
        print("Unsupported filetype: " .. filetype)
    end
end

vim.keymap.set('n', '<leader>r', run_code, { noremap = true, silent = true, desc = "Run code" })
----------------------------------------------------------------






--==================== lvim_plugins =====================
-- lvim插件
lvim.plugins = {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "lewis6991/gitsigns.nvim" },
  {"SmiteshP/nvim-navic"},
  {"nvim-lualine/lualine.nvim"}, -- 添加 lualine 插件
  {"morhetz/gruvbox"},  -- 添加 gruvbox 主题
  {"nvim-tree/nvim-tree.lua"}, -- 添加 nvim-tree 插件
  {"puremourning/vimspector"}, -- 添加 vimspector 插件,代码调试
  {"junegunn/fzf"},
  {"simrat39/symbols-outline.nvim"},
  {
    'Exafunction/codeium.vim',  -- 添加 codeium 插件
    config = function ()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<leader>g', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      -- vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      -- vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      -- vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },
}
-----------------------------------------------------------------




--==================== vimspector ====================
-- 设置 Vimspector 的快捷键映射模式
vim.g.vimspector_enable_mappings = 'HUMAN'

-- 定义符号
vim.fn.sign_define('vimspectorBP', {text = '☛', texthl = 'Normal'})
vim.fn.sign_define('vimspectorBPDisabled', {text = '☞', texthl = 'Normal'})
vim.fn.sign_define('vimspectorPC', {text = '🔶', texthl = 'SpellBad'})

-- 快捷键映射 
vim.api.nvim_set_keymap('n', '<leader>vs', ':tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>', { noremap = true, silent = true })
lvim.keys.normal_mode["<leader>esc"] = "<cmd>VimspectorReset<CR>"
-- 定义一个 Lua 函数来读取模板
function _G.read_template_into_buffer(template)
  local cmd = '0r /Users/nanachilil/.config/nvim/vimspector_json/' .. template
  print(cmd)  -- 打印出完整命令，供调试用end
  vim.cmd(cmd)
end

-- 用 FZF 加载 Vimspector JSON 模板的命令
vim.api.nvim_create_user_command('LoadVimSpectorJsonTemplate', function()
  vim.fn['fzf#run']({
    source = 'ls -1 /Users/nanachilil/.config/nvim/vimspector_json',
    down = 20,
    sink = _G.read_template_into_buffer
  })
end, { bang = true, nargs = '*' })





--==================== gitsigns====================
-- 配置 gitsigns
local status_ok, gitsigns = pcall(require, "gitsigns")
if status_ok then
  gitsigns.setup()
else
  print("Failed to load gitsigns.nvim")
end
-----------------------------------------------------





-- ==================== 缩略图 ====================
local opts = {
  highlight_hovered_item = true,
  show_guides = true,
  auto_preview = false,
  position = 'right',
  relative_width = true,
  width = 25,
  auto_close = false,
  show_numbers = false,
  show_relative_numbers = false,
  show_symbol_details = true,
  preview_bg_highlight = 'Pmenu',
  autofold_depth = nil,
  auto_unfold_hover = true,
  fold_markers = { '', '' },
  wrap = false,
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = {"<Esc>", "q"},
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    toggle_preview = "K",
    rename_symbol = "r",
    code_actions = "a",
    fold = "h",
    unfold = "l",
    fold_all = "W",
    unfold_all = "E",
    fold_reset = "R",
  },
  lsp_blacklist = {},
  symbol_blacklist = {},
  symbols = {
    File = { icon = "", hl = "@text.uri" },
    Module = { icon = "", hl = "@namespace" },
    Namespace = { icon = "", hl = "@namespace" },
    Package = { icon = "", hl = "@namespace" },
    Class = { icon = "𝓒", hl = "@type" },
    Method = { icon = "ƒ", hl = "@method" },
    Property = { icon = "", hl = "@method" },
    Field = { icon = "", hl = "@field" },
    Constructor = { icon = "", hl = "@constructor" },
    Enum = { icon = "ℰ", hl = "@type" },
    Interface = { icon = "ﰮ", hl = "@type" },
    Function = { icon = "", hl = "@function" },
    Variable = { icon = "", hl = "@constant" },
    Constant = { icon = "", hl = "@constant" },
    String = { icon = "𝓐", hl = "@string" },
    Number = { icon = "#", hl = "@number" },
    Boolean = { icon = "⊨", hl = "@boolean" },
    Array = { icon = "", hl = "@constant" },
    Object = { icon = "⦿", hl = "@type" },
    Key = { icon = "🔐", hl = "@type" },
    Null = { icon = "NULL", hl = "@type" },
    EnumMember = { icon = "", hl = "@field" },
    Struct = { icon = "𝓢", hl = "@type" },
    Event = { icon = "🗲", hl = "@type" },
    Operator = { icon = "+", hl = "@operator" },
    TypeParameter = { icon = "𝙏", hl = "@parameter" },
    Component = { icon = "", hl = "@function" },
    Fragment = { icon = "", hl = "@constant" },
  },
}

require("symbols-outline").setup(opts)
-- 使用 <leader>m 快捷键来切换打开/关闭大纲视图
vim.api.nvim_set_keymap('n', '<leader>m', ':SymbolsOutline<CR>', { noremap = true, silent = true })
-----------------------------------------------------




--==================== Treesitter ====================

-- markdown 高亮
vim.list_extend(lvim.builtin.treesitter.ensure_installed, {
  "c",
  "cpp",
  "lua",
  "python",
  "markdown",
  "markdown_inline"
})

lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "markdown" }


-- 设置折叠方法为 Treesitter
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'


-- 默认不折叠
vim.opt.foldenable = false
vim.opt.foldlevel = 99

-- 确保 Treesitter 的折叠功能启用
lvim.builtin.treesitter.fold = { enable = true }

-- 自定义折叠文本
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- 设置折叠列宽度
vim.opt.foldcolumn = "1"

-- 键位映射
lvim.keys.normal_mode["<CR>"] = "za"  -- 使用回车键切换折叠

-- 可选：添加其他有用的折叠快捷键
lvim.keys.normal_mode["zR"] = "zE"  -- 展开所有折叠
lvim.keys.normal_mode["zM"] = "zW"  -- 关闭所有折叠
lvim.keys.normal_mode["zr"] = "zr"  -- 打开一层折叠
lvim.keys.normal_mode["zm"] = "zm"  -- 关闭一层折叠

-- 自动命令：打开文件时记住上次的折叠状态
vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})

-- 为 Python 文件设置正确的折叠方法
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    print("Set foldmethod to expr for Python file")
  end
})

-- -- 更新诊断函数
-- function diagnose_python_folding()
--   print("Python Folding Diagnosis:")
--   print("File type: " .. vim.bo.filetype)
--   print("Fold method: " .. vim.wo.foldmethod)
--   print("Fold expr: " .. vim.wo.foldexpr)
--   
--   local ts_ok, ts = pcall(require, "nvim-treesitter.parsers")
--   if ts_ok then
--     local lang = ts.get_buf_lang()
--     print("Treesitter language: " .. lang)
--     print("Has parser: " .. tostring(ts.has_parser(lang)))
--   end
--   
--   local hl_ok, hl = pcall(require, "vim.treesitter.highlighter")
--   if hl_ok then
--     print("Highlighter active: " .. tostring(hl.active[vim.api.nvim_get_current_buf()] ~= nil))
--   end
--   
--   vim.cmd("normal! zx")
--   local fold_count = vim.fn.foldclosedend(1)
--   print("Folds created: " .. tostring(fold_count ~= -1))
--   
--   -- 尝试手动创建折叠
--   print("Attempting to manually create folds...")
--   vim.cmd("silent! %foldclose!")
--   fold_count = vim.fn.foldclosedend(1)
--   print("Manual folds created: " .. tostring(fold_count ~= -1))
-- end

-- vim.cmd("command! DiagnosePythonFolding lua diagnose_python_folding()")

-- -- 添加一个命令来重置折叠设置
-- vim.cmd([[
--   command! ResetPythonFolding lua vim.opt_local.foldmethod = "expr"; vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"; print("Reset Python folding settings")
-- ]])




--==================== lspconfig ====================
-- 跳转到下一个错误
vim.keymap.set("n", "<leader>en", function()
  vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})
end, { desc = "Next error" })

-- 跳转到上一个错误
vim.keymap.set("n", "<leader>ep", function()
  vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})
end, { desc = "Previous error" })

-- 显示错误列表
vim.keymap.set("n", "<leader>el", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- 显示当前行的错误信息
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })




---------------------------------------------------------






-- ====================== 配色方案 ===================== 
-- 自定义 gruvbox 配色方案
-- vim.o.background = "light"  -- 或者 "light" 根据你的偏好
vim.cmd("colorscheme gruvbox")
lvim.colorscheme = 'gruvbox-baby'
---------------------------------------------------------





--==================== codeium ====================
--  设置 codeium 插件






---------------------------------------------------------





--==================== NvimTree ====================
-- 如果您想添加复制绝对路径的功能
local function copy_absolute_path()
    local node = require('nvim-tree.lib').get_node_at_cursor()
    if node then
        vim.fn.setreg('+', node.absolute_path)
        print("Copied: " .. node.absolute_path)
    end
end

-- 新增当前文件目录为根目录
local function change_root_to_current_file_dir()
  local node = require'nvim-tree.lib'.get_node_at_cursor()
  if node and node.absolute_path then
    local current_file_dir = vim.fn.fnamemodify(node.absolute_path, ":h")
    require'nvim-tree.api'.tree.change_root(current_file_dir)
  end
end

-- 文件目录配置
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.which_key.mappings["z"] = { copy_absolute_path, "Copy Absolute Path" }
lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }
lvim.builtin.which_key.mappings["E"] = { change_root_to_current_file_dir, "Change Root to Current File Dir" }
---------------------------------------------------------







--==================== Dashboard ====================
-- 自定义 Dashboard 配置
-- Dashboard 图案
lvim.builtin.alpha.dashboard.section.header.val = {
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿]],
	[[⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿]],
	[[⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿]],
}
-- 设定颜色高亮组
vim.api.nvim_set_hl(0, 'CustomHeaderHighlight', { fg = '#b8c3f4', bg = '#282828', bold = true, italic = false })
lvim.builtin.alpha.dashboard.section.header.opts.hl = "CustomHeaderHighlight"

-- 打印加载成功的消息
print("Coding is all you need")
---------------------------------------------------------

