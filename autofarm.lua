-- autofarm.lua
local function searchEnemies()
    local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Client") and game:GetService("Workspace").Client:FindFirstChild("Enemies")
local enemySet = {}
local enemyList = {}

if enemiesFolder then
    for _, enemyModel in ipairs(enemiesFolder:GetChildren()) do
        if enemyModel:IsA("Model") and enemyModel.Name ~= "" and not enemySet[enemyModel.Name] then
            enemySet[enemyModel.Name] = true
            table.insert(enemyList, enemyModel.Name)
        end
    end
end
        warn("[searchEnemies] No se encontró 'Workspace.Client.Enemies'")
    end

    return enemyList
end

-- Función para actualizar el dropdown
local function updateEnemiesDropdown()
    local enemies = searchEnemies()

    if Fluent and Fluent.Options and Fluent.Options.EnemiesDropdown then
        Fluent.Options.EnemiesDropdown:SetValues(enemies)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Enemigos actualizados: " .. tostring(#enemies),
            Duration = 3
        })
    else
        warn("[updateEnemiesDropdown] Dropdown no encontrado")
    end
end

-- Exponemos la función globalmente para que el botón la pueda llamar
getgenv().RefreshEnemies = updateEnemiesDropdown

return {
    searchEnemies = searchEnemies
}
