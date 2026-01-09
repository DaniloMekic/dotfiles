-- Eclipse JDT Language Server (JDTLS)
-- Wiki: https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki
-- `org.eclipse.jdt.ls.core.internal.preferences.Preferences`: https://github.com/eclipse-jdtls/eclipse.jdt.ls/blob/main/org.eclipse.jdt.ls.core/src/org/eclipse/jdt/ls/core/internal/preferences/Preferences.java


--
-- JDTLS Paths
--
local jdtls_home = vim.fn.expand("$MASON/packages/jdtls")
local jdtls_jar = vim.fn.globpath(jdtls_home .. "/plugins", "org.eclipse.equinox.launcher_*.jar")
local jdtls_config_linux = jdtls_home .. "/config_linux"

-- JDTLS Project Paths
local project_root = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
if project_root == "." then -- Dot instead of a canonical path would throw java.net.URISyntaxException
  project_root = vim.fn.fnamemodify(project_root, ":p")
end

local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")

-- JDTLS Workspace Paths
local workspace_root = vim.fn.expand("~/.local/share/jdtls/")
local workspace_dir = workspace_root .. project_name

-- Create the root workspace directory if it doesn't exist
if vim.fn.isdirectory(workspace_root) == 0 then
  vim.fn.mkdir(workspace_root, "p")
end


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
vim.list_extend(jdtls_plugins, vim.split(vim.fn.glob(vim.fn.expand("$MASON/packages/java-test/extension/server/*.jar"), true), "\n"))

-- Java Agents
local java_agents = {
  lombok = vim.fn.expand("$MASON/packages/jdtls/lombok.jar")
}

--
-- JDTLS Config
--
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. java_agents["lombok"],
    "-jar", jdtls_jar,
    "-configuration", jdtls_config_linux,
    "-data", workspace_dir
  },
  root_dir = project_root,

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
          }
        }
      }
    }
  },

  -- Language server `initializationOptions`
  -- `bundles` table needs to be extended with paths to jar files
  init_options = {
    jvm_args = {},
    bundles = jdtls_plugins
  },
}

--vim.lsp.config("jdtls", config)
require("jdtls").start_or_attach(config)
