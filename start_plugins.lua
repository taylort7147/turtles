PluginManager = require("plugin_manager")
TestPlugin = require("plugins/test_plugin")

pm = PluginManager:new()
pm:register(TestPlugin:new("Test plugin"))

pm:start()
