if game.PlaceId ~= 8260276694 then
    return 
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
--local PathfindingService = game:GetService('PathfindingService');
local BadgeService = game:GetService('BadgeService');
local TextChatService = game:GetService('TextChatService');
local Workspace = game:GetService('Workspace');

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild('Backpack')
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerScripts = LocalPlayer:WaitForChild('PlayerScripts')

-- module
local GUI_Functions = require(PlayerScripts:WaitForChild('GUI Functions'))

local Arena = Workspace.Portals['Arena Frame']
local MapItems = Workspace:WaitForChild('Map Items')
local Secrets = Workspace.Secrets

local Bosses = ReplicatedStorage:WaitForChild('Bosses')
local RemoteEvents = ReplicatedStorage:WaitForChild('Remote Events')
local Punch = RemoteEvents.Punch

local RBXGeneral = TextChatService.TextChannels.RBXGeneral

local ID = 314159265359; -- but this is anti-exploit id

local IS_FLAGS = {
    ["player"] = {
        ["speed-slider"] = 21,
        ["speed-enable"] = false,
        ["jump-slider"] = 50,
        ["jump-enable"] = false,
        ["inf-jump"] = false,
        ["no-clip"] = false,
        -- ["no-ragdoll"] = false,
    },
    ["auto"] = {
        ["punch-hit-delay"] = 0.25,
        ["player-hit-distance"] = 17,
        ["punch-aura"] = false,
        ["punch-type"] = "blatant",
        ["kill-boss"] = false,
    },
    ["anti"] = {
        ["anti-void"] = false,
        ["anti-jello"] = false,
        -- ["anti-soap"] = false,
    },
    ["visuals"] = {
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

local Phrases_Chat = {
    -- made by hqt but he didn't know make script, also i wanna thank you for help me mke toxic
    "you are no match for my skill, go cry to your daddy about losing",
    "you're useless and loud-bad combo.",
    "bozo with a big mouth and no skills.",
    "you are a bozo, just quit and go touch grass if you are so bad.",
    "ez, you are so bad that you make me want to cry.",
    "call admin for ban me, you are bozo",
}

function get_bossesNames()
    local bossNames = {}
    for _, v in pairs(Bosses:GetChildren()) do
        if v:IsA("Folder") then
            table.insert(bossNames, v.Name)
        end
    end
    return bossNames
end

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

local tabs = {
    player = Window:CreateTab({ Title = "player", Icon = "" }),
    auto = Window:CreateTab({ Title = "auto", Icon = "" }),
    anti = Window:CreateTab({ Title = "anti", Icon = "" }),
    visuals = Window:CreateTab({ Title = "visuals", Icon = "" }),
    misc = Window:CreateTab({ Title = "misc", Icon = "" }),
    settings = Window:CreateTab({ Title = "settings", Icon = "" })
}

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
    end
})

local character = tabs.player:CreateSection("character")

character:CreateToggle("no-clip", {
    Title = "no-clip",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["no-clip"] = state
    end
})

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
    Default = 17,
    Min = 0,
    Max = 17,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["auto"]["player-hit-distance"] = value
    end
})

combat:CreateSlider("punch-hit-delay", {
    Title = "punch-hit-delay",
    Description = "",
    Default = 0.25,
    Min = 0.2,
    Max = 0.3,
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
            for k, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    local Character = v.Character
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
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and table.find(bossNames, v.Name) then
                        Punch:FireServer(ID, v, v:WaitForChild("HumanoidRootPart"))
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

-- visuals tabs
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
                local randomPhrase = Phrases_Chat[math.random(1, #Phrases_Chat)]
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

Window:SelectTab(2)

SaveManager:LoadAutoloadConfig()

-- Initialize anti-void part
task.spawn(function()
    Part_Void = Instance.new("Part", Workspace)
    Part_Void.Name = "anti_void"
    Part_Void.Anchored = true
    Part_Void.Size = Vector3.new(10000, 10, 10000)
    Part_Void.CFrame = CFrame.new(0, -2.47101189, 0)
    Part_Void.Transparency = 1
    Part_Void.Material = "Neon"
    Part_Void.CanCollide = false
    Part_Void.Color = Color3.fromRGB(146, 145, 145)
end)

-- Event connections
table.insert(Connections, Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        if child.Name == "Jello Castle" and IS_FLAGS["anti"]["anti-jello"] == true then
            local Hitbox = child:FindFirstChild("Hitbox") or child:WaitForChild("Hitbox", 5)
            if Hitbox then
                Hitbox.CanTouch = false
            end
        end
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
    for _, child in pairs(Character:GetDescendants()) do
        if child:IsA("BasePart") then
            child.CanCollide = not IS_FLAGS["player"]["no-clip"]
        end
    end
end))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        if IS_FLAGS["player"]["speed-enable"] then
            humanoid.WalkSpeed = IS_FLAGS["player"]["speed-slider"]
        else
            humanoid.WalkSpeed = 16 -- default walk speed
        end

        if IS_FLAGS["player"]["jump-enable"] == true then
            humanoid.JumpPower = IS_FLAGS["player"]["jump-slider"]
        else
            humanoid.JumpPower = 50 -- default jump power
        end
    end
end))

--[[
-- check when ui is destroyed
local function onDestroy()
    for _, connection in pairs(Connections) do
        if connection then
            connection:Disconnect()
        end
    end

    if Part_Void then
        Part_Void:Destroy()
        Part_Void = nil
    end

    Notify("Fluent UI", "UI has been destroyed", 5)
end
]]

