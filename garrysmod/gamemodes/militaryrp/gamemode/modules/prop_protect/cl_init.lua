local HookAdd = hook.Add

mp.pp = mp.pp or {}

HookAdd("CanTool", "mp.CanTool", function(pl, trace, mode)
	local ent = trace.Entity
	return IsValid(ent) and (ent:CPPIGetOwner() == true)
end)

HookAdd('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent)
	return false
end)

function mp.pp.SharePropMenu()
	--[[local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Поделиться Пропами')
		self:Center()
		self:MakePopup()
	end)
	local x, y = fr:GetDockPos()
	local sharedPlayers
	local unSharedPlayers

	ui.Create('DLabel', function(self)
		self:SetPos(x, y - 2)
		self:SetFont('ui.20')
		self:SetText('Добавить игрока')
		self:SizeToContents()
	end, fr)

	ui.Create('DLabel', function(self)
		self:SetPos(x + (fr:GetWide() * 0.5) + 5, y - 2)
		self:SetFont('ui.20')
		self:SetText('Удалить игрока')
		self:SizeToContents()
	end, fr)

	local sharedKeys = LocalPlayer():GetNetVar('ShareProps') or {}
	unSharedPlayers = ui.Create('ui_playerrequest', function(self, p)
		self:SetPos(x, y + 20)
		self:SetSize((fr:GetWide() * 0.5) - 7.5, (fr:GetTall() - y) - 25)

		self.LayoutPlayers = function(self)
			self:SetPlayers(table.Filter(player.GetAll(), function(v)
				return (sharedKeys[v] == false or sharedKeys[v] == nil)
			end))

			self.PlayerList:AddPlayers()
		end

		self.OnSelection = function(self, row, pl)
			cmd.Run('shareprops', pl:SteamID())

			sharedKeys[pl] = true

			self:LayoutPlayers()
			sharedPlayers:LayoutPlayers()
		end

		self:LayoutPlayers()
	end, fr)

	sharedPlayers = ui.Create('ui_playerrequest', function(self, p)
		self:SetPos(x + unSharedPlayers:GetWide() + 7.5, y + 20)
		self:SetSize((fr:GetWide() * 0.5) - 7.5, (fr:GetTall() - y) - 25)

		self.LayoutPlayers = function(self)
			self:SetPlayers(table.Filter(player.GetAll(), function(v)
				return (sharedKeys[v] == true and sharedKeys[v] ~= nil)
			end))

			self.PlayerList:AddPlayers()
		end

		self.OnSelection = function(self, row, pl)
			cmd.Run('shareprops', pl:SteamID())

			sharedKeys[pl] = false

			self:LayoutPlayers()
			unSharedPlayers:LayoutPlayers()
		end

		self:LayoutPlayers()
	end, fr)]]
end
