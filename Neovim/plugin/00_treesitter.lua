-- Disable entire built-in ftplugin mappings to avoid conflicts with nvim-treesitter-textobjects
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins
vim.g.no_plugin_maps = true

require('nvim-treesitter').install({
    'awk',
    'bash',
    'c',
    'css',
    'csv', -- CSV, PSV, TSV
    'dockerfile',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'groovy',
    'html',
    'hurl',
    'hyprlang', -- Hyprland Configuration Language
    'java',
    'javadoc',
    'javascript',
    'jq',
    'json',
    'kdl',
    'latex',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'passwd',
    'perl',
    'properties', -- Java Properties File
    'python',
    'query',
    'rasi', -- Rofi Advanced Style Information
    'rust',
    'sql',
    'ssh_config',
    'tmux',
    'toml',
    'typst',
    'vim', -- Vimscript
    'vimdoc',
    'xml',
    'yaml',
})

-- Enable syntax highlighting
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'awk',
        'bash',
        'c',
        'css',
        'csv',
        'dockerfile',
        'gitattributes',
        'gitcommit',
        'gitconfig',
        'gitrebase',
        'groovy',
        'html',
        'hurl',
        'hyprlang',
        'java',
        'javascript',
        'jq',
        'json',
        'lua',
        'markdown',
        'passwd',
        'python',
        'rust',
        'sql',
        'sshconfig',
        'tmux',
        'toml',
        'vim',
        'xml',
        'yaml',
    },
    callback = function()
        vim.treesitter.start()
    end,
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd('TSUpdate')
        end
    end,
})
