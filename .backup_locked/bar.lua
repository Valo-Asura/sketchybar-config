local colors = require("colors")
local settings = require("settings")

sbar.bar({
  position = "left",
  height = 46,
  margin = 8,
  x_offset = 0,
  y_offset = 160,
  corner_radius = 12,
  blur_radius = 30,
  color = colors.ref.bg,
  border_color = colors.ref.border,
  border_width = 1,
  padding_left = 0,
  padding_right = 0,
  topmost = "window",
  shadow = "off",
  font_smoothing = "on",
})
