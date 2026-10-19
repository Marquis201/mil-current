local PANEL = {}
PANEL.View = {}

local scale = 0
local x, y = 0, 0

local circle = Material("nykez/circle.png", "noclamp smooth")
local square = Material("nykez/square.png", "noclamp smooth")

local getMaterials = {}
getMaterials["circle"] = circle
getMaterials["square"] = square

local HoverNum = 0
local HoverX, SizeX
local HoverY, SizeY

local function screenscale(width)
    return (width * (ScrW() / 2560))
end

function PANEL:Init()
    local size = 720
    local setscale = 20

    if ScrH() >= 1080 then
        size = 1000
        setscale = 15
    end

    scale = setscale

    self:SetTitle("")
    self:SetSize(size, size)
    self:Center()
    self:MakePopup()

    HoverNum = 0
    HoverX, SizeX = nil, nil
    HoverY, SizeY = nil, nil

    self.beingHovered = false

    self:ShowCloseButton(false)

    local dx, dy = self:GetPos()
    self.View.angles = Angle(90, 0, 0)
    self.View.ortho = true
    self.View.x = dx + 1
    self.View.y = dy + 1
    self.View.w = self:GetWide() - 2
    self.View.h = self:GetTall() - 2
    self.View.ortholeft = -self.View.w
    self.View.orthoright = self.View.w
    self.View.orthotop = -self.View.h
    self.View.orthobottom = self.View.h
    self.View.dopostprocess = false
    self.View.drawhud = false
    self.View.drawviewmodel = false
    self.View.drawmonitors = false

    self.flag_font = mp.font("16:Futura PT Medium")

    self.color = {
        ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 100),
        ColorOutline = ColorAlpha(mp.Color.BASE, 150),
        ColorOutline2 = ColorAlpha(mp.Color.BASE, 75)
    }
end

local TableButton = {
    [0] = "А",
    [1] = "B",
    [2] = "C",
    [3] = "D",
    [4] = "E",
    [5] = "F",
    [6] = "G",
    [7] = "H",
    [8] = "I",
    [9] = "K",
    [10] = "L",
}

function PANEL:Paint(w, h)
    local pl = LocalPlayer()

    if not IsValid(pl) then return end

    Derma_DrawBackgroundBlur(self)

    surface.SetDrawColor(self.color.ColorOutline)
    surface.DrawOutlinedRect(0, 0, w, h)

    self.View.origin = Vector(x or 0, y or 0, 1000 * scale)
    self.View.ortholeft = -self.View.w * scale
    self.View.orthoright = self.View.w * scale
    self.View.orthotop = -self.View.h * scale
    self.View.orthobottom = self.View.h * scale
    self.View.zfar = 10000 * scale
    render.RenderView(self.View)
    local dx, dy = self:LocalToScreen(0, 0)
    render.SetScissorRect(self.View.x, self.View.y, self.View.x + self.View.w, self.View.y + self.View.h, true)

    render.SetScissorRect(0, 0, 0, 0, false)

    --draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE_TO, 200))


    for k, v in pairs(mp.Territory.Table) do
        if k ~= "base_rf" and k ~= "base_nato" then continue end
        if not v.control then continue end

        local data = mp.faction[v.control]

        if data.logo then
            mp.Icon(w / 2 + (y - (v.pos.x.y + v.pos.y.y) / 2) / scale * 0.5 - 24,
                h / 2 + (x - (v.pos.x.x + v.pos.y.x) / 2) / scale * 0.5 - 24, 48, 48, data.logo, color_white)
        end
    end

    local builtPlayers = {}
    for k, v in pairs(Conquest.cache) do
        local c_color = ColorAlpha(GetIconColor(v), 200)
        mp.Icon(w / 2 + (y - v.position.y) / scale * 0.5 - 16,
            h / 2 + (x - v.position.x) / scale * 0.5 - 16, 32, 32, mp.Material.FLAG, c_color)
        draw.SimpleText(v.tag, self.flag_font, w / 2 + (y - v.position.y) / scale * 0.5 - 1,
            h / 2 + (x - v.position.x) / scale * 0.5 - 1, c_color, 1, 1)
    end

    local plx, ply = w / 2 + (y - LocalPlayer():GetPos().y) / scale * 0.5 - 12,
        h / 2 + (x - LocalPlayer():GetPos().x) / scale * 0.5 - 12


    mp.Icon(plx, ply, 24, 24, mp.Material.USER_SPEC, mp.Color.YELLOW)
    draw.SimpleText("YOU", self.flag_font, plx, ply, color_white, 0, 4)

    local mouseX, mouseY = gui.MouseX(), gui.MouseY()
    local localX, localY = self:ScreenToLocal(mouseX, mouseY)

    local selectedCol = math.floor(localX / (w / 10)) + 1
    local selectedRow = math.floor(localY / (h / 10)) + 1

    local isHovering = localX >= 0 and localX <= w and localY >= 0 and localY <= h
    HoverNum = Lerp(FrameTime() * 4, HoverNum, 0)

    for i = 1, 10 do
        draw.RoundedBox(0, 0, i * h / 10, w, 1, self.color.ColorOutline)
        draw.RoundedBox(0, i * w / 10, 0, 1, h, self.color.ColorOutline)

        draw.SimpleText(i - 1, self.flag_font, 2, ((i - 1) * h / 10) + (h / 10) / 2, mp.Color.BASE, 0, 1)
        draw.SimpleText(TableButton[i - 1], self.flag_font, ((i - 1) * w / 10) + (w / 10) / 2, 2, mp.Color.BASE, 1, 0)
    end

    if isHovering and selectedCol >= 1 and selectedCol <= 10 and selectedRow >= 1 and selectedRow <= 10 then
        local squareW = w / 10
        local squareH = h / 10
        local xPos = (selectedCol - 1) * squareW
        local yPos = (selectedRow - 1) * squareH

        draw.RoundedBox(0, xPos, yPos, squareW + 1, squareH + 1, self.color.ColorOutline2)

        draw.SimpleText(TableButton[selectedCol - 1] .. (selectedRow - 1), self.flag_font, localX, localY,
            mp.Color.ORANGE, 0, 4)
    end

    if HoverX and HoverY and SizeX and SizeY then
        draw.RoundedBox(0, HoverX, HoverY, SizeX, SizeY, ColorAlpha(mp.Color.YELLOW, HoverNum))
    end

    if input.IsKeyDown(KEY_ESCAPE) then
        self:Close()
    end
end

function PANEL:OnMousePressed(lmb)
    if (self.beingHovered) or lmb ~= MOUSE_LEFT then return end
    local w, h = self:GetWide(), self:GetTall()
    local mouseX, mouseY = gui.MouseX(), gui.MouseY()
    local localX, localY = self:ScreenToLocal(mouseX, mouseY)
    local selectedCol = math.floor(localX / (w / 10)) + 1
    local selectedRow = math.floor(localY / (h / 10)) + 1
    local isHovering = localX >= 0 and localX <= w and localY >= 0 and localY <= h

    if isHovering and selectedCol >= 1 and selectedCol <= 10 and selectedRow >= 1 and selectedRow <= 10 then
        local squareW = w / 10
        local squareH = h / 10
        local xPos = (selectedCol - 1) * squareW
        local yPos = (selectedRow - 1) * squareH

        LocalPlayer():ConCommand("say Внимание на квадрат: " .. TableButton[selectedCol - 1] .. (selectedRow - 1))
        HoverNum = 255
        HoverX, HoverY, SizeX, SizeY = xPos, yPos, squareW + 1, squareH + 1
    end
end

function PANEL:AddOriginX(deltaOriginX)
    y = y + deltaOriginX
end

function PANEL:AddOriginY(deltaOriginY)
    x = x + deltaOriginY
end

function PANEL:Think()
    if input.IsButtonDown(KEY_F1) then
        self:Close()
    end
end

function PANEL:OnClose()
    CONQUEST_MAP = nil
end

function PANEL:OnRemove()
end

vgui.Register("Conquest_Map", PANEL, "DFrame")

net.Receive("Conquest_MapOpen", function()
    if CONQUEST_MAP then
        CONQUEST_MAP:Remove()
        CONQUEST_MAP = nil
    end

    timer.Simple(0.1, function()
        CONQUEST_MAP = vgui.Create("Conquest_Map")
    end)
end)

hook.Add("PlayerButtonUp", "conquest.ButtonUp", function(pPlayer, button)
    if not IsFirstTimePredicted() then return end
    if pPlayer ~= LocalPlayer() then return end
    if pPlayer:IsTyping() then return end

    local MAP_BUTTON = Conquest.Config.get("mapKeyBind", 0)

    if (MAP_BUTTON == 0) then return end

    if (MAP_BUTTON == button and Conquest.Config.get("enabledMap", false) == true) then
        if CONQUEST_MAP then
            CONQUEST_MAP:Remove()
            CONQUEST_MAP = nil
        end
        CONQUEST_MAP = vgui.Create("Conquest_Map")
    end
end)
