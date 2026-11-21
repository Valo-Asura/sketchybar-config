local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")

local apple = sbar.add("item", "apple", {
  position = "left",
  drawing = false,
  icon = {
    font = {
      family = settings.font.text,
      size = 12.0
    },
    string = icons.command, -- ⌘ symbol in spaces view
    color = colors.white,
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
})

apple:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec(config_dir .. "/helpers/menus/bin/menus -s 0")
  else
    sbar.trigger("swap_menus_and_spaces")
  end
end)

apple:subscribe("mouse.entered", function()
  apple:set({ background = { border_color = colors.white } })
end)

apple:subscribe("mouse.exited", function()
  apple:set({ background = { border_color = colors.bg2 } })
end)
