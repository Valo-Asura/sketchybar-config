local colors = require("colors")
local settings = require("settings")

local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")

-- Event provider for network load
sbar.exec("killall network_load >/dev/null 2>&1; \"" .. config_dir .. "/helpers/event_providers/network_load/bin/network_load\" en0 network_update 2.0")

local popup_width = 240

-- 1. Value (stacked above battery.icon with 8px gap)
local wifi_val = sbar.add("item", "widgets.wifi.val", {
  position = "right",
  icon = { drawing = false },
  label = {
    drawing = true,
    string = "0 K",
    font = {
      family = "SF Pro",
      style = "Semibold",
      size = 9.5,
    },
    align = "center",
    y_offset = 0,
    padding_left = 0,
    padding_right = 0,
    color = colors.ref.net,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 13,
  },
  padding_left = 0,
  padding_right = 8, -- 8px gap above battery.icon
})

-- 2. Icon (stacked directly above wifi_val)
local wifi_icon = sbar.add("item", "widgets.wifi.icon", {
  position = "right",
  icon = {
    drawing = true,
    string = "↑↓",
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 11.0,
    },
    align = "center",
    color = colors.ref.net,
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
  popup = { align = "left" }
})

local ssid = sbar.add("item", {
  position = "popup." .. wifi_icon.name,
  icon = {
    font = { style = settings.font.style_map["Bold"] },
    string = "􀖩",
  },
  width = popup_width,
  align = "center",
  label = {
    font = { size = 14, style = settings.font.style_map["Bold"] },
    max_chars = 18,
    string = "WiFi",
  },
  background = {
    height = 2,
    color = colors.grey,
    y_offset = -15
  }
})

local ip = sbar.add("item", {
  position = "popup." .. wifi_icon.name,
  icon = {
    align = "left",
    string = "IP:",
    width = popup_width / 2,
  },
  label = {
    string = "127.0.0.1",
    width = popup_width / 2,
    align = "right",
  }
})

local function format_speed(str)
  if not str then return "0 K" end
  local num, unit = str:match("(%d+)(%a+)")
  if not num then return "0 K" end
  num = tonumber(num)
  if unit:find("MB") or unit:find("M") then
    return num .. " M"
  elseif unit:find("KB") or unit:find("K") then
    return num .. " K"
  else
    return "0 K"
  end
end

wifi_icon:subscribe("network_update", function(env)
  local down = format_speed(env.download)
  wifi_val:set({
    label = { string = down, color = colors.ref.net }
  })
end)

wifi_icon:subscribe({"wifi_change", "system_woke", "forced", "routine"}, function(env)
  sbar.exec("ipconfig getifaddr en0", function(current_ip)
    local connected = not (current_ip == "")
    if not connected then
      wifi_val:set({
        label = { string = "--", color = colors.ref.bat_red }
      })
    end
  end)
end)

local function hide_details()
  wifi_icon:set({ popup = { drawing = false } })
end

local function toggle_details()
  local should_draw = wifi_icon:query().popup.drawing == "off"
  if should_draw then
    wifi_icon:set({ popup = { drawing = true }})
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result:gsub("[\r\n]", "") })
    end)
    sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}'", function(result)
      local clean_ssid = result:gsub("[\r\n]", "")
      if clean_ssid ~= "" then
        ssid:set({ label = clean_ssid })
      end
    end)
  else
    hide_details()
  end
end

wifi_icon:subscribe("mouse.clicked", toggle_details)
wifi_val:subscribe("mouse.clicked", toggle_details)
wifi_icon:subscribe("mouse.exited.global", hide_details)
