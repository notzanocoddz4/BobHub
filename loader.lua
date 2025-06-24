local server_Link = "https://discord.gg/zr575byvYK";

local Place_ID = game.PlaceId
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService('UserInputService');

local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()

local Supported_Games = {
	[8260276694] = "Ability_Wars", 
	[6403373529] = "Slap_Battles", [124596094333302] = "Slap_Battles",
}

local function load(id)
	local s, r = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/BobHub/main/Place/".. id ..".lua"))()
	end)
	if s then
		print('Successfully loaded script for: ' .. id)
	end
end

if Supported_Games[Place_ID] ~= nil then
	load(Supported_Games[Place_ID])
else
	LocalPlayer:Kick("\nThe current game is not supported.\n\nCheck the discord for the list of supported games!")
	
    if UserInputService:GetPlatform() == Enum.Platform.Windows then
        discordInviter.Join(server_Link)
    end
end