repeat task.wait() until game:IsLoaded()
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

function Send_Alert()
	local data = {
		["embeds"] = {{
			["title"] = "A Demon is spawning!",
			["type"] = "rich",
			["color"] = tonumber(0xff0000),
			["fields"] = {
				{
					["name"] = "Join Link",
					["value"] = "roblox://placeID="..tostring(game.PlaceId).."&gameInstanceId="..tostring(game.JobId)
					["inline"] = false
				}
			},
			["footer"] = {
				["text"] = 'demon detector | click the link to join the server | written by amiriki'
			}}}}
	request({Url = "https://discord.com/api/webhooks/1143211463092211923/Wr6Ok1IyMTAYrohcNkmgBXC_BOZ0sJ848W3_mDqGlEK-NM6sjfR9dkhNUC3t8eQF6anC", Method = 'POST', Headers = {['Content-Type'] = 'application/json'}, Body = HttpService:JSONEncode(data)})
end

ReplicatedStorage.Remote.ShowPlayerMessage.OnClientEvent:Connect(function(text, colour)
	if text:find('Billy Ray Joe:') then
		Send_Alert()
	end
end)
