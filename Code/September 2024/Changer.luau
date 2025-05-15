local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlas = require(ReplicatedStorage.Atlas)
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local marketplaceService = game:GetService("MarketplaceService")
local MenuRemoteEvent = Atlas:GetObject("MenuRemote")

local SecurityTeam = Teams:FindFirstChild("Security Department")
local PurchaseComplete = Instance.new("RemoteEvent")
PurchaseComplete.Name = "PurchaseComplete"
PurchaseComplete.Parent = ReplicatedStorage

@native function updateSDStatus()
	if SecurityTeam and #SecurityTeam:GetPlayers() > 0 then
		MenuRemoteEvent:FireAllClients("UpdateSDStatus")
	end
end
MenuRemoteEvent.OnServerEvent:Connect(@native function(player: Player, action: string, teamName: string)
    if action == "TeamSelect" then
        local team = Teams:FindFirstChild(teamName)
        if team then 
            player.Team = team
			player:LoadCharacter() -- nice security vuln lmao
           if team == SecurityTeam then
               updateSDStatus()
           end
        end
    end
end)


@native function handlePlayerAdded(player: Player)
	player:SetAttribute("IsLoaded", false)

	task.spawn(@native function()
		updateSDStatus()

		player:GetPropertyChangedSignal("Team"):Connect(@native function()
			if player.Team == SecurityTeam then
				updateSDStatus()
			end
		end)
	end)
end


@native function handlePlayerRemoving(player: Player)
    if player.Team == SecurityTeam then
        updateSDStatus()
    end
end

Players.PlayerAdded:Connect(handlePlayerAdded)
Players.PlayerRemoving:Connect(handlePlayerRemoving)

if SecurityTeam then
    SecurityTeam.PlayerAdded:Connect(updateSDStatus)
    SecurityTeam.PlayerRemoved:Connect(updateSDStatus)
end
