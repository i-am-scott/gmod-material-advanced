local PANEL = {}

PANEL.ValueTypeToPanel = {
    number = 'DNumberWang',
    text = 'DTextEntry',
    string = 'DTextEntry',
    vector = 'DYMMVectorEntry3',
    matrix = 'DTextEntry',
    color = 'DYMMColorEntry',

    /*
        TODO
        texture = "DYMMTextureTree",
        material = "DYMMMaterialTree",
    */
}

function PANEL:Init()
    self:DockPadding(1, 1, 1, 1)
    
    local dropdown = vgui.Create('DYMMEditableDropdown', self)
    dropdown:DockMargin(0,0,0,0)
    dropdown:Dock(LEFT)
    dropdown.OnSelect = function(dropdown, index, value, data)
        self:PopulateValueSelection(value, data)
    end

    self.KeyDropdown = dropdown

    local container = vgui.Create('DPanel', self)
    container:DockMargin(0,0,0,0)
    container:DockPadding(0,0,0,0)
    container:Dock(FILL)

    self.ValueContainer = container

    local removeButton = vgui.Create('DExpandButton', self)
    removeButton:SetExpanded(true)
    removeButton:Dock(RIGHT)
    removeButton:DockMargin(0, 0, 0, 0)
    removeButton:DockPadding(0, 0, 0, 0)
    removeButton:SetBackgroundColor(color_black)
    removeButton:SetWide(22)
    removeButton.DoClick = function(btn)
        self:Remove()
    end
end

function PANEL:PopulateValueSelection(value, data)
    self.ValueContainer:Clear()

    local valueType = data and data.Type or 'string'
    local valuePnlClass = self.ValueTypeToPanel[valueType] or self.ValueTypeToPanel.text

    local valuePnl = vgui.Create(valuePnlClass, self.ValueContainer)
    valuePnl:DockMargin(0, 0, 0, 0)
    valuePnl:Dock(FILL)

    self.ValuePanel = valuePnl
end

function PANEL:PerformLayout(w, h)
    self.KeyDropdown:SetWide(w/2)
end

function PANEL:Populate(knownParams)
    self.Params = knownParams
    self.KeyDropdown:Clear()

    for name, info in pairs(knownParams) do
        self.KeyDropdown:AddChoice(name, info)
    end
end

function PANEL:GetKeyValues()
    local key = self.KeyDropdown:GetSelected()
    local value = IsValid(self.ValuePanel) and self.ValuePanel:GetValue()

    if key and key ~= '' and value and value ~= '' then
        return key, value
    end
end

function PANEL:OnFocusGiven()

end

function PANEL:OnMousePressed(id)
    if id == MOUSE_LEFT then 
        self.Selected = true
        self:OnFocusGiven() 
    end    
end
vgui.Register('DYMMEditableRow', PANEL, 'DPanel')