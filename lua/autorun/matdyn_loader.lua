AddCSLuaFile()

matdyn = matdyn or {}

if SERVER then
    AddCSLuaFile 'matdyn/sh_data.lua'
    AddCSLuaFile 'matdyn/sh_init.lua'
    AddCSLuaFile 'matdyn/cl_init.lua'

    AddCSLuaFile 'matdyn/vgui/cl_editabledropdown.lua'
    AddCSLuaFile 'matdyn/vgui/cl_editablelist.lua'
    AddCSLuaFile 'matdyn/vgui/cl_editablerow.lua'
    AddCSLuaFile 'matdyn/vgui/cl_colorentry.lua'
    AddCSLuaFile 'matdyn/vgui/cl_vectorentry.lua'

    include 'matdyn/sh_data.lua'
    include 'matdyn/sh_init.lua'
    include 'matdyn/sv_init.lua'
else
    include 'matdyn/sh_data.lua'
    include 'matdyn/sh_init.lua'
    include 'matdyn/cl_init.lua'

    include 'matdyn/vgui/cl_editabledropdown.lua'
    include 'matdyn/vgui/cl_editablelist.lua'
    include 'matdyn/vgui/cl_editablerow.lua'
    include 'matdyn/vgui/cl_colorentry.lua'
    include 'matdyn/vgui/cl_vectorentry.lua'
end