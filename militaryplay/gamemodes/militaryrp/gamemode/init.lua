AddCSLuaFile('shared.lua')
AddCSLuaFile('sh_include.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')
include('sh_include.lua')

local resource_AddWorkshop = resource.AddWorkshop
local AddWorkshop = {
    -------------------------------------- основа(outdated) -----------------------------------
    --3163462680, -- Military Play - Weapons #1
    --3163469552, -- Military Play - Weapons #2
    --3142833932, -- Military Play - Vehicles #1
    --3163481233, -- Military Play - materials
    --3163487810, -- Military Play - materials 2
    --3142822649, -- Military Play - NPC #1
    --3142821528, -- Military Play - Interface #1
    -- 3153039234, -- MilitaryRP Map - Valkyrie_Fores
    --3602515427, -- map osnova content
    --3602572055, -- map osnova
    --3143700577, -- Military Play - PM #1
    --3163454883, -- Military Play - Vehicles #2
    ----------------------------- DEALER -------------------------------------------
    2652291377, -- digital compass
    2871596225, -- blik
    --3016731330,  -- Gredwitch's Base Explosion Fix
    ----------------------------- основа -------------------------------------------
    3605140228, -- map
    3605134499, -- map content
    3605125660, -- materials
    --3605124591, -- models
    3605130532, -- props 1
    3605131080, -- props 2
    --3605128767, -- vehicles
    3605161894, -- weapon 1
    3606987158, -- weapon 2
    --------------------------------MODELS--------------------------------------------
    2792741460, -- NLG NATO
    792509629,  -- GHOST MODEL
    2639779025, -- SSO-GROM
    2961255498, -- PMC MILITARY
    1340444324, -- general us
    -- 3153039234, -- MilitaryRP Map - Valkyrie_Fores
    2779430576, -- nato model
    3412531403, -- nato model test
    1413026516, -- flags capture
    3599130165, -- Полковник, подполковник
    1562180009, -- SAS
}

for k, v in ipairs(AddWorkshop) do
    resource_AddWorkshop(v)
end
