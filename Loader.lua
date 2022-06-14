repeat task.wait() until game.GameId ~= 0
if Hub and Hub.Loaded then
    Hub.Utilities.UI:Notification({
        Title = "Hub",
        Description = "Script already executed!",
        Duration = 5
    })
    return
end

getgenv().Hub = {Loaded = false,Debug = false, Current = "Loader",Utilities = {}}
Hub.Utilities.UI = Hub.Debug and loadfile("Hub/Utilities/UI.lua")()
or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Utilities/UI.lua"))()
Hub.Utilities.Drawing = Hub.Debug and loadfile("Hub/Utilities/Drawing.lua")()
or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Utilities/Drawing.lua"))()
Hub.Utilities.Misc = Hub.Debug and loadfile("Hub/Utilities/Misc.lua")()
or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Utilities/Misc.lua"))()

Hub.Games = {
    ["1054526971"] = {
        Name = "Blackhawk Rescue Mission 5",
        Script = Hub.Debug and readfile("Hub/Games/BRM5.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Games/BRM5.lua")
    },
    ["1168263273"] = {
        Name = "Bad Business",
        Script = Hub.Debug and readfile("Hub/Games/BB.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Games/BB.lua")
    }
}

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local function IfGameSupported()
    for Id, Info in pairs(Hub.Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end
end

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
        QueueOnTeleport(Hub.Debug and readfile("Hub/Loader.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Loader.lua"))
    end
end)

local SupportedGame = IfGameSupported()
if SupportedGame then
    Hub.Current = SupportedGame.Name
    loadstring(SupportedGame.Script)()
    Hub.Utilities.UI:Notification({
        Title = "Hub",
        Description = Hub.Current .. " loaded!",
        Duration = 5
    }) Hub.Loaded = true
else
    Hub.Current = "Universal"
    loadstring(Hub.Debug and readfile("Hub/Universal.lua")
    or game:HttpGetAsync("https://raw.githubusercontent.com/jw0902/Hub/main/Universal.lua"))()
    Hub.Utilities.UI:Notification({
        Title = "Hub",
        Description = Hub.Current .. " loaded!",
        Duration = 5
    }) Hub.Loaded = true
end
