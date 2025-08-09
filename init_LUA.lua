local function set_basic_options()
    vim.g.mapleader = ' '
    local options = {
        updatetime = 1000,
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
        expandtab = true,
        smartindent = true,
        ignorecase = true,
        smartcase = true,
        undofile = true,
        undodir = vim.fn.stdpath('data') .. '\\undodir'
    }

    for k, v in pairs(options) do
        vim.opt[k] = v
    end

    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
    }

    vim.api.nvim_create_autocmd('CursorHold', {
        pattern = '*',
        callback = function()
            vim.cmd('silent! mode')
        end
    })
end

local function set_paths()
    vim.g.python3_host_prog = 'C:\\Users\\yvev2\\.pyenv\\pyenv-win\\versions\\3.11.1\\python.exe'
end

local function map(mode, lhs, rhs, opts)
    local default_opts = {
        noremap = false,
        silent = false
    }
    if opts then
        default_opts = vim.tbl_extend('force', default_opts, opts)
    end
    vim.keymap.set(mode, lhs, rhs, default_opts)
end

local function disable_f15()
    for _, mode in ipairs({'n', 'v', 'o', 'i', 'c'}) do
        map(mode, '<F15>', '<nop>')
    end
end

local function setup_vscode_mappings()
    if not vim.g.vscode then
        return
    end

    local mappings = {
    -- LSP相关
    {'n', '<leader>lf', [[<Cmd>lua require('vscode').call('editor.action.formatDocument')<CR>]]},
    {'n', '<leader>la', [[<Cmd>lua require('vscode').call('editor.action.quickFix')<CR>]]},
    {'n', '<leader>lr', [[<Cmd>lua require('vscode').call('editor.action.rename')<CR>]]},
    {'n', '<leader>ls', [[<Cmd>lua require('vscode').call('workbench.action.gotoSymbol')<CR>]]},
    {'n', '<leader>lS', [[<Cmd>lua require('vscode').call('workbench.action.showAllSymbols')<CR>]]},
    {'n', '<leader>lR', [[<Cmd>lua require('vscode').call('editor.action.goToReferences')<CR>]]},
    {'n', 'gr', [[<Cmd>lua require('vscode').call('editor.action.goToReferences')<CR>]]},
    -- 文件操作
    {'n', '<leader>n', [[<Cmd>lua require('vscode').call('workbench.action.files.newUntitledFile')<CR>]]},
    {'n', '<leader>k', [[<Cmd>lua require('vscode').call('workbench.action.closeActiveEditor')<CR>]]},
    {'n', '<leader>e', [[<Cmd>lua require('vscode').call('workbench.view.explorer')<CR>]]},
    -- 设置相关
    {'n', '<leader>set', [[<Cmd>lua require('vscode').call('workbench.action.openSettingsJson')<CR>]]},
    -- 编辑器设置
    {'n', '<leader>sen', [[<Cmd>Edit C:/Users/yvev2/AppData/Local/nvim/init.lua<CR>]]},
    }

    for _, m in ipairs(mappings) do
        map(m[1], m[2], m[3], m[4])
    end
end

local function set_normal_mappings()
    local mappings = {
    -- 基础移动
    {'n', '<A-v>', '<C-u>'}, -- 上移半页
    {'n', '<C-v>', '<C-d>'}, -- 下移半页
    {'n', 'J', '^', { noremap = true }}, -- 行首
    {'n', 'K', '$', { noremap = true }}, -- 行尾
    {'n', '<C-q>', '<C-v>'}, -- 块选择
    -- 剪贴板操作
    {'n', '<A-w>', '"+y'}, -- 复制到系统剪贴板
    {'n', '<C-y>', '"+p'}, -- 粘贴系统剪贴板
    {'n', ',', '"', { noremap = true }}, -- 用,访问寄存器而不是"
    -- 实用功能
    {'n', '<leader>j', 'J', { noremap = true }}, -- 合并下一行
    {'n', '<leader><leader>', '<Cmd>nohl<CR><Cmd>mode<CR>'}, -- 清除高亮
    -- 编辑器设置
    {'n', '<leader>sen', [[<Cmd>e $MYVIMRC<CR>]]},
    }

    for _, m in ipairs(mappings) do
        map(m[1], m[2], m[3], m[4])
    end
end

local function set_visual_mappings()
    local mappings = {
    {'v', '<A-w>', '"+y'}, -- 复制到系统剪贴板
    {'v', '<C-y>', '"+p'}, -- 粘贴系统剪贴板
    {'v', '<A-v>', '<C-u>'}, -- 上移半页
    {'v', '<C-v>', '<C-d>'}, -- 下移半页
    {'v', 'J', '^', { noremap = true }}, -- 行首
    {'v', 'K', '$', { noremap = true }}, -- 行尾
    {'v', '<C-q>', '<C-v>'}, -- 块选择
    {'v', ';', 'o', { noremap = true }}, -- 用;来切换首尾
    }

    for _, m in ipairs(mappings) do
        map(m[1], m[2], m[3], m[4])
    end
end

local function set_insert_mappings()
    local mappings = {
    {'i', '<C-y>', '<C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>'},
    -- {'i', '<C-y>', '<C-o>"+p'},
    }

    for _, m in ipairs(mappings) do
        map(m[1], m[2], m[3], m[4])
    end
end


local function setup_plugins()
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system {'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath}
    end
    vim.opt.rtp:prepend(lazypath)

    require('lazy').setup(
    {{
        "folke/flash.nvim",
        -- event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    keys = { "f", "F", "t", "T", [";"] = "L", "," },
                },
                treesitter = {
                    jump = { pos = "end" },
                },
                treesitter_search = {
                    jump = { pos = "end" },
                    search = { multi_window = true, wrap = false, incremental = false },
                },
            }
        },
        keys = {
            { "s", mode = {"n", "x", "o"}, function() require("flash").jump() end, desc = "Flash" },
            -- { "\\", mode = {"n"}, function() require("flash").treesitter({jump = {pos = "range"}}) end, desc = "Flash Treesitter" },
            -- { "\\", mode = {"x", "o"}, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        }
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.ai').setup()
            require('mini.comment').setup({mappings = {
                comment = "",
                comment_line = '-',
                comment_visual = '-',
            }})
            require('mini.surround').setup({
                mappings = {
                    add = 'Sa',
                    delete = 'Sd',
                    find = 'Sf',
                    find_left = 'SF',
                    highlight = 'Sh',
                    replace = 'Sr',
                    update_n_lines = 'Sn',
                },
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',
        opts = {
            ensure_installed = {'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'json'},
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = {'ruby'}
            },
            indent = {
                enable = false
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = false,
                    scope_incremental = false,
                    node_incremental = "<M-O>",
                    node_decremental = "<M-I>",
                    -- node_incremental = "<BS>",
                    -- scope_incremental = "<C-H>", -- <C-BS> reads as <C-H> (in WezTerm, at least)
                },
            },
        }
    },
    {
        'gbprod/yanky.nvim',
        opts = {
            ring = {
                ignore_registers = {"_", "+", "*"}
            },
            highlight = {
                on_put = true,
                on_yank = true,
                timer = 200,
            },
            system_clipboard = {
                sync_with_ring = false, -- 开启这个会导致在 ssh / windows 切换窗口聚焦时产生极大的延迟
                -- 事实上，本身在 ssh / windows 中用 vim.fn.getreg("+")就会至少使用500ms
            },
        },
        config = function(_, opts)
            require('yanky').setup(opts)
            vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
            -- vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
            -- vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
            vim.keymap.set("n", "<A-p>", "<Plug>(YankyPreviousEntry)")
            vim.keymap.set("n", "<A-n>", "<Plug>(YankyNextEntry)")
        end
    },
    {
        -- 'drybalka/tree-climber.nvim',
        -- 'Fuann-Kinoko/tree-climber-custom.nvim',
        dir = 'Z:/Repos/tree-climber-custom.nvim',
        name = 'tree-climber-custom',
        opts = {
            skip_comments = true,
            highlight = true,
            timeout = 300,
        },
        config = function(_, opts)
            local tc = require('tree-climber-custom')
            local function make_action(action)
                return function()
                    return action(opts)
                end
            end
            local keyopts = { noremap = true, silent = true }
            vim.keymap.set({'n', 'x', 'o'}, '<M-k>', make_action(tc.goto_parent), keyopts)
            vim.keymap.set({'n', 'x', 'o'}, '<M-j>', make_action(tc.goto_child), keyopts)
            vim.keymap.set({'n', 'x', 'o'}, '<M-o>', make_action(tc.goto_next_smart), keyopts)
            vim.keymap.set({'n', 'x', 'o'}, '<M-i>', make_action(tc.goto_prev), keyopts)
            vim.keymap.set({'n'}, '<M-O>', make_action(tc.select_node), keyopts)
            vim.keymap.set('n', '\\<c-k>', make_action(tc.swap_prev), keyopts)
            vim.keymap.set('n', '\\<c-j>', make_action(tc.swap_next), keyopts)
        end
    }},
    {
        performance = {
            rtp = {
                reset = false, -- 禁用 runtimepath 重置
            },
        },
    }
    )
end

local function init()
    set_basic_options()
    set_paths()
    disable_f15()
    setup_plugins()
    set_normal_mappings()
    set_visual_mappings()
    set_insert_mappings()
    setup_vscode_mappings()
end

init()
