echat.addon = esclib:Addon("echat")
echat.addon:SetName("Military Play")
echat.addon:SetBranch("release")
echat.addon:SetVersion("1.0")
echat.addon:SetDescription("Chat")

if CLIENT then
	echat.addon:SetColor(Color(255,255,73))
	echat.addon:SetThumbnail(echat:GetMaterial("echat_icon.png"))
end
