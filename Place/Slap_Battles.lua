--[[
if game.PlaceId ~= 6403373529 then
    return
end
]]

repeat task.wait() until game:IsLoaded()

-- disable killfeed bin
for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
    if v:IsA("Frame") then
        if v.Name == "KillfeedBin" then
            v.Visible = false
        end
    end
end

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
local RunService = game:GetService('RunService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local UserInputService = game:GetService('UserInputService');
local HttpService = game:GetService('HttpService');
local BadgeService = game:GetService('BadgeService');
local TextChatService = game:GetService('TextChatService');
local Workspace = game:GetService('Workspace');

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

local Arena = Workspace.Lobby:WaitForChild("Teleport1") -- its arena normal

local RBXGeneral = TextChatService.TextChannels.RBXGeneral

local IS_FLAGS = {
    ["player"] = {
        ["speed-slider"] = 0,
        ["speed-enable"] = false,
        ["jump-slider"] = 0,
        ["jump-enable"] = false,
        ["no-ragdoll"] = false,
    },
    ["auto"] = {
        ["player-hit-distance"] = 0,
        ["slap-hit-delay"] = 0,
        ["slap-aura"] = false,
    },
    ["anti"] = {
        ["anti-void"] = false,
    },
    ["visuals"] = {
        ["disable-name-tag"] = true,
    },
    ["misc"] = {
        ["teleport-arena"] = false,
        ["toxic-chat"] = false,
    }
}

local Connections = {}

local Phrase_Chat = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/BobHub/main/Files/phrase_Chat.lua"))()

-- gloveHits made by r20 script (im not skid)
local gloveHits = {
    ["Default"] = game.ReplicatedStorage.b,
    ["Extended"] = game.ReplicatedStorage.b,
    ["Dual"] = game.ReplicatedStorage.GeneralHit,
    ["T H I C K"] = game.ReplicatedStorage.GeneralHit,
    ["Squid"] = game.ReplicatedStorage.GeneralHit,
    ["Gummy"] = game.ReplicatedStorage.GeneralHit,
    ["RNG"] = game.ReplicatedStorage.GeneralHit,
    ["Tycoon"] = game.ReplicatedStorage.GeneralHit,
    ["Charge"] = game.ReplicatedStorage.GeneralHit,
    ["Baller"] = game.ReplicatedStorage.GeneralHit,
    ["Tableflip"] = game.ReplicatedStorage.GeneralHit,
    ["Booster"] = game.ReplicatedStorage.GeneralHit,
    ["Shield"] = game.ReplicatedStorage.GeneralHit,
    ["Track"] = game.ReplicatedStorage.GeneralHit,
    ["Goofy"] = game.ReplicatedStorage.GeneralHit,
    ["Confusion"] = game.ReplicatedStorage.GeneralHit,
    ["Elude"] = game.ReplicatedStorage.GeneralHit,
    ["Glitch"] = game.ReplicatedStorage.GeneralHit,
    ["Snowball"] = game.ReplicatedStorage.GeneralHit,
    ["🗿"] = game.ReplicatedStorage.GeneralHit,
    ["Obby"] = game.ReplicatedStorage.GeneralHit,
    ["Voodoo"] = game.ReplicatedStorage.GeneralHit,
    ["Leash"] = game.ReplicatedStorage.GeneralHit,
    ["Flamarang"] = game.ReplicatedStorage.GeneralHit,
    ["Kinetic"] = game.ReplicatedStorage.GeneralHit,
    ["Berserk"] = game.ReplicatedStorage.GeneralHit,
    ["Rattlebones"] = game.ReplicatedStorage.GeneralHit,
    ["Chain"] = game.ReplicatedStorage.GeneralHit,
    ["Ping Pong"] = game.ReplicatedStorage.GeneralHit,
    ["Psycho"] = game.ReplicatedStorage.GeneralHit,
    ["Kraken"] = game.ReplicatedStorage.GeneralHit,
    ["Counter"] = game.ReplicatedStorage.GeneralHit,
    ["Hammer"] = game.ReplicatedStorage.GeneralHit,
    ["Excavator"] = game.ReplicatedStorage.GeneralHit,
    ["Slicer"] = game.ReplicatedStorage.GeneralHit,
    ["Whirlwind"] = game.ReplicatedStorage.GeneralHit,
    ["Home Run"] = game.ReplicatedStorage.GeneralHit,
    ["Diamond"] = game.ReplicatedStorage.DiamondHit,
    ["ZZZZZZZ"] = game.ReplicatedStorage.ZZZZZZZHit,
    ["Brick"] = game.ReplicatedStorage.BrickHit,
    ["Snow"] = game.ReplicatedStorage.SnowHit,
    ["Pull"] = game.ReplicatedStorage.PullHit,
    ["Flash"] = game.ReplicatedStorage.FlashHit,
    ["Spring"] = game.ReplicatedStorage.springhit,
    ["Swapper"] = game.ReplicatedStorage.HitSwapper,
    ["Bull"] = game.ReplicatedStorage.BullHit,
    ["Dice"] = game.ReplicatedStorage.DiceHit,
    ["Ghost"] = game.ReplicatedStorage.GhostHit,
    -- ["Thanos"] = game.ReplicatedStorage.ThanosHit, -- deleted
    ["Stun"] = game.ReplicatedStorage.HtStun,
    ["Za Hando"] = game.ReplicatedStorage.zhramt,
    ["Fort"] = game.ReplicatedStorage.Fort,
    ["Magnet"] = game.ReplicatedStorage.MagnetHIT,
    ["Pusher"] = game.ReplicatedStorage.PusherHit,
    ["Anchor"] = game.ReplicatedStorage.hitAnchor,
    ["Space"] = game.ReplicatedStorage.HtSpace,
    ["Boomerang"] = game.ReplicatedStorage.BoomerangH,
    ["Speedrun"] = game.ReplicatedStorage.Speedrunhit,
    ["Mail"] = game.ReplicatedStorage.MailHit,
    ["Golden"] = game.ReplicatedStorage.GoldenHit,
    ["Reaper"] = game.ReplicatedStorage.ReaperHit,
    ["Defense"] = game.ReplicatedStorage.DefenseHit,
    ["Killstreak"] = game.ReplicatedStorage.KSHit,
    ["Reverse"] = game.ReplicatedStorage.ReverseHit,
    ["Shukuchi"] = game.ReplicatedStorage.ShukuchiHit,
    ["Duelist"] = game.ReplicatedStorage.DuelistHit,
    ["Woah"] = game.ReplicatedStorage.woahHit,
    ["Ice"] = game.ReplicatedStorage.IceHit,
    ["Adios"] = game.ReplicatedStorage.hitAdios,
    ["Blocked"] = game.ReplicatedStorage.BlockedHit,
    ["Engineer"] = game.ReplicatedStorage.engiehit,
    ["Rocky"] = game.ReplicatedStorage.RockyHit,
    ["Conveyor"] = game.ReplicatedStorage.ConvHit,
    ["STOP"] = game.ReplicatedStorage.STOP,
    ["Phantom"] = game.ReplicatedStorage.PhantomHit,
    ["Wormhole"] = game.ReplicatedStorage.WormHit,
    ["Acrobat"] = game.ReplicatedStorage.AcHit,
    ["Plague"] = game.ReplicatedStorage.PlagueHit,
    ["Megarock"] = game.ReplicatedStorage.DiamondHit,
    ["[REDACTED]"] = game.ReplicatedStorage.ReHit,
    ["bus"] = game.ReplicatedStorage.hitbus,
    ["Phase"] = game.ReplicatedStorage.PhaseH,
    ["Warp"] = game.ReplicatedStorage.WarpHt,
    ["Bomb"] = game.ReplicatedStorage.BombHit,
    ["Bubble"] = game.ReplicatedStorage.BubbleHit,
    ["Jet"] = game.ReplicatedStorage.JetHit,
    ["Shard"] = game.ReplicatedStorage.ShardHIT,
    ["potato"] = game.ReplicatedStorage.potatohit,
    ["Cult"] = game.ReplicatedStorage.CULTHit,
    ["bob"] = game.ReplicatedStorage.bobhit,
    ["Buddies"] = game.ReplicatedStorage.buddiesHIT,
    ["Moon"] = game.ReplicatedStorage.CelestialHit,
    ["Jupiter"] = game.ReplicatedStorage.CelestialHit,
    ["Spy"] = game.ReplicatedStorage.SpyHit,
    ["Detonator"] = game.ReplicatedStorage.DetonatorHit,
    ["Rage"] = game.ReplicatedStorage.GRRRR,
    ["Trap"] = game.ReplicatedStorage.traphi,
    ["Orbit"] = game.ReplicatedStorage.Orbihit,
    ["Hybrid"] = game.ReplicatedStorage.HybridCLAP,
    ["Slapple"] = game.ReplicatedStorage.SlappleHit,
    ["Disarm"] = game.ReplicatedStorage.DisarmH,
    ["Dominance"] = game.ReplicatedStorage.DominanceHit,
    ["rob"] = game.ReplicatedStorage.robhit,
    ["Link"] = game.ReplicatedStorage.LinkHit,
    ["Rhythm"] = game.ReplicatedStorage.rhythmhit,
    ["Hitman"] = game.ReplicatedStorage.HitmanHit,
    ["Rojo"] = game.ReplicatedStorage.RojoHit,
    ["Thor"] = game.ReplicatedStorage.ThorHit,
    ["Custom"] = game.ReplicatedStorage.CustomHit,
    ["Mitten"] = game.ReplicatedStorage.MittenHit,
    ["Hallow Jack"] = game.ReplicatedStorage.HallowHIT,
    ["Boogie"] = game.ReplicatedStorage.HtStun,
    ["Balloony"] = game.ReplicatedStorage.HtStun,
    ["OVERKILL"] = game.ReplicatedStorage.Overkillhit,
    ["The Flex"] = game.ReplicatedStorage.FlexHit,
    ["God's Hand"] = game.ReplicatedStorage.Godshand,
    ["Error"] = game.ReplicatedStorage.Errorhit
}

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

function get_Glove()
    return LocalPlayer:GetAttribute("Glove") or LocalPlayer.leaderstats.Glove.Value
end

-- Creating a window
local Window = Library:CreateWindow({
    Title = "slap battles",
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

-- about tabs
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

combat:CreateSlider("player-hit-distance", {
    Title = "player-hit-distance",
    Description = "",
    Default = 20,
    Min = 10,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["auto"]["player-hit-distance"] = value
    end
})

combat:CreateSlider("slap-hit-delay", {
    Title = "slap-hit-delay",
    Description = "",
    Default = 0.8,
    Min = 0.5,
    Max = 1,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["auto"]["slap-hit-delay"] = value
    end
})

combat:CreateToggle("slap-aura", {
   Title = "slap-aura",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["auto"]["slap-aura"] = state

        repeat
            task.wait(IS_FLAGS["auto"]["slap-hit-delay"])
            for _, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    local isInArena = LocalPlayer.Character:FindFirstChild("isInArena")
                    if isInArena and isInArena.Value == true then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = LocalPlayer:DistanceFromCharacter(v.Character:WaitForChild("HumanoidRootPart").Position)

                            if distance <= tonumber(IS_FLAGS["auto"]["player-hit-distance"]) then
                                gloveHits[get_Glove()]:FireServer(v.Character:WaitForChild("HumanoidRootPart"))
                            end
                        end
                    end
                end
            end
        until not IS_FLAGS["auto"]["slap-aura"]
   end
})

-- anti tabs
local anti_world = tabs.anti:CreateSection("anti-world")

anti_world:CreateToggle("anti-void", {
   Title = "anti-void",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["anti"]["anti-void"] = state

        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "dedBarrier" then
                v.CanCollide = IS_FLAGS["anti"]["anti-void"]
                v.Transparency = (IS_FLAGS["anti"]["anti-void"] and 0.8) or 1
            end
        end
   end
})

-- local anti_glove = tabs.anti:CreateSection("anti-glove")

-- visuals tabs
local remove = tabs.visuals:CreateSection("remove")

remove:CreateToggle("disable-name-tag", {
   Title = "disable-name-tag",
   Description = "",
   Default = true,
   Callback = function(state)
        IS_FLAGS["visuals"]["disable-name-tag"] = state
            
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then
            local nameTag = head:FindFirstChild("Nametag")
            
            if nameTag then
                nameTag.Enabled = not IS_FLAGS["visuals"]["disable-name-tag"]
            end
        end
   end
})

-- misc tabs
local teleport = tabs.misc:CreateSection("teleport")

teleport:CreateToggle("teleport-arena", {
   Title = "teleport-arena",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["misc"]["teleport-arena"] = state

        while IS_FLAGS["misc"]["teleport-arena"] do
            if LocalPlayer.Character:FindFirstChild("isInArena") then
                if not LocalPlayer.Character.isInArena.Value == true then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Arena, 0)
                        task.wait()
                        firetouchinterest(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Arena, 1)
                    end
                end
            end
            task.wait()
        end
   end
})

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

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("bobhub")
SaveManager:SetFolder("bobhub/slap-battles")
InterfaceManager:BuildInterfaceSection(tabs.settings)
SaveManager:BuildConfigSection(tabs.settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(child)
    task.spawn(function()
        repeat task.wait() until child:FindFirstChild("Head")
        local Nametag = child.Head:FindFirstChild("Nametag")

        if Nametag then
            Nametag.Enabled = not IS_FLAGS["visuals"]["disable-name-tag"]
        end
    end)
end))

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