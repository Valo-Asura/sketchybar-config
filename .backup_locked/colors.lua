return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  blue = 0xff76cce0,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  transparent = 0x00000000,

  -- Palette extracted from reference design
  ref = {
    bg = 0xc81c1a19,             -- frosted dark translucent
    border = 0x28ffffff,         -- subtle 1px border
    divider = 0x22ffffff,        -- faint thin separator line
    cyan_active = 0xff5de4f0,    -- vibrant rounded cyan pill
    dark_charcoal = 0xff0b1215,  -- dark text on active pill
    inactive_space = 0x77ffffff, -- muted gray numbers
    clock_hour = 0xfff5f5f5,     -- bold bright white
    clock_min = 0xffd4d4d8,      -- medium softer white
    clock_ampm = 0xff9ca3af,     -- muted am/pm
    clock_date = 0xff71717a,     -- muted date
    vol = 0xffd6f4f7,            -- soft ice-cyan
    cpu = 0xffe89e64,            -- warm amber
    ram = 0xffe5e7eb,            -- clean white
    net = 0xff7a7a80,            -- dim gray
    bat_green = 0xff7ee081,      -- soft vibrant green
    bat_amber = 0xffe89e64,      -- amber (<30%)
    bat_red = 0xfffc5d7c,        -- red (<15%)
  },

  bar = {
    bg = 0xc81c1a19,
    border = 0x28ffffff,
  },
  popup = {
    bg = 0xc01c1a19,
    border = 0x28ffffff,
  },
  bg1 = 0xff27282b,
  bg2 = 0xff373940,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
