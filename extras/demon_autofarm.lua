-- Script Variables

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local NPCs = workspace.Unbreakable.Characters
local Configuration = workspace.Configuration

-- Script Functions

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
    if not DemonConfig.Enabled then return print'its disabled' end
    local Weapon = DemonConfig.Weapon
    repeat task.wait() until #LocalPlayer.Backpack:GetChildren() > 0

    if LocalPlayer.Team.Name ~= 'Neutral' and DemonConfig.AttackGenerals then
        print'looking for target'
        local target
        if LocalPlayer.Team.Name == 'Human' then
            print'player is human'
            target = NPCs.Orc:WaitForChild('Orc General')
        elseif LocalPlayer.Team.Name == 'Orc' then
            print'player is orc'
            target = NPCs.Human:WaitForChild('Human General')
        end
        print(target.Name)
        print'attacking!!'
        return Attack(target, Weapon)
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
