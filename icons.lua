local settings = require("settings")

local icons = {
  sf_symbols = {
    plus = "􀅼",
    loading = "􀖇",
    apple = "􀣺",
    command = "􀆔",
    chevron_right = "􀆊",
    chevron_left = "􀆉",
    gear = "􀍟",
    cpu = "􀫥",
    clipboard = "􀉄",
    clipboard_list = "􁕜",
    settings = "􀣋",
    restart = "􀚁",
    stop = "􀜪",
    pencil = "􀈊",
    upgrade = "􁾨",
    ram = "􀫦",
    weather = {
      sunny = "􀆭",
      partly = "􀇔",
      cloudy = "􀇂",
      rainy = "􀇆",
      snowy = "􀇎",
      clear = "􀇀",
      foggy = "􀇊",
      stormy = "􀇞",
      sleet = "􀇐"
    },
    stocks = {
      up = "􀄤",
      down = "􀄥",
      even = "􀂓"
    },
    switch = {
      on = "􁏮",
      off = "􁏯",
    },
    volume = {
      _100 = "􀊩",
      _66 = "􀊧",
      _33 = "􀊥",
      _10 = "􀊡",
      _0 = "􀊣",
    },
    battery = {
      _100 = "􀛨",
      _75 = "􀺸",
      _50 = "􀺶",
      _25 = "􀛩",
      _0 = "􀛪",
      charging = "􀢋"
    },
    wifi = {
      upload = "􀄨",
      download = "􀄩",
      connected = "􀙇",
      disconnected = "􀙈",
      router = "􁓤",
      vpn = "􀒲"
    },
    media = {
      back = "􀊊",
      forward = "􀊌",
      play_pause = "􀊈",
      play = "􀊄",
      pause = "􀊆"
    },
  },

  nerdfont = {
    plus = "",
    loading = "",
    apple = "",
    command = "⌘",
    chevron_right = "",
    chevron_left = "",
    gear = "",
    cpu = "󰍛",
    ram = "󰘚",
    clipboard = "",
    clipboard_list = "󰅍",
    settings = "",
    restart = "",
    stop = "",
    pencil = "",
    upgrade = "",

    stocks = {
      up = "",
      down = "",
      even = "󰇼",
    },

    weather = {
      sunny = "󰖙",
      partly = "󰖕",
      cloudy = "󰖐",
      rainy = "󰖗",
      snowy = "󰖘",
      clear = "󰖙",
      foggy = "󰖑",
      stormy = "󰖓",
      sleet = "󰙿",
    },

    switch = {
      on = "󱨥",
      off = "󱨦",
    },

    volume = {
      _100 = "󰕾",
      _66 = "󰕾",
      _33 = "󰖀",
      _10 = "󰕿",
      _0 = "󰖁",
    },

    battery = {
      _100 = "",
      _75 = "",
      _50 = "",
      _25 = "",
      _0 = "",
      charging = "",
    },

    wifi = {
      upload = "",
      download = "",
      connected = "󰖩",
      disconnected = "󰖪",
      router = "󰖩",
      vpn = "󰌾",
    },

    media = {
      back = "",
      forward = "",
      play_pause = "",
      play = "",
      pause = "",
    },
  },
}

if settings.icons == "sf-symbols" then
  return icons.sf_symbols
else
  return icons.nerdfont
end
