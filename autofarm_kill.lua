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
-- 2.  Obtener enemigo más cercano de los seleccionados
--------------------------------------------------
local function getClosestEnemy(selectedNames)
	local enemiesFolder = workspace:FindFirstChild("Client") and workspace.Client:FindFirstChild("Enemies")
	if not enemiesFolder then
		warn("[Autofarm] Carpeta Enemies no existe")
		return nil
	end
	--  IMPRESIÓN de modelos que hay ahora
	for _, mdl in ipairs(enemiesFolder:GetChildren()) do
		print("[Autofarm] Modelo encontrado:", mdl.Name, "| Clase:", mdl.ClassName)
	end

	local closest, dist = nil, math.huge
	for _, mdl in ipairs(enemiesFolder:GetChildren()) do
		if mdl:IsA("Model") and selectedNames[mdl.Name] then        -- selectedNames es un SET
			local hum  = mdl:FindFirstChildOfClass("Humanoid")
			local root = mdl:FindFirstChild("HumanoidRootPart") or mdl:FindFirstChild("Torso") or mdl:FindFirstChild("Head")
			--  IMPRESIÓN de por qué descarta
			print("[Autofarm]  - ", mdl.Name, "Hum:", hum and "Sí" or "No", "Root:", root and "Sí" or "No", "HP:", hum and hum.Health or "N/A")
			if hum and hum.Health > 0 and root then
				local d = (root.Position - lp.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
				if d < dist then
					dist, closest = d, mdl
				end
			end
		end
	end
	print("[Autofarm] Enemigo más cercano:", closest and closest.Name or "ninguno")
	return closest
end

--------------------------------------------------
-- 3.  Chequear si un modelo sigue vivo
--------------------------------------------------
local function isAlive(mdl)
	local hum = mdl:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

--------------------------------------------------
-- 4.  Teleportarse a un modelo
--------------------------------------------------
local function teleportTo(model)
	if not model then return end
	local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
	if root then
		lp.Character:WaitForChild("HumanoidRootPart").CFrame = root.CFrame + Vector3.new(0, 2, 0)
	end
end

--------------------------------------------------
-- 5.  Loop principal de farmeo
--------------------------------------------------
local farming = false

local function startFarm()
	if farming then return end
	farming = true

	-- delay del input
	local delaySec = 0
	if Fluent and Fluent.Options.TeleportdelaySecondsInput then
		delaySec = tonumber(Fluent.Options.TeleportdelaySecondsInput.Value) or 0
	end

	-- nombres seleccionados (dropdown Multi → SET)
	local selected = {}
	if Fluent and Fluent.Options.EnemiesDropdown then
		local raw = Fluent.Options.EnemiesDropdown.Value or {}
		print("[Autofarm] Dropdown raw:", raw)
		for _, name in pairs(raw) do selected[name] = true end
	end
	print("[Autofarm] selected (set):", selected)
	if not next(selected) then
		Fluent:Notify({Title = "Autofarm", Content = "No hay enemigos seleccionados", Duration = 3})
		farming = false
		return
	end

	Fluent:Notify({Title = "Autofarm", Content = "Iniciando farm...", Duration = 3})

	while farming do
		local target = getClosestEnemy(selected)
		if target then
			teleportTo(target)
			-- esperar muerte
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

--------------------------------------------------
-- 6.  Monitoreo del toggle
--------------------------------------------------
task.wait(2)
print("[Autofarm] Monitoreando AutofarmMainToggle...")
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
-- 7.  Export para otros scripts
--------------------------------------------------
return { searchEnemies = searchEnemies }
