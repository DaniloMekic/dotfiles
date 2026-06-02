require('mason-tool-installer').setup({
    -- Valid names: https://mason-registry.dev/registry/list
    ensure_installed = {
        'debugpy', -- Python debugger
        'java-debug-adapter',
        'java-test',
        'vscode-spring-boot-tools',
        'npm-groovy-lint',
    },
})
