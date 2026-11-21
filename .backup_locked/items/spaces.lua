local colors = require("colors")
local settings = require("settings")

local spaces = {}

for i = 1, 5, 1 do
  local space = sbar.add("item", "space." .. i, {
    position = "left",
    width = 34,
    align = "center",
    icon = {
      font = {
        family = "SF Pro",
        style = "Medium",
        size = 12.0
      },
      string = tostring(i),
      align = "center",
      padding_left = 0,
      padding_right = 0,
      color = colors.ref.inactive_space,
      y_offset = 0,
    },
    label = { drawing = false },
    padding_right = 1,
    padding_left = (i == 1) and 6 or 1,
    background = {
      drawing = true,
      color = 0x00000000,
      border_width = 0,
      height = 26,
      corner_radius = 8,
      padding_left = 0,
      padding_right = 0,
    },
  })

  spaces[i] = space

  space:subscribe("mouse.clicked", function(env)
    sbar.exec("/opt/homebrew/bin/cberry space " .. i)
    for j = 1, 5 do
      local is_active = (j == i)
      spaces[j]:set({
        icon = {
          color = is_active and colors.ref.dark_charcoal or colors.ref.inactive_space,
          font = {
            family = "SF Pro",
            style = is_active and "Bold" or "Medium",
            size = 12.0
          }
        },
        background = {
          drawing = true,
          color = is_active and colors.ref.cyan_active or 0x00000000,
          corner_radius = 8,
          height = 26,
          padding_left = 0,
          padding_right = 0,
        }
      })
    end
  end)
end

-- Subtle horizontal divider line below spaces
local spaces_divider = sbar.add("item", "spaces.divider", {
  position = "left",
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    drawing = true,
    color = colors.ref.divider,
    height = 1,
    padding_left = 6,
    padding_right = 6,
  },
  padding_left = 10,
  padding_right = 0,
})

local function update_spaces()
  sbar.exec("/opt/homebrew/bin/cberry query --spaces 2>/dev/null", function(output)
    if not output then return end
    local focused_idx = 1
    if type(output) == "table" then
      for _, sp in ipairs(output) do
        if sp.focused == true then
          focused_idx = tonumber(sp.index)
          break
        end
      end
    elseif type(output) == "string" then
      for idx in output:gmatch('"index":(%d+)[^}]-"focused":true') do
        focused_idx = tonumber(idx)
        break
      end
    end

    for i = 1, 5 do
      local is_active = (i == focused_idx)
      spaces[i]:set({
        icon = {
          color = is_active and colors.ref.dark_charcoal or colors.ref.inactive_space,
          font = {
            family = "SF Pro",
            style = is_active and "Bold" or "Medium",
            size = 12.0
          }
        },
        background = {
          drawing = true,
          color = is_active and colors.ref.cyan_active or 0x00000000,
          corner_radius = 8,
          height = 26,
          padding_left = 0,
          padding_right = 0,
        }
      })
    end
  end)
end

local watcher = sbar.add("item", "space_watcher", {
  drawing = false,
  update_freq = 1,
  updates = true,
})
watcher:subscribe({ "space_change", "space_windows_change", "system_woke", "routine", "forced" }, update_spaces)

update_spaces()
