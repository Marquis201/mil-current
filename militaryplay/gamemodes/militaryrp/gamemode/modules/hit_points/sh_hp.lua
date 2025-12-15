local PLAYER = PLAYER

function PLAYER:GetHead()
    return self.Head
end

function PLAYER:GetToso()
    return self.Torso
end

function PLAYER:GetLeftArm()
    return self.LeftArm
end

function PLAYER:GetRightArm()
    return self.RightArm
end

function PLAYER:GetLeftLeg()
    return self.LeftLeg
end

function PLAYER:GetRightLeg()
    return self.RightLeg
end

function PLAYER:GetBlooding()
    return self.Blooding
end

function PLAYER:GetFracture()
    return self.Fracture
end

function PLAYER:GetConcussion()
    return self.Concussion
end

function PLAYER:GetBurns()
    return self.Burns
end

mp.body_stats = {
    head = 35,
    torso = 60,
    l_arm = 40,
    r_arm = 40,
    l_leg = 50,
    r_leg = 50
}

local stats = mp.body_stats

function PLAYER:GetBrokenLimbs()
    if self.Head <= 0 or self.Torso <= 0 or self.LeftArm <= 0 or self.RightArm <= 0 or self.LeftLeg <= 0 or self.RightLeg <= 0 then
        return true
    end
end

function PLAYER:GetDamagedLimbs()
    if self.Head <= stats.head / 2 or self.Torso <= stats.torso / 2 or self.LeftArm <= stats.l_arm / 2 or self.RightArm <= stats.r_arm / 2 or self.LeftLeg <= stats.l_leg / 2 or self.RightLeg <= stats.r_leg / 2 then
        return true
    end
end

function PLAYER:GetAllDamagedLimbs()
    if self.Head < stats.head or self.Torso < stats.torso or self.LeftArm < stats.l_arm or self.RightArm < stats.r_arm or self.LeftLeg < stats.l_leg or self.RightLeg < stats.r_leg then
        return true
    end
end
