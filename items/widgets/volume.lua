local colors = require("colors")
local settings = require("settings")

local popup_width = 220

-- 1. Value (stacked above cpu_icon with 8px gap)
local volume_val = sbar.add("item", "widgets.volume.val", {
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
    color = colors.ref.vol,
  },
  background = {
    drawing = true,
    color = 0x00000000,
    height = 13,
  },
  padding_left = 0,
  padding_right = 8, -- 8px gap above cpu.icon
})

-- 2. Icon (stacked directly above volume_val)
local volume_icon = sbar.add("item", "widgets.volume.icon", {
  position = "right",
  icon = {
    drawing = true,
    string = "􀊧",
    font = {
      family = "SF Pro",
      style = "Regular",
      size = 13.0,
    },
    align = "center",
    color = colors.ref.vol,
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

local volume_slider = sbar.add("slider", popup_width, {
  position = "popup." .. volume_icon.name,
  slider = {
    highlight_color = colors.ref.cyan_active,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    knob = {
      string = "●",
      drawing = true,
    },
  },
  background = { color = colors.bg1, height = 2, y_offset = -20 },
  click_script = 'osascript -e "set volume output volume $PERCENT"'
})

volume_icon:subscribe("volume_change", function(env)
  local vol = tonumber(env.INFO) or 0
  volume_val:set({
    label = { string = vol .. "%" }
  })
  volume_slider:set({ slider = { percentage = vol } })
end)

local function volume_collapse_details()
  volume_icon:set({ popup = { drawing = false } })
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Applications/Utilities/Audio\\ MIDI\\ Setup.app")
    return
  end

  local should_draw = volume_icon:query().popup.drawing == "off"
  if should_draw then
    volume_icon:set({ popup = { drawing = true } })
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        local counter = 0
        for device in available:gmatch("[^\r\n]+") do
          local color = colors.grey
          if current_audio_device == device then
            color = colors.white
          end
          sbar.add("item", "volume.device." .. counter, {
            position = "popup." .. volume_icon.name,
            width = popup_width,
            align = "left",
            label = { string = device, color = color },
            click_script = 'SwitchAudioSource -s "' .. device .. '" && sketchybar --set /volume.device\\.*/ label.color=' .. colors.grey .. ' --set $NAME label.color=' .. colors.white
          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_val:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.exited.global", volume_collapse_details)

-- Initial volume query
sbar.exec("osascript -e 'output volume of (get volume settings)'", function(res)
  local vol = tonumber(res) or 0
  volume_val:set({ label = { string = vol .. "%" } })
  volume_slider:set({ slider = { percentage = vol } })
end)
