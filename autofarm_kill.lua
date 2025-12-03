-- autofarm_kill.lua
-- Cargar con loadstring(game:HttpGet("URL"))

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function searchEnemies()
    local enemiesFolder = workspace:FindFirstChild("Client") and workspace.Client:FindFirstChild("Enemies")
    local enemySet, enemyList = {}, {}
    if enemiesFolder then
        for _, mdl in ipairs(enemiesFolder:GetChildren()) do
            if mdl:IsA("Model") and mdl.Name ~= "" and not enemySet[mdl.Name] then
                enemySet[mdl.Name] = true
                table.insert(enemyList, mdl.Name)
            end
        end
    end
    return enemyList
end

local function getClosestEnemy(selectedNames)
    local enemiesFolder = workspace:FindFirstChild("Client") and workspace.Client:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    local closest = nil
    local dist = math.huge
    for _, mdl in ipairs(enemiesFolder:GetChildren()) do
        if mdl:IsA("Model") and selectedNames[mdl.Name] then
            local hum = mdl:FindFirstChildOfClass("Humanoid")
            local root = mdl:FindFirstChild("HumanoidRootPart") or mdl:FindFirstChild("Torso") or mdl:FindFirstChild("Head")
            if hum and hum.Health > 0 and root then
                local d = (root.Position - lp.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
                if d < dist then
                    dist = d
                    closest = mdl
                end
            end
        end
    end
    return closest
end

local function isAlive(mdl)
    local hum = mdl:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function teleportTo(model)
    if not model then return end
    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
    if root then
        lp.Character:WaitForChild("HumanoidRootPart").CFrame = root.CFrame + Vector3.new(0, 2, 0)
    end
end

local farming = false
local function startFarm()
    if farming then return end
    farming = true

    -- leemos delay del input
    local delaySec = 0
    if Fluent and Fluent.Options.TeleportdelaySecondsInput then
        local txt = Fluent.Options.TeleportdelaySecondsInput.Value or "0"
        delaySec = tonumber(txt) or 0
    end

    -- leemos nombres seleccionados
    local selected = {}
    if Fluent and Fluent.Options.EnemiesDropdown then
        selected = Fluent.Options.EnemiesDropdown.Value or {}
    end
    if #selected == 0 then
        Fluent:Notify({Title = "Autofarm", Content = "No hay enemigos seleccionados", Duration = 3})
        farming = false
        return
    end

    Fluent:Notify({Title = "Autofarm", Content = "Iniciando farm...", Duration = 3})

    while farming do
        local target = getClosestEnemy(selected)
        if target then
            teleportTo(target)
            -- esperamos a que muera
            while farming and target.Parent and isAlive(target) do
                task.wait(0.5)
            end
            -- delay entre kills
            if farming and delaySec > 0 then
                task.wait(delaySec)
            end
        else
            task.wait(1)
        end
    end
end

local function stopFarm()
    farming = false
    Fluent:Notify({Title = "Autofarm", Content = "Farm detenido", Duration = 3})
end

-- conectamos el toggle de Autofarm
task.wait(1)
if Fluent and Fluent.Options.AutofarmToggle then
    Fluent.Options.AutofarmToggle:Callback(function(v)
        if v then
            startFarm()
        else
            stopFarm()
        end
    end)
end

return {
    searchEnemies = searchEnemies
}
