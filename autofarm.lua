-- https://raw.githubusercontent.com/zulisxs/practice/refs/heads/main/autofarm.lua
-- LÓGICA PESTAÑA "FARM"

local Options = Fluent.Options   -- expuesto por la UI

--------------------------------------------------------
-- 1)  Función reutilizable
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
-- 2)  Llenar dropdown
--------------------------------------------------------
local function refreshEnemies()
    local names = searchEnemies()
    if #names == 0 then names = { "(No enemies found)" } end

    Options.EnemiesDropdown.Values = names
    Options.EnemiesDropdown:SetValue({ names[1] })   -- multi-dropdown → tabla
    print("[AUTOFARM] Enemies recargados:", #names)
end

--------------------------------------------------------
-- 3)  Conectar botón REFRESH
--------------------------------------------------------
Options.RefreshBtn:OnClick(refreshEnemies)

--------------------------------------------------------
-- 4)  Auto-llenado al iniciar
--------------------------------------------------------
refreshEnemies()

--------------------------------------------------------
-- 5)  Escuchar toggle de farm
--------------------------------------------------------
Options.AutofarmToggle:OnChanged(function()
    local activo = Options.AutofarmToggle.Value
    print("[AUTOFARM] Toggle:", activo)
    -- Aquí irá el loop / detención del farm
end)
