util.AddNetworkString 'matdyn.Create'
util.AddNetworkString 'matdyn.Update'
util.AddNetworkString 'matdyn.Remove'

hook.Add('OnPlayerSpawned', 'matdyn.SyncMaterialInfo', function(pl) 
    net.Start 'matdyn.Sync'
        net.WriteUInt(table.Count(materials), 32)
        for id, tbl in pairs(materials) do
            net.WriteString(id)
            net.WriteString(tbl.Shader)
            net.WriteString(tbl.KeyValueParams)
        end
    net.Send(pl)
end)

net.Receive('matdyn.Create', function(_, pl) 
    local id = net.ReadString()
    local shader = net.ReadString()

    local params = {}
    local pcount = net.ReadUInt(8)

    for i = 1, pcount do
        local key = net.ReadString()
        local val = net.ReadType(net.ReadUInt(6))

        params[key] = val
    end

    matdyn.CreateMaterial(pl, id, shader, params)
end)

do
    local files = file.Find(matdyn.MaterialPath, 'DATA')
    for _, path in ipairs(files) do
        file.Delete(matdyn.MaterialPath .. '/' .. path)
    end
end