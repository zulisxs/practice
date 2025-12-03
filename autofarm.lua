-- https://raw.githubusercontent.com/zulisxs/practice/refs/heads/main/autofarm.lua
-- Lógica exclusiva de la pestaña "Farm"

local Options = Fluent.Options  -- tabla global creada por la UI

--------------------------------------------------------
-- 1) Función reutilizable: devuelve array con los nombres
--    de los modelos dentro de workspace.client.enemies
--------------------------------------------------------
local function searchEnemies()
    local list = {}
    local folder = game:GetService("Workspace"):FindFirstChild("client")
    if folder then
        local enemies = folder:FindFirstChild("enemies")
        if enemies then
            for _, model in ipairs(enemies:GetChildren()) do
                if model:IsA("Model") then
                    table.insert(list, model.Name)
                end
            end
        end
    end
    return list
end

--------------------------------------------------------
-- 2) Llenar el dropdown con la lista obtenida
--------------------------------------------------------
local function refreshDropdown()
    local enemiesArray = searchEnemies()
    if #enemiesArray == 0 then
        enemiesArray = {"(No enemies found)"}
    end

    -- Actualizar valores y forzar valor por defecto
    Options.FarmMenu.Values = enemiesArray
    Options.FarmMenu:SetValue(enemiesArray[1])

    print("[AUTOFARM] Enemies recargados:", #enemiesArray)
end

--------------------------------------------------------
-- 3) Conectar botón "Recargar menú"
--------------------------------------------------------
Options.ReloadMenu:OnClick(refreshDropdown)

--------------------------------------------------------
-- 4) Auto-llenado al cargar el script
--------------------------------------------------------
refreshDropdown()
