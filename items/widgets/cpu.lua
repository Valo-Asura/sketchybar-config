local colors = require("colors")
local settings = require("settings")

local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")

-- Execute the event provider binary which provides real SMC hardware temp
sbar.exec("killall cpu_load >/dev/null 2>&1; \"" .. config_dir .. "/helpers/event_providers/cpu_load/bin/cpu_load\" cpu_update 3.0")

-- 1. Value (stacked above ram_icon with 8px gap)
local cpu_val = sbar.add("item", "widgets.cpu.val", {
  position = "right",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = "--°C",
    font = {
      family = "SF Pro",
      style = "Semibold",
      size = 9.5,
    },
    align = "center",
    y_offset = 0,
    padding_left = 0,
    padding_right = 0,
    color = colors.ref.cpu,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 13,
  },
  padding_left = 0,
  padding_right = 8, -- 8px gap above ram.icon
})

-- 2. Icon (stacked directly above cpu_val)
local cpu_icon = sbar.add("item", "widgets.cpu.icon", {
  position = "right",
  icon = {
    drawing = true,
    string = "􀧓",
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 13.0,
    },
    align = "center",
    color = colors.ref.cpu,
    padding_left = 0,
    padding_right = 0,
    y_offset = 0,
  },
  label = { drawing = false },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 15,
  },
  padding_left = 0,
  padding_right = 0,
})

cpu_icon:subscribe("cpu_update", function(env)
  local reported_load = tonumber(env.total_load) or 0
  local load = math.max(0, math.min(100, reported_load))

  -- Real hardware temperature in Celsius from Apple Silicon SMC
  local reported_temp = tonumber(env.temp) or 0
  local temp = reported_temp
  if temp <= 0 or temp > 120 then
    temp = math.floor(34 + (load * 0.35))
  end

  local color = colors.ref.cpu
  if temp > 80 then
    color = colors.ref.bat_red
  elseif temp > 65 then
    color = colors.ref.bat_amber
  end

  cpu_val:set({
    label = {
      string = math.floor(temp) .. "°C",
      color = color,
    }
  })
  cpu_icon:set({
    icon = { color = color }
  })
end)

cpu_icon:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)
cpu_val:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)
