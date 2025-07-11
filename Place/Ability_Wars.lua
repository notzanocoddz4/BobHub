if game.PlaceId ~= 8260276694 then
    return 
end

repeat task.wait() until game:IsLoaded()

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
local Backpack = LocalPlayer:WaitForChild('Backpack')
-- local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerScripts = LocalPlayer:WaitForChild('PlayerScripts')

-- module
local GUI_Functions = require(PlayerScripts:WaitForChild('GUI Functions'))

local CurrentCamera = Workspace.CurrentCamera

local Arena = Workspace.Portals['Arena Frame']
local MapItems = Workspace:WaitForChild('Map Items')
local Secrets = Workspace.Secrets

local Bosses = ReplicatedStorage:WaitForChild('Bosses')
local RemoteEvents = ReplicatedStorage:WaitForChild('Remote Events')
local Punch = RemoteEvents.Punch

local RBXGeneral = TextChatService.TextChannels.RBXGeneral

local ID = 314159265359; -- i think this is the ID of anti-exploit, but i don't know what it does

local IS_FLAGS = {
    ["player"] = {
        ["speed-slider"] = 0,
        ["speed-enable"] = false,
        ["jump-slider"] = 0,
        ["jump-enable"] = false,
        ["inf-jump"] = false,
        ["no-ragdoll"] = false,
        ["target-move"] = false,
    },
    ["auto"] = {
        ["punch-hit-delay"] = 0,
        ["player-hit-distance"] = 0,
        ["punch-aura"] = false,
        ["punch-type"] = "blatant",
        ["kill-boss"] = false,
    },
    ["anti"] = {
        ["anti-void"] = false,
        ["anti-jello"] = false,
        ["anti-slime"] = false,
        ["anti-lava"] = false,
    },
    ["visuals"] = {
        ["field-of-view"] = 0,
        ["disable-name-tag"] = false,
    },
    ["misc"] = {
        ["teleport-arena"] = false,
        ["toxic-chat"] = false,
    }
}

local Part_Void = nil
local Items = {"Burger", "Cake", "Pizza"}

local Connections = {}

local Phrase_Chat = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/BobHub/main/Files/phrase_Chat.lua"))()

local Get_ItemTouch = {
    Burger = function()
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, MapItems.Burger, 0)
        task.wait(0.1)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, MapItems.Burger, 1)
    end,
    Cake = function()
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, MapItems.Cake, 0)
        task.wait(0.1)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, MapItems.Cake, 1)
    end,
    Pizza = function()
        local pizzaHitbox = MapItems:WaitForChild("Pizza"):WaitForChild("Pizza Hitbox")
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, pizzaHitbox, 0)
        task.wait(0.1)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, pizzaHitbox, 1)
    end
}

local Get_Bagde = {
    Backrooms = function()
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Secrets["Cave Teleport"], 0)
        task.wait(.1)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Secrets["Cave Teleport"], 1)
    end,
    Cake = function()
        Get_ItemTouch.Cake()
    end,
    Boring = function()
        LocalPlayer.Character:MoveTo(Secrets["Big Mushroom Hitbox"]:GetPivot().Position)
    end,
    GroceryShopping = function()
        for _, item in pairs(Items) do
            task.wait()
            if Get_ItemTouch[item] and not Backpack:FindFirstChild(item) then
                Get_ItemTouch[item]()
            end
        end
    end
}

function find_target()
    local nearest_distance, nearest_player = math.huge, nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local HumanoidRootPart = player.Character and player.Character:WaitForChild("HumanoidRootPart")
            if HumanoidRootPart then
                local distance = LocalPlayer:DistanceFromCharacter(player.Character.HumanoidRootPart.Position)

                if distance <= nearest_distance then
                    nearest_player = player
                    nearest_distance = distance
                end
            end
        end
    end

    return nearest_distance, nearest_player
end

function get_bossesNames()
    local bossNames = {}
    for _, v in pairs(Bosses:GetChildren()) do
        table.insert(bossNames, v.Name)
    end

    return bossNames
end

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
    Title = "ability wars",
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

movement:CreateToggle("inf-jump", {
    Title = "inf-jump",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["inf-jump"] = state
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

character:CreateToggle("target-move", {
    Title = "target-move",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["target-move"] = state

        while IS_FLAGS["player"]["target-move"] do
            local _, target = find_target()
            local location

            if not GUI_Functions.PlayerModifiers.Started == true then
                location = Arena.Portal.Position
            else
                location = target.Character.HumanoidRootPart.Position
            end
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.Humanoid:MoveTo(location)
            end

            task.wait()
        end
    end
})

-- auto tabs
local combat = tabs.auto:CreateSection("combat")

combat:CreateDropdown("punch-type", {
    Title = "punch-type",
    Description = "select the type of punch",
    Values = {"blatant", "legit"},
    Multi = false,
    Default = 1,
    Callback = function(options)
        IS_FLAGS["auto"]["punch-type"] = options
    end
})

combat:CreateSlider("player-hit-distance", {
    Title = "player-hit-distance",
    Description = "",
    Default = 18,
    Min = 10,
    Max = 18,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["auto"]["player-hit-distance"] = value
    end
})

combat:CreateSlider("punch-hit-delay", {
    Title = "punch-hit-delay",
    Description = "",
    Default = 0.3,
    Min = 0.3,
    Max = 0.4,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["auto"]["punch-hit-delay"] = value
    end
})

combat:CreateToggle("punch-aura", {
   Title = "punch-aura",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["auto"]["punch-aura"] = state

        repeat
            task.wait(IS_FLAGS["auto"]["punch-hit-delay"])
            for _, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    local Character = v.Character or v.CharacterAdded:Wait()
                                                                                    -- ingore uno reverse
                    if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Left Arm"):FindFirstChild("SelectionBox") == nil then
                        local distance = LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)

                        if distance <= tonumber(IS_FLAGS["auto"]["player-hit-distance"]) then
                            if IS_FLAGS["auto"]["punch-type"] == "blatant" then
                                -- blatant punch (normal punch)
                                Punch:FireServer(ID, Character, Vector3.new(), Character:WaitForChild("HumanoidRootPart"))
                            elseif IS_FLAGS["auto"]["punch-type"] == "legit" then
                                -- legit punch (fast punch)
                                Punch:FireServer(ID, Character, Character:WaitForChild("HumanoidRootPart"))
                            end
                        end
                    end
                end
            end
        until not IS_FLAGS["auto"]["punch-aura"]
   end
})

combat:CreateToggle("kill-boss", {
   Title = "kill-boss",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["auto"]["kill-boss"] = state

        while IS_FLAGS["auto"]["kill-boss"] do
            local bossNames = get_bossesNames()

            if bossNames then
                for _, boss in pairs(Workspace:GetChildren()) do
                    if table.find(bossNames, boss.Name) then
                        Punch:FireServer(ID, boss, boss:WaitForChild("HumanoidRootPart"))
                    end
                end
            end

            task.wait()
        end
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

        if Part_Void then
            Part_Void.CanCollide = IS_FLAGS["anti"]["anti-void"]
            Part_Void.Transparency = (IS_FLAGS["anti"]["anti-void"] and 0.8) or 1
        end
   end
})

local anti_ability = tabs.anti:CreateSection("anti-ability")

anti_ability:CreateToggle("anti-jello", {
   Title = "anti-jello",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["anti"]["anti-jello"] = state

        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Model") then
                if v.Name == "Jello Castle" then
                    local Hitbox = v:FindFirstChild("Hitbox") or v:WaitForChild("Hitbox", 5)
                    if Hitbox then
                        Hitbox.CanTouch = not IS_FLAGS["anti"]["anti-jello"]
                    end
                end
            end
        end
   end
})

anti_ability:CreateToggle("anti-slime", {
   Title = "anti-slime",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["anti"]["anti-slime"] = state

        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Slime Block" then
                v.CanTouch = not IS_FLAGS["anti"]["anti-slime"]
            end
        end
   end
})

anti_ability:CreateToggle("anti-lava", {
   Title = "anti-lava",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["anti"]["anti-lava"] = state

        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Puddle" and v.Name == "Cookie" then
                v.CanTouch = not IS_FLAGS["anti"]["anti-lava"]
            end
        end
   end
})

-- visuals tabs
tabs.visuals:CreateSlider("field-of-view", {
    Title = "field-of-view",
    Description = "",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["visuals"]["field-of-view"] = value
    end
})

local remove = tabs.visuals:CreateSection("remove")

remove:CreateToggle("disable-name-tag", {
   Title = "disable-name-tag",
   Description = "",
   Default = false,
   Callback = function(state)
        IS_FLAGS["visuals"]["disable-name-tag"] = state
            
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then
            local nameTag = head:FindFirstChild("Name Tag")
            
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
            if not GUI_Functions.PlayerModifiers.Started then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Arena.Portal, 0)
                    task.wait(0.1)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, Arena.Portal, 1)
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

local bagde = tabs.misc:CreateSection("bagde")

bagde:CreateButton({
   Title = "get-backrooms",
   Description = "",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2124927822) then
            Get_Bagde.Backrooms()
        else
            Notify("get-backrooms", "You already have this badge", 5)
        end
   end
})

bagde:AddButton({
   Title = "get-cake",
   Description = "",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2124923949) then
            Get_Bagde.Cake()
        else
            Notify("get-cake", "You already have this badge", 5)
        end
   end
})

bagde:AddButton({
   Title = "get-boring",
   Description = "",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2125734830) then
            Get_Bagde.Boring()
        else
            Notify("get-boring", "You already have this badge", 5)
        end
   end
})

bagde:AddButton({
   Title = "get-grocery-shopping",
   Description = "",
   Callback = function()
        if not BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, 2126802066) then
            Get_Bagde.GroceryShopping()
        else
            Notify("get-grocery-shopping", "You already have this badge", 5)
        end
   end
})

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("bobhub")
SaveManager:SetFolder("bobhub/ability-wars")
InterfaceManager:BuildInterfaceSection(tabs.settings)
SaveManager:BuildConfigSection(tabs.settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

-- Initialize anti-void part
if not Workspace:FindFirstChild("anti_void") then
    task.spawn(function()
        Part_Void = Instance.new("Part", Workspace)
        Part_Void.Name = "anti_void"
        Part_Void.Anchored = true
        Part_Void.Size = Vector3.new(10000, 10, 10000)
        Part_Void.CFrame = CFrame.new(0, -2.6, 0)
        Part_Void.Transparency = 1
        Part_Void.Material = "Neon"
        Part_Void.CanCollide = false
        Part_Void.Color = Color3.fromRGB(195, 195, 195)
    end)
end

-- Event connections
table.insert(Connections, Workspace.ChildAdded:Connect(function(child)
    -- anti jello
    if child:IsA("Model") then
        if IS_FLAGS["anti"]["anti-jello"] == true then
            if child.Name == "Jello Castle" then
                local Hitbox = child:FindFirstChild("Hitbox") or child:WaitForChild("Hitbox", 5)
                if Hitbox then
                    Hitbox.CanTouch = false
                end
            end
        end
    end

    -- anti slime
    if child.Name == "Slime Block" and IS_FLAGS["anti"]["anti-slime"] == true then
        child.CanTouch = false
    end

    -- anti lava
    if child.Name == "Puddle" and child.Name == "Cookie" and IS_FLAGS["anti"]["anti-lava"] == true then
        child.CanTouch = false
    end
end))

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(character)
    task.spawn(function()
        repeat task.wait() until character:FindFirstChild("Head")
        local nameTag = character.Head:FindFirstChild("Name Tag")

        if nameTag then
            nameTag.Enabled = not IS_FLAGS["visuals"]["disable-name-tag"]
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
            if GUI_Functions.PlayerModifiers.Ragdolled == true then
                HumanoidRootPart.Anchored = true
            else
                HumanoidRootPart.Anchored = false
            end
        end
    end

    CurrentCamera.FieldOfView = IS_FLAGS["visuals"]["field-of-view"]
end))

table.insert(Connections, UserInputService.JumpRequest:Connect(function()
    if IS_FLAGS["player"]["inf-jump"] == true then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

--[[
-- check when ui is destroyed
local function onDestroy()
    for _, connection in ipairs(Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    for _, var in pairs(IS_FLAGS) do
        print(_, var)
    end

    if Part_Void then
        Part_Void:Destroy()
        Part_Void = nil
    end


    CurrentCamera.FieldOfView = 70
    LocalPlayer.Character:WaitForChild("Head"):FindFirstChild("Name Tag").Enabled = true
end

while true and task.wait() do 
    if Library.Unloaded then 
        onDestroy() 
        break 
    end 
end 
]]