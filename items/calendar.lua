local colors = require("colors")
local settings = require("settings")

-- Center Section — Vertically Stacked Clock
-- Split the clock into stacked centered items in position = "center"

local hour = sbar.add("item", "clock.hour", {
  position = "center",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = os.date("%I"),
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Bold",
      size = 18.0,
    },
    color = colors.ref.clock_hour,
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 20,
  },
  padding_left = 0,
  padding_right = 0,
})

local min = sbar.add("item", "clock.min", {
  position = "center",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = os.date("%M"),
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Medium",
      size = 18.0,
    },
    color = colors.ref.clock_min,
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 20,
  },
  padding_left = 0,
  padding_right = 0,
})

local ampm = sbar.add("item", "clock.ampm", {
  position = "center",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = os.date("%p"),
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 10.0,
    },
    color = colors.ref.clock_ampm,
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 14,
  },
  padding_left = 3,
  padding_right = 0,
})

local date = sbar.add("item", "clock.date", {
  position = "center",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = os.date("%a %d"):upper(),
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 9.0,
    },
    color = colors.ref.clock_date,
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 13,
  },
  padding_left = 0,
  padding_right = 0,
  update_freq = 30,
})

local function update_clock()
  hour:set({ label = { string = os.date("%I") } })
  min:set({ label = { string = os.date("%M") } })
  ampm:set({ label = { string = os.date("%p") } })
  date:set({ label = { string = os.date("%a %d"):upper() } })
end

date:subscribe({ "forced", "routine", "system_woke" }, update_clock)

hour:subscribe("mouse.clicked", function()
  sbar.exec(settings.calendar.click_script or "open -a Calendar")
end)
min:subscribe("mouse.clicked", function()
  sbar.exec(settings.calendar.click_script or "open -a Calendar")
end)
ampm:subscribe("mouse.clicked", function()
  sbar.exec(settings.calendar.click_script or "open -a Calendar")
end)
date:subscribe("mouse.clicked", function()
  sbar.exec(settings.calendar.click_script or "open -a Calendar")
end)

update_clock()
