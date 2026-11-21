local settings = require("settings")
local colors = require("colors")

-- Default properties matching reference vertical pill design
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 13.0
    },
    color = colors.ref.vol,
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  label = {
    drawing = true,
    font = {
      family = "SF Pro",
      style = "Semibold",
      size = 9.5
    },
    color = colors.ref.ram,
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 14,
    corner_radius = 6,
    border_width = 0,
  },
  popup = {
    background = {
      border_width = 1,
      corner_radius = 8,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 30,
    align = "left",
  },
  padding_left = 0,
  padding_right = 0,
  scroll_texts = false,
})
