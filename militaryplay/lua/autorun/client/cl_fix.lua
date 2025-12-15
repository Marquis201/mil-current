net.Receive("dance.yopta", function()
    local bool = net.ReadBool();
    local client = net.ReadPlayer();
    if (not client:IsValid()) then return end;

    if (bool) then
        client:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_TAUNT_DANCE, false)
        return 
    end;

    client:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
end)

local function SoundFix()
    RunConsoleCommand("snd_surround_speakers", "4")
    RunConsoleCommand("snd_surround_speakers", "2")
end

SoundFix()


local toggleDelay = CurTime()