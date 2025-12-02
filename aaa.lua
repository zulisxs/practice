-- Fluent Plus UI Builder Generated Code
-- https://docs.fluent-pl.us/

-- Load Fluent Pluas library
--local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua"))()

-- Optional: Load addons (SaveManager & InterfaceManager)
local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "aaaaaa",
    SubTitle = "Fluent Plus UI",
    TitleIcon = "home",
    Size = UDim2.fromOffset(700, 550),
    TabWidth = 180,
    Acrylic = true,
    Theme = "Dark",
    Search = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = true,
    UserInfoTitle = game.Players.LocalPlayer.Name,
    UserInfoSubtitleColor = Color3.fromRGB(255, 215, 0),
    UserInfoTop = false
})

-- Create Tabs
local TabNewTab = Window:AddTab({ Title = "New Tab" })

local SectionNewSection = TabNewTab:AddSection("New Section")


-- Select first tab
Window:SelectTab(1)

-- Optional: Build config section with SaveManager
-- SaveManager:SetLibrary(Fluent)
-- InterfaceManager:SetLibrary(Fluent)
-- SaveManager:SetFolder("YourScriptName")
-- InterfaceManager:SetFolder("YourScriptName")
-- InterfaceManager:BuildInterfaceSection(Tabs.Settings)
-- SaveManager:BuildConfigSection(Tabs.Settings)
