local colors = require("colors")
local settings = require("settings")

-- Paired items in position = "right" (stacks bottom-up)
-- 1. Value (bottom-most)
local battery_val = sbar.add("item", "widgets.battery.val", {
  position = "right",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = "--%",
    font = {
      family = "SF Pro",
      style = "Semibold",
      size = 9.5,
    },
    align = "center",
    y_offset = 0,
    padding_left = 0,
    padding_right = 0,
    color = colors.ref.bat_green,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 13,
  },
  padding_left = 0,
  padding_right = 6, -- 6px bottom padding inside the bar
})

-- 2. Icon (stacked directly above value)
local battery_icon = sbar.add("item", "widgets.battery.icon", {
  position = "right",
  icon = {
    drawing = true,
    string = "􀛨",
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 13.0,
    },
    align = "center",
    color = colors.ref.bat_green,
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
  update_freq = 120,
  popup = { align = "left" }
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery_icon.name,
  icon = {
    string = "Remaining:",
    width = 110,
    align = "left"
  },
  label = {
    string = "??:??h",
    width = 100,
    align = "right"
  },
})

local function update_battery()
  sbar.exec("pmset -g batt", function(batt_info)
    local found, _, charge = batt_info:find("(%d+)%%")
    charge = found and tonumber(charge) or 100

    local color = colors.ref.bat_green
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      color = colors.ref.bat_green
    elseif charge <= 15 then
      color = colors.ref.bat_red
    elseif charge <= 30 then
      color = colors.ref.bat_amber
    end

    battery_icon:set({
      icon = { color = color }
    })
    battery_val:set({
      label = {
        string = charge .. "%",
        color = color
      }
    })
  end)
end

battery_icon:subscribe({"routine", "power_source_change", "system_woke"}, update_battery)

local function toggle_details()
  local drawing = battery_icon:query().popup.drawing
  battery_icon:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      local charging, _, _ = batt_info:find("AC Power")
      local icon = charging and "Time till full:" or "Time remaining:"
      remaining_time:set({ icon = icon, label = label })
    end)
  end
end

battery_icon:subscribe("mouse.clicked", toggle_details)
battery_val:subscribe("mouse.clicked", toggle_details)

battery_icon:subscribe("mouse.exited.global", function()
  battery_icon:set({ popup = { drawing = "off" } })
end)

update_battery()
