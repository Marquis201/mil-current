SWEP.PrintName = "Briefcase Bomb"

SWEP.Author = "Hoff"
SWEP.Category = "CoD Multiplayer"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 64
SWEP.ViewModel = "models/hoff/weapons/briefcasebomb/c_briefcasebomb.mdl"
SWEP.WorldModel = "models/hoff/weapons/briefcasebomb/w_briefcasebomb.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.UseHands = true

SWEP.HoldType = "fist"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = false

SWEP.Base = "weapon_base"

SWEP.Primary.Damage = 11
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1.9
SWEP.Primary.Delay = 0.1
SWEP.Primary.Force = 17

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Next = CurTime()

SWEP.UseHands = true

-- Цвета как в cl_donate
local color_background = Color(29,29,29,225)
local color_title = Color(52,58,64)
local color_text = Color(163,166,169)
local color_panel = Color(108,117,125)
local color_bottom = Color(33,37,41)
local color_item = Color(41,43,46)
local color_name = Color(239,239,239)
local color_red = Color(255, 88, 88)

function SWEP:Initialize()
	self:SetNWFloat("CurrentCharge",0)
	self:SetNWInt("LocalCountdownTimer", 30)

	self:SetModelScale( 0.8, 0 )

	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	self:GetOwner():EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_raise_v1.wav")
	self:SendWeaponAnim(ACT_VM_DEPLOY)
	self:SetNWFloat("CurrentCharge", 0)
	self:SetNWBool("bCanPress",false)
	timer.Simple(2.5, function()
		if !IsValid(self) then
			return
		end
		self:SetNWBool("bCanPress",true)
	end)

	self.Next = CurTime()

	return true
end

function SWEP:PlayButtonSequence()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_DEPLOYED)
	self:EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_beep_tone1_old.wav")

	timer.Simple(0.25, function()
		if !IsValid(self) then
			return
		end
		self:EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_beep_tone1_old.wav")
	end)
	timer.Simple(0.5, function()
		if !IsValid(self) then
			return
		end
		self:EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_beep_tone5_old.wav")
		self:IncrementCharge()
	end)
end

function SWEP:IncrementCharge()
	if !IsValid(self) then
		return
	end
	local IncrementDirection = 0.2
	if self:GetNWBool("bDefusing") == true then
		IncrementDirection = -0.335
	end
	local NewCharge = self:GetNWFloat("CurrentCharge") + IncrementDirection
	self:SetNWFloat("CurrentCharge", NewCharge)
	timer.Simple(0.1, function()
		if !IsValid(self) then
			return
		end
		if NewCharge >= 1 then
			self:PlantBomb()
		elseif NewCharge <= 0 then
			self:EmitSound("hoff/mpl/briefcase/bomb_defuse_sound_but_really_c4_lol.wav")
			self:FinishDefuse()
		else
			self:SetNWString("bCanPress", true)
		end
	end)
end

function SWEP:PlantBomb()
	self:SetNWString("bCanPress",false)
	self:EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_interrupt_v1.wav")
	timer.Simple(0.2,function()
		if !IsValid(self) then
			return
		end
		self:SendWeaponAnim(ACT_VM_THROW)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		timer.Stop("pressButtons")
		timer.Stop("AddChargeDefuse")
		timer.Simple(1,function()
			if SERVER then
				if !IsValid(self) then
					return
				end
				local briefcaseent = ents.Create("briefcase_bomb")
				briefcaseent:SetPos(self:GetOwner():GetPos() + Vector(0,0,1))
				briefcaseent:Spawn()
				briefcaseent:SetAngles(self:GetOwner():GetAngles() - Angle(0,90,0))
				briefcaseent:DrawShadow( false )
				briefcaseent:SetModelScale( 0.8, 0 )

				undo.Create("Briefcase Bomb")
					undo.AddEntity(briefcaseent)
					undo.SetPlayer(self:GetOwner())
				undo.Finish()

				self:GetOwner():AddCount("sents", briefcaseent) -- Add to the SENTs count ( ownership )
				self:GetOwner():AddCount("my_props", briefcaseent) -- Add count to our personal count
				self:GetOwner():AddCleanup("sents", briefcaseent) -- Add item to the sents cleanup
				self:GetOwner():AddCleanup("my_props", briefcaseent) -- Add item to the cleanup

				timer.Simple(0.5, function()
					if IsValid(self:GetOwner()) then
						self:GetOwner():StripWeapon("weapon_hoff_briefcasebomb")
					end
				end)
			end
		end)
	end)
end

function SWEP:PrimaryAttack()
	if self:GetNWBool("bDefusing") == true then
		return
	end

	if !self:GetNWBool("bCanPress") then
		return
	end

	if self:GetNWFloat("CurrentCharge") == 0 then
		self:SetNWFloat("CurrentCharge", 0.01)
	end

	self:PlayButtonSequence()

	self:SetNextPrimaryFire( CurTime() + 0.8 )
end

function SWEP:Holster()
	if self:GetNWBool("bDefusing") == true then
		return false
	end
	if self:GetNWBool("bCanPress") == false then
		return false
	else
		self:SetNWFloat("CurrentCharge", 0)
		self.Next = CurTime()
		return true
	end
end

function SWEP:SecondaryAttack()
end

if CLIENT then

	-- Шрифты как в cl_donate
	surface.CreateFont("Briefcase_35", {
		font = "Arial",
		antialias = true,
		size = 35
	})

	surface.CreateFont("Briefcase_25", {
		font = "Arial",
		antialias = true,
		size = 25
	})

	surface.CreateFont("Briefcase_22", {
		font = "Arial",
		antialias = true,
		size = 22
	})

	function SWEP:DrawHUD()
		local x = ScrW() / 2.0
		local y = ScrH() / 2.7
		local newcharge = tonumber(self:GetNWFloat("CurrentCharge"))

		if newcharge > 0 then
			local w, h = 200, 18

			-- Фон прогресс бара (стиль cl_donate)
			draw.RoundedBox(4, x - w / 2 - 5, y - h - 5, w + 10, h + 10, color_background)
			
			-- Заполнение прогресс бара
			local progress_color = color_red
			if self:GetNWBool("bDefusing") == true then
				progress_color = Color(88, 255, 88) -- Зеленый для обезвреживания
			end
			
			draw.RoundedBox(4, x - w / 2, y - h, w * newcharge, h, progress_color)

			-- Текст (стиль cl_donate)
			local TextToDisplay = "Установка..."
			if self:GetNWBool("bDefusing") == true then
				TextToDisplay = "Обезвреживание..."
			end

			-- Фон для текста
			local text_w, text_h = 250, 40
			draw.RoundedBox(4, x - text_w/2, y - 85, text_w, text_h, color_item)
			
			-- Текст
			draw.SimpleText(TextToDisplay, "Briefcase_25", x, y - 65, color_name, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			-- Дополнительная информация о прогрессе
			local progress_percent = math.Round(newcharge * 100)
			draw.SimpleText(progress_percent .. "%", "Briefcase_22", x, y - 35, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

SWEP.Offset = {
	Pos = {
		Up = -3,
		Right = 2.5,
		Forward = 6,
	},
	Ang = {
		Up = 70,
		Right = 200,
		Forward = -20,
	}
}

function SWEP:DrawWorldModel( )
	if !IsValid( self:GetOwner() ) then
		self:DrawModel( )
		return
	end

	local bone = self:GetOwner():LookupBone( "ValveBiped.Bip01_R_Hand" )
	if !bone then
		self:DrawModel( )
		return
	end

	local pos, ang = self:GetOwner():GetBonePosition( bone )
	pos = pos + ang:Right() * self.Offset.Pos.Right + ang:Forward() * self.Offset.Pos.Forward + ang:Up() * self.Offset.Pos.Up
	ang:RotateAroundAxis( ang:Right(), self.Offset.Ang.Right )
	ang:RotateAroundAxis( ang:Forward(), self.Offset.Ang.Forward )
	ang:RotateAroundAxis( ang:Up(), self.Offset.Ang.Up )

	self:SetRenderOrigin( pos )
	self:SetRenderAngles( ang )

	self:DrawModel()
end

SWEP.BombOriginalLocation = Vector(0,0,0)
SWEP.BombOriginalRotation = Angle(0,0,0)

function SWEP:StartDefuse(BombLocation, BombRotation, CurrentTime)
	self:SetNWBool("bDefusing", true)
	self:SetNWFloat("CurrentCharge", 1)
	self:SetNWInt("DefuseState", 1)
	self.BombOriginalLocation = BombLocation
	self.BombOriginalRotation = BombRotation

	self:SetNWInt("LocalCountdownTimer",CurrentTime)
	timer.Create("BriefcaseFuse" .. self:GetOwner():UniqueID(),1,8,function()
		if !IsValid(self) then
			return
		end
		local CurrentCountdown = self:GetNWInt("LocalCountdownTimer")
		if CurrentCountdown - 1 <= 0 then
			timer.Remove("BriefcaseFuse" .. self:EntIndex())
			self:Explode()
		else
			self:GetOwner():EmitSound(Sound("weapons/c4/c4_beep1.wav"))
			--self:SetNWInt("LocalCountdownTimer", CurrentCountdown - 1)
		end
	end)

	timer.Simple(1.5, function()
		if !IsValid(self) then
			return
		end
		if self:GetNWInt("DefuseState") == 1 then
			timer.Create("DefuseBombTimer" .. self:GetOwner():UniqueID(), 0.8, 0, function()
				if !IsValid(self) then
					return
				end
				if self:GetNWInt("DefuseState") == 3 then
					timer.Remove("DefuseBombTimer" .. self:GetOwner():UniqueID())
					return
				end
				self:PlayButtonSequence()
			end)
		end
	end)
end

function SWEP:Explode()
	if !SERVER then
		return
	end
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( self:GetPos() )

	explode:SetOwner( self:GetOwner() )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", "220" )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 )
	self:GetOwner():StripWeapon("weapon_hoff_briefcasebomb")
end

function SWEP:FinishDefuse()
	self:SetNWInt("DefuseState", 3)
	timer.Remove("DefuseBombTimer" .. self:GetOwner():UniqueID())
	timer.Remove("BriefcaseFuse " .. self:GetOwner():UniqueID())
	self:GetOwner():EmitSound("ui/buttonclickrelease.wav")
	self:EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_defuse_v1.wav")
	timer.Simple(0.25,function()
		if !IsValid(self) then
			return
		end
		self:SendWeaponAnim(ACT_VM_RELEASE)
		timer.Simple(1.8,function()
			if SERVER and IsValid(self) and IsValid(self:GetOwner()) then
				self:GetOwner():RemoveFlags(FL_ATCONTROLS)
				self:GetOwner():StripWeapon("weapon_hoff_briefcasebomb")
			end
		end)
	end)
end

function SWEP:CancelDefuse()
	timer.Remove("DefuseBombTimer" .. self:GetOwner():UniqueID())
	self:EmitSound("hoff/mpl/briefcase/wpfoly_case_bomb_interrupt_v1.wav")
	if !IsValid(self) || self:GetNWInt("DefuseState") == 3 then
		return
	end
	timer.Simple(0.25,function()
		if !IsValid(self) || self:GetNWInt("DefuseState") == 3 then
			return
		end
		self:SendWeaponAnim(ACT_VM_THROW)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		timer.Stop("pressButtons")
		timer.Stop("AddChargeDefuse")
		if SERVER then
			timer.Simple(0.5,function()
				if !IsValid(self) || self:GetNWInt("DefuseState") == 3 then
					return
				end
				self:GetOwner():RemoveFlags(FL_ATCONTROLS)
				local briefcaseent = ents.Create("briefcase_bomb")
				briefcaseent:SetPos(self.BombOriginalLocation)
				briefcaseent:Spawn()
				briefcaseent:SetAngles(self.BombOriginalRotation)
				briefcaseent:DrawShadow( false )
				briefcaseent:SetModelScale( 0.8, 0 )

				briefcaseent:SetNWInt("CountdownTimer",self:GetNWInt("LocalCountdownTimer"))

				undo.Create("Briefcase Bomb")
					undo.AddEntity(briefcaseent)
					undo.SetPlayer(self:GetOwner())
				undo.Finish()

				self:GetOwner():AddCount("sents", briefcaseent) -- Add to the SENTs count ( ownership )
				self:GetOwner():AddCount("my_props", briefcaseent) -- Add count to our personal count
				self:GetOwner():AddCleanup("sents", briefcaseent) -- Add item to the sents cleanup
				self:GetOwner():AddCleanup("my_props", briefcaseent) -- Add item to the cleanup			
				self:GetOwner():StripWeapon("weapon_hoff_briefcasebomb")
			end)
		end
	end)
end

function SWEP:Think()
	if self:GetNWInt("bDefusing") == true then
		if self.Next < CurTime() then
			if self:GetNWInt("DefuseState") == 3 then
				return
			end
			if self.Owner:KeyDown(IN_USE) then
				if self:GetNWInt("DefuseState") ~= 1 and self:GetNWInt("DefuseState") ~= 2 then
					self.DefuseState = 1
				end
			else
				if self:GetNWInt("DefuseState") ~= 2 and self:GetNWInt("DefuseState") ~= 3 then
					self:SetNWInt("DefuseState", 2)
					self:CancelDefuse()
				end
			end
			self.Next = CurTime() + 0.5
		end
	end
end