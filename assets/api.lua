--[[
    Feel free to use any part of this code for any of your  work
    Just please credit me if you do
    Also ignore the fact that it's messy as hell
--]]

-- [[ Checking if script is already running ]] --
if FOHAPI then return warn('Field of Heaven has already been initialised.') end

-- [[ Services ]] --
local Players = game:GetService('Players')
local Teams = game:GetService('Teams')
local HttpService = game:GetService('HttpService')
local RunService = game:GetService('RunService')
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Lighting = game:GetService('Lighting')
local StarterGui = game:GetService('StarterGui')

-- [[ Variables ]] --
local Path = PathfindingService:CreatePath()
local LocalPlayer = Players.LocalPlayer
local PlayerStats = LocalPlayer.leaderstats
local Camera = workspace.CurrentCamera
local Time = os.time()
local NPCs = workspace['Unbreakable']['Characters']
local Projectiles = workspace['Unbreakable']['Projectiles']
local ChatRemote = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local GemResponses = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Amiriki/Heaven/main/assets/gemresponses.json"))
local ValuableGems = {[32] = true, [33] = true, [34] = true, [35] = true, [36] = true, [42] = true}

-- [[ Config Script ]] --
getgenv().FOHAPI = {}
FOHAPI.Configuration = {
    ['AutofarmEnabled'] = false,
    ['GeneralWeapon'] = "",
    ['NPCWeapon'] = "",
    ['AutofarmMap'] = "Savannah",
    ['WebhookEnabled'] = false,
    ['WebhookURL'] = "",
    ['DisableOnJoin'] = true,
    ['EnableOnLeave'] = true,
    ['IgnorePlayers'] = false,
    ['AutoMapvoteRogue'] = true,
    ['GemESPEnabled'] = true,
    ['GemESPColour'] = Color3.fromRGB(255, 255, 255),
    ['GemTracersEnabled'] = true,
    ['GemTracersColour'] = Color3.fromRGB(255, 255, 255),
    ['RedDiamondESPEnabled'] = true,
    ['RedDiamondESPColour'] = Color3.fromRGB(255, 0, 0),
    ['RedDiamondTracersEnabled'] = true,
    ['RedDiamondTracersColour'] = Color3.fromRGB(255, 00, 0),
    ['PathfindToGem'] = true,
    ['Walkspeed'] = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').WalkSpeed,
    ['Jumppower'] = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').JumpPower,
    ['Fullbright'] = true,
    ['DisableDecoration'] = true,
}

-- [[ Autofarm Variables ]] --
local PlayerThumbnail = game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar?userIds="..LocalPlayer.UserId.."&size=420x420&format=Png&isCircular=false")
local FailsafeTripped = false
local Stats = LocalPlayer.leaderstats
local Gold = Stats.Gold.Value
local XP = Stats.XP.Value
local GoldEarned = 0
local ExperienceEarned = 0
local HourlyGold = 0
local HourlyExperience = 0
local TimeElapsed = 0

-- [[ Functions ]] --
function NotifyChat(message, colour)
	StarterGui:SetCore("ChatMakeSystemMessage", {Text = "[Field of Heaven] "..message, Color = colour, Font = Enum.Font.SourceSansBold, TextSize = 16})
end

function ObtainTargets()
	local TargetsList
    local EnemyTeam
    local Index
	local General

	if LocalPlayer.Team == Teams:FindFirstChild('Neutral') then return {} end
	if LocalPlayer.Team == Teams:FindFirstChild('Orc') then EnemyTeam = 'Human' end
	if LocalPlayer.Team == Teams:FindFirstChild('Human') then EnemyTeam = 'Orc' end

	TargetsList = NPCs[EnemyTeam]:GetChildren()

	for i, npc in pairs(TargetsList) do
		if npc.Name:find('General')  then
			Index = i
			General = npc
		end
	end

    if FOHAPI.Configuration.IgnorePlayers then
        for i, player in pairs(Players:GetPlayers()) do
            if table.find(TargetsList, player.Name) then
                TargetsList[i] = nil
            end
        end
    end

	TargetsList[Index] = nil
	table.insert(TargetsList, #TargetsList, General)

	return TargetsList
end

function SendWebhook()

end

function Attack(target, weapon)
    if not target or not weapon then return end
	if LocalPlayer.Backpack:FindFirstChild(weapon) then LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(weapon)) end

	repeat
		if not target:FindFirstChild('Torso') or FailsafeTripped then return end
		LocalPlayer.Character:FindFirstChild(weapon):Activate()
		LocalPlayer.Character.HumanoidRootPart.CFrame = target.Torso.CFrame * CFrame.new(0,0,3)
		task.wait(0.125)
	until not target or not target:FindFirstChild('Humanoid') or target:FindFirstChild('Humanoid').Health == 0
end

function DrawTracer(Object, Thickness, Colour, Enabled) 
    local ObjectParent = Object.Parent
    local Tracer = Drawing.new("Line")
    Tracer.Thickness = Thickness
    Tracer.Transparency = 0.5
    Tracer.Color = (FOHAPI.Configuration[Colour] or Colour)

    local Connection = RunService.RenderStepped:Connect(function()
        if FOHAPI.Configuration[Enabled] then
            local Pos, OnScreen = Camera:WorldToViewportPoint(Object.Position)
            if OnScreen then 
                Tracer.Color = (FOHAPI.Configuration[Colour] or Colour)
                Tracer.Visible = true
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                Tracer.To = Vector2.new(Pos.X, Pos.Y)
            else
                Tracer.Visible = false
            end
        else
            Tracer.Visible = false
        end
    end)

    Object:GetPropertyChangedSignal('Parent'):Connect(function() 
        if Object.Parent ~= ObjectParent then
            Connection:Disconnect()
            Tracer:Remove()
        end
    end)
end

function DrawGemESP(Object, Colour, Enabled) 
    local Box = Instance.new("BoxHandleAdornment", Object)
    Box.Size = Object.Size + Vector3.new(0.1, 0.1, 0.1)
    Box.Adornee = Object
    Box.Color3 = FOHAPI.Configuration[Colour]
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Transparency = 0

    local Connection = RunService.RenderStepped:Connect(function()
        if FOHAPI.Configuration[Enabled] then
            Box.Color3 = FOHAPI.Configuration[Colour]
            Box.Visible = true
        else
            Box.Visible = false
        end
    end)

    Object:GetPropertyChangedSignal('Parent'):Connect(function()
        if Object.Parent ~= Projectiles then
            Connection:Disconnect()
        end
    end)
end

function PathfindToObject(Object, Character) 
	if not Object or not Character then return error('Missing object or character') end
    local Waypoints
    repeat task.wait()
		Path:ComputeAsync(Character.PrimaryPart.Position, Object.Position)
	until Path.Status == Enum.PathStatus.Success

	if Path.Status == Enum.PathStatus.Success then
		NotifyChat("Path has successfully been computed!", Color3.fromRGB(69, 215, 69))
		Waypoints = Path:GetWaypoints()

		for i, v in pairs(Waypoints) do
			if Object.Parent ~= Projectiles then return end
			NotifyChat("Moving to waypoint #"..tostring(i).."!", Color3.fromRGB(69, 69, 215))
			Character.Humanoid:MoveTo(v.Position)
			if v.Action == Enum.PathWaypointAction.Jump then Character.Humanoid.Jump = true end
			Character.Humanoid.MoveToFinished:Wait()
		end

		if Object.Parent == Projectiles then
			Character.Humanoid:MoveTo(Object.Position)
		end
	end
end

-- [[ Events ]] --

LocalPlayer.CharacterAdded:Connect(function()
    if FOHAPI.Configuration.AutofarmEnabled then
        local CurrentWeapon
        local Enemies = ObtainTargets()
        for index, npc in pairs(Enemies) do
            if not FOHAPI.Configuration.AutofarmEnabled or FailsafeTripped then return print'autofarm is disabled or failsafe is tripped' end
            if Teams:FindFirstChild('Neutral') and LocalPlayer.Team == Teams:FindFirstChild('Neutral') then return end

            if npc.Name:find('General') then CurrentWeapon = FOHAPI.Configuration.GeneralWeapon else CurrentWeapon = FOHAPI.Configuration.NPCWeapon end 
	        repeat task.wait() until LocalPlayer.Backpack:FindFirstChild(CurrentWeapon) or LocalPlayer.Character:FindFirstChild(CurrentWeapon)
			Attack(npc, CurrentWeapon)
            Enemies[index] = nil
        end
    end
end)

Players.PlayerAdded:Connect(function(Player)
    -- [[ Autofarm Failsafe ]] --
    if FOHAPI.Configuration.DisableOnJoin and FOHAPI.Configuration.AutofarmEnabled and not FailsafeTripped then
	    FailsafeTripped = true
	    LocalPlayer.Character:BreakJoints()
    end
end)

Players.PlayerRemoving:Connect(function()
    -- [[ Autofarm Failsafe ]] --
    if FOHAPI.Configuration.EnableOnLeave and FOHAPI.Configuration.AutofarmEnabled and FailsafeTripped then
	    if #Players:GetPlayers() == 1 then
		    FailsafeTripped = false
		    LocalPlayer.Character:BreakJoints()
	    end
    end
end)

RunService.RenderStepped:Connect(function()
    -- [[ Fullbright code (skidded from IY but whatever) ]] --
    if FOHAPI.Configuration.Fullbright then 
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end

    (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').WalkSpeed = FOHAPI.Configuration.Walkspeed;
    LocalPlayer.Character:WaitForChild('Humanoid').JumpPower = FOHAPI.Configuration.Jumppower;
    LocalPlayer.Character:WaitForChild('Humanoid').UseJumpPower = true;
end)

Projectiles.ChildAdded:Connect(function(obj)
	if FOHAPI.Configuration.GemTracersEnabled or FOHAPI.Configuration.GemESPEnabled or FOHAPI.Configuration.RedDiamondESPEnabled or FOHAPI.Configuration.PathfindToGem then
		local GemType = obj:WaitForChild('GemType', 5)
        if GemType then
            local GemNum = GemType.Value
                -- [[ Red Diamond Visuals ]] --
            if FOHAPI.Configuration.RedDiamondESPEnabled or FOHAPI.Configuration.RedDiamondTracersEnabled then
                if GemNum == 10 then
                    if FOHAPI.Configuration.RedDiamondESPEnabled then
                        DrawGemESP(obj, "RedDiamondESPColour", "RedDiamondESPEnabled")
                    end

                    if FOHAPI.Configuration.RedDiamondTracersEnabled then
                        DrawTracer(obj, 2, "RedDiamondTracersColour", "RedDiamondTracersEnabled")
                    end
                end
            end
		    if ValuableGems[GemNum] then
                NotifyChat("Legendary Gem Dropped, GemType is "..tostring(GemNum), obj:FindFirstChild('GemGlow').Color)

			    if FOHAPI.Configuration.GemTracersEnabled then
				    DrawTracer(obj, 2, "GemTracersColour", "GemTracersEnabled")
			    end

                if FOHAPI.Configuration.GemESPEnabled then
				    DrawGemESP(obj, "GemESPColour", "GemESPEnabled")
			    end
			    if FOHAPI.Configuration.PathfindToGem then
				    --task.wait(1)
				    PathfindToObject(obj, LocalPlayer.Character)
			    end
            end
		end  
	end
end)

NPCs.DescendantAdded:Connect(function(obj)
    if obj.Name:find('General') then 
        local Humanoid = obj:WaitForChild('Humanoid', 3)
        if Humanoid then
            obj:WaitForChild('Humanoid').Died:Connect(function()
                if FOHAPI.Configuration.AutofarmEnabled then
                    Players:Chat(':mapvote '..(FOHAPI.Configuration.Map or 'Savannah'))
                    if FOHAPI.Configuration.WebhookEnabled then 
                        SendWebhook() 
                    end
                end
                
                if FOHAPI.Configuration.AutoMapvoteRogue and not FOHAPI.Configuration.AutofarmEnabled then
                    Players:Chat(':mapvote rogue')
                end
            end)
        end
    end
end)

spawn(function()
	while task.wait(1) do
		if FOHAPI.Configuration.AutofarmEnabled and not FailsafeTripped then 
		    GoldEarned = Stats.Gold.Value - Gold
		    ExperienceEarned = Stats.XP.Value - XP
		    TimeElapsed = TimeElapsed + 1
		    HourlyGold = (GoldEarned / TimeElapsed) * 3600
		    HourlyExperience = (ExperienceEarned / TimeElapsed) * 3600
		end
	end
end)

-- Thanks to Sown for helping me with this

local OldIndex
OldIndex = hookmetamethod(game, "__index", newcclosure(function(Self, Key)
    if not checkcaller() and Self:IsA('Humanoid') and Key == "WalkSpeed" then
        return Humanoid.MaxSpeed.Value
    elseif not checkcaller() and Self:IsA('Humanoid') and Key == "JumpPower" then
        return 50
    end

    return OldIndex(Self, Key)
end))

-- [[ Server Message Remote ]] --

ReplicatedStorage.Remote.ShowPlayerMessage.OnClientEvent:Connect(function(text, colour)
	if text:find('Billy Ray Joe:') then
        NotifyChat('Great Demon Spawn is spawning! Defeat it!', Color3.fromRGB(215, 69, 69))
	end

    if text:find(' found a ') then
        if text:split(" ")[1] == LocalPlayer.Name then
            
        end
    end
end)


-- [[ Final Code ]] --

NotifyChat("Field of Heaven Beta has successfully been executed.", Color3.fromRGB(69, 215, 69))
NotifyChat("Report any bugs to Amiriki on Discord", Color3.fromRGB(69, 69, 215))
NotifyChat("Join the Discord at dsc.gg/amiriki", Color3.fromRGB(69, 69, 215))
