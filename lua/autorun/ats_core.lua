-- # --------------------------------------
-- # Alex's Teleport System [CORE]
-- # Made by Alex511. you can use any code from this with my permission.
-- # --------------------------------------

local map = game.GetMap()

	ATS_WARP_TABELS = { "Data" }


if CLIENT then

		-- # ------------------------------
		-- # Fonts
		-- # ------------------------------

		surface.CreateFont( "ATS_FONT", {
		font = "ChatFont",
		size = 12,
		weight = 900,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = true,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
		} )


end

if SERVER then
		
		-- # ------------------------------
		-- # Functions
		-- # ------------------------------
			
		function ATS_WARP_EFFECT( Ent )
		
			umsg.Start( "ATS_WARP_EFFECT", Ent )
			umsg.Entity( Ent )
			umsg.End()
		
		end
			
		function ATS_WARP( Ent, Destination )
			
			if IsValid( Ent ) and Ent:Alive() then
			
			local Vector_ = Vector( 0, 0, 0)
			local Angle_ = Angle( 0, 0, 0)
			
			if file.Exists( "data/ats_warps/" .. map .. "/" .. Destination .. ".txt", "GAME" ) then
		
			local Data = file.Read( "ats_warps/" .. map .. "/" .. Destination .. ".txt", "DATA" )
				local Strings = string.Explode( ";", Data )
					local Vector_ = string.Replace( Strings[3], "vec=", "" )
						local Angle_ = string.Replace( Strings[4], "ang=", "" )
			
			MsgN("Player, " .. Ent:Nick() .. " has warped to, " .. Destination .. "")
		
			Ent:SendLua( "chat.AddText(Color(255,255,255), \"[\", Color(40,40,40), \"ATS\", Color(255,255,255), \"] teleporting to, " .. Destination .. ".\")" )
		
			ATS_WARP_EFFECT( Ent )
			
			timer.Simple(4, function() 
			
			Ent:EmitSound("ambient/machines/teleport" .. math.random( 3, 4 ) ..".wav", 100)
			
			end)
			
			timer.Simple(5, function() 
			
			Ent:SetPos( util.StringToType( Vector_, "Vector") )
				Ent:SetEyeAngles(  util.StringToType( Angle_, "Angle") )
			
			end)
			
			else
			
			Ent:SendLua([[chat.AddText(Color(255,255,255), "[", Color(40,40,40), "ATS", Color(255,255,255), "] Invalid Warp." )]])
			Ent:EmitSound("resource/warning.wav", 100)
			
			end
			
			end
			
		end

		function ATS_ADD_WARP( Ent, Destination, Vector_, Angle_ )

				if file.Exists( "data/ats_warps/" .. map .. "/" .. Destination .. ".txt", "GAME" ) then
			
				Ent:SendLua([[chat.AddText(Color(255,255,255), "[", Color(40,40,40), "ATS", Color(255,255,255), "] this warp already exists." )]])
				
				else
				
				
				local Compressed_data = "steamid=" .. Ent:SteamID() .. ";name=" .. Destination .. ";vec=" .. tostring(Vector_) .. ";ang=" .. tostring(Angle_) .. ""
				
				file.CreateDir("ats_warps")
					file.CreateDir("ats_warps/" .. map )
						file.Write("ats_warps/" .. map .. "/" .. Destination .. ".txt", Compressed_data )
				
				Ent:SendLua( "chat.AddText(Color(255,255,255), \"[\", Color(40,40,40), \"ATS\", Color(255,255,255), \"] warp created and saved as, " .. string.Replace( Destination, " ", "" ) .. ".\")" )
					Ent:EmitSound("garrysmod/content_downloaded.wav", 100)
						MsgN("Player, " .. Ent:Nick() .. " has created a warp called, " .. Destination .. "")
				
				end

		end
		
		function ATS_REMOVE_WARP( Ent, Destination )
		
		if file.Exists( "data/ats_warps/" .. map .. "/" .. Destination .. ".txt", "GAME" ) then
		
		file.Delete( "ats_warps/" .. map .. "/" .. Destination .. ".txt" )
		
		Ent:SendLua( "chat.AddText(Color(255,255,255), \"[\", Color(40,40,40), \"ATS\", Color(255,255,255), \"] warp was removed ( " .. string.Replace( Destination, " ", "" ) .. " )\")" )
			
		MsgN("Player, " .. Ent:Nick() .. " has removed warp, " .. Destination .. "")
			
		else
		
		Ent:SendLua([[chat.AddText(Color(255,255,255), "[", Color(40,40,40), "ATS", Color(255,255,255), "] Invalid Warp. (Not Found)" )]])
		
		end
		
		
		end


		-- # ------------------------------
		-- # Commands
		-- # ------------------------------

		function ATS_CHAT_COMMANDS( ply, text, public )
				local chat_string = string.Explode(" ", text);

				
				if chat_string[1] == "/warp" then
					
				if chat_string[2] == nil then
					
					local files,dir = file.Find("ats_warps/" .. map .. "/*.txt","DATA")
					
					for i,warp_txt in ipairs(files) do
						umsg.Start( "ATS_WARP_LIST", ply );
							umsg.String( warp_txt );
						umsg.End();
					end
					
					ply:ConCommand("ATS_WARP_MENU")
					
					return false
				else
				
					local textentry = "" .. tostring(chat_string[2]) .. " " .. tostring(chat_string[3]) .. ""
					local ats_add_warp_process_1_ = string.Replace(textentry, "nil", "")
					local ats_add_warp_process_2_ = string.Replace(ats_add_warp_process_1_, " ", "")
				
				
					ATS_WARP( ply, string.Replace(ats_add_warp_process_2_, "nil", "") )
					
					return false
				end
				  
					 return false
				end
				
				if ply:IsSuperAdmin() then
				
				if chat_string[1] == "/setwarp" then
					
					local textentry = "" .. tostring(chat_string[2]) .. " " .. tostring(chat_string[3]) .. ""
					local ats_add_warp_process_1 = string.Replace(textentry, "nil", "")
					local ats_add_warp_process_2 = string.Replace(ats_add_warp_process_1, " ", "")
					
					local pos = ply:GetPos()
					local ang = ply:GetAngles()
					
					ATS_ADD_WARP( ply, ats_add_warp_process_2, pos, ang )
			 
				  
					 return false
				end
				
				if chat_string[1] == "/removewarp" then
					
					local textentry = "" .. tostring(chat_string[2]) .. " " .. tostring(chat_string[3]) .. ""
					local process_1 = string.Replace(textentry, "nil", "")
					local process_2 = string.Replace(process_1, " ", "")
					
					
					ATS_REMOVE_WARP( ply, process_2 )
			 
				  
					 return false
				end
				
				end
				
		end
		hook.Add( "PlayerSay", "ATS_CHAT_FUNC", ATS_CHAT_COMMANDS );
		
		util.AddNetworkString( "ATS_WARP_FROM_CLIENT" )

		net.Receive( "ATS_WARP_FROM_CLIENT", function( Length, Ply )

		--Read message and do stuff with it.
		local Ent = net.ReadEntity()
		local Dest = net.ReadString()
				
		ATS_WARP( Ent, Dest )
		
			
		end )
		
end