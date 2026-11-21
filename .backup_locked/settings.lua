local lunajson = require 'lunajson'

local file = require("utils.file")
local tbl = require("utils.tbl")

local function load_config()
    local config = {
        bar_height = 40,
        calendar = {
            click_script = "open -a Calendar"
        },
        clipboard = {
            max_items = 5
        },
        font = {
            text = "JetBrainsMono Nerd Font",
            numbers = "JetBrainsMono Nerd Font",
            style_map = {
                ["Regular"] = "Regular",
                ["Semibold"] = "Medium",
                ["Bold"] = "SemiBold",
                ["Heavy"] = "Bold",
                ["Black"] = "ExtraBold",
            },
        },
        group_paddings = 5,
        hide_widgets = {},
        icons = "NerdFont",
        paddings = 3,
        python_command = "python3",
        stocks = {
            default_symbol = { symbol = "^GSPC", name = "S&P 500" },
            symbols = {
                { symbol = "^DJI", name = "Dow" },
                { symbol = "^IXIC", name = "Nasdaq" },
                { symbol = "^RUT", name = "Russell 2K" }
            }
        },
        weather = {
            location = false,
            use_shortcut = false
        }
    }

    local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")
    local config_filepath = config_dir .. "/config.json"
    local content, error = file.read(config_filepath)
    if not error then
        local json_content = lunajson.decode(content)
        tbl.merge(config, json_content)
    end
    return config
end

return load_config()
