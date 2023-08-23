--[[
    Automatic Demon Farming Script
    Blatant - Don't use in public servers or you risk a ban
    Written by Amiriki
--]]

getgenv().DemonConfig = {
    ["Enabled"] = true,
    ["AttackGenerals"] = true,
    ["Weapon"] = "Greatsword of Flying II", -- Leave this blank if you want the script to automatically choose a weapon.
}

-- Script Variables

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local NPCs = workspace.Unbreakable.Characters
local Configuration = workspace.Configuration

-- Script Functions

function Attack(target, weapon)
    if not target or not weapon then return end
    repeat task.wait() until LocalPlayer.Backpack:FindFirstChild(weapon) or LocalPlayer.Character:FindFirstChild(weapon)
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

    if not LocalPlayer.Neutral then
		local Target
		if LocalPlayer.Team.Name == "Human" then
			Target = NPCs.Orc['Orc General']
		elseif LocalPlayer.Team.Name == "Orc" then
			Target = NPCs.Human['Human General']
		end

        return Attack(Target, DemonConfig.Weapon)
    else
        local DemonFolder = NPCs:WaitForChild('Demon', 3)
        if DemonFolder then
            pcall(function() return Attack(DemonFolder:FindFirstChild('Giant Demon Spawn'), DemonConfig.Weapon) end)
        end
    end
end)

LocalPlayer.Character:BreakJoints()
