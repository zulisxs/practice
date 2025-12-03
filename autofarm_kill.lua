--  autofarm_kill.lua (VERSIÓN CORREGIDA)
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
--------------------------------------------------
local function getClosestEnemy(selectedNames)
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
				if d < dist then 
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
-- 4.  Función de Kill (CORREGIDA)
--     Mantiene posición hasta que el enemigo muera
--------------------------------------------------
local function killEnemy(enemy, farming)
	local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("Head")
	if not root then return end

	local char = lp.Character
	if not char then return end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Calcular posición segura (igual que el script original)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrpToFeet = (hrp.Size.Y / 2) + (humanoid.HipHeight or 2)
	local safeHeight = -2
	
	-- LOOP: Mantener posición hasta que muera
	while farming.active and isAlive(enemy) do
		-- Recalcular posición en cada frame (por si el enemigo se mueve)
		root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("Head")
		if not root then break end
		
		local headPos = root.Position
		local targetPosition = headPos + Vector3.new(5, hrpToFeet + safeHeight, 5)
		
		-- ✅ TELEPORTARSE CONSTANTEMENTE
		hrp.CFrame = CFrame.new(targetPosition)
		
		task.wait(0.1)  -- Más frecuente para mejor seguimiento
	end
end

--------------------------------------------------
-- 5.  Loop de farmeo (CORREGIDO)
--------------------------------------------------
local farmingState = { active = false }

local function startFarm()
	if farmingState.active then return end
	farmingState.active = true

	-- Obtener delay configurado
	local delaySec = 0
	if Fluent and Fluent.Options.TeleportdelaySecondsInput then
		delaySec = tonumber(Fluent.Options.TeleportdelaySecondsInput.Value) or 0
		delaySec = math.max(delaySec, 0.1)  -- Mínimo 0.1s
	end

	-- Obtener enemigos seleccionados
	local selectedNames = {}
	if Fluent and Fluent.Options.EnemiesDropdown then
		local raw = Fluent.Options.EnemiesDropdown.Value or {}
		for _, name in pairs(raw) do 
			selectedNames[name] = true 
		end
	end
	
	if not next(selectedNames) then
		Fluent:Notify({
			Title = "Autofarm", 
			Content = "No hay enemigos seleccionados", 
			Duration = 3
		})
		farmingState.active = false
		return
	end

	Fluent:Notify({
		Title = "Autofarm", 
		Content = "Iniciando farm...", 
		Duration = 3
	})

	print("[Autofarm] Enemigos objetivo:", table.concat(selectedNames, ", "))

	-- LOOP PRINCIPAL
	while farmingState.active do
		local target = getClosestEnemy(selectedNames)
		
		if target then
			print("[Autofarm] Atacando:", target.Name)
			
			-- ✅ FUNCIÓN CORREGIDA: Mantiene posición
			killEnemy(target, farmingState)
			
			-- Delay entre kills
			if farmingState.active and delaySec > 0 then 
				task.wait(delaySec) 
			end
		else
			-- No hay enemigos, esperar
			task.wait(1)
		end
	end
end

local function stopFarm()
	farmingState.active = false
	Fluent:Notify({
		Title = "Autofarm", 
		Content = "Farm detenido", 
		Duration = 3
	})
	print("[Autofarm] Farm detenido por el usuario")
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
			if v and not farmingState.active then
				task.spawn(startFarm)
			elseif not v and farmingState.active then
				stopFarm()
			end
		end
	end
end)

--------------------------------------------------
-- 7.  Export
--------------------------------------------------
return { 
	searchEnemies = searchEnemies,
	startFarm = startFarm,
	stopFarm = stopFarm
}
