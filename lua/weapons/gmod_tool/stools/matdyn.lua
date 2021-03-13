TOOL.Category = 'Render'
TOOL.Name = 'Materials - Dynamic'
TOOL.ClientConVar['id'] = 'testid'

TOOL.Information = {
	{ name = 'left' },
	{ name = 'right' },
    { name = 'reload' },
}

local MaterialPreview
local EditableList
local black = Color(0, 0, 0, 255)

if CLIENT then
	language.Add('Tool.matdyn.name', 'Materials - Dynamic')
	language.Add('Tool.matdyn.id', 'Material ID')
	language.Add('Tool.matdyn.help', 'This is prefixed with your SteamID. If you create a new material with the same ID then it will be replaced instead.')
	language.Add('Tool.matdyn.left', 'Sets your custom material on the entity')
	language.Add('Tool.matdyn.right', 'Preview the material on this entity locallaly')
	language.Add('Tool.matdyn.reload', 'Reset the entities material.')
	language.Add('Tool.matdyn.desc', 'Create custom materials.')
end

local function showMaterial()
	if MaterialPreview and MaterialPreview.PreviewMaterial then
		hook.Add('HUDPaint', 'matdyn.PreviewMaterial', function() 
			if MaterialPreview.PreviewMaterial then
				draw.DrawText('DynMat Preview:', 'Trebuchet18', 5, 230, color_white)
		
				surface.SetMaterial(MaterialPreview.PreviewMaterial)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(5, 250, 128, 128)
			end
		end)
	end
end

function TOOL:LeftClick(trace)
	if IsValid(trace.Entity) then
		local accid = self:GetOwner():AccountID()
		local path = '../data/' .. matdyn.MaterialPath .. '/' .. accid .. '_' .. self:GetClientInfo('id'):gsub('(^[%w_-])', ''):lower()
		trace.Entity:SetMaterial(path, true)
	end
end

function TOOL:RightClick(trace)
	if IsValid(trace.Entity) then
		trace.Entity:SetMaterial ''
	end
end

function TOOL:Deploy()
	showMaterial()
end

function TOOL:Holster()
	hook.Remove('HUDPaint', 'matdyn.PreviewMaterial')
end

function TOOL.BuildCPanel(cpnl)
	cpnl:AddControl('Header', {
        Description = '#tool.matdyn.desc'
    })

    cpnl:AddControl('Textbox', {
        Label = '#Tool.matdyn.id',
        Command = 'matdyn_id', 
        Help = true
    })

	MaterialPreview = vgui.Create('DPanel', cpnl)
	MaterialPreview:Dock(TOP)
	MaterialPreview:SetTall(256)
	MaterialPreview:DockMargin(10, 5, 10, 5)
	MaterialPreview:SetVisible(false)

	local materialPreviewText = vgui.Create('DLabel', MaterialPreview)
	materialPreviewText:Dock(TOP)
	materialPreviewText:SetTextColor(color_black)
	materialPreviewText:SetText('Material Preview')

	MaterialPreview.Paint = function(s, w, h)
		if s.PreviewMaterial then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(s.PreviewMaterial)
			surface.DrawTexturedRect(10, 10, w-20, h-20)
		end
	end

	local panel = vgui.Create('DPanel', cpnl)
	panel:DockMargin(10, 10, 10, 10)
	panel:Dock(TOP)

	local ddown = vgui.Create('DComboBox', panel)
	ddown:DockMargin(0, 0, 0, 0)
	ddown:Dock(FILL)
	ddown:SetValue('Select Shader')

	local shaderKeys = table.GetKeys(matdyn.ShaderInfo)
	table.sort(shaderKeys)

	for i, shader in ipairs(shaderKeys) do
		ddown:AddChoice(shader, matdyn.ShaderInfo[shader])
	end

	ddown.OnSelect = function(self, index, value, data)
		-- EditableList:SetOptions(data)
		EditableList.SelectedShader = value
		EditableList:SetOptions(matdyn.ShaderParams)
	end

	local submit = vgui.Create('DButton', panel)
	submit:DockMargin(2, 0, 0, 0)
	submit:Dock(RIGHT)
	submit:SetWide(120)
	submit:SetText 'Send Material'
	submit.DoClick = function(s)
		if not EditableList.SelectedShader then
			matdyn.log('EditableList.SelectedShader is missing')
			return
		end

		local id = GetConVar('matdyn_id'):GetString()
		local keyValues = EditableList:GetKeyValues()

		if (not id or id:Trim() == '') or (not keyValues or table.Count(keyValues) == 0) then
			matdyn.log('id is missing/empty and/or keyvalues is empty.')
			return
		end
 
		local mat = matdyn.CreateMaterial(LocalPlayer(), id, EditableList.SelectedShader, keyValues)
		MaterialPreview.PreviewMaterial = mat

		showMaterial()
	end

	submit.OnRemove = function(pnl)
		hook.Remove('HUDPaint', pnl)
	end

	EditableList = vgui.Create('DYMMEditableList', cpnl)
    EditableList:Dock(TOP)
	EditableList:SetTall(388)
end