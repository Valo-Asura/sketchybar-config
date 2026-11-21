local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local tbl = require("utils.tbl")
local file = require("utils.file")
local lunajson = require("lunajson")

local default_symbol = tbl.copy(settings.stocks.default_symbol)
local symbols = tbl.copy(settings.stocks.symbols)
local data_key = "today"
local loading = false
local refresh_popup

local stocks = sbar.add("item", "widgets.stocks", {
    position = "left",
    icon = {
        string = icons.stocks.even,
        color = colors.white,
        font = {
            family = settings.font.text,
            size = 11.0,
        },
        align = "center",
        y_offset = 4,
        padding_left = 0,
        padding_right = 0,
    },
    label = {
        string = "--%",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 7.0,
        },
        align = "center",
        y_offset = -5,
        padding_left = 0,
        padding_right = 0,
        color = colors.white,
    },
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
    update_freq = 600,
    popup = { align = "left", height = 25 }
})

local stock_popups = {}
for i, _ in ipairs(symbols) do
    local popup = sbar.add("item", "stocks.popup" .. i, {
        position = "popup." .. stocks.name,
        label = {
            string = "No data",
            width = 130,
            align = "left",
            font = { size = 11.0 }
        },
        drawing = true
    })
    table.insert(stock_popups, popup)
end

local function get_stock_info(percent_change)
    local percent_change_str = string.format("%.1f%%", math.abs(percent_change))
    local icon
    if percent_change_str == "0.0%" then
        icon = { string = icons.stocks.even, color = colors.white }
    else
        local icon_value = percent_change > 0 and icons.stocks.up or icons.stocks.down
        local icon_color = percent_change > 0 and colors.green or colors.red
        icon = { string = icon_value, color = icon_color }
    end
    return icon, { string = (percent_change > 0 and "+" or "-") .. percent_change_str, drawing = true }
end

local function load_stocks()
    local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")
    local json_encoded = file.read(config_dir .. "/data/stock_data.json")
    if not json_encoded or json_encoded == "" then
        loading = false
        if refresh_popup then refresh_popup:set({ label = { string = "Refresh" } }) end
        return
    end
    local success, stock_data = pcall(lunajson.decode, json_encoded)
    if not success or type(stock_data) ~= "table" then
        loading = false
        if refresh_popup then refresh_popup:set({ label = { string = "Refresh" } }) end
        return
    end

    local percent_change = stock_data[default_symbol.symbol]
    if not percent_change or not percent_change[data_key] then
        for _, fallback_symbol in ipairs(symbols) do
            local fallback_data = stock_data[fallback_symbol.symbol]
            if fallback_data and fallback_data[data_key] then
                percent_change = fallback_data
                break
            end
        end
    end
    if not percent_change or not percent_change[data_key] then
        loading = false
        stocks:set({ icon = { string = icons.stocks.even } })
        if refresh_popup then refresh_popup:set({ label = { string = "Refresh" } }) end
        return
    end

    local icon, label = get_stock_info(percent_change[data_key])
    stocks:set({ icon = icon, label = label })

    for i, sym in ipairs(symbols) do
        local sym_data = stock_data[sym.symbol]
        local sym_icon, sym_label = " ", "No data"
        if sym_data and sym_data[data_key] then
            local icon_info, label_info = get_stock_info(sym_data[data_key])
            sym_icon = icon_info.string
            sym_label = label_info.string
        end
        stock_popups[i]:set({
            icon = { string = sym_icon },
            label = { string = sym.name .. " " .. sym_label }
        })
    end
    loading = false
    if refresh_popup then refresh_popup:set({ label = { string = "Refresh" } }) end
end

refresh_popup = sbar.add("item", {
    position = "popup." .. stocks.name,
    label = {
        string = "Refresh",
        width = 130,
        align = "center",
        font = { size = 11.0 }
    },
    drawing = true
})

local function refresh_stocks()
    if loading then
        return
    end
    loading = true
    refresh_popup:set({ label = { string = "Loading..." } })
    stocks:set({ icon = { string = icons.loading } })
    local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")
    local function shell_quote(value)
        return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
    end
    local symbols_to_fetch = { default_symbol.symbol }
    for _, symbol in ipairs(symbols) do
        if symbol.symbol ~= default_symbol.symbol then
            table.insert(symbols_to_fetch, symbol.symbol)
        end
    end
    local arguments = { config_dir }
    for _, symbol in ipairs(symbols_to_fetch) do
        table.insert(arguments, symbol)
    end
    local quoted_arguments = {}
    for _, argument in ipairs(arguments) do
        table.insert(quoted_arguments, shell_quote(argument))
    end
    sbar.exec(
        shell_quote(settings.python_command) .. " " .. shell_quote(config_dir .. "/helpers/stocks.py") .. " " .. table.concat(quoted_arguments, " "),
        function()
            load_stocks()
        end
    )
end

refresh_popup:subscribe("mouse.clicked", refresh_stocks)
stocks:subscribe({ "routine", "forced", "system_woke" }, refresh_stocks)

stocks:subscribe("mouse.clicked", function(env)
    stocks:set({ popup = { drawing = "toggle" } })
end)

stocks:subscribe("mouse.exited.global", function()
    stocks:set({ popup = { drawing = "off" } })
end)

load_stocks()
