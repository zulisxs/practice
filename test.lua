-- Fluent Plus UI Builder Generated Code
-- https://docs.fluent-pl.us/

-- Load Fluent Plus library
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua"))()

-- Optional: Load addons (SaveManager & InterfaceManager)
-- local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "zUlisxs",
    SubTitle = "Script test",
    TitleIcon = "home",
    Size = UDim2.fromOffset(700, 550),
    TabWidth = 180,
    Acrylic = true,
    Theme = "Darker",
    Search = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = true,
    UserInfoTitle = "game.Players.LocalPlayer.Name",
    UserInfoSubtitleColor = Color3.fromRGB(255, 215, 0),
    UserInfoTop = true
})

-- Create Tabs
local TabFarm = Window:AddTab({ Title = "Farm", Icon = "Sword" })

local SectionFarm = TabFarm:AddSection("Farm", "Sword")

SectionFarm:AddDropdown("MyDropdown", {
    Title = "Enemies",
    Description = "xdxd",
    Values = { "Option 1", "Option 2", "Option 3" },
    Default = {},
    Multi = true,
    AllowNull = false,
    Search = true,
    KeepSearch = false,
    Icon = "skull",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Selected:", Value)
    end
})


-- Select first tab
Window:SelectTab(1)

-- Optional: Build config section with SaveManager
-- SaveManager:SetLibrary(Fluent)
-- InterfaceManager:SetLibrary(Fluent)
-- SaveManager:SetFolder("YourScriptName")
-- InterfaceManager:SetFolder("YourScriptName")
-- InterfaceManager:BuildInterfaceSection(Tabs.Settings)
-- SaveManager:BuildConfigSection(Tabs.Settings)
