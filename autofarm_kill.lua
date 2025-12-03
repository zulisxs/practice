--  autofarm_kill.lua (VERSIÓN FINAL CON CAMBIO DE OBJETIVO)
--  Cargar con loadstring(game:HttpGet("URL"))

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

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
-- 2.  Obtener enemigo más cercano de una lista de nombres
--------------------------------------------------
local function getClosestEnemy(selectedNames, preferName)
	local enemiesFolder = workspace:FindFirstChild("Client") and workspace.Client:FindFirstChild("Enemies")
	if not enemiesFolder then return nil end

	local char = lp.Character
	if not char then return nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closest, dist = nil, math.huge

	for _, mdl in ipairs(enemiesFolder:GetChildren()) do
		if mdl:IsA("Model") and selectedNames[mdl.Name] then
			local hum = mdl:FindFirstChildOfClass("Humanoid")
			local root = mdl:FindFirstChild("HumanoidRootPart") or mdl:FindFirstChild("Torso") or mdl:FindFirstChild("Head")

			if hum and hum.Health > 0 and root then
				local d = (root.Position - hrp.Position).Magnitude

				-- Si hay un nombre preferido, priorízalo
				if preferName and mdl.Name == preferName and d < dist then
					dist = d
					closest = mdl
				elseif not preferName and d < dist then
					dist = d
					closest = mdl
				end
			end
		end
	end

	return closest
end

--------------------------------------------------
-- 3.  Chequear vida
--------------------------------------------------
local function isAlive(mdl)
	if not mdl or not mdl.Parent then return false end
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
-- 5.  Obtener enemigos seleccionados (dropdown)
--------------------------------------------------
local function getSelectedEnemies()
	if not Fluent or not Fluent.Options or not Fluent.Options.EnemiesDropdown then return nil end

	local raw = Fluent.Options.EnemiesDropdown.Value or {}
	local selected = {}

	if type(raw) == "table" then
		-- Diccionario o array
		for k, v in pairs(raw) do
			if type(k) == "string" and v == true then
				selected[k] = true
			elseif type(v) == "string" then
				selected[v] = true
			end
		end
	elseif type(raw) == "string" and raw ~= "" then
		selected[raw] = true
	end

	return selected
end

--------------------------------------------------
-- 6.  Loop de farmeo con cambio de objetivo
--------------------------------------------------
local farmingState = { active = false }

local function startFarm()
	if farmingState.active then return end
	farmingState.active = true

	local delaySec = 0
	if Fluent and Fluent.Options.TeleportdelaySecondsInput then
		delaySec = tonumber(Fluent.Options.TeleportdelaySecondsInput.Value) or 0
		delaySec = math.max(delaySec, 0.1)
	end

	local selectedNames = getSelectedEnemies()
	if not selectedNames then
		Fluent:Notify({Title = "Autofarm", Content = "No hay enemigos seleccionados", Duration = 3})
		farmingState.active = false
		return
	end

	Fluent:Notify({Title = "Autofarm", Content = "Iniciando farm...", Duration = 3})

	local lastName = nil -- para priorizar mismo tipo

	while farmingState.active do
		local target = getClosestEnemy(selectedNames, lastName)

		if target then
			lastName = target.Name -- guardamos tipo
			print("[Autofarm] Atacando:", target.Name)
			teleportTo(target)

			-- Esperar a que muera
			while farmingState.active and target.Parent and isAlive(target) do
				task.wait(0.5)
			end

			-- Delay entre kills
			if farmingState.active and delaySec > 0 then
				task.wait(delaySec)
			end
		else
			lastName = nil -- reset si no hay más del mismo tipo
			task.wait(1)
		end
	end
end

local function stopFarm()
	farmingState.active = false
	Fluent:Notify({Title = "Autofarm", Content = "Farm detenido", Duration = 3})
	print("[Autofarm] Farm detenido")
end

--------------------------------------------------
-- 7.  Monitoreo del toggle
--------------------------------------------------
task.wait(2)
task.spawn(function()
	while true do
		task.wait(0.5)
		if Fluent and Fluent.Options.AutofarmMainToggle then
			local v = Fluent.Options.AutofarmMainToggle.Value
			if v and not farmingState.active then
				task.spawn(startFarm)
			elseif not v and farmingState.active then
				stopFarm()
			end
		end
	end
end)

--------------------------------------------------
-- 8.  Export
--------------------------------------------------
return {
	searchEnemies = searchEnemies,
	startFarm = startFarm,
	stopFarm = stopFarm,
	getSelectedEnemies = getSelectedEnemies
}
