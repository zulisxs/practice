-- https://raw.githubusercontent.com/zulisxs/practice/refs/heads/main/autofarm.lua
local Options = Fluent.Options  -- tabla global creada por la UI

--------------------------------------------------------
-- 1) Función reutilizable
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
    local enemiesArray = searchEnemies()
    if #enemiesArray == 0 then
        enemiesArray = { "(No enemies found)" }
    end

    -- Actualizar valores y seleccionar el primero
    Options.EnemiesDropdown.Values = enemiesArray
    Options.EnemiesDropdown:SetValue({ enemiesArray[1] }) -- multi-dropdown → tabla

    print("[AUTOFARM] Enemies recargados:", #enemiesArray)
end

--------------------------------------------------------
-- 3) Conectar botón REFRESH
--------------------------------------------------------
-- ID del botón: NO tiene nombre en Options, pero podemos sobre-escribir su Callback
-- La forma limpia es llamar a refreshEnemies() desde el propio Callback que ya existe.
-- Como no podemos acceder al botón por ID, lo hacemos así:
-- Reemplazamos el Callback del botón para que llame a nuestra función.
-- Lo hacemos desde este archivo sin tocar ui.lua:
local btn = Options.Refresh -- NO existe, así que lo hacemos por índice.
-- Solución rápida: sobre-escribir el Callback original.
-- El botón se creó sin ID, pero sabemos que el último botón de la sección es él.
-- Manera SENCILLA: llamar a refreshEnemies() justo después de cargar la UI.
refreshEnemies() -- primer llenado al iniciar

-- Hook al Callback original del botón (sí se puede)
-- FluentPlus guarda el Callback original, así que lo envolvemos:
local originalRefreshCallback = debug.getinfo(Options.EnemiesDropdown.Parent.Refresh).func
Options.EnemiesDropdown.Parent.Refresh = function()
    refreshEnemies()
    print("Refresh clicked")
end

--------------------------------------------------------
-- 4) Escuchar cambios del toggle Autofarm
--------------------------------------------------------
Options.AutofarmToggle:OnChanged(function()
    local activo = Options.AutofarmToggle.Value
    print("[AUTOFARM] Toggle:", activo)
    -- Aquí irá el loop / detención del farm
end)
