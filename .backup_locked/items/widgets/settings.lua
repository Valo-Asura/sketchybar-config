local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")

local settings_widget = sbar.add("item", "widgets.settings", {
    position = "left",
    icon = {
        string = icons.settings,
        color = colors.white,
        font = {
            family = settings.font.text,
            size = 12.0,
        },
        align = "center",
        padding_left = 0,
        padding_right = 0,
    },
    label = { drawing = false },
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        border_width = 1,
        height = 24,
        corner_radius = 9,
        drawing = true,
    },
    padding_left = 0,
    padding_right = 0,
    popup = { align = "left", height = 32 }
})

local restart = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.restart },
    label = { string = "Restart SketchyBar" }
})

restart:subscribe("mouse.clicked", function()
    sbar.exec("sketchybar --reload")
end)

local stop = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.stop },
    label = { string = "Stop SketchyBar" }
})

stop:subscribe("mouse.clicked", function()
    sbar.exec("brew services stop sketchybar")
end)

local edit_configuration = sbar.add("item", {
    position = "popup." .. settings_widget.name,
    icon = { string = icons.pencil },
    label = { string = "Edit Config" }
})

local function build_script(editor)
    return "osascript -e 'tell application \"Terminal\" to if (count of windows) = 0 then reopen' -e 'tell application \"Terminal\" to activate' -e 'tell application \"Terminal\" to do script \"cd ~/.config/sketchybar && " .. editor .. " config.json\" in front window'"
end

edit_configuration:subscribe("mouse.clicked", function()
    sbar.exec(build_script("code"), function(output)
        if output == "" then
            sbar.exec(build_script("vim"))
        end
    end)
end)

settings_widget:subscribe("mouse.clicked", function(env)
    local should_draw = settings_widget:query().popup.drawing == "off"
    settings_widget:set({ popup = { drawing = should_draw } })
end)

settings_widget:subscribe("mouse.exited.global", function()
    settings_widget:set({ popup = { drawing = false } })
end)
