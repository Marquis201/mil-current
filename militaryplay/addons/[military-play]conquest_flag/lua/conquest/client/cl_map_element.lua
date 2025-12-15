

local PANEL = {}

local circle = Material("nykez/circle.png", "noclamp smooth")
local square = Material("nykez/square.png", "noclamp smooth")

local getMaterials = {}
getMaterials["circle"] = circle
getMaterials["square"] = square


function PANEL:Init()
    self.scale = 1.8
    self.view = {}

    self.mousePosX, self.mousePosY = gui.MousePos()

    self.lpX = LocalPlayer():GetPos().x
    self.lpY = LocalPlayer():GetPos().y

    local spawnsEnabled = Conquest.Config.get("spawning", false)

    self.showTeams = Conquest.Config.get("showTeammates", false)
    self.contestedSpawns = Conquest.Config.get("nocontestedSpawns", false)

    if (spawnsEnabled ) then
        self.spawning = true
    end

    self.teamPlayers = {}

    self.beingHovered = false

    self.buttonPanels = {}

    local w = self:GetWide()
    local h = self:GetTall()

    if (spawnsEnabled) then
        for k,v in pairs(Conquest.cache) do

            self.buttonPanels[k] = vgui.Create('DButton', self)
            self.buttonPanels[k]:SetSize(64, 64)
            self.buttonPanels[k]:SetVisible(false)
            self.buttonPanels[k]:SetText("")
            self.buttonPanels[k]:SetPos(w / 2 + (self.lpY - v.position.y) / self.scale * 0.5, h / 2 + (self.lpX - v.position.x) / self.scale * 0.5 - 32 + 12)

            self.buttonPanels[k].id = v
        end
    end

end

function PANEL:Paint(w, h)
    local x, y = self:LocalToScreen(0, 0)
        
    render.RenderView( {
        origin = Vector( self.lpX, self.lpY, 1000 * self.scale ),
        angles = Angle( 90, 0, 0 ),
        x = x, 
        y = y,
        w = w, 
        h = h,
        dopostprocess = false,
        drawhud = false,
        drawviewmodel = false,
        drawmonitors = false,
        ortho = true,
        ortholeft = -w * self.scale,
        orthoright = w * self.scale,
        orthotop = -h * self.scale,
        orthobottom = h * self.scale,
        zfar = 10000 * self.scale
    } )

    local dx, dy = self:LocalToScreen(0, 0)
    render.SetScissorRect(x, y, x + w, y + h, true)


    local builtPlayers = {}
    for k,v in pairs(Conquest.cache) do

        if (self.showTeams) then

            if (v.teamBased and v.teamBased) then
                
                local customTeam = Conquest.TeamManager.QuickCache[LocalPlayer():Team()]
                for k,v in pairs(player.GetAll()) do
                    if v == LocalPlayer() then continue end

                    if (Conquest.TeamManager.QuickCache[v:Team()] == customTeam) then
                        
                        table.insert(builtPlayers, v)

                    end

                end


            else

                if (v.category) and (v.category == true) then
                    for k,v in pairs(player.GetAll()) do
                        if v == LocalPlayer() then continue end
                        if v:getJobTable().category == LocalPlayer():getJobTable().category then
                            
                        table.insert(builtPlayers, v)

                        end
                    end
                else

                    for k,v in pairs(player.GetAll()) do
                        if v == LocalPlayer() then continue end

                        if v:Team() == LocalPlayer():Team() then

                            table.insert(builtPlayers, v)

                        end

                    end
                end
            
            end

        end

        if (v.isCapturing) or (v.isContested) then

            local clr = GetIconColor(v)

            surface.SetMaterial(getMaterials[tostring(v.shape)])
            surface.SetDrawColor(clr.r, clr.g, clr.b,  math.abs(math.sin(CurTime()*4)*255))
            surface.DrawTexturedRectRotated(w / 2 + (y - v.position.y) / self.scale * 0.5, h / 2 + (x - v.position.x) / self.scale * 0.5 - 32 + 12, 64, 64, 0)

        else

            surface.SetMaterial(getMaterials[tostring(v.shape)])
            surface.SetDrawColor(GetIconColor(v))
            surface.DrawTexturedRectRotated(w / 2 + (y - v.position.y) / self.scale * 0.5, h / 2 + (x - v.position.x) / self.scale * 0.5 - 32 + 12, 64, 64, 0)

        end
        
        draw.SimpleTextOutlined(v.tag, "Conquest_Button1", w / 2 + (y - v.position.y) / self.scale * 0.5, h / 2 + (x - v.position.x) / self.scale * 0.5 - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, nil, 2, Color(0, 0, 0, 255))
		
        if (self.buttonPanels[k]) then
            self.buttonPanels[k]:SetVisible(true)
            self.buttonPanels[k]:SetPos(w / 2 + (y - v.position.y) / self.scale * 0.5 - 25, h / 2 + (x - v.position.x) / self.scale * 0.5 - 58 + 12)

            self.buttonPanels[k].Paint = function(s, w, h)
            end

            self.buttonPanels[k].DoClick = function(s)
                if self.contestedSpawns == true and v.isCapturing then return end
                net.Start("conquest_spawnon")
                    net.WriteTable(self.buttonPanels[k].id)
                net.SendToServer()

                CONQUEST_MAP:Close()
                CONQUEST_MAP = nil

            end

            self.buttonPanels[k].OnCursorEntered = function()
                self.beingHovered = true
            end

            self.buttonPanels[k].OnCursorExited = function()
                self.beingHovered = false
            end

        end
    end

    for k,v in pairs(builtPlayers) do
        surface.SetDrawColor(255, 255, 255, 255)
        draw.NoTexture()
        ConquestCircle(w / 2 + (y - v:GetPos().y) / self.scale * 0.5, h / 2 + (x - v:GetPos().x) / self.scale * 0.5 - 20, 16, 32)
    end

    if input.IsKeyDown(KEY_ESCAPE) then
      self:Close()
    end
end

function PANEL:OnCursorEntered()
    self.beingHovered = true
end

function PANEL:OnCursorExited()
    self.beingHovered = false
end

function PANEL:OnMouseWheeled(delta)
    self.scale = math.Clamp(self.scale - delta * 0.3, 1.8, 10)
end

function PANEL:OnMousePressed(btn)
    if (!self.beingHovered) then return end 
    self.mousePosX, self.mousePosY = input.GetCursorPos()
    self.cachePosX, self.cachePosY = input.GetCursorPos()
end

function PANEL:OnMouseReleased()
    if (!self.beingHovered) then return end 
    self.mousePosX, self.mousePosY = gui.MousePos()
end

function PANEL:MoveX(deltaX)
    self.lpY = self.lpY + deltaX
end

function PANEL:MoveY(deltaY)
    self.lpX = self.lpX + deltaY
end

function PANEL:ComputeDelta( diff )
    if (!self.beingHovered) then return end
    if diff > -1 and diff < 1 then return 0 end

    return -( diff * self.scale )
end

function PANEL:Think()

    if (input.IsButtonDown(MOUSE_LEFT)  and (self.beingHovered) ) then
        local mousePosX, mousePosY = gui.MousePos()

        local deltaX = self:ComputeDelta( self.mousePosX - mousePosX )
        local deltaY = self:ComputeDelta( self.mousePosY - mousePosY )

        self:MoveX( deltaX )
        self:MoveY( deltaY )


        self.mousePosX, self.mousePosY = gui.MousePos()
    end
end

vgui.Register("Conquest.MapElement", PANEL, "EditablePanel")