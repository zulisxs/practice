-- Fluent Plus UI Builder Generated Code
-- https://docs.fluent-pl.us/

-- Load Fluent Plus library
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua"))()

-- Optional: Load addons (SaveManager & InterfaceManager)
-- local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "Complete Hub",
    SubTitle = "All Features Demo",
    TitleIcon = "sparkles",
    Image = "rbxassetid://10723407389",
    Size = UDim2.fromOffset(800, 650),
    TabWidth = 200,
    Acrylic = true,
    Theme = "Dark",
    Search = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = true,
    UserInfoTitle = "Username",
    UserInfoSubtitle = "VIP Member",
    UserInfoSubtitleColor = Color3.fromRGB(138, 43, 226),
    UserInfoTop = true
})

-- Create Tabs
local TabFeatures = Window:AddTab({ Title = "Features", Icon = "sparkles" })

local SectionAllComponents = TabFeatures:AddSection("All Components")

SectionAllComponents:AddParagraph({
    Title = "Welcome",
    Content = "This template showcases all available Fluent Plus components.",
    Icon = "info",
    Visible = true
})

SectionAllComponents:AddButton({
    Title = "Action Button",
    Description = "Click to perform action",
    Icon = "play",
    Visible = true,
    Callback = function()
        -- Add your callback code here
        print("Button clicked!")
    end
})

SectionAllComponents:AddToggle("MainToggle", {
    Title = "Main Feature",
    Description = "Enable the main feature",
    Default = true,
    Icon = "power",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Toggle:", Value)
    end
})

SectionAllComponents:AddSlider("MainSlider", {
    Title = "Value Slider",
    Description = "Adjust this value",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Icon = "sliders",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Slider:", Value)
    end
})

SectionAllComponents:AddDropdown("MainDropdown", {
    Title = "Select Option",
    Description = "Choose from the list",
    Values = { "Option A", "Option B", "Option C", "Option D" },
    Default = "Option A",
    Multi = false,
    AllowNull = false,
    Search = true,
    KeepSearch = false,
    Icon = "list",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Selected:", Value)
    end
})

SectionAllComponents:AddColorpicker("MainColor", {
    Title = "Pick Color",
    Description = "Select your color",
    Default = Color3.fromRGB(0, 150, 255),
    Icon = "palette",
    Visible = true,
    Callback = function(Color)
        -- Add your callback code here
        print("Color:", Color)
    end
})

SectionAllComponents:AddKeybind("MainKeybind", {
    Title = "Activation Key",
    Description = "Press to activate",
    Default = "E",
    Mode = "Toggle",
    Icon = "keyboard",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Key pressed, value:", Value)
    end,
    ChangedCallback = function(Key)
        print("Key changed to:", Key)
    end
})

SectionAllComponents:AddInput("MainInput", {
    Title = "Text Input",
    Description = "Enter your text",
    Default = "",
    Placeholder = "Type here...",
    Numeric = false,
    Finished = true,
    MaxLength = 100,
    Icon = "type",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Input:", Value)
    end
})


local TabSettings = Window:AddTab({ Title = "Settings", Icon = "settings" })

local SectionConfiguration = TabSettings:AddSection("Configuration")

SectionConfiguration:AddToggle("AutoSave", {
    Title = "Auto Save",
    Description = "Automatically save settings",
    Default = true,
    Icon = "save",
    Visible = true,
    Callback = function(Value)
        -- Add your callback code here
        print("Toggle:", Value)
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
