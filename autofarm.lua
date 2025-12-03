-- https://raw.githubusercontent.com/zulisxs/practice/refs/heads/main/autofarm.lua
-- Lógica de la pestaña "Farm"

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
-- 2) Llenar / refrescar dropdown
--------------------------------------------------------
local function refreshEnemies()
    local real = searchEnemies()
    if #real == 0 then
        real = { "(No enemies found)" }
    end

    -- Actualizar valores y seleccionar el primero
    Options.EnemiesDropdown.Values = real
    Options.EnemiesDropdown:SetValue({ real[1] }) -- multi-dropdown → tabla

    print("[AUTOFARM] Enemies recargados:", #real)
end

--------------------------------------------------------
-- 3) Conectar botón REFRESH  (ID = RefreshBtn)
--------------------------------------------------------
Options.RefreshBtn:OnClick(refreshEnemies)

--------------------------------------------------------
-- 4) Auto-llenado al cargar el script
--------------------------------------------------------
refreshEnemies()

--------------------------------------------------------
-- 5) Escuchar cambios del toggle Autofarm
--------------------------------------------------------
Options.AutofarmToggle:OnChanged(function()
    local activo = Options.AutofarmToggle.Value
    print("[AUTOFARM] Toggle:", activo)
    -- Aquí irá el loop / detención del farm
end)
