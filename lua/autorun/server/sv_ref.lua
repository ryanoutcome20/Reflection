--[[ ~~~~~~~~~~ ]]--
--[[ Reflection ]]--
--[[ ~~~~~~~~~~ ]]--

Reflection = { }

--- Constants ---

Reflection.Version = "0.1.1"
Reflection.Edition = "Pre-Alpha"

Reflection.RED = Color(255,0,0)
Reflection.GREEN = Color(0,255,0)
Reflection.BLUE = Color(0,0,255)
Reflection.YELLOW = Color(255,255,0)
Reflection.GRAY = Color(180,180,180)
Reflection.WHITE = Color(255,255,255)
Reflection.BLACK = Color(0,0,0)
Reflection.SIGNITURE_BLUE = Color(51,153,255)
Reflection.SIGNITURE_GREEN = Color(66,255,96)
Reflection.SIGNITURE_RED = Color(225, 1, 26)
Reflection.SIGNITURE_GOLD = Color(245,194,71)

--- Utility ---

function Reflection.Header()
    MsgN("\n--[[ ~~~~~~~~~~ ]]--\n--[[ Reflection ]]--\n--[[ ~~~~~~~~~~ ]]--\n")
end

function Reflection.Print(Text, ...)
    MsgC(
        color_white,
        "[",
        Reflection.SIGNITURE_GOLD,
        " Reflection ",
        color_white,
        "] ",
        string.format(
            Text,
            ...
        ),
        "\n"
    )
end

function Reflection.Merge(Path)
    local Size = 0

    -- Add regular path.
    local File = Path .. ".lua"
    
    local List = include(File)
    
    Size = Size + file.Size(File, "LUA")

    -- Add sub paths.
    for i = 2, math.huge do 
        local File = string.format("%s_%d.lua", Path, i)

        if not file.Exists(File, "LUA") then
            break
        end

        table.Add(List, include(File))

        Size = Size + file.Size(File, "LUA")
    end

    -- Compile into main blacklist (merge).
    if istable(List) then
        for k, Info in pairs(List) do 
            local ID, Reason = Info[1], Info[2]

            if not ID or not Reason then
                Reflection.Print("Invalid list index from `%s`: %i", Path, k)
                continue
            end
            
            if Reflection.Blacklist[ID] then
                Reflection.Blacklist[ID] = Reflection.Blacklist[ID] .. ", " .. Reason
            else
                Reflection.Blacklist[ID] = Reason
            end
        end

        MsgN("  Loaded list `" .. Path .. "` (" .. string.NiceSize(Size) .. ")")
    else
        MsgN("  Couldn't load list: `" .. Path .. "`")
    end
end

Reflection.Header()

--- Load Lists ---

function Reflection.LoadLists()
    MsgN("  Loading lists...")
    
    Reflection.Blacklist = { }
    
    for Path, Enabled in pairs(Reflection.Config.Lists) do 
        if Enabled then
            Reflection.Merge(Path)
        end
    end
end

concommand.Add("reflection_reload", Reflection.LoadLists)

--- Load Config ---

include("reflection/config/server.lua")

if not Reflection.Config then
    MsgN("  Missing config path `reflection/config/server.lua`, did you delete it?")
    MsgN("  Recommended to reinstall Reflection: https://github.com/ryanoutcome20/Reflection")
    return
end

--- Counter ---

function Reflection.Counter()
    Reflection.Print("Actively protecting the server from %i registered cheaters!", table.Count(Reflection.Blacklist))
end

concommand.Add("reflection_counter", Reflection.Counter)

--- Blacklist ---

function Reflection.CheckAllowed(Player)
    if not Player then
        return
    end

    local SID, oSID = Player:SteamID64(), Player:OwnerSteamID64()

    local BlacklistSID, BlacklistOSID = Reflection.Blacklist[SID], Reflection.Blacklist[oSID]

    if BlacklistSID then
        if Reflection.Config.Kick then
            game.KickID(SID, "[Reflection] Blacklisted: " .. SID)
        end

        Reflection.Print("`%s`, blacklisted! Reason: \"%s\"", SID, BlacklistSID)
        return
    elseif BlacklistOSID then
        if Reflection.Config.Kick then
            game.KickID(ID, "[Reflection] Blacklisted: " .. oSID)
        end
        
        Reflection.Print("`%s`, blacklisted owner (%s -> %s)!", SID, oSID, isstring(BlacklistOSID) and BlacklistOSID or "no id")
        return
    end

    Reflection.Print("Verified player: `%s` -> `%s`", SID, Player:Name())
end

hook.Add("PlayerInitialSpawn", "Reflection.CheckAllowed", Reflection.CheckAllowed)

--- Load Message ---

MsgN("  Reflection version " .. Reflection.Version .. " [" .. Reflection.Edition .. "] loaded!\n")

MsgN("  Open Source Software")
MsgN("  github.com/ryanoutcome20/Reflection")

Reflection.Header()