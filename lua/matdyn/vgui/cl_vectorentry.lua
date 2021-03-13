local PANEL = {}

function PANEL:Init()
    self.Vector = Vector(0, 0, 0)
    self:DockMargin(0, 0, 0, 0)

    local x = vgui.Create('DNumberWang', self)
    x:SetMinMax(0, 255)
    x:SetDecimals(0)
    x:SetValue(self.Vector.x)
    x.OnValueChanged = function(s, val)
        self.Vector.x = val
    end

    local y = vgui.Create('DNumberWang', self)
    y:SetMinMax(0, 255)
    y:SetDecimals(0)
    y:SetValue(self.Vector.y)
    y.OnValueChanged = function(s, val)
        self.Vector.y = val
    end

    local z = vgui.Create('DNumberWang', self)
    z:SetMinMax(0, 255)
    z:SetDecimals(0)
    z:SetValue(self.Vector.z)
    z.OnValueChanged = function(s, val)
        self.Vector.z = val
    end
end

function PANEL:PerformLayout(w, h)
    local children = self:GetChildren()
    local count = #children
    local width = (w - (count-1) * 2 - 2)/count

    for i, child in pairs(children) do
        child:SetSize(width, h-2)
        child:SetPos(1 + ((i-1) * width) + (i - 1) * 2, 1)
    end
end

function PANEL:SetValue(val)
    if (val.x and val.y and val.z) then
        x:SetValue(val.x or 255)
        y:SetValue(val.y or 255)
        z:SetValue(val.z or 255)
    else
        val = val:Replace(val, '[ ', ''):Replace(' ]', '')

        local values = val:Explode(' ')
        x:SetValue(tonumber((values[1] or '255'):Replace(' ', '')))
        y:SetValue(tonumber((values[2] or '255'):Replace(' ', '')))
        z:SetValue(tonumber((values[3] or '255'):Replace(' ', '')))
    end
end

function PANEL:GetStringValue()
    return Format('[ %f %f %f ]', 
        self.Vector.x, 
        self.Vector.y, 
        self.Vector.z)
end

function PANEL:GetValue()
    return {
        self.Vector.x,
        self.Vector.y,
        self.Vector.z
    }
end
vgui.Register('DYMMVectorEntry3', PANEL, 'DPanel')

local PANEL = {}

function PANEL:Init()
    self.Vector = {x = 0, y = 0, z = 0, f = 0}
    self:DockMargin(0, 0, 0, 0)

    local x = vgui.Create('DNumberWang', self)
    x:SetMinMax(0, 255)
    x:SetDecimals(0)
    x:SetValue(self.Vector.x)
    x.OnValueChanged = function(s, val)
        self.Vector.x = val
    end

    local y = vgui.Create('DNumberWang', self)
    y:SetMinMax(0, 255)
    y:SetDecimals(0)
    y:SetValue(self.Vector.y)
    y.OnValueChanged = function(s, val)
        self.Vector.y = val
    end

    local z = vgui.Create('DNumberWang', self)
    z:SetMinMax(0, 255)
    z:SetDecimals(0)
    z:SetValue(self.Vector.z)
    z.OnValueChanged = function(s, val)
        self.Vector.z = val
    end

    local f = vgui.Create('DNumberWang', self)
    f:SetMinMax(0, 255)
    f:SetDecimals(0)
    f:SetValue(self.Vector.f)
    f.OnValueChanged = function(s, val)
        self.Vector.f = val
    end
end

function PANEL:PerformLayout(w, h)
    local children = self:GetChildren()
    local count = #children
    local width = (w/count) - (count-1) * 2

    for i, child in pairs(children) do
        child:SetWide(width)
        child:SetPos(((i-1) * width) + (i - 1) * 2, 0)
    end
end

function PANEL:SetValue(val)
    if (val.x or val.y or val.z or val.f) then
        x:SetValue(val.x or 255)
        y:SetValue(val.y or 255)
        z:SetValue(val.z or 255)
        f:SetValue(val.f or 255)
    else
        val = val:Replace(val, '[ ', ''):Replace(' ]', '')

        local values = val:Explode(' ')
        x:SetValue(tonumber((values[1] or '255'):Replace(' ', '')))
        y:SetValue(tonumber((values[2] or '255'):Replace(' ', '')))
        z:SetValue(tonumber((values[3] or '255'):Replace(' ', '')))
        f:SetValue(tonumber((values[4] or '255'):Replace(' ', '')))
    end
end

function PANEL:GetStringValue()
    return Format('[ %f %f %f %f ]', 
        self.Vector.x, 
        self.Vector.y, 
        self.Vector.z,
        self.Vector.f)
end

function PANEL:GetValue()
    return {
        self.Vector.x,
        self.Vector.y,
        self.Vector.z,
        self.Vector.f
    }
end
vgui.Register('DYMMVectorEntry4', PANEL, 'DPanel')