local ColorScheme = {
	DarkGrey = Color( 92, 92, 92, 250 ),
	LightGrey = Color( 125, 125, 125, 200 ),
	RedTeam = Color( 186, 60, 60, 250 ),
	BlueTeam = Color( 61, 136, 188, 250 ),
}

local function GSC( clr ) -- Get a color in our color scheme
	return ColorScheme[ clr ] or color_white
end

local Scoreboard = {}

surface.CreateFont ( "Tahoma", ScreenScale( 15 ), 1, true, false, "GMPBGMName")
surface.CreateFont ( "Tahoma", ScreenScale( 8 ), 1, true, false, "GMPBGMAuthors")

function GAMEMODE:ScoreboardShow()
	Scoreboard.Draw = true
end

function GAMEMODE:ScoreboardHide()
	Scoreboard.Draw = false
end

hook.Add( "HUDPaint", "GMPB_Scoreboard", function()

	if Scoreboard.Draw then
	
		Scoreboard.Width = ScrW() * 0.7
		Scoreboard.Height = ScrH() * 0.8
		Scoreboard.XPos = ( ScrW() - Scoreboard.Width ) / 2
		Scoreboard.YPos = ( ScrH() - Scoreboard.Height ) / 2
		Scoreboard.Top = Scoreboard.Height * 0.1
		
		--Top bar
		draw.RoundedBoxEx( 16, Scoreboard.XPos, Scoreboard.YPos, Scoreboard.Width, Scoreboard.Top, GSC( "DarkGrey" ), true, true, false, false )
		
		-- Logo
		surface.SetDrawColor( color_black )
		surface.DrawRect( Scoreboard.XPos + 10, Scoreboard.YPos + 10, Scoreboard.Top - 20, Scoreboard.Top - 20 )
		
		-- Scoreboard title info
		draw.SimpleText( "Paintball", "GMPBGMName", Scoreboard.XPos + Scoreboard.Top, Scoreboard.YPos + 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		draw.SimpleText( "The Deuce Box, Panda X, BlackOps, & Sassafrass", "GMPBGMAuthors", Scoreboard.XPos + Scoreboard.Top, Scoreboard.YPos + Scoreboard.Top - 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( "69.197.191.218:27015", "GMPBGMAuthors", Scoreboard.XPos + Scoreboard.Width - 10 , Scoreboard.YPos + Scoreboard.Top - 10, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		
		-- Red team banner
		surface.SetDrawColor( GSC( "RedTeam" ) )
		surface.DrawRect( Scoreboard.XPos, Scoreboard.YPos + Scoreboard.Top, Scoreboard.Width / 2, Scoreboard.Top )
		
		draw.SimpleText( "Red", "GMPBGMName", Scoreboard.XPos + ( Scoreboard.Width / 4 ), Scoreboard.YPos + Scoreboard.Top + ( Scoreboard.Top / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Blue team banner
		surface.SetDrawColor( GSC( "BlueTeam" ) )
		surface.DrawRect( Scoreboard.XPos + ( Scoreboard.Width / 2 ), Scoreboard.YPos + Scoreboard.Top, Scoreboard.Width / 2, Scoreboard.Top )
		
		draw.SimpleText( "Blue", "GMPBGMName", Scoreboard.XPos + Scoreboard.Width - ( Scoreboard.Width / 4 ), Scoreboard.YPos + Scoreboard.Top + ( Scoreboard.Top / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Player list area
		draw.RoundedBoxEx( 16, Scoreboard.XPos, Scoreboard.YPos + ( Scoreboard.Top * 2 ), Scoreboard.Width, Scoreboard.Height - ( Scoreboard.Top * 2 ), GSC( "LightGrey" ), false, false, true, true )

	end
	
end )