Load.now(function()
    local metals_config = require("metals").bare_config()
    metals_config.settings = {
        -- serverVersion = "1.3.5",
    }
    metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
    end
    require("metals").initialize_or_attach(metals_config)
end)
