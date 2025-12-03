--  autofarm.lua
--  Script completo – cárgalo con loadstring(game:HttpGet("URL"))

local function searchEnemies()
    local enemiesFolder = game:GetService("Workspace"):FindFirstChild("Client") and game:GetService("Workspace").Client:FindFirstChild("Enemies")
    local enemySet  = {}
    local enemyList = {}

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
        Fluent.Options.EnemiesDropdown:Clear()          -- limpia valores anteriores
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

-- conecta el botón Refresh de la UI (si ya existe)
if Fluent and Fluent.Options and Fluent.Options.RefreshEnemiesButton then
    Fluent.Options.RefreshEnemiesButton:Callback(updateEnemiesDropdown)
end

-- expone la función para otros scripts
return {
    searchEnemies = searchEnemies
}
