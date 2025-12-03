-- autofarm.lua (completo)
local function searchEnemies()
    local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Client") and game:GetService("Workspace").Client:FindFirstChild("Enemies")
    local enemySet, enemyList = {}, {}
    if enemiesFolder then
        for _, mdl in ipairs(enemiesFolder:GetChildren()) do
            if mdl:IsA("Model") and mdl.Name ~= "" and not enemySet[mdl.Name] then
                enemySet[mdl.Name] = true
                table.insert(enemyList, mdl.Name)
            end
        end
    else
        warn("[searchEnemies] No se encontró 'Workspace.Client.Enemies'")
    end
    return enemyList
end

local function updateEnemiesDropdown()
    local enemies = searchEnemies()
    if Fluent and Fluent.Options and Fluent.Options.EnemiesDropdown then
-- limpiar sobrescribiendo con tabla vacía
Fluent.Options.EnemiesDropdown:SetValues({})
-- cargar nuevos valores
Fluent.Options.EnemiesDropdown:SetValues(enemies)
        Fluent:Notify({
            Title   = "Autofarm",
            Content = "Enemigos actualizados: " .. tostring(#enemies),
            Duration = 3
        })
    else
        warn("[updateEnemiesDropdown] Dropdown no encontrado")
    end
end

-- exponemos la función globalmente
getgenv().RefreshEnemiesDropdown = updateEnemiesDropdown

return { searchEnemies = searchEnemies }
