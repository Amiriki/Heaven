-- Script Variables

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local NPCs = workspace.Unbreakable.Characters
local Configuration = workspace.Configuration
local DemonSpawned = false

-- Script Functions

function Attack(target, weapon)
    if not target or not weapon then return end
    repeat task.wait() until LocalPlayer.Backpack:FindFirstChild(weapon) or LocalPlayer.Character:FindFirstChild(weapon)
	if LocalPlayer.Backpack:FindFirstChild(weapon) then LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(weapon)) end

	repeat
		pcall(function()
			if not target:FindFirstChild('Torso') then return end
            if LocalPlayer.Backpack:FindFirstChild(weapon) then LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(weapon)) end
			LocalPlayer.Character:FindFirstChild(weapon):Activate()
			LocalPlayer.Character.HumanoidRootPart.CFrame = target.Torso.CFrame * CFrame.new(0,0,3)
		end)
		task.wait()
	until not target or not target:FindFirstChild('Humanoid') or target:FindFirstChild('Humanoid').Health == 0 or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('Humanoid') or LocalPlayer.Character:FindFirstChild('Humanoid').Health == 0
end

function GetBestWeapon()
    repeat task.wait() until #LocalPlayer.Backpack:GetChildren() > 0
    task.wait(0.5)
    local HighestDamage = 0
    local BestWeapon
    local Tools = LocalPlayer.Backpack:GetChildren()
    
    for i, v in ipairs(Tools) do
        if v:IsA('Tool') and v:WaitForChild('WeaponType').Value == 'Sword' then 
            if v:FindFirstChild('BaseDamage').Value > HighestDamage then
                HighestDamage = v:FindFirstChild('BaseDamage').Value
                BestWeapon = v
            end
        end
    end

    return (BestWeapon.Name)
end

-- Events

LocalPlayer.CharacterAdded:Connect(function(Character)
    if not DemonConfig.Enabled then return end
    if DemonConfig.Weapon and DemonConfig.Weapon ~= "" then Weapon = DemonConfig.Weapon else Weapon = GetBestWeapon() end

    if not LocalPlayer.Neutral and DemonConfig.AttackGenerals then
        
        if LocalPlayer.Team.Name == "Human" then
			Target = NPCs.Orc['Orc General']
		elseif LocalPlayer.Team.Name == "Orc" then
			Target = NPCs.Human['Human General']
		end

        return Attack(Target, Weapon)
    end

    repeat task.wait() until DemonSpawned
    if Character.Humanoid.Health == 0 then return end
    Attack(NPCs:FindFirstChild('Giant Demon Spawn', true), Weapon)
end)

NPCs.DescendantAdded:Connect(function(obj)
    if not DemonConfig.Enabled then return end
    if obj.Name:find("Giant Demon Spawn") then
        obj:WaitForChild('Humanoid').Died:Connect(function()
            LocalPlayer.Character:BreakJoints()
            DemonSpawned = false
        end)
        DemonSpawned = true
    end
end)

if DemonConfig.ShutdownTimer and DemonConfig.ShutdownTimer > 0 then
	spawn(function()
		task.wait(DemonConfig.ShutdownTimer * 3600)
		game:Shutdown()
	end)
end

LocalPlayer.Character:BreakJoints()
