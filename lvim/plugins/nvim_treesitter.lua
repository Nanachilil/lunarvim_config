
-- local function setup_treesitter()
--   require'nvim-treesitter.configs'.setup {
--     -- 确保安装的解析器
--     ensure_installed = {
--       "c",
--       "cpp",
--       "lua",
--       "markdown",
--       "markdown_inline",
--       "python"
--     },
--     sync_install = false,
--     auto_install = true,
--     ignore_install = { "javascript" },  -- 这里有冲突，请确认是否真的要忽略 javascript

--     highlight = {
--       enable = true,
--       disable = function(lang, buf)
--         local max_filesize = 100 * 1024 -- 100 KB
--         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--         if ok and stats and stats.size > max_filesize then
--           return true
--         end
--       end,
--       additional_vim_regex_highlighting = false,
--     },

--     indent = {
--       enable = true
--     },

--     fold = {
--       enable = true,
--     },

--     incremental_selection = {
--       enable = true,
--     },

--     textobjects = {
--       select = {
--         enable = true,
--       },
--     },
--   }

--   -- 上下文感知，跳过重复模块，加快速度
--   vim.g.skip_ts_context_commentstring_module = true

--   -- 配置 ts_context_commentstring
--   require('ts_context_commentstring').setup {
--     enable = true,
--   }

--   -- 设置折叠方法和折叠表达式
--   vim.opt.foldmethod = "expr"
--   vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
--   vim.opt.foldlevel = 99 -- 默认不折叠
-- end

-- -- 调用设置函数
-- setup_treesitter()

-- -- 键映射设置
-- lvim.keys.normal_mode["zR"] = "zR" -- 展开所有折叠
-- lvim.keys.normal_mode["zM"] = "zM" -- 折叠所有代码
-- lvim.keys.normal_mode["zr"] = "zr" -- 减少折叠级别
-- lvim.keys.normal_mode["zm"] = "zm" -- 增加折叠级别

-- -- 确保 ts_context_commentstring 插件已安装
-- table.insert(lvim.plugins, {
--   "JoosepAlviste/nvim-ts-context-commentstring",
--   event = "BufRead",
-- })
--
--

-- 检查 Treesitter 解析器安装状态
function check_ts_parsers()
  local parsers = require'nvim-treesitter.parsers'
  local lang_list = { "markdown", "markdown_inline" }
  for _, lang in ipairs(lang_list) do
    if parsers.has_parser(lang) then
      print(lang .. " parser is installed")
    else
      print(lang .. " parser is NOT installed")
    end
  end
end

-- 检查当前文件的 Treesitter 高亮状态
function check_ts_highlight()
  local highlighter = require'vim.treesitter.highlighter'
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    print("Treesitter highlighting is active for this buffer")
  else
    print("Treesitter highlighting is NOT active for this buffer")
  end
end

-- 检查文件类型
function check_filetype()
  print("Current filetype: " .. vim.bo.filetype)
end

-- 创建命令以运行这些检查
vim.cmd([[
  command! CheckTSParsers lua check_ts_parsers()
  command! CheckTSHighlight lua check_ts_highlight()
  command! CheckFileType lua check_filetype()
]])

-- 修改 Treesitter 设置
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 1024 * 1024 -- 设置为 1 MB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = { "markdown" },
  },
}

-- 确保 .md 文件被识别为 Markdown
vim.cmd([[
  augroup MarkdownFileType
    autocmd!
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  augroup END
]])

-- 强制重新加载 Treesitter 高亮
vim.cmd([[
  augroup ForceTreesitterReload
    autocmd!
    autocmd BufEnter *.md TSBufEnable highlight
  augroup END
]])
