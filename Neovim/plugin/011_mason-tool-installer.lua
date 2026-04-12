require("mason-tool-installer").setup({
            -- Valid names: https://mason-registry.dev/registry/list 
                ensure_installed = {
                    "java-debug-adapter",
                    "java-test",
                    "vscode-spring-boot-tools",
                    "debugpy",                          -- Python debugger
                }
	})
