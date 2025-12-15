function PLAYER:GetChanelRadio()
    return tonumber(self:GetNWInt('ChanelRadio'))
end

function PLAYER:GetRadioOwner()
    return self:GetNWBool('OwnerRadio')
end

function PLAYER:GetRadioSpeak()
    return self:GetNWBool('SpeakRadio')
end

function PLAYER:GetRadioMicro()
    return self:GetNWBool('MicroRadio')
end