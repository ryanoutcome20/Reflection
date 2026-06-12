--[[ ~~~~~~~~~~ ]]--
--[[ Reflection ]]--
--[[ ~~~~~~~~~~ ]]--

-- Don't touch.
local Config = { }

--[[
    This is the main way to disable or enable various lists. Set
    to false to disable a particular list.

    If you add custom lists be sure to follow the correct list
    internal format. Also be sure it avoid adding `.lua` to the
    end of the string in this table. 
--]]

Config.Lists = {
    -- A collection of named bad actors and verified cheaters.
    ["reflection/lists/main"] = true,
    
    -- A collection of cheating, trolling, and minge IDs salvaged from Steam groups.
    ["reflection/lists/groups"] = true,

    -- A collection of cheaters, trolls, and minges from HeX's blacklist.
    ["reflection/lists/hex"] = true,

    -- A collection of cheaters and propkillers whom were detected manually in bad servers.
    ["reflection/lists/servers"] = true
}

--[[
    Set this to false to enable log only mode where it just outputs to the console.
--]]

Config.Kick = true

-- Don't touch.
Reflection.Config = Config
MsgN("  Config Loaded!")
Reflection.LoadLists()

return Config