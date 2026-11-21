local colors = require("colors")
local settings = require("settings")

-- Bottom group items stack bottom-up in position = "right"
-- 1. Battery (bottom)
require("items.widgets.battery")

-- 2. WiFi
require("items.widgets.wifi")

-- 3. RAM
require("items.widgets.ram")

-- 4. CPU
require("items.widgets.cpu")

-- 5. Volume (top of widgets)
require("items.widgets.volume")

-- 6. Subtle horizontal divider above Volume / separating widgets from Center Clock
local widgets_divider = sbar.add("item", "widgets.divider", {
  position = "right",
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    drawing = true,
    color = colors.ref.divider,
    height = 1,
    padding_left = 6,
    padding_right = 6,
  },
  padding_left = 0,
  padding_right = 10, -- breathing space above volume
})
