--[[
    Field of Heaven Frontend
    Developed by Amiriki
    UI library used is Fluent made by dawid
    dsc.gg/amiriki
--]]

repeat task.wait() until FOHAPI and FOHAPI.Configuration

-- Importing Services
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Config = FOHAPI.Configuration

-- Waiting for Character to load
repeat task.wait() until LocalPlayer.Character

-- Importing UI elements (i love u dawid for this amazing ui)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Creating the main window for the UI

local Window = Fluent:CreateWindow({
    Title = "Field of Heaven BETA",
    SubTitle = "by amiriki",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- Creating tabs for the UI

local Tabs = {
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "gauge"}),
    Demon = Window:AddTab({ Title = "Demon", Icon = "skull"}),
    Misc = Window:AddTab({ Title = "Miscellaneous", Icon = "plus-circle"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Creating elements for the tabs

-- Autofarm Elements
Tabs.Autofarm:AddSection('Basic Settings')
Tabs.Autofarm:AddToggle("AutofarmToggle", {Title = "Autofarm Enabled", Default = false })
Tabs.Autofarm:AddInput("NPCWeapon", {Title = "NPC Weapon", Default = "", Placeholder = "e.g. Venomancer", Numeric = false, Finished = true})
Tabs.Autofarm:AddInput("GeneralWeapon", {Title = "General Weapon", Default = "", Placeholder = "e.g. Heavens Edge", Numeric = false, Finished = true})
Tabs.Autofarm:AddInput("Map", {Title = "Map Voter", Default = "Savannah", Placeholder = "e.g. Savannah", Numeric = false, Finished = true})

Tabs.Autofarm:AddSection('Logging')
Tabs.Autofarm:AddToggle("WebhookToggle", {Title = "Webhook Logging Enabled", Default = false })
Tabs.Autofarm:AddInput("WebhookURL", {Title = "Webhook URL", Default = "", Placeholder = "https://discord.com/api/webhooks/", Numeric = false, Finished = true})
Tabs.Autofarm:AddToggle("StatsCalculator", {Title = "Show Stats Calculator", Default = false })

Tabs.Autofarm:AddSection('Failsafes')
Tabs.Autofarm:AddToggle("DisableOnJoin", {Title = "Disable on Player Join", Default = true })
Tabs.Autofarm:AddToggle("EnableOnLeave", {Title = "Re-enable on Player Leaving", Default = true })
Tabs.Autofarm:AddToggle("IgnorePlayers", {Title = "Ignore Other Players", Default = false })

-- Demon Elements
Tabs.Demon:AddSection('Legendary Gem Visuals')
Tabs.Demon:AddToggle("GemESPToggle", {Title = "Legendary Gem ESP", Default = false })
Tabs.Demon:AddColorpicker("GemESPColour", {Title = "ESP Colour", Default = Color3.fromRGB(255, 255, 255)})
Tabs.Demon:AddToggle("GemTracersToggle", {Title = "Legendary Gem Tracers", Default = false })
Tabs.Demon:AddColorpicker("GemTracersColour", {Title = "Tracer Colour", Default = Color3.fromRGB(255, 255, 255)})

Tabs.Demon:AddSection('Red Diamond Visuals')
Tabs.Demon:AddToggle("RedESPToggle", {Title = "Red Diamond ESP", Default = false })
Tabs.Demon:AddColorpicker("RedESPColour", {Title = "Red Diamond ESP Colour", Default = Color3.fromRGB(255, 0, 0)})
Tabs.Demon:AddToggle("RedTracersToggle", {Title = "Red Diamond Tracers", Default = false })
Tabs.Demon:AddColorpicker("RedTracersColour", {Title = "Red Diamond Tracer Colour", Default = Color3.fromRGB(255, 0, 0)})

Tabs.Demon:AddSection('Legendary Gem Obtainer')
Tabs.Demon:AddToggle("ObtainGemToggle", {Title = "Pathfind to Legendary Gem", Default = false })

Tabs.Demon:AddSection('Extras')
Tabs.Demon:AddToggle("AutoMapvoteRogueToggle", {Title = "Automatically Vote Rogue", Default = true })

-- Misc Elements
Tabs.Misc:AddSection('Character')
Tabs.Misc:AddSlider("Walkspeed", {Title = 'Walkspeed', Default = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()).Humanoid.WalkSpeed, Min = 0, Max = 250, Rounding = 0.5})
Tabs.Misc:AddSlider("Jumppower", {Title = 'JumpPower', Default = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()).Humanoid.JumpPower, Min = 0, Max = 200, Rounding = 0.5})

Tabs.Misc:AddSection('World')
Tabs.Misc:AddToggle('FullbrightToggle', {Title = "Fullbright", Default = true})
Tabs.Misc:AddToggle('RemoveGrassToggle', {Title = "Remove Grass", Default = true})
--Tabs.Misc:AddToggle('AllMapFly', {Title = "Enable Flying on All Maps", Default = false})
--Tabs.Misc:AddToggle('AllWeaponFly', {Title = "Enable Flying with Every Item", Default = false})

-- Scripting the tab elements

-- Autofarm Elements
Options.AutofarmToggle:OnChanged(function()
    Config.AutofarmEnabled = Options.AutofarmToggle.Value
end)

Options.NPCWeapon:OnChanged(function()
    Config.NPCWeapon = Options.NPCWeapon.Value
end)

Options.GeneralWeapon:OnChanged(function()
    Config.GeneralWeapon = Options.GeneralWeapon.Value
end)

Options.Map:OnChanged(function()
    Config.Map = Options.Map.Value
end)

Options.WebhookToggle:OnChanged(function()
    Config.WebhookEnabled = Options.WebhookToggle.Value
end)

Options.WebhookURL:OnChanged(function()
    Config.WebhookURL = Options.WebhookURL.Value
end)

--[[
    Stats calculator not implemented yet
--]]

Options.DisableOnJoin:OnChanged(function()
    Config.DisableOnJoin = Options.DisableOnJoin.Value
end)

Options.EnableOnLeave:OnChanged(function()
    Config.EnableOnLeave = Options.EnableOnLeave.Value
end)

Options.IgnorePlayers:OnChanged(function()
    Config.IgnorePlayers = Options.IgnorePlayers.Value
end)

-- Demon Elements
Options.GemESPToggle:OnChanged(function()
    Config.GemESPEnabled = Options.GemESPToggle.Value
end)

Options.GemESPColour:OnChanged(function()
    Config.GemESPColour = Options.GemESPColour.Value
end)

Options.GemTracersToggle:OnChanged(function()
    Config.GemTracersEnabled = Options.GemTracersToggle.Value
end)

Options.GemTracersColour:OnChanged(function()
    Config.GemTracersColour = Options.GemTracersColour.Value
end)

Options.RedESPToggle:OnChanged(function()
    Config.RedDiamondESPEnabled = Options.RedESPToggle.Value
end)

Options.RedESPColour:OnChanged(function()
    Config.RedDiamondESPColour = Options.RedESPColour.Value
end)

Options.RedTracersToggle:OnChanged(function()
    Config.RedDiamondTracersEnabled = Options.RedTracersToggle.Value
end)

Options.RedTracersColour:OnChanged(function()
    Config.RedDiamondTracersColour = Options.RedTracersColour.Value
end)

Options.ObtainGemToggle:OnChanged(function()
    Config.PathfindToGem = Options.ObtainGemToggle.Value
end)

Options.AutoMapvoteRogueToggle:OnChanged(function()
    Config.AutoMapvoteRogue = Options.AutoMapvoteRogueToggle.Value
end)

-- Misc Elements
Options.Walkspeed:OnChanged(function()
    (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').WalkSpeed = Options.Walkspeed.Value
    Config.Walkspeed = Options.Walkspeed.Value
end)

Options.Jumppower:OnChanged(function()
    (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').JumpPower = Options.Jumppower.Value
    Config.Jumppower = Options.Jumppower.Value
end)

Options.FullbrightToggle:OnChanged(function()
    Config.Fullbright = Options.FullbrightToggle.Value
end)

Options.RemoveGrassToggle:OnChanged(function()
    sethiddenproperty(workspace.Terrain, "Decoration", not Options.RemoveGrassToggle.Value)
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FieldOfHeavenConfig")
SaveManager:SetFolder("FieldOfHeavenConfig")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Field of Heaven",
    Content = "Script has successfully initialized",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
