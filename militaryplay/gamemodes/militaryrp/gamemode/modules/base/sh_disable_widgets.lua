local hook = hook

hook.Add( "PreGamemodeLoaded", "DisableWidget_PreGamemodeLoaded", function()
	widgets.PlayerTick = nil
	hook.Remove( "OnEntityCreated", "CreateWidgets" )
	hook.Remove( "EntityRemoved", "RemoveWidgets" )
	hook.Remove( "PlayerTick", "TickWidgets" )
	hook.Remove( "PostDrawEffects", "RenderWidgets" )
end )
