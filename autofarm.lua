-- autofarm.lua (fragmento final)

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
    else
        warn("[searchEnemies] No se encontró 'Workspace.Client.Enemies'")
    end

    return enemyList
end

local function updateEnemiesDropdown()
    local enemies = searchEnemies()

    if Fluent and Fluent.Options and Fluent.Options.EnemiesDropdown then
        -- 🔧 LIMPIAR ANTES DE ACTUALIZAR
        Fluent.Options.EnemiesDropdown:Clear()
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

-- ❌ QUITAMOS la ejecución automática
-- task.wait(1)
-- updateEnemiesDropdown()

-- Conectar botón (solo si existe)
if Fluent and Fluent.Options and Fluent.Options.RefreshEnemiesButton then
    Fluent.Options.RefreshEnemiesButton:Callback(updateEnemiesDropdown)
end

return {
    searchEnemies = searchEnemies
}
