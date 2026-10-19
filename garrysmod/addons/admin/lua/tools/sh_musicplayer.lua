
serverguard.musicBox = serverguard.musicBox or {}
	
if (SERVER) then
	AddCSLuaFile();
else
	serverguard.netstream.Hook("sgMusicBoxPlay", function(data)
		serverguard.musicBox:PlayId(data[1], data[2]);
	end);

	concommand.Add("musicbox_stop", function()
		serverguard.musicBox:Stop();
	end);

	concommand.Add("musicbox_pause", function()
		serverguard.musicBox:Pause();
	end);
		
	concommand.Add("musicbox_resume", function()
		serverguard.musicBox:Play();
	end);
		
	surface.CreateFont( "musicbox_titlefont", {	
		["font"] = "verdana",
		["size"] = 18,
		["weight"] = 768,
		["shadow"] = true,
		["antialias"] = true
	});
		
	surface.CreateFont( "musicbox_timefont", {		
		["font"] = "verdana",
		["size"] = 14,
		["weight"] = 768,
		["shadow"] = true,
		["antialias"] = true
	});
		
	function serverguard.musicBox:Stop() self._html:RunJavascript( 'stop();' ) self:SetPlaying( false ) end
	function serverguard.musicBox:Pause() self._html:RunJavascript( 'pause();' ) self:SetPlaying( false ) end
	function serverguard.musicBox:Play() self._html:RunJavascript( 'resume();' ) self:SetPlaying( true ) end
	
	function serverguard.musicBox:GetDeltaTime()
		if self._startTime then 
			return CurTime() - self._startTime;
		end;

		return 0;	
	end;
		
	function serverguard.musicBox:SetDuration(duration) self._duration = duration end
	function serverguard.musicBox:GetDuration() return self._duration or 0 end
		
	function serverguard.musicBox:SetStartTime(time) self._startTime = time end
	function serverguard.musicBox:GetStartTime() return self._duration or 0 end
		
	function serverguard.musicBox:SetTitle(title) self._title = title end
	function serverguard.musicBox:GetTitle() return self._title or "None" end
		
	function serverguard.musicBox:SetPlaying(bPlaying) self._playing = bPlaying end
	function serverguard.musicBox:IsPlaying() return self._playing or false end
		
	function serverguard.musicBox:SetLoading(bLoading) self._loading = bLoading end
	function serverguard.musicBox:IsLoading() return self._loading or false end
		
	function serverguard.musicBox:SetVideo(id, time) self._html:RunJavascript( string.format( 'play( "%s", "%s" );', id, time ) )  end
		
	function serverguard.musicBox:GetInfo(id, callback)
		http.Fetch(string.format("http://gdata.youtube.com/feeds/api/videos/%s?v=2&alt=jsonc", id), function(data)
			data = util.JSONToTable( data ).data
			callback(data)
		end)
	end
		
	function serverguard.musicBox:GetThumbnail()
		self._thumbnailHtml:UpdateHTMLTexture();

		return self._thumbnailHtml:GetHTMLMaterial();
	end;
		
	function serverguard.musicBox:PlayUrl( url, time )
		local id = string.match(url, "^[A-Za-z0-9%.%-]*%.youtube%.com/watch%?.*v=([A-Za-z0-9_%-]+)")

		if (id) then
			self:PlayId(id, time);
		end;
	end;
		
	function serverguard.musicBox:PlayId(id, time)
		time = time or 0;
			
		self:SetLoading(true);
		self:Stop();
		self:GetInfo(id, function(data)
			if (data.accessControl.embed == "allowed") then
				self._thumbnailHtml:OpenURL(data.thumbnail.sqDefault);
					
				if (!self:GetVolume()) then
					self:SetVolume(50);
				end;
					
				self:SetVideo(id, time);
				self:Pause();
					
				self:SetDuration(data.duration);
				self:SetTitle(data.title);
					
				timer.Simple(2, function()
					self:SetStartTime(CurTime() - time);
					self:SetLoading(false);
					self:Play();
				end);
			else
				print("YouTube video: '"..data.title.."' may not be embedded!");
			end;
		end);
	end;
		
	function serverguard.musicBox:GetVolume() return self._volume end
	function serverguard.musicBox:SetVolume(volume) 
		volume = math.Clamp(volume, 0, 100);
			
		self._html:RunJavascript(string.format('setVolume( "%s" )', volume));
		self._volume = volume;
	end;
		
	function serverguard.musicBox:CreateHTML()
		if (!IsValid( self._html)) then
			local html = vgui.Create("HTML");
				html:SetSize(480, 300);
				html:OpenURL("http://gmodserverguard.com/assets/player.html");
				html:SetMouseInputEnabled(false);
			html:SetPaintedManually(true);

			local thumbnail = vgui.Create("HTML");
				thumbnail:SetSize(120, 90);
				thumbnail:SetMouseInputEnabled(false);
			thumbnail:SetPaintedManually(true);
					
			self._html = html;
			self._thumbnailHtml = thumbnail;
		else
			self:Stop();
		end;
	end;
		
	hook.Add( "Think", "musicbox_think", function()
		if serverguard.musicBox:IsPlaying() then
			if serverguard.musicBox:GetDeltaTime() > serverguard.musicBox:GetDuration() then
				serverguard.musicBox:Stop();
			end;
		end;
	end);
	
	hook.Add("HUDPaint", "musicbox_draw", function()
		if (serverguard.musicBox:IsPlaying() or serverguard.musicBox:IsLoading()) then
			surface.SetFont( "musicbox_titlefont" )
				
			if (serverguard.musicBox:IsPlaying()) then
				local textWidth, textHeight = surface.GetTextSize( serverguard.musicBox:GetTitle() )
				local width, height = math.Clamp( textWidth, 220, textWidth ), 8
				local boxWidth, boxHeight = width + 8, height + textHeight + 22
				local x, y = ScrW() / 2 - width / 2, input.IsKeyDown( KEY_C ) and 38 or 8
					
				surface.SetDrawColor( Color( 0, 0, 0, 96 ) )
				surface.DrawRect( x - 4, y - 4, boxWidth, boxHeight )
					
				surface.SetTextColor( Color( 255, 255, 255 ) )
				surface.SetTextPos( x, y - 2 )
				surface.DrawText( serverguard.musicBox:GetTitle() )
					
				surface.SetDrawColor( Color( 0, 0, 0 ) )
				surface.DrawRect( x, y + textHeight, width, height )
					
				surface.SetDrawColor( Color( 190, 225, 180 ) )
				surface.DrawRect( x + 1, y + 1 + textHeight, ( width - 2 ) / serverguard.musicBox:GetDuration() * serverguard.musicBox:GetDeltaTime(), height - 2 )
					
				local timeText = string.FormattedTime( serverguard.musicBox:GetDeltaTime(), "%2i:%02i" ) .. "/" .. string.FormattedTime( serverguard.musicBox:GetDuration(), "%2i:%02i" )
				surface.SetFont( "musicbox_timefont" )
				surface.SetTextColor( Color( 255, 255, 255, 196 ) )
				surface.SetTextPos( x + width - surface.GetTextSize( timeText ), y + textHeight + height + 1 )
				surface.DrawText( timeText )
				
				if serverguard.musicBox:GetDeltaTime() < 0.05 then		
					surface.SetDrawColor( Color( 255, 255, 255 ) )
					surface.DrawRect( x - 4, y - 4, width + 8, height + textHeight + 22 )
				end
					
				local controlX, controlY = x + 5, y + boxHeight - 14
				local controlWidth = 96
						
				surface.SetDrawColor( Color( 0, 0, 0 ) )
				surface.DrawRect( controlX, controlY, controlWidth, 2 )
						
				surface.DrawRect( controlX - 5 + controlWidth / 100 * serverguard.musicBox:GetVolume(), controlY - 4, 10, 10 )
				surface.SetDrawColor( Color( 220, 220, 220 ) )
				surface.DrawRect( controlX - 4 + controlWidth / 100 * serverguard.musicBox:GetVolume(), controlY - 3, 8, 8 )
						
				if input.IsMouseDown( MOUSE_LEFT ) then
					local mouseX, mouseY = gui.MousePos()
					local deltaX = math.floor( mouseX - controlX )
					local deltaY = math.floor( mouseY - controlY )
							
					if deltaY > -14 and deltaY < 14 then
						if deltaX > -10 and deltaX < controlWidth + 10 then
							local volume = math.Clamp( deltaX, 0, 100 )

							if volume != serverguard.musicBox:GetVolume() then
								serverguard.musicBox:SetVolume( volume )
							end
						end
					end
				end
			elseif (serverguard.musicBox:IsLoading()) then
				local width, height = 48, 48
				local x, y = ScrW() / 2 - width / 2, 8
				local thumbnail = serverguard.musicBox:GetThumbnail()

				if thumbnail then
					surface.SetDrawColor( Color( 255, 255, 255 ) )
					surface.SetMaterial( thumbnail )
					surface.DrawTexturedRect( x + width / 2 - 60 + 3, y, 120, 120 )
				end
					
				local dotCount = 8

				for i = 1, dotCount do
					local xDir = math.cos( math.rad( 360 / dotCount * i ) + CurTime() * 3 )
					local yDir = math.sin( math.rad( 360 / dotCount * i ) + CurTime() * 3 )
						
					local rectX = x + width / 2 + xDir * width / 1.4
					local rectY = y + 18 + height / 2 + yDir * width / 1.4
						
					surface.SetDrawColor( Color( 0, 0, 0, 196 ) )
					surface.DrawRect( rectX - 2 + xDir * 3, rectY - 2 + yDir * 3, 4, 4 )
						
					surface.SetDrawColor( Color( 220, 220, 220, 196 ) )
					surface.DrawRect( rectX - 2, rectY - 2, 4, 4 )
				end;
			end;
		end;
	end);
	
	serverguard.musicBox:CreateHTML()
end
