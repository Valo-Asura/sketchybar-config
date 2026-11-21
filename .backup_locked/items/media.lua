local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local whitelist = {
  ["Spotify"] = true,
  ["Music"] = true
}

local popup_width = 180

local media_cover = sbar.add("item", "media_cover", {
  position = "left",
  background = {
    image = {
      string = "media.artwork",
      scale = 0.7,
      corner_radius = 8,
    },
    color = 0x00000000,
    border_width = 0,
    height = 24,
    corner_radius = 6,
    drawing = false,
  },
  label = {
    font = { family = settings.font.text, size = 7.0 },
    color = colors.grey,
    align = "center",
    max_chars = 7,
    y_offset = -5,
    padding_left = 0,
    padding_right = 0,
    drawing = true,
  },
  icon = {
    string = "",
    color = colors.white,
    font = {
      family = settings.font.text,
      size = 12.0,
    },
    align = "center",
    padding_left = 0,
    padding_right = 0,
    y_offset = 4,
  },
  padding_left = 0,
  padding_right = 0,
  drawing = false,
  updates = true,
  popup = {
    align = "left",
  }
})

local media_title = sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { drawing = false },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
    max_chars = 20,
    width = popup_width,
    align = "center",
  },
})

local media_artist = sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { drawing = false },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 10.5,
    },
    color = colors.grey,
    max_chars = 20,
    width = popup_width,
    align = "center",
  },
})

local controls = sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = {
    string = icons.media.back .. "   " .. icons.media.play_pause .. "   " .. icons.media.forward,
    font = { size = 14.0 },
    align = "center",
    width = popup_width,
  },
  label = { drawing = false },
  click_script = "nowplaying-cli togglePlayPause",
})

media_cover:subscribe("media_change", function(env)
  if whitelist[env.INFO.app] then
    local is_playing = (env.INFO.state == "playing")
    local is_paused = (env.INFO.state == "paused")
    local drawing = (is_playing or is_paused)

    media_artist:set({ label = { string = env.INFO.artist or "" } })
    media_title:set({ label = { string = env.INFO.title or "" } })
    media_cover:set({
      drawing = drawing,
      label = { string = env.INFO.title or "" },
    })
  else
    media_cover:set({ drawing = false })
  end
end)

media_cover:subscribe("mouse.clicked", function()
  media_cover:set({ popup = { drawing = "toggle" } })
end)

media_cover:subscribe("mouse.exited.global", function()
  media_cover:set({ popup = { drawing = false } })
end)
