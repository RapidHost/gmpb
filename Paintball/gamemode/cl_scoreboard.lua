local ColorScheme = {
	DarkGrey = Color( 92, 92, 92, 250 ),
	LightGrey = Color( 125, 125, 125, 200 ),
	RedTeam = Color( 186, 60, 60, 250 ),
	BlueTeam = Color( 61, 136, 188, 250 ),
	PlayerRow0 = Color( 32, 32, 32, 200 ),
	PlayerRow1 = Color( 90, 90, 90, 200 ),
}

local function GSC( clr ) -- Get a color in our color scheme
	return ColorScheme[ clr ] or color_white
end

local Scoreboard = {
	GameName = "Paintball",
	Authors = "The Deuce Box, Panda X, BlackOps, & Sassafrass",
	IP = "69.197.191.218:27015",
}

surface.CreateFont ( "Tahoma", ScreenScale( 15 ), 1, true, false, "GMPBGMName" )
surface.CreateFont ( "Tahoma", ScreenScale( 8 ), 1, true, false, "GMPBGMAuthors" )
surface.CreateFont ( "Tahoma", ScreenScale( 6 ), 1, true, false, "GMPBPlayers" )

function GM:ScoreboardShow()
	Scoreboard.Draw = true
end

function GM:ScoreboardHide()
	Scoreboard.Draw = false
end

hook.Add( "HUDPaint", "GMPB_Scoreboard", function()

	if Scoreboard.Draw then
	
		Scoreboard.Width = ScrW() * 0.7
		Scoreboard.Height = ScrH() * 0.8
		Scoreboard.XPos = ( ScrW() - Scoreboard.Width ) / 2
		Scoreboard.YPos = ( ScrH() - Scoreboard.Height ) / 2
		Scoreboard.Top = Scoreboard.Height * 0.1
		Scoreboard.PlayerRow = ScreenScale( 10 )
		
		--Top bar
		draw.RoundedBoxEx( 16, Scoreboard.XPos, Scoreboard.YPos, Scoreboard.Width, Scoreboard.Top, GSC( "DarkGrey" ), true, true, false, false )
		
		-- Logo
		surface.SetDrawColor( color_black )
		surface.DrawRect( Scoreboard.XPos + 10, Scoreboard.YPos + 10, Scoreboard.Top - 20, Scoreboard.Top - 20 )
		
		-- Scoreboard title info
		draw.SimpleText( Scoreboard.GameName, "GMPBGMName", Scoreboard.XPos + Scoreboard.Top, Scoreboard.YPos + 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		draw.SimpleText( Scoreboard.Authors, "GMPBGMAuthors", Scoreboard.XPos + Scoreboard.Top, Scoreboard.YPos + Scoreboard.Top - 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( Scoreboard.IP, "GMPBGMAuthors", Scoreboard.XPos + Scoreboard.Width - 10 , Scoreboard.YPos + Scoreboard.Top - 10, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		
		-- Red team banner
		surface.SetDrawColor( GSC( "RedTeam" ) )
		surface.DrawRect( Scoreboard.XPos, Scoreboard.YPos + Scoreboard.Top, Scoreboard.Width / 2, Scoreboard.Top )
		
		draw.SimpleText( "Red", "GMPBGMName", Scoreboard.XPos + ( Scoreboard.Width / 4 ), Scoreboard.YPos + Scoreboard.Top + ( Scoreboard.Top / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Blue team banner
		surface.SetDrawColor( GSC( "BlueTeam" ) )
		surface.DrawRect( Scoreboard.XPos + ( Scoreboard.Width / 2 ), Scoreboard.YPos + Scoreboard.Top, Scoreboard.Width / 2, Scoreboard.Top )
		
		draw.SimpleText( "Blue", "GMPBGMName", Scoreboard.XPos + Scoreboard.Width - ( Scoreboard.Width / 4 ), Scoreboard.YPos + Scoreboard.Top + ( Scoreboard.Top / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		Scoreboard.PXpos = Scoreboard.XPos
		Scoreboard.PYpos = Scoreboard.YPos + ( Scoreboard.Top * 2 )
		
		-- Player list area
		draw.RoundedBoxEx( 16, Scoreboard.PXpos, Scoreboard.PYpos, Scoreboard.Width, Scoreboard.Height - ( Scoreboard.Top * 2 ), GSC( "LightGrey" ), false, false, true, true )
		
		-- Red list
		surface.SetDrawColor( GSC( "PlayerRow0" ) )
		surface.DrawRect( Scoreboard.PXpos, Scoreboard.YPos + ( Scoreboard.Top * 2 ), Scoreboard.Width / 2, Scoreboard.PlayerRow )
		
		surface.SetFont( "GMPBPlayers" )
		
		local w,h = surface.GetTextSize( "OUT" )
		
		draw.SimpleText( "OUT", "GMPBPlayers", Scoreboard.PXpos + 5, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( string.format( "Players (%i)", #team.GetPlayers( TEAM_RED or 1001 ) ), "GMPBPlayers", Scoreboard.PXpos + 15 + w, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local pingw, pingh = surface.GetTextSize( "Ping" )
		draw.SimpleText( "Ping", "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local scorew, scoreh = surface.GetTextSize( "Score" )
		draw.SimpleText( "Score", "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw - scorew - 10, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		for i, ply in pairs( team.GetPlayers( TEAM_RED or 1001 ) ) do
			surface.SetDrawColor( GSC( "PlayerRow" .. ( i % 2 ) ) )
			surface.DrawRect( Scoreboard.PXpos, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ), Scoreboard.Width / 2, Scoreboard.PlayerRow )
			draw.SimpleText( ply:Nick(), "GMPBPlayers", Scoreboard.PXpos + 15 + w, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( ply:Ping(), "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( ply:Frags(), "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw - scorew - 10, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		Scoreboard.PXpos = Scoreboard.XPos + ( Scoreboard.Width / 2 )
		
		-- Blue list
		surface.SetDrawColor( GSC( "PlayerRow0" ) )
		surface.DrawRect( Scoreboard.PXpos, Scoreboard.YPos + ( Scoreboard.Top * 2 ), Scoreboard.Width / 2, Scoreboard.PlayerRow )
		
		surface.SetFont( "GMPBPlayers" )
		
		local w,h = surface.GetTextSize( "OUT" )
		
		draw.SimpleText( "OUT", "GMPBPlayers", Scoreboard.PXpos + 5, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( string.format( "Players (%i)", #team.GetPlayers( TEAM_BLUE or 1001 ) ), "GMPBPlayers", Scoreboard.PXpos + 15 + w, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local pingw, pingh = surface.GetTextSize( "Ping" )
		draw.SimpleText( "Ping", "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		local scorew, scoreh = surface.GetTextSize( "Score" )
		draw.SimpleText( "Score", "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw - scorew - 10, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		for i, ply in pairs( team.GetPlayers( TEAM_BLUE or 1001 ) ) do
			surface.SetDrawColor( GSC( "PlayerRow" .. ( i % 2 ) ) )
			surface.DrawRect( Scoreboard.PXpos, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ), Scoreboard.Width / 2, Scoreboard.PlayerRow )
			draw.SimpleText( ply:Nick(), "GMPBPlayers", Scoreboard.PXpos + 15 + w, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( ply:Ping(), "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( ply:Frags(), "GMPBPlayers", Scoreboard.PXpos + ( Scoreboard.Width / 2 ) - pingw - scorew - 10, Scoreboard.YPos + ( Scoreboard.Top * 2 ) + ( Scoreboard.PlayerRow * i ) + ( Scoreboard.PlayerRow / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
	end
	
end )