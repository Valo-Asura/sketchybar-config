local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local tbl = require("utils.tbl")

local clipboard = sbar.add("item", "widgets.clipboard", {
    position = "left",
    icon = {
        string = icons.clipboard_list,
        color = colors.white,
        font = {
            family = settings.font.text,
            size = 12.0,
        },
        align = "center",
        padding_left = 0,
        padding_right = 0,
    },
    label = { drawing = false },
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        border_width = 1,
        height = 24,
        corner_radius = 9,
        drawing = true,
    },
    padding_left = 0,
    padding_right = 0,
    update_freq = 4,
    popup = { align = "left" }
})

local clipboard_popups = {}
local clipboard_items = {}
local max_items = settings.clipboard.max_items

for i = 1, max_items do
    local popup_item = sbar.add("item", "clipboard.popup" .. i, {
        position = "popup." .. clipboard.name,
        label = {
          string = "?",
          width = 300,
          align = "left",
          font = { size = 11.0 }
        },
        drawing = false
    })
    popup_item:subscribe("mouse.clicked", function()
        local value = clipboard_items[i]
        sbar.exec("pbcopy <<'EOF'\n" .. value .. "\nEOF")
        popup_item:set({ label = { string = icons.clipboard, align = "center" } })
        sbar.delay(1, function()
            popup_item:set({ label = { string = value, align = "left" } })
        end)
    end)
    table.insert(clipboard_popups, popup_item)
end

clipboard:subscribe({ "routine", "forced", "system_woke" }, function()
    sbar.exec("pbpaste", function(current_clipboard)
        local clipboard_text = current_clipboard:gsub("^%s*(.-)%s*$", "%1")
        if clipboard_text ~= "" and not tbl.is_duplicate(clipboard_items, clipboard_text) then
            table.insert(clipboard_items, 1, clipboard_text)
            if #clipboard_items > max_items then
                table.remove(clipboard_items)
            end
        end
    end)
end)

clipboard:subscribe("mouse.clicked", function(env)
    local should_draw = clipboard:query().popup.drawing == "off"
    if should_draw then
        clipboard:set({ popup = { drawing = true } })
        for i, item in ipairs(clipboard_popups) do
            local value = clipboard_items[i]
            if value then
                item:set({ label = { string = value }, drawing = true })
            else
                item:set({ drawing = false })
            end
        end
    else
        clipboard:set({ popup = { drawing = false } })
    end
end)

clipboard:subscribe("mouse.exited.global", function()
    clipboard:set({ popup = { drawing = false } })
end)
