-- Fluent Plus UI Builder Generated Code
-- https://docs.fluent-pl.us/

-- Load Fluent Plus library
--local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua"))()

-- Optional: Load addons (SaveManager & InterfaceManager)
local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

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
    UserInfoTop = false
})

-- Create Tabs
local TabFarm = Window:AddTab({ Title = "Farm", Icon = "sword" })

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

SectionFarm:AddToggle("MyToggle", {
    Title = "Toggle",
    Default = false,
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Toggle:", Value)
    end
})

SectionFarm:AddSlider("MySlider", {
    Title = "Slider",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Slider:", Value)
    end
})


local TabNewTab = Window:AddTab({ Title = "New Tab" })

local SectionNewSection = TabNewTab:AddSection("New Section")

SectionNewSection:AddKeybind("MyKeybind", {
    Title = "Keybind",
    Default = "F",
    Mode = "Toggle",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Key pressed, value:", Value)
    end,
    ChangedCallback = function(Key)
        print("Key changed to:", Key)
    end
})

SectionNewSection:AddDropdown("MyDropdown", {
    Title = "Dropdown",
    Values = { "Option 1", "Option 2", "Option 3" },
    Default = "Option 1",
    Multi = false,
    AllowNull = false,
    Search = true,
    KeepSearch = false,
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Selected:", Value)
    end
})

SectionNewSection:AddInput("MyInput", {
    Title = "Input",
    Default = "",
    Placeholder = "Enter text...",
    Numeric = false,
    Finished = false,
    MaxLength = 50,
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Input:", Value)
    end
})

SectionNewSection:AddColorpicker("MyColorpicker", {
    Title = "Color",
    Default = Color3.fromRGB(255, 0, 0),
    Visible = true,
    Callback = function(Color)
        -- Add your callback code here
        print("Color:", Color)
    end
})

SectionNewSection:AddParagraph({
    Title = "Information",
    Content = "Enter your text here...",
    Visible = true
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
