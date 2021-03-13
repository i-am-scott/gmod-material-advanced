local PANEL = {}

function PANEL:Init()
    self:DockPadding(0, 0, 0, 0)
    self.Options = {}

    local dropdown = vgui.Create('DComboBox', self)
    dropdown:DockMargin(0, 0, 0, 0)
    dropdown:Dock(LEFT)
    dropdown:SetValue('Keyname')
    dropdown.OnSelect = function(dd, index, value, data)
        self:OnMousePressed(MOUSE_LEFT)
        self.CustomInput:SetText(value)
        self:OnSelect(index, value, data)

        local tbl = self.Options[value]
        if tbl and tbl.Help then
            self:SetTooltip(tbl.Help)
        end
    end

    self.Dropdown = dropdown

    local editManualButton = vgui.Create('DExpandButton', self)
    editManualButton:Dock(FILL)
    editManualButton:DockMargin(0, 0, 0, 0)
    editManualButton:DockPadding(0, 0, 0, 0)
    editManualButton.DoClick = function(btn)
        if self.CustomInput:IsVisible() then
            self.CustomInput:SetVisible(false)
            btn:SetExpanded(false)
        else
            self:OnMousePressed(MOUSE_LEFT)
            self.CustomInput:SetVisible(true)
            self.CustomInput:RequestFocus()
            btn:SetExpanded(true)
        end
    end

    self.EditManualButton = editManualButton

    local customInput = vgui.Create('DTextEntry', self)
    customInput:DockMargin(0, 0, 0, 0)
    customInput:SetText('KeyName')
    customInput:SetVisible(false)
    customInput.OnValueChange = function(txtentry, value)
        if not txtentry:IsVisible() then
            return
        end

        self:OnMousePressed(MOUSE_LEFT)
        self.Dropdown:SetValue(value)
        self:OnSelect(nil, value, self.Options[value])

        local tbl = self.Options[value]
        if tbl and tbl.Help then
            self:SetTooltip(tbl.Help)
        end

        txtentry:SetVisible(false)
        self.EditManualButton:SetExpanded(false)
    end

    customInput.GetAutoComplete = function(s, value)
        value = value:upper():Trim():Trim('$')
        
        local selection = {}
        for id, _ in pairs(self.Options) do
            if id:StartWith(value) then
                table.insert(selection, id)
            end
        end

        return selection
    end
 
    self.CustomInput = customInput
    self:SetValue('KeyName')
end

function PANEL:OnMousePressed(id)
    if IsValid(self:GetParent()) then
        self:GetParent():OnMousePressed(id)
    end
end

function PANEL:PerformLayout(w, h)
    self.Dropdown:SetWide(w-h)
    self.CustomInput:SetSize(w-h, h)
end

function PANEL:SetValue(value)
    self.Dropdown:SetValue(value)
    self.CustomInput:SetText(value)
end

function PANEL:GetSelected()
    return self.Dropdown:GetSelected()
end

function PANEL:AddChoice(id, tbl, select)
    self.Options[id] = tbl
    self.Dropdown:AddChoice(id, tbl, select)
end

function PANEL:OnSelect(index, value, data)
end

function PANEL:Clear()
    self.Dropdown:Clear()
end
vgui.Register('DYMMEditableDropdown', PANEL, 'DPanel')