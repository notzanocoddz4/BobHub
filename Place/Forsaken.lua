if game.PlaceId ~= 18687417158 then
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
local HttpService = game:GetService('HttpService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local RunService = game:GetService('RunService');
local Lighting = game:GetService('Lighting');
local Workspace = game:GetService('Workspace');

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TemporaryUI = PlayerGui.TemporaryUI

-- module
local Sprinting_Module = require(ReplicatedStorage.Systems.Character.Game.Sprinting)

local Ingame = Workspace:WaitForChild("Map").Ingame
local Survivors = Workspace.Players.Survivors
local Killers = Workspace.Players.Killers

local IS_FLAGS = {
    ["player"] = {
        ["sprint-slider"] = 0,
        ["sprint-enable"] = false,
        ["inf-stamina"] = false,
    },
    ["auto"] = {
        ["solve-delay"] = 0,
        ["auto-solve-generator"] = false,
    },
    ["anti"] = {
        ["disable-cam-shaker"] = false,
    },
    ["visuals"] = {
        ["generator-esp"] = false,
        ["item-esp"] = false,
        ["survivor-esp"] = false,
        ["killer-esp"] = false,
        ["field-of-view-slider"] = 70,
        ["full-bright"] = false,
    },
}

local Connections = {}
local ItemNames = {"BloxyCola", "Medkit"}

local Color = {
    ["Generator"] = Color3.fromRGB(250, 169, 82),
    ["Item"] = {
        ["BloxyCola"] = Color3.fromRGB(165, 164, 56),
        ["Medkit"] = Color3.fromRGB(158, 11, 10),
    },
    ["Survivor"] = Color3.fromRGB(0, 255, 0),
    ["Killer"] = Color3.fromRGB(255, 0 , 0),
}

-- esp library by bocaj111004
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/ESPLibrary/main/main.lua"))()

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

function In_Map()
    local Map = Ingame:FindFirstChild("Map")
    if Map then
        return true
    end

    return false
end

function find_PuzzleGenerator()
    local PuzzleUI = PlayerGui:FindFirstChild("PuzzleUI")
    if PuzzleUI then
        return true
    end

    return false
end

-- Creating a window
local Window = Library:CreateWindow({
    Title = "forsaken",
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
    -- misc = Window:CreateTab({ Title = "misc", Icon = "folder-open" }),
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

movement:CreateSlider("sprint-slider", {
    Title = "sprint-slider",
    Description = "",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["player"]["sprint-slider"] = value
    end
})

movement:CreateToggle("sprint-enable", {
    Title = "sprint-enable",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["sprint-enable"] = state

        if not IS_FLAGS["player"]["sprint-enable"] then
            LocalPlayer.Character.SpeedMultipliers.Sprinting.Value = 1
        end
    end
})

movement:CreateToggle("inf-stamina", {
    Title = "inf-stamina",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["player"]["inf-stamina"] = state
    end
})

-- auto tabs
local setup = tabs.auto:CreateSection("setup")

setup:CreateSlider("solve-delay", {
    Title = "solve-delay",
    Description = "",
    Default = 0.3,
    Min = 0.3,
    Max = 0.5,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["auto"]["solve-delay"] = value
    end
})

setup:CreateToggle("auto-solve-generator", {
    Title = "auto-solve-generator",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["auto"]["auto-solve-generator"] = state

        while IS_FLAGS["auto"]["auto-solve-generator"] do
            local inPuzzle = find_PuzzleGenerator()
            if inPuzzle then
                for _, map in pairs(Ingame.Map:GetChildren()) do
                    if map.Name == "Generator" then
                        map.Remotes.RE:FireServer()
                        task.wait(IS_FLAGS["auto"]["solve-delay"])
                    end
                end
            end
            task.wait(.1)
        end
    end
})

local notifiter = tabs.auto:CreateSection("notifiter")

notifiter:CreateToggle("item-spawned", {
    Title = "item-spawned",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["auto"]["item-spawned"] = state
    end
})

-- anti tabs
local remove = tabs.anti:CreateSection("remove")

remove:CreateToggle("disable-cam-shaker", {
    Title = "disable-cam-shaker",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["anti"]["disable-cam-shaker"] = state
    end
})

-- visuals tabs
local esp = tabs.visuals:CreateSection("esp")

esp:CreateToggle("generator-esp", {
    Title = "generator-esp",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["visuals"]["generator-esp"] = state

        local inMap = In_Map()
        if inMap then
            for _, gen in pairs(Ingame.Map:GetChildren()) do
                if gen.Name == "Generator" then
                    if IS_FLAGS["visuals"]["generator-esp"] then
                        ESPLibrary:AddESP({
                            Text = gen.Name,
                            Object = gen,
                            Color = Color[gen.Name]
                        })
                    else
                        ESPLibrary:RemoveESP(gen)
                    end
                end
            end
        end
    end
})

esp:CreateToggle("item-esp", {
    Title = "item-esp",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["visuals"]["item-esp"] = state

        local inMap = In_Map()
        if inMap then
            for _, item in pairs(Ingame:GetChildren()) do
                if table.find(ItemNames, item.Name) then
                    if IS_FLAGS["visuals"]["item-esp"] then
                        ESPLibrary:AddESP({
                            Text = item.Name,
                            Object = item,
                            Color = Color["Item"][item.Name]
                        })
                    else
                        ESPLibrary:RemoveESP(item)
                    end
                end
            end
        end
    end
})

esp:CreateToggle("survivor-esp", {
    Title = "survivor-esp",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["visuals"]["survivor-esp"] = state

        local inMap = In_Map()
        if inMap then
            for _, sv in pairs(Survivors:GetChildren()) do
                if sv:IsA("Model") then
                    if IS_FLAGS["visuals"]["survivor-esp"] then
                        ESPLibrary:AddESP({
                            Text = sv.Name .. "\n" .. sv:GetAttribute("Username"),
                            Object = sv,
                            Color = Color["Survivor"]
                        })
                    else
                        ESPLibrary:RemoveESP(sv)
                    end
                end
            end
        end
    end
})

esp:CreateToggle("killer-esp", {
    Title = "killer-esp",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["visuals"]["killer-esp"] = state

        local inMap = In_Map()
        if inMap then
            for _, ks in pairs(Killers:GetChildren()) do
                if ks:IsA("Model") then
                    if IS_FLAGS["visuals"]["killer-esp"] then
                        ESPLibrary:AddESP({
                            Text = ks.Name .. "\n" .. ks:GetAttribute("Username"),
                            Object = ks,
                            Color = Color["Killer"]
                        })
                    else
                        ESPLibrary:RemoveESP(ks)
                    end
                end
            end
        end
    end
})

local camera = tabs.visuals:CreateSection("camera")

camera:CreateSlider("field-of-view-slider", {
    Title = "field-of-view-slider",
    Description = "",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 1,
    Callback = function(value)
        IS_FLAGS["visuals"]["field-of-view-slider"] = value
    end
})

camera:CreateToggle("full-bright", {
    Title = "full-bright",
    Description = "", 
    Default = false,
    Callback = function(state)
        IS_FLAGS["visuals"]["full-bright"] = state

        if IS_FLAGS["visuals"]["full-bright"] then
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 10
        else
            Lighting.Brightness = 3
            Lighting.GlobalShadows = true
        end
    end
})

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("bobhub")
SaveManager:SetFolder("bobhub/forsaken")
InterfaceManager:BuildInterfaceSection(tabs.settings)
SaveManager:BuildConfigSection(tabs.settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()


-- Events Connections
table.insert(Connections, Ingame.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        if table.find(ItemNames, child.Name) then
            if IS_FLAGS["auto"]["item-spawned"] == true then
                Notify("item-spawned", child.Name .. " has spawned!", 5)
            end

            if IS_FLAGS["visuals"]["item-esp"] == true then
                ESPLibrary:AddESP({
                    Text = child.Name,
                    Object = child,
                    Color = Color["Item"][child.Name]
                })
            end
        end
    end
end))

table.insert(Connections, Ingame.DescendantAdded:Connect(function(child)
    if child:IsA("Model") then
        if child.Name == "Generator" then
            if IS_FLAGS["visuals"]["generator-esp"] == true then
                ESPLibrary:AddESP({
                    Text = child.Name,
                    Object = child,
                    Color = Color[child.Name]
                })
            end
        end
    end
end))

table.insert(Connections, Survivors.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        if IS_FLAGS["visuals"]["survivor-esp"] == true then
            ESPLibrary:AddESP({
                Text = child.Name .. "\n" .. child:GetAttribute("Username"),
                Object = child,
                Color = Color["Survivor"]
            })
        end
    end
end))

table.insert(Connections, Killers.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        if IS_FLAGS["visuals"]["killer-esp"] == true then
            ESPLibrary:AddESP({
                Text = child.Name .. "\n" .. child:GetAttribute("Username"),
                Object = child,
                Color = Color["Killer"]
            })
        end
    end
end))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if IS_FLAGS["visuals"]["full-bright"] == true then
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 10
    end
end))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if IS_FLAGS["player"]["sprint-enable"] == true then
        LocalPlayer.Character.SpeedMultipliers.Sprinting.Value = IS_FLAGS["player"]["sprint-slider"]
    end
    
    -- cam shaker
    LocalPlayer.PlayerData.Settings.Customization.ScreenShakeEnabled.Value = not IS_FLAGS["anti"]["disable-cam-shaker"]
    LocalPlayer.PlayerData.Settings.Customization.ScreenShakeOnLow.Value = not IS_FLAGS["anti"]["disable-cam-shaker"]

    Workspace.CurrentCamera.FieldOfView = IS_FLAGS["visuals"]["field-of-view-slider"]
    Sprinting_Module.StaminaLossDisabled = IS_FLAGS["player"]["inf-stamina"]
end))