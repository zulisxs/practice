-- main.lua
-- 1) Cargar FluentPlus
local Fluent = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/discoart/FluentPlus/main/Beta.lua"
))()

-- 2) Cargar tu UI directamente desde GitHub
loadstring(game:HttpGet("https://raw.githubusercontent.com/zulisxs/practice/refs/heads/main/ui.lua"))()
-- 3) Lógicas por pestaña
loadstring(game:HttpGet("https://raw.githubusercontent.com/zulisxs/practice/refs/heads/main/autofarm.lua"))()

 
