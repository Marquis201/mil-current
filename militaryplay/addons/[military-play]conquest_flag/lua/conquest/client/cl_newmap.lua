
local PANEL = {}

function PANEL:Init()
    self:SetSize(1157, 698)
    self:Center()
    self:MakePopup()

    self:TDLib():Background(Color(32, 32, 32)):Outline(Color(64, 64, 64))

    self.header = self:Add("DPanel")
    self.header:Dock(TOP)
    self.header:SetTall(45)
    self.header:TDLib():ClearPaint():Background(Color(40, 40, 40)):Outline(Color(64, 64, 64))

    local closeBtn = self.header:Add("DButton")
    closeBtn:Dock(RIGHT)
    closeBtn:DockMargin(5, 5, 5, 5)
    closeBtn:SetWide(35)
    closeBtn:SetText('X')
    closeBtn:SetTextColor(color_white)
    closeBtn:TDLib():ClearPaint():Background(Color(231, 76, 60)):Outline(Color(128, 128, 128, 150)):FadeHover():CircleClick()
    closeBtn:On("DoClick", function(s)
        self:Close()
    end)

    self.map = self:Add("Conquest.MapElement")
    self.map:Dock(FILL)
    self.map:DockMargin(5, 5, 5, 5)
end

function PANEL:Close()
    CONQUEST_MAP = nil
    self:Remove()
end

function PANEL:Think()
    if input.IsKeyDown(KEY_F1) then
        self:Close()
    end
end


vgui.Register("Conquest_NewMap", PANEL, "EditablePanel")
