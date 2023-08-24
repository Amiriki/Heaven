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
local ValuableGemsNamed = {["Mithril"] = 32, ["Demonite"] = 33, ["Fury Stone"] = 34, ["Dragon Bone"] = 35, ["Spirit Shard"] = 36, ["Titan Core"] = 42}
local ValuableGems = {[32] = true, [33] = true, [34] = true, [35] = true, [36] = true, [42] = true}

-- [[ Config Script ]] --
getgenv().FOHAPI = {}
FOHAPI.Configuration = {
    ['GemLoggingEnabled'] = false,
    ['GemWebhookURL'] = '',
    ['GemLoggingIncludesUsername'] = false,
    ['AutoGemResponseEnabled'] = false,
    ['GemResponseMithril'] = "",
    ['GemResponseDemonite'] = "",
    ['GemResponseFuryStone'] = "",
    ['GemResponseDragonBone'] = "",
    ['GemResponseSpiritShard'] = "",
    ['GemResponseTitanCore'] = "",
    ['GemResponseHallowedShard'] = "",
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
    ['Fullbright'] = true,
    ['DisableDecoration'] = true,
    ['DebugMode'] = false,
}

-- [[ Functions ]] --
function NotifyChat(message, colour, required)
	if required then
		return StarterGui:SetCore("ChatMakeSystemMessage", {Text = "[Field of Heaven] "..message, Color = colour, Font = Enum.Font.SourceSansBold, TextSize = 16})
	end

	if FOHAPI.Configuration.DebugMode then
		return StarterGui:SetCore("ChatMakeSystemMessage", {Text = "[Field of Heaven] "..message, Color = colour, Font = Enum.Font.SourceSansBold, TextSize = 16})
	end
end

function Send_Log(url, gem)
    if FOHAPI.Configuration.IncludeUsernameToggle then username = LocalPlayer.Username else username = "Username Hidden" end

    local data = {
        ["username"] = "Field of Heaven Legendary Gem Alerts | Username: "..username,
        ["embeds"] = {
            ["title"] = "Legendary Gem Picked Up!",
            ["type"] = "rich",
            ["color"] = tonumber(0xaf0000),
            ["fields"] = {
                {
                    ["name"] = "**Gem Name**",
                    ["value"] = gem
                },
            },
            ["footer"] = {
				["text"] = 'legendary gem detector | dsc.gg/amiriki | written by amiriki'
			}}}

    request({Url = url, Method = 'POST', Headers = {['Content-Type'] = 'application/json'}, Body = HttpService:JSONEncode(data)})
end

function Attack(target, weapon)
    if not target or not weapon then return end
	if LocalPlayer.Backpack:FindFirstChild(weapon) then LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(weapon)) end

	repeat
		pcall(function()
			if not target:FindFirstChild('Torso') then return end
			LocalPlayer.Character:FindFirstChild(weapon):Activate()
			LocalPlayer.Character.HumanoidRootPart.CFrame = target.Torso.CFrame * CFrame.new(0,0,3)
		end)
		task.wait(0.125)
	until not target or not target:FindFirstChild('Humanoid') or target:FindFirstChild('Humanoid').Health == 0 or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('Humanoid') or LocalPlayer.Character:FindFirstChild('Humanoid').Health == 0
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
    task.wait(0.5)
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

RunService.RenderStepped:Connect(function()
    if FOHAPI.Configuration.Fullbright then 
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

Projectiles.ChildAdded:Connect(function(obj)
	if FOHAPI.Configuration.GemTracersEnabled or FOHAPI.Configuration.GemESPEnabled or FOHAPI.Configuration.RedDiamondESPEnabled or FOHAPI.Configuration.PathfindToGem then
		local GemType = obj:WaitForChild('GemType', 5)
        local Legendary = false
        if GemType then
            local GemNum = GemType.Value

            --[[for gem, gemtype in pairs(ValuableGems) do
                if GemNum == GemType then Legendary = true end
            end]]

            if GemNum == 31 and workspace.Difficulty.Value ~= 1 then
                if FOHAPI.Configuration.RedDiamondESPEnabled then DrawGemESP(obj, "RedDiamondESPColour", "RedDiamondESPEnabled") end
                if FOHAPI.Configuration.RedDiamondTracersEnabled then DrawTracer(obj, 2, "RedDiamondTracersColour", "RedDiamondTracersEnabled") end
            end

		    if ValuableGems[GemNum] then
                NotifyChat("Legendary Gem Dropped, GemType is "..tostring(GemNum), obj:FindFirstChild('GemGlow').Color)
			    if FOHAPI.Configuration.GemTracersEnabled then DrawTracer(obj, 2, "GemTracersColour", "GemTracersEnabled") end
                if FOHAPI.Configuration.GemESPEnabled then DrawGemESP(obj, "GemESPColour", "GemESPEnabled") end
                if FOHAPI.Configuration.PathfindToGem then PathfindToObject(obj, LocalPlayer.Character) end
            end
		end  
	end
end)

NPCs.DescendantAdded:Connect(function(obj)
    if obj.Name:find('General') then 
        local Humanoid = obj:WaitForChild('Humanoid', 3)
        if Humanoid then
            obj:WaitForChild('Humanoid').Died:Connect(function()
                if FOHAPI.Configuration.AutoMapvoteRogue then
                    Players:Chat(':mapvote rogue')
                end
            end)
        end
    end
end)

workspace.ChildAdded:Connect(function(obj)
    if obj.Name ~= "Configuration" or obj.ClassName ~= "Folder" then return end
    local Demon = obj:WaitForChild('Objectives'):WaitForChild('Demon', 3)
    if Demon then
        NotifyChat('Great Demon Spawn is spawning! Defeat it!', Color3.fromRGB(175, 0, 0), true)
    end
end)

-- [[ Server Message Remote ]] --

ReplicatedStorage.Remote.ShowPlayerMessage.OnClientEvent:Connect(function(text, colour)
    if not text:find(LocalPlayer.Name..' found a ') then return end
    local textSplit = text:gsub('!', ''):split(' ')
    local gemName = table.concat({textSplit[4], textSplit[5]}, ' ')
    LocalObtainedGem({textSplit[4], textSplit[5]}) else ElseObtainedGem({textSplit[4], textSplit[5]}) end

    if FOHAPI.Configuration['GemResponse'..gemName:gsub(' ', '')] and FOHAPI.Configuration.AutoGemResponseEnabled then
        task.wait(math.random(1, 2.5));
        ChatRemote:FireServer(FOHAPI.Configuration['GemResponse'..gemName:gsub(' ', '')], "All")
    end

    if FOHAPI.Configuration.GemLoggingEnabled then
        Send_Log(FOHAPI.Configuration.GemWebhookURL, (gemName or "Unknown Gem (Report This)"))
    end
end)

-- [[ Final Code ]] --

NotifyChat("Field of Heaven Beta has successfully been executed.", Color3.fromRGB(69, 215, 69), true)
NotifyChat("Report any bugs to Amiriki on Discord", Color3.fromRGB(69, 69, 215), true)
NotifyChat("Join the Discord at dsc.gg/amiriki", Color3.fromRGB(69, 69, 215), true)
