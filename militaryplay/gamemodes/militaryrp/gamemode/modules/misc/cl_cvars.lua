--[[local cmdlist = {
	r_shadows = { 1, GetConVarNumber },
	r_shadowrendertotexture = { 0, GetConVarNumber },
	r_shadowmaxrendered = { 0, GetConVarNumber },
	r_WaterDrawReflection = { 0, GetConVarNumber },
	r_3dsky = { 0, GetConVarNumber },
	mat_shadowstate = { 0, GetConVarNumber },
	cl_phys_props_enable = { 0, GetConVarNumber },
	cl_phys_props_max = { 0, GetConVarNumber },
	props_break_max_pieces = { 0, GetConVarNumber },
	r_propsmaxdist = { 0, GetConVarNumber },
	r_drawmodeldecals = { 0, GetConVarNumber },
	cl_threaded_bone_setup = { 1, GetConVarNumber },
	cl_threaded_client_leaf_system = { 1, GetConVarNumber },
	r_threaded_client_shadow_manager = { 1, GetConVarNumber },
	r_threaded_particles = { 1, GetConVarNumber },
	r_threaded_renderables = { 1, GetConVarNumber },
	r_queued_ropes = { 1, GetConVarNumber },
	studio_queue_mode = { 1, GetConVarNumber },
	mat_queue_mode = { 2, GetConVarNumber },
	gmod_mcore_test = { 1, GetConVarNumber },
	//fov_desired = { 90, GetConVarNumber },
	cl_updaterate = { 24, GetConVarNumber },
	cl_cmdrate = { 24, GetConVarNumber },
	cl_timeout = { 900, GetConVarNumber },
	cl_interp_ratio = { 2, GetConVarNumber },
	r_waterforceexpensive = { 0, GetConVarNumber },
	violence_agibs = { 0, GetConVarNumber },
	violence_hgibs = { 0, GetConVarNumber },
	r_WaterDrawRefraction = { 0, GetConVarNumber },
	mat_specular = { 0, GetConVarNumber },
	r_radiosity = { 2, GetConVarNumber },
}

local detours = {}
local orig_drawmodel = GetConVarNumber("r_drawmodeldecals")

for k,v in pairs( cmdlist ) do
	detours[k] = v[2](k)
	RunConsoleCommand(k, v[1])
end

hook.Add("NetworkEntityCreated", "FpsFixModel", function(ent)
    timer.Simple(1, function()
		if IsValid(ent) then
			ent.RenderOverride = function()
				if IsValid(ent) and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 4000) then
					ent:DrawModel()
				end
			end
		end
    end)
end)

hook.Add( 'ShutDown', 'FlameDev.Cvars.ShutDown', function()
	for k,v in pairs(detours) do
		RunConsoleCommand(k,v)
		RunConsoleCommand("r_drawmodeldecals", orig_drawmodel)
	end
end)--]]

timer.Create("ClearDecals", 300, 0, function()
	RunConsoleCommand("r_cleardecals", "")
end)

