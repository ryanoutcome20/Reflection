--[[ ~~~~~~~~~~ ]]--
--[[ Reflection ]]--
--[[ ~~~~~~~~~~ ]]--

Reflection = { }

--- Constants ---

Reflection.Version = "0.0.3"
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
    Path = Path .. ".lua"

    local List = include(Path)

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

        Reflection.Print("Loaded list `%s` (%s)", Path, string.NiceSize(file.Size(Path, "LUA")))
    else
        Reflection.Print("Couldn't load list: `%s`", Path)
    end
end

--- Load Lists ---

function Reflection.LoadLists()
    Reflection.Blacklist = { }
    
    Reflection.Merge("lists/main")
    Reflection.Merge("lists/groups")
    Reflection.Merge("lists/groups_2")
end

concommand.Add("reflection_reload", Reflection.LoadLists)

Reflection.LoadLists()

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
        game.KickID(SID, "[Reflection] Blacklisted: " .. SID)
        Reflection.Print("Kicked `%s`, blacklisted! Reason: \"%s\"", SID, BlacklistSID)
        return
    elseif BlacklistOSID then
        game.KickID(ID, "[Reflection] Blacklisted: " .. oSID)
        Reflection.Print("Kicked `%s`, blacklisted owner (%s -> %s)!", SID, oSID, isstring(BlacklistOSID) and BlacklistOSID or "no id")
        return
    end

    Reflection.Print("Verified player: `%s` -> `%s`", SID, Player:Name())
end

hook.Add("PlayerInitialSpawn", "Reflection.CheckAllowed", Reflection.CheckAllowed)

--- Load Message ---

Reflection.Print("Reflection version %s [%s] loaded!", Reflection.Version, Reflection.Edition)