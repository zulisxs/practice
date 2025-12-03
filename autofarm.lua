-- autofarm.lua
-- Cargado desde raw.githubusercontent.com

local function searchEnemies()
    local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Client") and game:GetService("Workspace").Client:FindFirstChild("Enemies")
    local enemyList = {}

    if enemiesFolder then
        for _, enemyModel in ipairs(enemiesFolder:GetChildren()) do
            if enemyModel:IsA("Model") and enemyModel.Name ~= "" then
                table.insert(enemyList, enemyModel.Name)
            end
        end
    else
        warn("[searchEnemies] No se encontró 'workspace.client.enemies'")
    end

    return enemyList
end

-- Función para actualizar el dropdown de enemigos en la UI
local function updateEnemiesDropdown()
    local enemies = searchEnemies()

    -- Verificar si Fluent y el dropdown están disponibles
    if Fluent and Fluent.Options and Fluent.Options.EnemiesDropdown then
        Fluent.Options.EnemiesDropdown:SetValues(enemies)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Enemigos actualizados: " .. tostring(#enemies),
            Duration = 3
        })
    else
        warn("[updateEnemiesDropdown] No se encontró el dropdown 'EnemiesDropdown'")
    end
end

-- Conectar el botón Refresh de la UI
if Fluent and Fluent.Options and Fluent.Options.RefreshEnemiesButton then
    Fluent.Options.RefreshEnemiesButton:Callback(updateEnemiesDropdown)
else
    -- Si aún no está cargado, lo guardamos para cuando esté disponible
    getgenv().RefreshEnemiesCallback = updateEnemiesDropdown
end

-- Retornar la función para uso externo
return {
    searchEnemies = searchEnemies
}
