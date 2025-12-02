-- Ventana principal
local Window = Fluent:CreateWindow({
    Title = "My Script UI",
    SubTitle = "Solo UI (sin lógica aún)",
    TitleIcon = "home",
    Image = "rbxassetid://10723407389",
    Size = UDim2.fromOffset(700, 550),
    TabWidth = 180,
    Acrylic = true,
    Theme = "Dark",
    Search = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = false
})

-- Pestañas
local Tabs = {
    About = Window:AddTab({ Title = "About", Icon = "info" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "picker" }),
    Bosses = Window:AddTab({ Title = "Bosses", Icon = "swords" }),
    GameMode = Window:AddTab({ Title = "Game mode", Icon = "gamepad-2" })
}

-- Opciones centralizadas (para usar luego)
local Options = Fluent.Options

-- ========== TAB: ABOUT ==========
local AboutSection = Tabs.About:AddSection("About / Info")
local AboutParagraph = AboutSection:AddParagraph({
    Title = "Información del script",
    Content = "Aquí mostrarás la info del script, cambios y arreglos.\n(Edita este texto luego).",
    Icon = "info",
    Visible = true
})

-- ========== TAB: FARM ==========
local FarmSection = Tabs.Farm:AddSection("Farm Controls")

-- Dropdown del menú (placeholder de opciones)
local FarmMenu = FarmSection:AddDropdown("FarmMenu", {
    Title = "Farm Menu",
    Description = "Selecciona una opción (placeholder).",
    Values = { "Option 1", "Option 2", "Option 3" },
    Default = "Option 1",
    Multi = false,
    Search = true,
    KeepSearch = false,
    Icon = "list",
    Visible = true,
    Callback = function(Value)
        print("FarmMenu seleccionado:", Value)
    end
})

-- Botón para recargar el menú
local FarmReloadButton = FarmSection:AddButton({
    Title = "Recargar menú",
    Description = "Vuelve a cargar las opciones del menú.",
    Icon = "refresh-ccw",
    Visible = true,
    Callback = function()
        print("Recargando menú Farm...")
        -- Aquí luego actualizas FarmMenu:SetValue(...) o su lista de Values
    end
})

-- Switch activar/desactivar función de Farm
local FarmToggle = FarmSection:AddToggle("FarmToggle", {
    Title = "Activar Farm",
    Description = "Activa o desactiva la función de farm.",
    Default = false,
    Icon = "toggle-right",
    Visible = true,
    Callback = function(Value)
        print("Farm activado:", Value)
    end
})

-- ========== TAB: BOSSES ==========
local BossSection = Tabs.Bosses:AddSection("Bosses (8 toggles)")

-- 8 toggles: Boss 1 ... Boss 8
for i = 1, 8 do
    BossSection:AddToggle(("Boss%02dToggle"):format(i), {
        Title = ("Boss %d"):format(i),
        Description = "Activar/Desactivar objetivo",
        Default = false,
        Icon = "skull",
        Visible = true,
        Callback = function(Value)
            print(("Boss %d -> %s"):format(i, tostring(Value)))
        end
    })
end

-- ========== TAB: GAME MODE ==========
local GMSection = Tabs.GameMode:AddSection("Game Mode Settings")

-- Menú de modos (por ahora solo 'Trial Easy')
local GameModeDropdown = GMSection:AddDropdown("GameMode", {
    Title = "Game Mode",
    Description = "Selecciona el modo de juego",
    Values = { "Trial Easy" },
    Default = "Trial Easy",
    Multi = false,
    Search = false,
    Icon = "flag",
    Visible = true,
    Callback = function(Value)
        print("GameMode seleccionado:", Value)
    end
})

-- Switch: Activate
local GMActivate = GMSection:AddToggle("GMActivate", {
    Title = "Activate",
    Description = "Activa el modo seleccionado",
    Default = false,
    Icon = "play",
    Visible = true,
    Callback = function(Value)
        print("GameMode Activate:", Value)
    end
})

-- Switch: Autoleave
local GMAutoleave = GMSection:AddToggle("GMAutoleave", {
    Title = "Autoleave",
    Description = "Salir automáticamente según la regla configurada",
    Default = false,
    Icon = "log-out",
    Visible = true,
    Callback = function(Value)
        print("GameMode Autoleave:", Value)
    end
})

-- Campo numérico: Auto leave in room
local GMAutoleaveRoom = GMSection:AddInput("GMAutoleaveRoom", {
    Title = "Auto leave in room",
    Description = "Ingresa el número de sala para autoleave",
    Default = "0",
    Placeholder = "0",
    Numeric = true,
    Finished = true,  -- dispara callback al presionar Enter
    MaxLength = 5,
    Icon = "hash",
    Visible = true,
    Callback = function(Value)
        local num = tonumber(Value)
        print("Auto leave in room:", num)
    end
})

-- TIP: Puedes leer/ajustar valores desde Fluent.Options más adelante, por ejemplo:
-- print(Options.FarmToggle.Value)
-- Options.GMActivate:SetValue(true)
