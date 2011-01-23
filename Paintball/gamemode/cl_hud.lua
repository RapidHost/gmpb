local MaskMat = surface.GetTextureID( "paintball/mask" )

hook.Add( "HUDPaint", "GMPB_HUD", function()
	if LocalPlayer():Alive() and ( LocalPlayer():Team() == TEAM_RED or LocalPlayer():Team() == TEAM_BLUE ) then
		surface.SetTexture( MaskMat )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())
	end
	
	draw.RoundedBox( 4, ScrW() / 2 - 128, ScrH() - 48, 64, 48, Color( 0, 128, 255, 128 ) )
	draw.RoundedBox( 4, ScrW() / 2 + 64, ScrH() - 48, 64, 48, Color( 255, 0, 0, 128 ) )
	draw.SimpleText( "Blue", "ScoreboardText", ScrW() / 2 - 110, ScrH() - 48, color_white, 0, 0)
	draw.SimpleText( "Red", "ScoreboardText", ScrW() / 2 + 84, ScrH() - 48, color_white, 0, 0)
	draw.SimpleText( team.GetScore( TEAM_BLUE ), "ScoreboardHead", ScrW() / 2 - 96, ScrH() - 38, color_white, 1, 0 )
	draw.SimpleText( team.GetScore( TEAM_RED ), "ScoreboardHead", ScrW() / 2 + 96, ScrH() - 38, color_white, 1, 0 )

	draw.RoundedBox( 4, ScrW() / 2 - 64, ScrH() - 48, 128, 48, Color( 225,126,0,128 ) )
	draw.SimpleText( "Credits", "ScoreboardText", ScrW() / 2 - 24, ScrH() - 48, color_white, 0, 0 )
	draw.SimpleText( LocalPlayer():GetNetworkedFloat("GMPBMoney"), "ScoreboardHead", ScrW() / 2 - 2,ScrH() - 38, color_white, 1, 0 )
	
end )

local ToHide = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo" }

hook.Add( "HUDShouldDraw", "GMPB_HideHud", function( element )
	if table.HasValue( ToHide, element ) then
		return false
	end
end )