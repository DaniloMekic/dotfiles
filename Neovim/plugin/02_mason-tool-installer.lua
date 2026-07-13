require('mason-tool-installer').setup({
    -- Valid names: https://mason-registry.dev/registry/list
    ensure_installed = {
        'debugpy', -- Python debugger
        'java-debug-adapter',
        'java-test',
        'npm-groovy-lint',
        'vscode-spring-boot-tools',
        'clang-format',
        'google-java-format',
        'isort',
        'black',
        'jq',
        'kdlfmt',
        'npm-groovy-lint',
        'prettierd',
        'prettier',
        'shfmt',
        'stylua',
        'tex-fmt',
        'typstyle',
    },
})
