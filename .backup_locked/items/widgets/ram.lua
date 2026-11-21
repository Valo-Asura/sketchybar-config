local colors = require("colors")
local settings = require("settings")

-- 1. Value (stacked above wifi_icon with 8px gap)
local ram_val = sbar.add("item", "widgets.ram.val", {
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
    color = colors.ref.ram,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 13,
  },
  padding_left = 0,
  padding_right = 8, -- 8px gap above wifi.icon
})

-- 2. Icon (stacked directly above ram_val)
local ram_icon = sbar.add("item", "widgets.ram.icon", {
  position = "right",
  icon = {
    drawing = true,
    string = "􀫦",
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 13.0,
    },
    align = "center",
    color = colors.ref.ram,
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
  update_freq = 4,
  updates = true,
})

local function update_ram()
  sbar.exec("memory_pressure", function(output)
    local percentage = output:match("System%-wide memory free percentage: (%d+)")
    if percentage then
      local load = 100 - tonumber(percentage)
      local color = colors.ref.ram
      if load > 85 then
        color = colors.ref.bat_red
      elseif load > 70 then
        color = colors.ref.bat_amber
      end
      ram_val:set({
        label = {
          string = math.floor(load) .. "%",
          color = color
        }
      })
      ram_icon:set({
        icon = { color = color }
      })
    end
  end)
end

ram_icon:subscribe({ "routine", "forced", "system_woke" }, update_ram)

ram_icon:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)
ram_val:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)

update_ram()
