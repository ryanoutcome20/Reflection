--- This is something for testing, your meant to comment out alot of this code. ---
--- I've already done all the work and you can find it in the lists section of  ---
--- the GitHub repo.                                                            ---

-- We have to expect HeX's skidlist, you can find a copy of it here:
-- https://github.com/MFSiNC/SkidCheck-2.0
local Files = file.Find("lua/skidcheck/*.lua", "GAME")

list = { }

for k,File in pairs(Files) do 
    include("skidcheck/" .. File)    
end

MsgN(table.Count(list))

for sid,reason in pairs(list) do 
    file.Append("list.txt", string.format("\n[\"%s\"] = \"%s\"", util.SteamIDTo64(sid), reason))
end

for sid,reason in pairs(list) do 
    local s,e = string.find(reason, "2S: ")
    
    if not s and not  e then
        if s == 1 then
            MsgN(string.sub(reason, 5))
            file.Append("ids1.txt", string.format([[{"%s", MG.."%s"},]] .. "\n", util.SteamIDTo64(sid), string.sub(reason, 5)))
        else
            file.Append("ids2.txt", string.format([[{"%s", CH.."%s"},]] .. "\n", util.SteamIDTo64(sid), reason))
        end
        file.Append("ids3.txt", [[{"%s", MG.."oxide playerlist"},)]])
    end

    file.Append("list2.txt", string.format("\n[\"%s\"] = \"%s\"", util.SteamIDTo64(sid), reason))
end