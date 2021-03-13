net.Receive('matdyn.SaveMaterial', function(_, pl) 
    matdyn.SaveMaterial(net.ReadString(), net.ReadString())
end)

net.Receive('matdyn.Sync', function() 
    for i = 1, net.ReadUInt(32) do
        saveVMFInfo(net.ReadString(), net.ReadString())
    end
end)