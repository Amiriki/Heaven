-- Script Variables

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local NPCs = workspace.Unbreakable.Characters
local Configuration = workspace.Configuration

-- Script Functions

function GetBestWeapon()
    local HighestDamage = 0
    local BestWeapon
    local Tools = LocalPlayer.Backpack:GetChildren()
    
    for i, v in pairs(Tools) do
        if v:IsA('Tool') and v:FindFirstChild('BaseDamage') and v:FindFirstChild('WeaponType').Value ~= 'Bow' then
            if v.BaseDamage.Value > HighestDamage then
                HighestDamage = v.BaseDamage.Value
                BestWeapon = v
            end
        end
    end

    return BestWeapon
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

LocalPlayer.CharacterAdded:Connect(function()
    if not DemonConfig.Enabled then return end
    local Weapon
    repeat task.wait() until #LocalPlayer.Backpack:GetChildren() > 0
    if DemonConfig.Weapon ~= "" then Weapon = DemonConfig.Weapon else Weapon = GetBestWeapon() end

    if LocalPlayer.Team.Name ~= 'Neutral' and DemonConfig.AttackGenerals then
        print('Trying to attack Generals')
        return Attack(NPCs:FindFirstChild(Configuration:FindFirstChild('Objectives')[LocalPlayer.Team.Name].Kill.Value, true), Weapon)
    end

    local DemonFolder = NPCs:WaitForChild('Demon', 5)
    if DemonFolder then
        local Demon = DemonFolder:WaitForChild('Giant Demon Spawn', 10)
        if Demon then
            Attack(Demon, Weapon)
        end
        return
    end
end)

LocalPlayer.Character:BreakJoints()
