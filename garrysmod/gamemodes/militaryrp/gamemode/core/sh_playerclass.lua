local PLAYER             = {}
local mp                 = mp
if not mp.config or not mp.config.player_stats then return end

-- Value of -1 = set to config value, if a corresponding setting exists
PLAYER.DisplayName       = "Default Player Class"

PLAYER.WalkSpeed         = mp.config.player_stats.walkspeed -- How fast to move when not running
PLAYER.RunSpeed          = mp.config.player_stats.runspeed  -- How fast to move when running
PLAYER.CrouchedWalkSpeed = 25                   -- Multiply move speed by this when crouching
PLAYER.DuckSpeed         = 0.3                  -- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed       = 0.3                  -- How fast to go from ducking, to not ducking
PLAYER.JumpPower         = mp.config.player_stats.jumppower -- How powerful our jump should be
PLAYER.CanUseFlashlight  = true                 -- Can we use the flashlight
PLAYER.MaxHealth         = mp.config.player_stats.max_health -- Max health we can have
PLAYER.StartHealth       = mp.config.player_stats.start_health -- How much health we start with
PLAYER.StartArmor        = 0                    -- How much armour we start with
PLAYER.DropWeaponOnDie   = false                -- Do we drop our weapon when we die
PLAYER.TeammateNoCollide = true                 -- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers      = true                 -- Automatically swerves around other players
PLAYER.UseVMHands        = true                 -- Uses viewmodel hands

function PLAYER:GetHandsModel()
	-- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

	local playermodel = player_manager.TranslateToPlayerModelName(self.Player:GetModel())
	return player_manager.TranslatePlayerHands(playermodel)
end

player_manager.RegisterClass("player_mp", PLAYER, "player_default")
