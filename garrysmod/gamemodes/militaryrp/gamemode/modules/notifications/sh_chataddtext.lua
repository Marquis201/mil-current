do
	local Tag = "ChatAddText"

	if SERVER then
		util.AddNetworkString(Tag)

		function ChatAddText(target, ...)
			net.Start(Tag)
			net.WriteTable({ ... })
			net.Send(target)
		end

		function ChatAddTextAll(...)
			net.Start(Tag)
			net.WriteTable({ ... })
			net.Broadcast()
		end
	end

	if CLIENT then
		local function receive()
			local data = net.ReadTable()
			if not istable(data) then return end

			chat.AddText(unpack(data))
		end

		net.Receive(Tag, receive)
	end
end

do
	local Tag = "NotifyAddText"

	if SERVER then
		util.AddNetworkString(Tag)

		function NotifyAddText(target, type, text, time)
			if not type then return end
			net.Start(Tag)
			net.WriteUInt(type, 4)
			net.WriteString(text)
			net.WriteUInt(time or 3, 6)
			net.Send(target)
		end

		function NotifyAddTextAll(type, text, time)
			if not type then return end
			net.Start(Tag)
			net.WriteUInt(type, 4)
			net.WriteString(text)
			net.WriteUInt(time or 3, 6)
			net.Broadcast()
		end
	end

	if CLIENT then
		local function receive()
			local type = net.ReadUInt(4)
			local text = net.ReadString()
			local time = net.ReadUInt(6)
			if not text or not type then return end

			notification.AddLegacy(text, type, time or 3)
		end

		net.Receive(Tag, receive)
	end
end
