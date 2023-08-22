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
Tabs.Autofarm:AddParagraph({Title = "This function is not available in this GUI", Content = "For optimisation and maintenance reasons, this feature is not available in this gui.\nClick the buttons below to either join the discord server, or to copy the script to your clipboard!"})
Tabs.Autofarm:AddButton({Title = "Copy Discord Invite", Description = "dsc.gg/amiriki", Callback = function() setclipboard('dsc.gg/amiriki') end})
Tabs.Autofarm:AddButton({Title = "Copy Script", Description = "dsc.gg/amiriki", Callback = function() setclipboard(game:HttpGet("https://scriptblox.com/raw/Field-of-Battle-Farming-Autarm-7317"))() end})


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
Tabs.Demon:AddToggle("AutoGemResponseToggle", {Title = "Automatically Respond to Legendary Gems", Default = false })
Tabs.Demon:AddInput("GemResponseMithril", {Title = "Response to Mithril", Default = "I GOT MITH", Placeholder = "Response to Mithril", Numeric = false, Finished = true})
Tabs.Demon:AddInput("GemResponseDemonite", {Title = "Response to Demonite", Default = "DEMO", Placeholder = "Response to Demonite", Numeric = false, Finished = true})
Tabs.Demon:AddInput("GemResponseFury", {Title = "Response to Fury", Default = "FURY!!!", Placeholder = "Response to Fury", Numeric = false, Finished = true})
Tabs.Demon:AddInput("GemResponseDragon", {Title = "Response to Dragon", Default = "bruh drag", Placeholder = "Response to Dragon", Numeric = false, Finished = true})
Tabs.Demon:AddInput("GemResponseSpirit", {Title = "Response to Spirit", Default = "shard", Placeholder = "Response to Spirit", Numeric = false, Finished = true})
Tabs.Demon:AddInput("GemResponseTitan", {Title = "Response to Titan", Default = "yess titan", Placeholder = "Response to Titan", Numeric = false, Finished = true})
Tabs.Demon:AddInput("GemResponseHallowed", {Title = "Response to Hallowed Shard", Default = "WOOOOO", Placeholder = "Response to Hallowed", Numeric = false, Finished = true})

-- Misc Elements
--Tabs.Misc:AddSection('Character')
--Tabs.Misc:AddSlider("Walkspeed", {Title = 'Walkspeed', Default = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()).Humanoid.WalkSpeed, Min = 0, Max = 250, Rounding = 0.5})
--Tabs.Misc:AddSlider("Jumppower", {Title = 'JumpPower', Default = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()).Humanoid.JumpPower, Min = 0, Max = 200, Rounding = 0.5})

Tabs.Misc:AddSection('World')
Tabs.Misc:AddToggle('FullbrightToggle', {Title = "Fullbright", Default = true})
Tabs.Misc:AddToggle('RemoveGrassToggle', {Title = "Remove Grass", Default = true})
--Tabs.Misc:AddToggle('AllMapFly', {Title = "Enable Flying on All Maps", Default = false})
--Tabs.Misc:AddToggle('AllWeaponFly', {Title = "Enable Flying with Every Item", Default = false})

-- Scripting the tab elements

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

Options.AutoGemResponseToggle:OnChanged(function()
    Config.AutoGemResponse = Options.AutoGemResponseToggle.Value
end)

Options.GemResponseMithril:OnChanged(function()
    Config.GemResponseMithril = Options.GemResponseMithril.Value
end)

Options.GemResponseDemonite:OnChanged(function()
    Config.GemResponseDemonite = Options.GemResponseDemonite.Value
end)

Options.GemResponseFury:OnChanged(function()
    Config.GemResponseFury = Options.GemResponseFury.Value
end)

Options.GemResponseDragon:OnChanged(function()
    Config.GemResponseDragon = Options.GemResponseDragon.Value
end)

Options.GemResponseSpirit:OnChanged(function()
    Config.GemResponseSpirit = Options.GemResponseSpirit.Value
end)

Options.GemResponseTitan:OnChanged(function()
    Config.GemResponseTitan = Options.GemResponseTitan.Value
end)

Options.GemResponseHallowed:OnChanged(function()
    Config.GemResponseHallowed = Options.GemResponseHallowed.Value
end)


-- Misc Elements
--[[Options.Walkspeed:OnChanged(function()
    (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').WalkSpeed = Options.Walkspeed.Value
    Config.Walkspeed = Options.Walkspeed.Value
end)

Options.Jumppower:OnChanged(function()
    (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid').JumpPower = Options.Jumppower.Value
    Config.Jumppower = Options.Jumppower.Value
end)]]

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
