# SketchyBar & Cranberry Locked Configuration Rules

This document locks the approved vertical left status bar design. Do not modify these core values without explicit user confirmation.

## 1. Bar Specifications (`~/.config/sketchybar/bar.lua`)
- **Position**: `left` (vertical bar anchored on left edge of display)
- **Bar Width**: `height = 46` (in SketchyBar vertical mode, `height` specifies bar width)
- **Margins & Offsets**: `margin = 8`, `x_offset = 0`, `y_offset = 160` (centered vertically on a 900px display, producing a 580px tall dock)
- **Corner & Blur**: `corner_radius = 12`, `blur_radius = 30`
- **Internal Padding**: `padding_left = 12`, `padding_right = 12` (provides 12px breathing room from the top and bottom curved pill ends)
- **Colors**:
  - Background: `0xc81c1a19` (frosted translucent dark charcoal)
  - Border: `border_width = 1`, `border_color = 0x28ffffff` (subtle 1px border)
- **Window Level**: `topmost = "window"`, `shadow = "off"`, `font_smoothing = "on"`

## 2. Window Manager Configuration (`~/.config/yabai/yabairc` & `~/.config/skhd/skhdrc`)
- **Tiling Window Manager**: Yabai (bsp layout) + skhd (hotkey daemon) + JankyBorders
- **Screen Padding**:
  - `top_padding 8`, `bottom_padding 8`, `right_padding 8`
  - `left_padding 62`: Accommodates the 8px screen margin + 46px bar width + 8px gap before tiled windows.
- **Window Gaps**: `window_gap 8`
- **Active Window Border**: JankyBorders with `active_color=0xff5de4f0` (matching cyan pill), `width=2.0`, `style=round`.

## 3. Top Section — Workspaces (`~/.config/sketchybar/items/spaces.lua`)
- Spaces 1 through 5, position `left`:
  - **Inactive Spaces**: `icon.color = 0x77ffffff` (muted gray numerals), transparent background `0x00000000`, font `SF Pro:Medium:12.0`, `width = 34`, `icon.width = 34`, `icon.align = "center"`.
  - **Active Workspace**: Rounded cyan rectangle (`34x26px`, `corner_radius = 8`), `0xff5de4f0`, `width = 34`, `height = 26`, `icon.width = 34`, `icon.align = "center"`, text `0xff0b1215` (bold dark charcoal), font `SF Pro:Bold:12.0`.
- **Top Divider Line**: `spaces.divider` (height = 1, `background.color = 0x22ffffff`, `padding_left = 10`).

## 4. Center Section — Vertically Stacked Clock (`~/.config/sketchybar/items/calendar.lua`)
4 vertically stacked, centered items in `position = "center"`:
- **Hour** (`clock.hour`): `os.date("%I")`, `JetBrainsMono Nerd Font:Bold:18.0`, color `0xfff5f5f5` (bright white), height = 20.
- **Minute** (`clock.min`): `os.date("%M")`, `JetBrainsMono Nerd Font:Medium:18.0`, color `0xffd4d4d8` (soft white), height = 20.
- **AM/PM** (`clock.ampm`): `os.date("%p")`, `SF Pro:Regular:10.0`, color `0xff9ca3af` (muted), height = 14, `padding_left = 3`.
- **Date** (`clock.date`): `os.date("%a %d"):upper()`, `SF Pro:Regular:9.0`, color `0xff71717a` (muted gray), height = 13.

## 5. Bottom Section — Stacked Widgets (`~/.config/sketchybar/items/widgets/`)
Items stack bottom-up in `position = "right"`. Added in exact order from bottom to top:
1. **Battery**:
   - `widgets.battery.val`: font `SF Pro:Semibold:9.5`, string `<charge>%`, color `0xff7ee081` (green, amber <30%, red <15%), `padding_right = 0` (dock margin provided by `bar.padding_right`).
   - `widgets.battery.icon`: glyph `􀛨`, font `SF Pro:Regular:13.0`, color matching battery state.
2. **Network**:
   - `widgets.wifi.val`: font `SF Pro:Semibold:9.5`, string `<speed> K` (default `0 K`), color `0xff7a7a80`, `padding_right = 8`.
   - `widgets.wifi.icon`: glyph `↑↓`, font `SF Pro:Regular:11.0`, color `0xff7a7a80`.
3. **RAM**:
   - `widgets.ram.val`: font `SF Pro:Semibold:9.5`, string `<load>%`, color `0xffe5e7eb` (clean white), `padding_right = 8`.
   - `widgets.ram.icon`: glyph `􀫦`, font `SF Pro:Regular:13.0`, color `0xffe5e7eb`.
4. **CPU**:
   - `widgets.cpu.val`: font `SF Pro:Semibold:9.5`, string `<temp>°C`, color `0xffe89e64` (warm amber), `padding_right = 8`. Reads live Apple Silicon SMC temp via native helper.
   - `widgets.cpu.icon`: glyph `􀧓`, font `SF Pro:Regular:13.0`, color `0xffe89e64`.
5. **Volume**:
   - `widgets.volume.val`: font `SF Pro:Semibold:9.5`, string `<vol>%`, color `0xffd6f4f7` (soft ice-cyan), `padding_right = 8`.
   - `widgets.volume.icon`: glyph `􀊧`, font `SF Pro:Regular:13.0`, color `0xffd6f4f7`.
6. **Bottom Divider Line**: `widgets.divider` (height = 1, `background.color = 0x22ffffff`, `padding_right = 10`).
