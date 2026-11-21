local user = os.getenv("USER") or "vimal"
local config_dir = os.getenv("CONFIG_DIR") or ("/Users/" .. user .. "/.config/sketchybar")

-- Add lua paths
package.path = package.path .. ";/opt/homebrew/share/lua/5.5/?.lua;/opt/homebrew/share/lua/5.5/?/init.lua;/Users/" .. user .. "/.luarocks/share/lua/5.5/?.lua;/Users/" .. user .. "/.luarocks/share/lua/5.5/?/init.lua;" .. config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua"

-- Add the sketchybar module and C libs to the package cpath
package.cpath = package.cpath .. ";/opt/homebrew/lib/lua/5.5/?.so;/Users/" .. user .. "/.local/share/sketchybar_lua/?.so;/Users/" .. user .. "/.luarocks/lib/lua/5.5/?.so"

os.execute("(cd \"" .. config_dir .. "/helpers\" && make)")

