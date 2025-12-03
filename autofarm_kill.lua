--  autofarm_kill.lua
--  Cargar con loadstring(game:HttpGet("URL"))

local Players = game:GetService("Players")
local lp      = Players.LocalPlayer

--------------------------------------------------
-- 1.  Buscar nombres únicos de enemigos
--------------------------------------------------
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

--------------------------------------------------
-- 2.  Obtener enemigo más cercano
--     silent = true  →  no imprime
--------------------------------------------------
local function getClosestEnemy(selectedNames, silent)
	local enemiesFolder = workspace:FindFirstChild("Client") and workspace.Client:FindFirstChild("Enemies")
	if not enemiesFolder then return nil end

	local closest, dist = nil, math.huge
	for _, mdl in ipairs(enemiesFolder:GetChildren()) do
		if mdl:IsA("Model") and selectedNames[mdl.Name] then
			local hum  = mdl:FindFirstChildOfClass("Humanoid")
			local root = mdl:FindFirstChild("HumanoidRootPart") or mdl:FindFirstChild("Torso") or mdl:FindFirstChild("Head")
			if hum and hum.Health > 0 and root then
				local d = (root.Position - lp.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
				if d < dist then dist, closest = d, mdl end
			end
		end
	end

	if not silent then
		print("[Autofarm] Enemigo más cercano:", closest and closest.Name or "ninguno")
	end
	return closest
end

--------------------------------------------------
-- 3.  Chequear vida
--------------------------------------------------
local function isAlive(mdl)
	local hum = mdl:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

--------------------------------------------------
-- 4.  Teleport
--------------------------------------------------
local function teleportTo(model)
	if not model then return end
	local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
	if root then
		lp.Character:WaitForChild("HumanoidRootPart").CFrame = root.CFrame + Vector3.new(0, 2, 0)
	end
end

--------------------------------------------------
-- 5.  Loop de farmeo
--------------------------------------------------
local farming = false

local function startFarm()
	if farming then return end
	farming = true

	local delaySec = 0
	if Fluent and Fluent.Options.TeleportdelaySecondsInput then
		delaySec = tonumber(Fluent.Options.TeleportdelaySecondsInput.Value) or 0
	end

	-- selectedNames → SET
	local selectedNames = {}
	if Fluent and Fluent.Options.EnemiesDropdown then
		local raw = Fluent.Options.EnemiesDropdown.Value or {}
		for _, name in pairs(raw) do selectedNames[name] = true end
	end
	if not next(selectedNames) then
		Fluent:Notify({Title = "Autofarm", Content = "No hay enemigos seleccionados", Duration = 3})
		farming = false; return
	end

	Fluent:Notify({Title = "Autofarm", Content = "Iniciando farm...", Duration = 3})

	local first = true           -- solo imprime la 1ª vuelta
	while farming do
		local target = getClosestEnemy(selectedNames, first)   -- silent = first
		if target then
			teleportTo(target)
			while farming and target.Parent and isAlive(target) do task.wait(0.5) end
			if farming and delaySec > 0 then task.wait(delaySec) end
		else
			task.wait(1)
		end
		first = false
	end
end

local function stopFarm()
	farming = false
	Fluent:Notify({Title = "Autofarm", Content = "Farm detenido", Duration = 3})
end

--------------------------------------------------
-- 6.  Monitoreo del toggle
--------------------------------------------------
task.wait(2)
task.spawn(function()
	while true do
		task.wait(0.5)
		if Fluent and Fluent.Options.AutofarmMainToggle then
			local v = Fluent.Options.AutofarmMainToggle.Value
			if v and not farming then
				startFarm()
			elseif not v and farming then
				stopFarm()
			end
		end
	end
end)

--------------------------------------------------
-- 7.  Export
--------------------------------------------------
return { searchEnemies = searchEnemies }
