local pid = game.PlaceId
local LocalPlayer = game.Players.LocalPlayer

local ID_tbl = { [8260276694] = true }

local function load(id:number)
    local s, r = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/BobHub/main/Place/".. id ..".lua"))()
    end)
    if s then
        print('successfully load script')
    end
end

if ID_tbl[pid] == true then
    load(pid)
else
    LocalPlayer:Kick("not supported")
end