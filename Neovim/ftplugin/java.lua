-- Eclipse JDT Language Server (JDTLS)
-- Wiki: https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki
-- `org.eclipse.jdt.ls.core.internal.preferences.Preferences`: https://github.com/eclipse-jdtls/eclipse.jdt.ls/blob/main/org.eclipse.jdt.ls.core/src/org/eclipse/jdt/ls/core/internal/preferences/Preferences.java
-- Java 21 is required. See https://wiki.archlinux.org/title/Java

--
-- JDTLS Plugins
--
local jdtls_plugins = {}
-- Installation via WhoIsSethDaniel/mason-tool-installer
-- Spring Tools:
--      https://spring.io/tools
--      https://github.com/spring-projects/spring-tools
local spring_boot = require("spring_boot").java_extensions()
vim.list_extend(jdtls_plugins, spring_boot)
-- https://github.com/microsoft/java-debug
vim.list_extend(jdtls_plugins, vim.fn.glob(vim.fn.expand("$MASON/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), true, true))
-- https://github.com/microsoft/vscode-java-test
local java_test_bundles = vim.split(vim.fn.glob(vim.fn.expand("$MASON/packages/java-test/extension/server/*.jar"), 1), "\n")
local excluded = {
    "com.microsoft.java.test.runner-jar-with-dependencies.jar",
    "jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
    local fname = vim.fn.fnamemodify(java_test_jar, ":t")
    if not vim.tbl_contains(excluded, fname) then
        table.insert(jdtls_plugins, java_test_jar)
    end
end

--
-- JDTLS Config
--
local config = {
    name = "jdtls",
    cmd = { "jdtls" },
    root_dir = vim.fs.root(0, {'gradlew', '.git', 'mvnw'}),

    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "/usr/lib/jvm/java-8-openjdk"
                    },
                    {
                        name = "JavaSE-11",
                        path = "/usr/lib/jvm/java-11-openjdk"
                    },
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk"
                    },
                    {
                        name = "JavaSE-21",
                        path = "/usr/lib/jvm/java-21-openjdk"
                    },
                    {
                        name = "JavaSE-25",
                        path = "/usr/lib/jvm/java-25-openjdk"
                    }
                }
            }
        }
    },

    -- Language server `initializationOptions`
    -- `bundles` table needs to be extended with paths to jar files
    init_options = {
        bundles = jdtls_plugins
    },
}

--vim.lsp.config("jdtls", config)
require("jdtls").start_or_attach(config)
