local Color = Color
local types = {
	["yellow"] = Color(255, 246, 116),
	["red"]    = Color(209, 33, 33),
	["blue"]   = Color(54, 169, 240),
	["green"]  = Color(158, 204, 52),
	["purple"] = Color(233, 106, 188),
	["cyan"]   = Color(84, 247, 211),
	["base"]   = Color(199, 181, 137),
}


if SERVER then
	function mp.util.Notify(target, type, text, time)
		NotifyAddText(target, type, text, time)
	end

	function mp.util.ChatPrint(type, target, ...)
		ChatAddText(target, types[type], ...)
	end
else
	function mp.util.Notify(type, text, time)
		notification.AddLegacy(text, type, time or 3)
	end

	function mp.util.ChatPrint(type, ...)
		chat.AddText(types[type], ...)
	end
end

function mp.util.NotifyAll(type, text, time)
	NotifyAddTextAll(type, text, time)
end

function mp.util.ChatPrintAll(type, ...)
	ChatAddTextAll(types[type], ...)
end
