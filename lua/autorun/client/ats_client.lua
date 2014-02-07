-- # --------------------------------------
-- # Alex's Teleport System [CLIENT]
-- # Made by Alex511. you can use any code from this with my permission.
-- # --------------------------------------

local Warp_Table = {  }
local Flash = 0
local T = 0
local TeleEntity = NULL

local function ATS_WARP_LIST( data )
 
	// insert the received warp name into the table of warps
	table.insert( Warp_Table, data:ReadString() );
 
end
usermessage.Hook( "ATS_WARP_LIST", ATS_WARP_LIST );

local function ATS_WRP_EFCT( data )

	TeleEntity = data:ReadEntity()
 
	surface.PlaySound("vo/k_lab/kl_initializing02.wav")
	
	timer.Simple(4, function() 

	Flash = 1
	
	timer.Simple(1,function()
	
	Flash = 0
	
	end)
		
	end)
 
end
usermessage.Hook( "ATS_WARP_EFFECT", ATS_WRP_EFCT );


local function ATS_EFFECT()

	local ply = TeleEntity//LocalPlayer()
	
	if TeleEntity:IsValid() then
    if !ply:Alive() then return end
		if(ply:GetActiveWeapon() == NULL or ply:GetActiveWeapon() == "Camera") then return end
	
	draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255,255,255,T))
	
	end
	
end
hook.Add( "HUDPaint", "ATS_EFFECT", ATS_EFFECT )


local function ATS_MENU( ply )

	local panel = vgui.Create( "DFrame" )
		panel:SetSize( 700, 400 )
		panel:SetPos( (ScrW()/1.4)-panel:GetWide(),(ScrH()/1.4)-panel:GetTall() )
		panel:SetTitle( "" )
		panel:SetVisible( true )
		panel:SetDraggable( true )
		panel:ShowCloseButton( false )
		panel:SetMouseInputEnabled( false )
		panel:SetKeyboardInputEnabled( false )
		panel:MakePopup()
		panel.Paint = function()
		
			local R = RealTime()*2.2
		
			draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(255,255,255,230))
			draw.RoundedBox(0, panel:GetWide() - 70, 0, 60, 30, Color(255,10,10,230))
			
		
		end
		
		function panel_close()
	
		Warp_Table = { }
			panel:Close()
		
		end
		
		local show_warp_destinations = vgui.Create("DListView")
		show_warp_destinations:SetParent( panel )
		show_warp_destinations:SetPos(25, 50)
		show_warp_destinations:SetSize(280, 300)
		show_warp_destinations:SetMultiSelect(false)
		show_warp_destinations:AddColumn("Warp List For Map, " .. game.GetMap()) -- Add column
		 
		for i,wrp_txt in pairs(Warp_Table) do
		
		show_warp_destinations:AddLine( string.Replace( wrp_txt, ".txt", "" ) )
		
		end
		
		show_warp_destinations.OnClickLine = function(parent, line, selected)
	
		surface.PlaySound("ui/buttonclickrelease.wav")
		
		local menu = DermaMenu()
		
			menu:AddOption( 'Warp to this location?', function()
			
			surface.PlaySound("buttons/button14.wav")
			
			chat.AddText( Color(255,255,255), "[", Color(60,60,60), "ATS", Color(255,255,255), "] Destination set to, " .. line:GetValue(1) .. ".")
				
			//ATS_WARP( ply, line:GetValue(1) )
				
			net.Start( "ATS_WARP_FROM_CLIENT" )
				
				net.WriteEntity( ply )
				net.WriteString( line:GetValue(1) )
						
			net.SendToServer()
			
			panel_close()
				
			end ):SetImage("icon16/arrow_join.png")
			
			/*menu:AddOption( 'Remove Restriction on this', function()
				
			surface.PlaySound("buttons/button14.wav")
			
			chat.AddText( Color(255,255,255), "[", Color(60,60,60), "ATS", Color(255,255,255), "] You removed restrictions on stool, " .. line:GetValue(1) .. "")
				
			end ):SetImage("icon16/user_go.png")*/
			
			menu:Open()
		end
		
		// // DLabel // //
	
		local information = vgui.Create("DLabel", panel)
		information:SetPos( 10, 370 )
		information:SetColor(Color( 60, 60, 60, 255 ))
		information:SetFont("ChatFont")
		information:SetText("Hover over a warp above this text and left click to teleport to the selected location.")
		information:SizeToContents()
	
		local close_button = vgui.Create( "DImageButton", panel )
		close_button:SetPos( panel:GetWide() - 48, 5 )
		close_button:SetImage("icon16/circlecross.png")
		close_button:SizeToContents() 
		close_button.DoClick = function()
			 
			 panel_close()
		end
		
		close_button.Paint = function()
			
		//surface.SetDrawColor( 0, 0, 0, 255 )
		//surface.DrawOutlinedRect( 0, 0, close_button:GetWide(), close_button:GetTall())
		
		draw.RoundedBox(0, 0, 0, close_button:GetWide(), close_button:GetTall(), Color(255,10,10,230))
		
		end


end
concommand.Add("ATS_WARP_MENU", ATS_MENU)

hook.Add( "Think", "flashatseffect", function() 

	if Flash == 0 then
	
	T = T - 5
	
	else
	
	T = T + 5
	
	end
	
	if T > 255 then
	
	T = 255
	
	end
	
	if T < 0 then 
	
	T = 0
	
	end


end )
