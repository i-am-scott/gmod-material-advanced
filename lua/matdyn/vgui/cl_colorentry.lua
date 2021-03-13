local PANEL = {}

function PANEL:Init()
    self.Color = Color(255,255,255,255)
    self:DockMargin(0, 0, 0, 0)
    
    local col = vgui.Create('DPanel', self)
    col:DockMargin(0, 0, 0, 0)
    col.Paint = function(s, w, h)
        draw.RoundedBox(2, 0, 0, w, h, self.Color or color_white)
    end

    local r = vgui.Create('DNumberWang', self)
    r:SetTextColor(Color(255, 50,50, 255))
    r:SetMinMax(0, 255)
    r:SetDecimals(0)
    r:SetValue(self.Color.r)
    r.OnValueChanged = function(s, val)
        self.Color.r = val
    end

    local g = vgui.Create('DNumberWang', self)
    g:SetTextColor(Color(50, 255, 50, 255))
    g:SetMinMax(0, 255)
    g:SetDecimals(0)
    g:SetValue(self.Color.g)
    g.OnValueChanged = function(s, val)
        self.Color.g = val
    end

    local b = vgui.Create('DNumberWang', self)
    b:SetTextColor(Color(50, 50, 255, 255))
    b:SetMinMax(0, 255)
    b:SetDecimals(0)
    b:SetValue(self.Color.b)
    b.OnValueChanged = function(s, val)
        self.Color.b = val
    end

    local a = vgui.Create('DNumberWang', self)
    a:SetTextColor(Color(0, 0, 0, 255))
    a:SetMinMax(0, 255)
    a:SetDecimals(0)
    a:SetValue(self.Color.a)
    a.OnValueChanged = function(s, val)
        self.Color.a = val
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
    val = val:Replace(val, '[ ', ''):Replace(' ]', '')

    local values = val:Explode(' ')
    r:SetValue(tonumber(values[1] or 1) * 255)
    g:SetValue(tonumber(values[2] or 1) * 255)
    b:SetValue(tonumber(values[3] or 1) * 255)
    a:SetValue(tonumber(values[4] or 1) * 255)
end

function PANEL:GetStringValue()
    return Format('[ %f %f %f %f ]', 
        self.Color.r/255, 
        self.Color.g/255, 
        self.Color.b/255, 
        self.Color.a/255)
end

function PANEL:GetValue()
    return self.Color
end
vgui.Register('DYMMColorEntry', PANEL, 'DPanel')