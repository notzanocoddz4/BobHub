if game.PlaceId ~= 9431156611 then
     return
end

repeat task.wait() until game:IsLoaded()

game.Players.LocalPlayer.PlayerScripts.e.Enabled = false -- anti cheat

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local function Notify(title, content, duration)
    Library:Notify({
        Title = "bobhub",
        Content = title,
        SubContent = content,
        Duration = duration or nil
    })
end

local Players = game:GetService('Players');
local HttpService = game:GetService('HttpService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local RunService = game:GetService('RunService');
local Workspace = game:GetService('Workspace');
local TextChatService = game:GetService('TextChatService');

local LocalPlayer = Players.LocalPlayer

local Events = ReplicatedStorage.Events
local Map = Workspace:WaitForChild("Map")

local RBXGeneral = TextChatService.TextChannels.RBXGeneral

local IS_FLAGS = {
    ["player"] = {
        ["speed-slider"] = 0,
        ["speed-enable"] = false,
        ["jump-slider"] = 0,
        ["jump-enable"] = false,
    },
    ["auto"] = {
        ["slap-aura"] = false,
    },
    ["anti"] = {
        ["anti-acid"] = false,
    },
    ["misc"] = {
        ["toxic-chat"] = false,
    }
}

local Connections = {}

local Phrase_Chat = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/BobHub/main/Files/phrase_Chat.lua"))()

function discord_Info() -- bobhub server
    local url_inviteAPI = "https://discord.com/api/v9/invites/zr575byvYK?with_counts=true"
    local request = (syn and syn.request) or (http and http.request) or (HttpService and HttpService.RequestAsync) or request

    local content = {}
    local success, result = pcall(function()
        local response = request({
            Url = url_inviteAPI,
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })

        if response.StatusCode == 200 then
            local decoded = HttpService:JSONDecode(response.Body)
            local server_Name = decoded["guild"] and decoded["guild"]["name"] or "Unknown"
            local token = decoded["code"] or ""
            local member_Count = decoded["approximate_member_count"] or 0
            local online_Count = decoded["approximate_presence_count"] or 0

            content = {
                server_name = server_Name,
                token = token,
                member_count = member_Count,
                online_count = online_Count
            }
        else
            error("Failed to fetch Discord invite data: " .. response.Body)
        end
    end)

    return content
end

-- Creating a window
local Window = Library:CreateWindow({
    Title = "slap royale",
    SubTitle = "by bobhub",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Creating a tabs of table
local tabs = {
    info = Window:CreateTab({ Title = "info", Icon = "info" }),
    player = Window:CreateTab({ Title = "player", Icon = "circle-user-round" }),
    auto = Window:CreateTab({ Title = "auto", Icon = "zap" }),
    anti = Window:CreateTab({ Title = "anti", Icon = "shield-ban" }),
    visuals = Window:CreateTab({ Title = "visuals", Icon = "eye" }),
    misc = Window:CreateTab({ Title = "misc", Icon = "folder-open" }),
    settings = Window:CreateTab({ Title = "settings", Icon = "settings" })
}

-- info tabs
local data = discord_Info()
local discord_info = tabs.info:CreateSection("discord-information")

discord_info:CreateParagraph("discord-info", {
    Title = data.server_name,
    Content = "online count: " .. data.online_count .. ", member count: " .. data.member_count,
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

discord_info:CreateButton({
   Title = "copy-discord-server",
   Description = "",
   Callback = function()
        setclipboard("https://discord.gg/".. data.token)
   end 
})

local credits = tabs.info:CreateSection("credits")

credits:CreateParagraph("dev-credits", {
    Title = "bobhub dev (mmm)",
    Content = [[
    - notzanocoddz: creator & developer
    ]],
    TitleAlignment = "Left",
    ContentAlignment = Enum.TextXAlignment.Left
})

-- player tabs
local movement = tabs.player:CreateSection("movement")

movement:CreateSlider("speed-slider", {
    Title = "speed-slider",
    Description = "",
    Default = 21,
    Min = 0,
    Max = 350,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["player"]["speed-slider"] = value
    end
})

movement:CreateToggle("speed-enable", {
    Title = "speed-enable",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["speed-enable"] = state

        if not IS_FLAGS["player"]["speed-enable"] then
            LocalPlayer.Character.Humanoid.WalkSpeed = 21
        end
    end
})

movement:CreateSlider("jump-slider", {
    Title = "jump-slider",
    Description = "",
    Default = 50,
    Min = 0,
    Max = 550,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["player"]["jump-slider"] = value
    end
})

movement:CreateToggle("jump-enable", {
    Title = "jump-enable",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["jump-enable"] = state

        if not IS_FLAGS["player"]["jump-enable"] then
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
})

local character = tabs.player:CreateSection("character")

character:CreateToggle("no-ragdoll", {
    Title = "no-ragdoll",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["no-ragdoll"] = state
    end
})

-- auto tabs
local combat = tabs.auto:CreateSection("combat")

combat:CreateToggle("slap-aura", {
   Title = "slap-aura",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["auto"]["slap-aura"] = state

        while IS_FLAGS["auto"]["slap-aura"] do
            task.wait()
            for _, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    local inMatch = LocalPlayer.Character:FindFirstChild("inMatch")
                    if inMatch and inMatch.Value == true then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = LocalPlayer:DistanceFromCharacter(v.Character:WaitForChild("HumanoidRootPart").Position)

                            if distance <= 20 then
                                Events.Slap:FireServer(v.Character:WaitForChild("HumanoidRootPart"))
                            end
                        end
                    end
                end
            end
        end
   end
})

-- anti tabs
tabs.anti:CreateToggle("anti-acid", {
   Title = "anti-acid",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["anti"]["anti-acid"] = state

        for _, v in pairs(Map.AcidAbnormality:GetChildren()) do
            if v:IsA("BasePart") and v.Name == "Acid" then
                v.CanTouch = not IS_FLAGS["anti"]["anti-acid"]
            end
        end
   end
})

-- misc tabs
local toxic = tabs.misc:CreateSection("toxic")

toxic:CreateToggle("toxic-chat", {
   Title = "toxic-chat",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["misc"]["toxic-chat"] = state

        while IS_FLAGS["misc"]["toxic-chat"] do
            if RBXGeneral then
                local randomPhrase = Phrase_Chat[math.random(1, #Phrase_Chat)]
                RBXGeneral:SendAsync(randomPhrase)
            end
            task.wait(8) -- send a message every 8 seconds
        end
   end
})

table.insert(Connections, RunService.RenderStepped:Connect(function()
    local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    if Humanoid then
        if IS_FLAGS["player"]["speed-enable"] == true then
            Humanoid.WalkSpeed = IS_FLAGS["player"]["speed-slider"]
        end

        if IS_FLAGS["player"]["jump-enable"] == true then
            Humanoid.JumpPower = IS_FLAGS["player"]["jump-slider"]
        end
    end

    local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    if HumanoidRootPart then
        if IS_FLAGS["player"]["no-ragdoll"] == true then
            local Ragdolled = LocalPlayer.Character:FindFirstChild("Ragdolled")
            if Ragdolled and Ragdolled.Value == true then
                HumanoidRootPart.Anchored = true
            else
                HumanoidRootPart.Anchored = false
            end
        end
    end    
end))