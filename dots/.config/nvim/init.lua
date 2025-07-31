--[[
───────────────────────────────────────────────────
           Table of Contents
───────────────────────────────────────────────────
  1.  Settings
  2.  Keymaps
    2.1 Visual Mode
    2.2 Operator-pending & Text-obj mappings
  3.  Autocommands
  4.  Plugin Manager (lazy.nvim)
  5.  Plugins
    5.1 guess-indent.nvim
    5.2 gitsigns.nvim
    5.3 Telescope
    5.4 nvim-treesitter
    5.5 which-key.nvim
    5.6 LSP & Completion
  6.  Colorscheme & UI Tweaks
───────────────────────────────────────────────────
]]
--

--[[
───────────────────────────────────────────────────
=> 1. Settings
───────────────────────────────────────────────────
--]]
local o = vim.opt
local g = vim.g

-- Leader
g.mapleader = ' '
g.maplocalleader = ' '

-- Numbers & UI
o.number = true -- show absolute line numbers
o.relativenumber = true -- show relative line numbers
o.signcolumn = 'yes' -- always show the sign column
o.cursorline = true -- highlight the current line
o.termguicolors = true -- enable 24-bit RGB colors

-- Indentation
o.expandtab = true -- use spaces instead of tabs
o.shiftwidth = 4 -- size of an indent
o.tabstop = 4 -- number of spaces tabs count for
o.autoindent = true -- carry indent from previous line
o.smartindent = true -- make indenting smarter

-- Clipboard & Mouse
vim.schedule(function()
  o.clipboard = 'unnamedplus' -- sync with system clipboard
end)
o.mouse = 'a' -- enable mouse in all modes

-- Splits & Windows
o.splitright = true -- vertical splits to the right
o.splitbelow = true -- horizontal splits below

-- Search
o.ignorecase = true -- case-insensitive search...
o.smartcase = true -- ... unless you use capitals
o.incsearch = true -- show matches as you type

-- File Handling & Undo
o.undofile = true -- persistent undo
o.confirm = true -- prompt on unsaved changes

-- Performance & UX
o.updatetime = 250 -- faster completion
o.timeoutlen = 300 -- faster mapped sequence timeout
o.breakindent = true -- keep wrapped lines visually indented
o.inccommand = 'split' -- live-preview substitutions
o.scrolloff = 10 -- keep 10 lines visible above/below cursor

-- Whitespace
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

--[[
───────────────────────────────────────────────────
=> 2. Keymaps
───────────────────────────────────────────────────
--]]
local km = vim.keymap.set

-- General
km('n', '0', '^', { desc = 'Jump to first non-blank character', silent = true })
km('n', '<leader>w', ':w<CR>', { desc = '[W]rite file', silent = true })
km('n', '<leader><CR>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight', silent = true })

-- Diagnostics
km('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list', silent = true })

-- Terminal
km('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode', silent = true })

-- Disable arrow keys
km('n', '<left>', '<cmd>echo "Use h to move!"<CR>', { desc = 'Disable left arrow', silent = true })
km('n', '<down>', '<cmd>echo "Use j to move!"<CR>', { desc = 'Disable down arrow', silent = true })
km('n', '<up>', '<cmd>echo "Use k to move!"<CR>', { desc = 'Disable up arrow', silent = true })
km('n', '<right>', '<cmd>echo "Use l to move!"<CR>', { desc = 'Disable right arrow', silent = true })

-- Window navigation (Ctrl-h/j/k/l)
km('n', '<C-h>', '<C-w>h', { desc = 'Move to left window', silent = true })
km('n', '<C-j>', '<C-w>j', { desc = 'Move to below window', silent = true })
km('n', '<C-k>', '<C-w>k', { desc = 'Move to above window', silent = true })
km('n', '<C-l>', '<C-w>l', { desc = 'Move to right window', silent = true })

km('n', '<C-d>', '<C-d>zz', { silent = true })
km('n', '<C-u>', '<C-u>zz', { silent = true })

--[[
───────────────────────────────────────────────────
=> 2.1 Visual Mode
───────────────────────────────────────────────────
--]]
-- Search for selected text (forward/backward)
km('v', '*', "<Esc>:<C-u>let @/ = escape(@\", '\\/.*$^~[]')<CR>:set hlsearch<CR>gv", { desc = 'Search selection forward', silent = true })
km('v', '#', "<Esc>:<C-u>let @/ = escape(@\", '\\/.*$^~[]')<CR>:set hlsearch<CR>gv", { desc = 'Search selection backward', silent = true })

-- Reselect & indent
km('v', '<', '<gv', { desc = 'Indent left & reselect', silent = true })
km('v', '>', '>gv', { desc = 'Indent right & reselect', silent = true })

-- Move visual block up/down
km('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move block down', silent = true })
km('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move block up', silent = true })

-- Paste over selection without yanking it
km('v', 'p', '"_dP', { desc = 'Paste without overwrite', silent = true })

--[[
───────────────────────────────────────────────────
=> 2.2 Operator-pending & Text-obj mappings
───────────────────────────────────────────────────
--]]
-- NOTE: these rely on the 'nvim-treesitter-textobjects' plugin being installed and configured.

-- Text-object selection (operator-pending, visual & select modes)
km({ 'o', 'x', 's' }, 'aa', '@parameter.outer', { desc = 'Around parameter', silent = true })
km({ 'o', 'x', 's' }, 'ia', '@parameter.inner', { desc = 'Inner parameter', silent = true })
km({ 'o', 'x', 's' }, 'af', '@function.outer', { desc = 'Around function', silent = true })
km({ 'o', 'x', 's' }, 'if', '@function.inner', { desc = 'Inner function', silent = true })
km({ 'o', 'x', 's' }, 'ac', '@class.outer', { desc = 'Around class', silent = true })
km({ 'o', 'x', 's' }, 'ic', '@class.inner', { desc = 'Inner class', silent = true })

-- Swap parameters (next/previous)
km('n', '<leader>a', '<cmd>lua require("nvim-treesitter.textobjects.swap").swap_next("@parameter.inner")<CR>', {
  desc = 'Swap next parameter',
  silent = true,
})
km(
  'n',
  '<leader>A',
  '<cmd>lua require("nvim-treesitter.textobjects.swap").swap_previous("@parameter.inner")<CR>',
  { desc = 'Swap previous parameter', silent = true }
)

-- Move between functions & classes
km('n', ']m', '<cmd>lua require("nvim-treesitter.textobjects.move").goto_next_start("@function.outer")<CR>', { desc = 'Next function start', silent = true })
km('n', ']M', '<cmd>lua require("nvim-treesitter.textobjects.move").goto_next_end("@function.outer")<CR>', { desc = 'Next function end', silent = true })
km(
  'n',
  '[m',
  '<cmd>lua require("nvim-treesitter.textobjects.move").goto_previous_start("@function.outer")<CR>',
  { desc = 'Previous function start', silent = true }
)
km(
  'n',
  '[M',
  '<cmd>lua require("nvim-treesitter.textobjects.move").goto_previous_end("@function.outer")<CR>',
  { desc = 'Previous function end', silent = true }
)
km('n', ']]', '<cmd>lua require("nvim-treesitter.textobjects.move").goto_next_start("@class.outer")<CR>', { desc = 'Next class start', silent = true })
km('n', '][', '<cmd>lua require("nvim-treesitter.textobjects.move").goto_next_end("@class.outer")<CR>', { desc = 'Next class end', silent = true })
km('n', '[[', '<cmd>lua require("nvim-treesitter.textobjects.move").goto_previous_start("@class.outer")<CR>', { desc = 'Previous class start', silent = true })
km('n', '[]', '<cmd>lua require("nvim-treesitter.textobjects.move").goto_previous_end("@class.outer")<CR>', { desc = 'Previous class end', silent = true })

--[[
───────────────────────────────────────────────────
=> 3. Autocommands
───────────────────────────────────────────────────
--]]
local aug = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

-- Jump to last edit position when reopening a buffer
aug('RememberCursor', { clear = true })
aucmd('BufReadPost', {
  group = 'RememberCursor',
  callback = function()
    local pos = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if pos[1] > 0 and pos[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-on-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Disable hover capability from Ruff so basedpyright can handle it
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover from Ruff',
})

--[[
───────────────────────────────────────────────────
=> 4. Plugin Manager (lazy.nvim)
───────────────────────────────────────────────────
--]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
--@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  -- auto-detect indent settings
  'NMAC427/guess-indent.nvim',

  -- Git signs in gutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Which-key for better discoverability
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      delay = 50,
      icons = {
        mappings = true,
        keys = {},
      },
      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            '%.git/',
            '%.venv/',
            'dist/',
            'build/',
            'target/',
          },
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
        },
        pickers = { find_files = { hidden = true } },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          --@param client vim.lsp.Client
          --@param method vim.lsp.protocol.Method
          --@param bufnr? integer some lsp support methods only in specific files
          --@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client.supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Highlight references
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints if supported
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostics UI
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers config
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                diagnosticMode = 'OpenFilesOnly',
                excludes = { '*' },
                inlayHints = { callArgumentNames = true },
              },
              disableOrganizeImports = true,
            },
          },
        },
        ruff = {},
        bashls = {},
        just = {},
      }

      -- Mason auto-install missing LSPs
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua', 'ruff', 'shfmt' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- Autoformatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
      vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Additional plugins/modules
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = true }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}, {
  ui = { icons = {} },
})

-- vim: ts=2 sts=2 sw=2 et
