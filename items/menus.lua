local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")

local menu_watcher = sbar.add("item", "menu_watcher", {
  drawing = false,
  updates = false,
})

local space_menu_swap = sbar.add("item", "space_menu_swap", {
  drawing = false,
  updates = true,
})

sbar.add("event", "swap_menus_and_spaces")

local max_items = 15
local menu_items = {}
local is_menu_active = false

for i = 1, max_items, 1 do
  local menu = sbar.add("item", "menu." .. i, {
    position = "left",
    padding_left = 1,
    padding_right = 1,
    drawing = false,
    icon = { drawing = false },
    label = {
      font = {
        family = settings.font.text,
        style = settings.font.style_map[i == 1 and "Heavy" or "Semibold"],
        size = (i == 1 and 11.5 or 10.5)
      },
      color = (i == 1 and colors.blue or colors.white),
      align = "center",
      padding_left = 1,
      padding_right = 1,
    },
    background = {
      color = colors.bg1,
      border_color = colors.bg2,
      border_width = 1,
      height = 26,
      corner_radius = 7,
      drawing = true,
    },
    click_script = config_dir .. "/helpers/menus/bin/menus -s " .. i,
  })

  menu:subscribe("mouse.entered", function()
    menu:set({
      background = { border_color = colors.white },
      label = { color = colors.white, highlight = true }
    })
  end)

  menu:subscribe("mouse.exited", function()
    menu:set({
      background = { border_color = colors.bg2 },
      label = { color = (i == 1 and colors.blue or colors.white), highlight = false }
    })
  end)

  menu_items[i] = menu
end

-- Close / toggle back button at end of menu items
local menu_toggle = sbar.add("item", "menu.toggle", {
  position = "left",
  padding_left = 1,
  padding_right = 1,
  drawing = false,
  icon = {
    string = "", -- Chevron up to close vertical menu
    color = colors.grey,
    align = "center",
    font = {
      family = settings.font.text,
      size = 12.0
    },
    padding_left = 0,
    padding_right = 0,
  },
  label = { drawing = false },
  background = { drawing = false },
})

menu_toggle:subscribe("mouse.entered", function()
  menu_toggle:set({ icon = { color = colors.white } })
end)

menu_toggle:subscribe("mouse.exited", function()
  menu_toggle:set({ icon = { color = colors.grey } })
end)

menu_toggle:subscribe("mouse.clicked", function()
  sbar.trigger("swap_menus_and_spaces")
end)

local function update_menus(env)
  sbar.exec(config_dir .. "/helpers/menus/bin/menus -l", function(menus)
    sbar.set('/menu\\..*/', { drawing = false })
    local id = 1
    for menu in string.gmatch(menus, '[^\r\n]+') do
      if id <= max_items then
        menu_items[id]:set({
          label = {
            string = menu,
            color = (id == 1 and colors.blue or colors.white),
          },
          drawing = true
        })
      else break end
      id = id + 1
    end
    menu_toggle:set({ drawing = true })
  end)
end

menu_watcher:subscribe("front_app_switched", function()
  if is_menu_active then
    update_menus()
  end
end)

space_menu_swap:subscribe("swap_menus_and_spaces", function(env)
  if is_menu_active then
    -- Turn menus OFF, show spaces & front app
    is_menu_active = false
    menu_watcher:set({ updates = false })
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("/space\\..*/", { drawing = true })
    sbar.set("spaces_indicator", { drawing = true })
    sbar.set("front_app", { drawing = true })
    sbar.set("apple", {
      icon = { string = icons.command, color = colors.white }
    })
  else
    -- Turn menus ON, hide spaces & front app
    is_menu_active = true
    menu_watcher:set({ updates = true })
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("spaces_indicator", { drawing = false })
    sbar.set("front_app", { drawing = false })
    sbar.set("apple", {
      icon = { string = icons.apple, color = colors.blue }
    })
    update_menus()
  end
end)

return menu_watcher
