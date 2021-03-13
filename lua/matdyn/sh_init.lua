matdyn.MaterialPath = 'matdym'
file.CreateDir(matdyn.MaterialPath)

matdyn.ShowLogs =  CreateConVar('matdyn_logs', '1', bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED), 'Display print logs in console. Useful for debugging.')
matdyn.AllowAllShaders = CreateConVar('matdyn_shaders_allow_all', '1', bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED), 'Allow any key value shader parameters')
matdyn.AllowAnyShaderParams = CreateConVar('matdyn_shaders_allow_any_keys', '1', bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED), 'Allow any key value shader parameters')
matdyn.ShaderMaxParams = CreateConVar('matdyn_shaders_max_params', '15', bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED), 'The maximum amount of keys a material can have. 0 = Infinite, Max 50')
matdyn.AllowProxies = CreateConVar('matdyn_proxies_allow', '1', bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED), 'Allow the creation of proxies')
matdyn.CreationCooldown = CreateConVar('matdyn_cooldown', '2', bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED), 'How long in seconds you must wait to create another material. Minimum of 1 second.')

matdyn.CleanValues = {
    number = function(self, val)
        if isstring(val) then
            val = tonumber(val)
        end
        return math.Round(val, 4)
    end,
    string = function(self, val)
        val = val:Replace('..', ''):Replace('\\', '/'):gsub('(^[A-z0-0%.%-%+_/ ])', ''):sub(0, matdyn.ShaderParamValueMaxLength)
        return val
    end,
    text = function(self, val)
        return self:string(val)
    end,
    matrix = function(self, val)
        return self:string(val)
    end,
    texture = function(self, val)
        return self:string(val):Replace('materials/', '')
    end,
    vector = function(self, val)
        var.x = math.Clamp(math.Round(val.x, 3), -5000, 5000)
        var.y = math.Clamp(math.Round(val.y, 3), -5000, 5000)
        var.z = math.Clamp(math.Round(val.z, 3), -5000, 5000)
        return {var.x, var.y, var.z}
    end,
    color = function(self, val)
        var.r = math.Clamp(math.Round(val.r, 3), 0, 255)
        var.g = math.Clamp(math.Round(val.g, 3), 0, 255)
        var.b = math.Clamp(math.Round(val.b, 3), 0, 255)
        var.a = math.Clamp(math.Round(val.b, 3), 0, 255)
        return {var.r, var.g, var.b, var.a}
    end,
}

local blue = Color(150, 150, 255, 255)
function matdyn.log(message, throwError)
    if matdyn.ShowLogs:GetBool() then
        MsgC(blue, '[MATDYN LOG] ' .. message .. '\n')

        if throwError then
            ErrorNoHalt(message)
        end
    end
end

function matdyn.CreateMaterial(pl, id, shader, keyValues)
    if pl.matdynNextCooldown and pl.matdynNextCooldown > CurTime() then
        matdyn.log('Creation cooldown')
        return
    end

    id = pl:AccountID() .. '_' .. id:gsub('(^[%w_-])', ''):lower()
    shader = shader:sub(0, 150)

    if not matdyn.ShaderInfo[shader] then
        matdyn.log('Invalid shader given. Must be in matdyn.ShaderInfo')
        return
    end

    local maxParams = math.Clamp(matdyn.ShaderMaxParams:GetInt() or 10, 0, 50)
    if maxParams > 0 and table.Count(keyValues) > maxParams then
        matdyn.log('Too many paramters given.')
        return
    end

    local allowAllParams = matdyn.AllowAnyShaderParams:GetBool()
    local cleanedKeyValueTbl = {}

    for key, value in pairs(keyValues) do
        local paramInfo = matdyn.ShaderParams[key]
        if not allowAllParams and not paramInfo or matdyn.ShaderParamBlacklist[key:upper()] then
            matdyn.log('Only known param keys are allowed or the key is blacklisted. Given: ' .. key)
            continue
        end

        matdyn.log(key .. ' : ' .. (paramInfo and paramInfo.Type or 'UNKNOWN'))

        local cleanFunc = matdyn.CleanValues[ paramInfo and paramInfo.Type or 'string' ] or matdyn.CleanValues.string
        cleanedKeyValueTbl['$' .. key:sub(0, matdyn.ShaderParamKeyMaxLength)] = cleanFunc(matdyn.CleanValues, value)
    end

    local keyValueString = util.TableToKeyValues(cleanedKeyValueTbl, shader)

    if SERVER then
        net.Start 'matdyn.SaveMaterial'
            net.WriteString(id)
            net.WriteString(shader)
            net.WriteString(keyValueString)
        net.Broadcast()
    end

    pl.matdynNextCooldown = CurTime() + math.Max(matdyn.CreationCooldown:GetInt() or 1, 1)
    return matdyn.SaveMaterial(id, keyValueString)
end

function matdyn.SaveMaterial(id, keyValues)
    local path = matdyn.MaterialPath .. '/' .. id
    file.Write(path .. '.vmt', keyValues)

    -- Traverse back to the data path since materialName is relative to materials/
    local mat = Material('../data/' .. path)
    mat:Recompute()

    matdyn.log('Material Path: ../data/' .. path)
    matdyn.log(keyValues)

    return mat
end