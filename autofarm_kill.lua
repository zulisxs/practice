--  autofarm_kill.lua (VERSIÓN FINAL CORREGIDA)
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
--------------------------------------------------
local function killEnemy(enemy, farming)
	local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("Head")
	if not root then return end

	local char = lp.Character
	if not char then return end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Calcular posición segura
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrpToFeet = (hrp.Size.Y / 2) + (humanoid.HipHeight or 2)
	local safeHeight = -2
	
	-- LOOP: Mantener posición hasta que muera
	while farming.active and isAlive(enemy) do
		-- Recalcular posición en cada frame
		root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("Head")
		if not root then break end
		
		local headPos = root.Position
		local targetPosition = headPos + Vector3.new(5, hrpToFeet + safeHeight, 5)
		
		-- ✅ TELEPORTARSE CONSTANTEMENTE
		hrp.CFrame = CFrame.new(targetPosition)
		
		task.wait(0.1)
	end
end

--------------------------------------------------
-- 5.  Obtener enemigos seleccionados (CORREGIDO)
--------------------------------------------------
local function getSelectedEnemies()
	local selectedNames = {}
	
	-- Verificar que Fluent y el dropdown existen
	if not Fluent then
		warn("❌ Fluent no está cargado")
		return nil
	end
	
	if not Fluent.Options then
		warn("❌ Fluent.Options no existe")
		return nil
	end
	
	if not Fluent.Options.EnemiesDropdown then
		warn("❌ Fluent.Options.EnemiesDropdown no existe")
		return nil
	end
	
	local raw = Fluent.Options.EnemiesDropdown.Value
	
	-- Debug: Mostrar qué recibimos
	print("[DEBUG] Tipo de Value:", type(raw))
	
	if raw == nil then
		warn("❌ Dropdown.Value es nil")
		return nil
	end
	
	-- Procesar según el tipo
	if type(raw) == "table" then
		-- CASO 1: Diccionario {["Goblin"] = true, ["Orc"] = true}
		-- Este es el formato más común con Multi = true
		local hasKeys = false
		for k, v in pairs(raw) do
			hasKeys = true
			if type(k) == "string" and v == true then
				selectedNames[k] = true
				print("[DEBUG] Añadido (diccionario):", k)
			end
		end
		
		-- CASO 2: Array {"Goblin", "Orc"}
		-- Por si acaso usa este formato
		if not hasKeys and #raw > 0 then
			for _, name in ipairs(raw) do
				if type(name) == "string" then
					selectedNames[name] = true
					print("[DEBUG] Añadido (array):", name)
				end
			end
		end
	elseif type(raw) == "string" then
		-- CASO 3: String simple (Multi = false)
		if raw ~= "" then
			selectedNames[raw] = true
			print("[DEBUG] Añadido (string):", raw)
		end
	end
	
	-- Verificar si encontramos algo
	local count = 0
	for _ in pairs(selectedNames) do
		count = count + 1
	end
	
	print("[DEBUG] Total de enemigos seleccionados:", count)
	
	if count == 0 then
		return nil
	end
	
	return selectedNames
end

--------------------------------------------------
-- 6.  Loop de farmeo (CORREGIDO)
--------------------------------------------------
local farmingState = { active = false }

local function startFarm()
	if farmingState.active then return end
	farmingState.active = true

	-- Obtener delay configurado
	local delaySec = 0
	if Fluent and Fluent.Options.TeleportdelaySecondsInput then
		delaySec = tonumber(Fluent.Options.TeleportdelaySecondsInput.Value) or 0
		delaySec = math.max(delaySec, 0.1)
	end

	-- ✅ OBTENER ENEMIGOS SELECCIONADOS (NUEVA FUNCIÓN)
	local selectedNames = getSelectedEnemies()
	
	if not selectedNames then
		Fluent:Notify({
			Title = "Autofarm", 
			Content = "No hay enemigos seleccionados", 
			Duration = 3
		})
		farmingState.active = false
		return
	end

	-- Mostrar enemigos objetivo
	local enemyList = {}
	for name, _ in pairs(selectedNames) do
		table.insert(enemyList, name)
	end
	
	print("[Autofarm] Enemigos objetivo:", table.concat(enemyList, ", "))
	
	Fluent:Notify({
		Title = "Autofarm", 
		Content = "Iniciando farm de " .. #enemyList .. " enemigos", 
		Duration = 3
	})

	-- LOOP PRINCIPAL
	while farmingState.active do
		local target = getClosestEnemy(selectedNames)
		
		if target then
			print("[Autofarm] Atacando:", target.Name)
			
			-- ✅ Mantiene posición
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
