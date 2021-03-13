local PANEL = {}

local blue = Color(100, 100, 255)
local red = Color(200, 100, 100)

function PANEL:Init()
    self:DockPadding(0, 0, 0, 0)
    self:DockMargin(10, 5, 10, 5)
    
    self.Rows = {}
    self.AvailableOptions = {}

    local controlBar = vgui.Create('DPanel', self)
    controlBar:DockPadding(0, 0, 0, 0)
    controlBar:DockMargin(0, 0, 0, 5)
    controlBar:SetTall(20)
    controlBar:Dock(TOP)

    local controlTitle = vgui.Create('DLabel', controlBar)
    controlTitle:DockPadding(0, 0, 0, 0)
    controlTitle:DockMargin(3, 0, 0, 0)
    controlTitle:Dock(FILL)
    controlTitle:SetTextColor(color_black)
    controlTitle:SetText('Key-Value List')

    local addBtn = vgui.Create('DExpandButton', controlBar)
    addBtn:DockMargin(0, 0, 0, 0)
    addBtn:Dock(RIGHT)
    addBtn:SetWide(22)
    addBtn.DoClick = function(btn)
        self:AddField()
    end

    local controlList = vgui.Create('DScrollPanel', self)
    controlList:DockPadding(0, 0, 0, 0)
    controlList:DockMargin(0, 0, 0, 0)
    controlList:Dock(FILL)
    controlList.Paint = function(s, w, h)
        derma.SkinHook('Paint', 'Panel', s, w, h)
    end

    self.ControlPanel = controlList
end

function PANEL:SetOptions(tbl)
    self.AvailableOptions = tbl

    for _, pnl in pairs(self.Rows) do
        if IsValid(pnl) then
            pnl:Populate(self.AvailableOptions)
        end
    end
end

function PANEL:AddField()
    local row = vgui.Create('DYMMEditableRow', self.ControlPanel)
    row:Populate(self.AvailableOptions)
    row.OnFocusGiven = function(s)
        self.SelectedField = s
    end

    table.insert(self.Rows, row)
    self.SelectedField = row

    row:Dock(TOP)
    self.ControlPanel:AddItem(row)
end

function PANEL:RemoveField()
    if IsValid(self.SelectedField) then
        self.SelectedField:Remove()
    end
end

function PANEL:GetKeyValues()
    local keyValues = {}

    for _, pnl in pairs(self.Rows) do
        if IsValid(pnl) and pnl.GetKeyValues then
            local key, value = pnl:GetKeyValues()
            if key then
                keyValues[key] = value
            end
        end
    end

    return keyValues
end

function PANEL:Paint()
    
end
vgui.Register('DYMMEditableList', PANEL, 'DPanel')