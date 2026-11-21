local colors = require("colors")
local settings = require("settings")

-- Front app icon disabled per minimalist left bar specification (numbers and small icons only)
local front_app = sbar.add("item", "front_app", {
  position = "left",
  drawing = false,
  updates = false,
})
