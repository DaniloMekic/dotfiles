require('mason-tool-installer').setup({
    -- Valid names: https://mason-registry.dev/registry/list
    ensure_installed = {
        'black',
        'clang-format',
        'debugpy', -- Python debugger
        'google-java-format',
        'isort',
        'java-debug-adapter',
        'java-test',
        'kdlfmt',
        'nixfmt', -- https://github.com/NixOS/nixfmt
        'npm-groovy-lint',
        'npm-groovy-lint',
        'prettier',
        'prettierd',
        'shfmt',
        'stylua',
        'tex-fmt',
        'vscode-spring-boot-tools',
        'typstyle',
    },
})
