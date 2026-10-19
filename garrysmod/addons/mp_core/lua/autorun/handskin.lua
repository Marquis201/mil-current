--[[
player_manager.AddValidModel( "sss", "playermodel" )

player_manager.AddValidHands( "sss", "handsmodel", 0, "0000000" )
models/stalkertnb/bandit3.mdl
]]
if SERVER then
--монорфные
player_manager.AddValidModel( "rf1", "models/arma3/russia/soldier.mdl" )
player_manager.AddValidHands( "rf1", "models/balkanvm.mdl", 0, "0000000" )

--секс инструкторы
player_manager.AddValidModel( "nato1", "models/arma3/nato/soldier.mdl" )
player_manager.AddValidHands( "nato1", "models/notart/veneratedvm.mdl", 0, "0000000" )
end