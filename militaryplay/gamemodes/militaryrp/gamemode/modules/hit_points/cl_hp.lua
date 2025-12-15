local net = net
local mp = mp
local stats = mp.body_stats

net.Receive('hp_init', function()
    local ply = LocalPlayer()

    ply.Head = mp.body_stats.head
    ply.Torso = mp.body_stats.torso
    ply.LeftArm = mp.body_stats.l_arm
    ply.RightArm = mp.body_stats.r_arm
    ply.LeftLeg = mp.body_stats.l_leg
    ply.RightLeg = mp.body_stats.r_leg

    ply.Blooding = false
    ply.Fracture = false
    ply.Concussion = false
    ply.Burns = false
end)

net.Receive('hp_update', function()
    local ply = LocalPlayer()

    ply.Head = net.ReadInt(11)
    ply.Torso = net.ReadInt(11)
    ply.LeftArm = net.ReadInt(11)
    ply.RightArm = net.ReadInt(11)
    ply.LeftLeg = net.ReadInt(11)
    ply.RightLeg = net.ReadInt(11)

    ply.Blooding = net.ReadBool()
    ply.Fracture = net.ReadBool()
    ply.Concussion = net.ReadBool()
    ply.Burns = net.ReadBool()
end)
