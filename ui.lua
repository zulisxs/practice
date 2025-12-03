local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

local Window = Fluent:CreateWindow({
    Title = "zUlisxs HUB",
    SubTitle = "",
    TitleIcon = "home",
    TabWidth = 180,
    Size = UDim2.fromOffset(700, 550),
    Acrylic = true,
    Theme = "Dark",
    Search = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = true,
    UserInfoTitle = game.Players.LocalPlayer.Name,
    UserInfoSubtitle = "Premium User",
    UserInfoSubtitleColor = Color3.fromRGB(255, 215, 0),
    UserInfoTop = false,
})


local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "swords" }),
    Bosses = Window:AddTab({ Title = "Bosses", Icon = "skull" }),
    GameMode = Window:AddTab({ Title = "Game Mode", Icon = "puzzle" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Others = Window:AddTab({ Title = "Others", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Main Tab

local InfoSection = Tabs.Main:AddSection("Info", "info")

InfoSection:AddParagraph({
    Title = "Priority",
    Content = "1- Raids (Only in auto join)\n2- Trials\n2- Raids (in auto open)\n3- Bosses\n", Icon = "info"
})

InfoSection:AddButton({
    Title = "Discord", Description = "Join discord for add suggestion, bugs and notify of updates", Icon = "external-link",
    Callback = function()
        print("Discord clicked")
    end
})

-- Farm Tab

local ElemSection = Tabs.Farm:AddSection("")

local EnemiesDropdown = ElemSection:AddDropdown("EnemiesDropdown", {
    Title = "Enemies", Description = "Select enemies",
    Values = { "" },
    Default = {},
    Multi = true,
    Search = true,
    AllowNull = false, Icon = "list",
    Callback = function(Value)
        print("Enemies changed:", Value)
    end
})

ElemSection:AddButton({
    Title = "Refresh", Description = "Refresh enemies", Icon = "rotate-cw",
    Callback = function()
        local autofarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/zulisxs/practice/main/autofarm.lua"))()
        autofarm.searchEnemies()
        updateEnemiesDropdown() -- Esta función estará disponible tras cargar el script
    end
})

local AutofarmToggle = ElemSection:AddToggle("AutofarmToggle", {
    Title = "Autofarm", Description = "Activate Auto Farm",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Autofarm changed:", Value)
    end
})

-- Bosses Tab

local ElemSection = Tabs.Bosses:AddSection("")

local XYZMetropolisSeaKingToggle = ElemSection:AddToggle("XYZMetropolisSeaKingToggle", {
    Title = "XYZ Metropolis Sea King",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("XYZ Metropolis Sea King changed:", Value)
    end
})

local XYZMetropolisCosmicGaroToggle = ElemSection:AddToggle("XYZMetropolisCosmicGaroToggle", {
    Title = "XYZ Metropolis Cosmic Garo",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("XYZ Metropolis Cosmic Garo changed:", Value)
    end
})

local NinjaVillageItachuToggle = ElemSection:AddToggle("NinjaVillageItachuToggle", {
    Title = "Ninja Village Itachu",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Ninja Village Itachu changed:", Value)
    end
})

local NinjaVillageNankoToggle = ElemSection:AddToggle("NinjaVillageNankoToggle", {
    Title = "Ninja Village Nanko",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Ninja Village Nanko changed:", Value)
    end
})

local ForgottenShoreLuciuToggle = ElemSection:AddToggle("ForgottenShoreLuciuToggle", {
    Title = "Forgotten Shore Luciu",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Forgotten Shore Luciu changed:", Value)
    end
})

local ForgottenShoreHawkeyeToggle = ElemSection:AddToggle("ForgottenShoreHawkeyeToggle", {
    Title = "Forgotten Shore Hawkeye",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Forgotten Shore Hawkeye changed:", Value)
    end
})

local SlayerForestHantengoToggle = ElemSection:AddToggle("SlayerForestHantengoToggle", {
    Title = "Slayer Forest Hantengo",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Slayer Forest Hantengo changed:", Value)
    end
})

local SlayerForestKokushibeToggle = ElemSection:AddToggle("SlayerForestKokushibeToggle", {
    Title = "Slayer Forest Kokushibe",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Slayer Forest Kokushibe changed:", Value)
    end
})

-- Game Mode Tab

local TrialsSection = Tabs.GameMode:AddSection("Trials")

local SelectTrialDropdown = TrialsSection:AddDropdown("SelectTrialDropdown", {
    Title = "Select Trial",
    Values = { "Trial Easy" },
    Default = {},
    Multi = true,
    Search = true,
    AllowNull = false, Icon = "list",
    Callback = function(Value)
        print("Select Trial changed:", Value)
    end
})

local AutoleaveInput = TrialsSection:AddInput("AutoleaveInput", {
    Title = "Auto leave", Description = "Leave in wave",
    Default = "",
    Placeholder = "Enter wave...",
    Numeric = false,
    Finished = false,
    MaxLength = 50, Icon = "type",
    Callback = function(Value)
        print("Auto leave changed:", Value)
    end
})

local AutoJoinToggle = TrialsSection:AddToggle("AutoJoinToggle", {
    Title = "Auto Join ",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Auto Join  changed:", Value)
    end
})

local AutoFarmToggle = TrialsSection:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm", Description = "Auto farm npc in trial",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Auto Farm changed:", Value)
    end
})

local RaidsSection = Tabs.GameMode:AddSection("Raids")

local AutoleaveInput = RaidsSection:AddInput("AutoleaveInput", {
    Title = "Auto leave", Description = "Leave in wave",
    Default = "",
    Placeholder = "Enter wave...",
    Numeric = false,
    Finished = false,
    MaxLength = 50, Icon = "type",
    Callback = function(Value)
        print("Auto leave changed:", Value)
    end
})

local AutojoinToggle = RaidsSection:AddToggle("AutojoinToggle", {
    Title = "Auto join", Description = "Only auto join when is open raid",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Auto join changed:", Value)
    end
})

local AutoOpenToggle = RaidsSection:AddToggle("AutoOpenToggle", {
    Title = "Auto Open", Description = "Auto open + auto join raid",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Auto Open changed:", Value)
    end
})

local AutoFarmToggle = RaidsSection:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm", Description = "Auto farm npc in raid",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Auto Farm changed:", Value)
    end
})

-- Teleport Tab

local ElemSection = Tabs.Teleport:AddSection("")

ElemSection:AddParagraph({
    Title = "Teleport after farm",
    Content = "This is to get to the right place after farming trials, raids, bosses, etc.", Icon = "info"
})

local SelectmapDropdown = ElemSection:AddDropdown("SelectmapDropdown", {
    Title = "Select map",
    Values = { "XYZ Metropolis", "Ninja Village", "Forgotten Shore", "Slayer Forest" },
    Default = "",
    Multi = false,
    Search = true, Icon = "list",
    Callback = function(Value)
        print("Select map changed:", Value)
    end
})

ElemSection:AddButton({
    Title = "Save ubication", Icon = "pin",
    Callback = function()
        print("Save ubication clicked")
    end
})

ElemSection:AddButton({
    Title = "Tp in ubication", Icon = "map-pin",
    Callback = function()
        print("Tp in ubication clicked")
    end
})

local ActivateautotpToggle = ElemSection:AddToggle("ActivateautotpToggle", {
    Title = "Activate auto tp",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Activate auto tp changed:", Value)
    end
})

-- Others Tab

local AutoStarSection = Tabs.Others:AddSection("Auto Star", "star")

local SelectmapDropdown = AutoStarSection:AddDropdown("SelectmapDropdown", {
    Title = "Select map",
    Values = { "XYZ Metropolis", "Ninja Village", "Forgotten Shore", "Slayer Forest" },
    Default = "",
    Multi = false,
    Search = true, Icon = "list",
    Callback = function(Value)
        print("Select map changed:", Value)
    end
})

local AutostarToggle = AutoStarSection:AddToggle("AutostarToggle", {
    Title = "Auto star", Description = "You have to be close to the stars for this function",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Auto star changed:", Value)
    end
})

local AutoExpeditionSection = Tabs.Others:AddSection("Auto Expedition", "shield")

local SelectmapDropdown = AutoExpeditionSection:AddDropdown("SelectmapDropdown", {
    Title = "Select map",
    Values = { "XYZ Metropolis", "Ninja Village", "Forgotten Shore", "Slayer Forest" },
    Default = {},
    Multi = true,
    Search = true,
    AllowNull = false, Icon = "list",
    Callback = function(Value)
        print("Select map changed:", Value)
    end
})

local ActivateautoexpeditionToggle = AutoExpeditionSection:AddToggle("ActivateautoexpeditionToggle", {
    Title = "Activate auto expedition", Description = "Auto claim + auto send expedition",
    Default = false, Icon = "toggle-right",
    Callback = function(Value)
        print("Activate auto expedition changed:", Value)
    end
})

-- SaveManager & InterfaceManager Configuration
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentPlusSettings")
SaveManager:SetFolder("FluentPlusSettings/Configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

Fluent:Notify({
    Title = "Fluent Plus",
    Content = "Script Loaded Successfully",
    Duration = 5
})
