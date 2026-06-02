--[[ ~~~~~~~~~~ ]]--
--[[ Reflection ]]--
--[[ ~~~~~~~~~~ ]]--

Reflection = {
    Blacklist = { }
}

--- Constants ---

Reflection.Version = "0.0.1"
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
        table.Merge(Reflection.Blacklist, List)
        Reflection.Print("Loaded list `%s` (%s)", Path, string.NiceSize(file.Size(Path, "LUA")))
    else
        Reflection.Print("Couldn't load list: `%s`", Path)
    end
end

--- Load Lists ---

Reflection.Merge("lists/main")
Reflection.Merge("lists/groups")

--- Blacklist ---

function Reflection.CheckAllowed(Player)
    if not Player then
        return
    end

    local SID, oSID = Player:SteamID64(), Player:OwnerSteamID64()

    local BlacklistSID, BlacklistOSID = Reflection.Blacklist[SID], Reflection.Blacklist[oSID]

    if BlacklistSID then
        game.KickID(SID, "[Reflection] Blacklisted: " .. SID)
        Reflection.Print("Kicked `%s`, blacklisted (%s)!", SID, isstring(BlacklistSID) and BlacklistSID or "no id")
        return
    elseif BlacklistOSID then
        game.KickID(ID, "[Reflection] Blacklisted: " .. oSID)
        Reflection.Print("Kicked `%s`, blacklisted owner (%s -> %s)!", SID, oSID, isstring(BlacklistOSID) and BlacklistOSID or "no id")
        return
    end

    Reflection.Print("Verified player: `%s` -> `%s`", SID, Player:Name())
end

hook.Add("PlayerSpawn", "Reflection.CheckAllowed", Reflection.CheckAllowed)

--- Load Message ---

Reflection.Print("Reflection version %s [%s] loaded!", Reflection.Version, Reflection.Edition)