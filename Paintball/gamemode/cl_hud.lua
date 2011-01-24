local MaskMat = surface.GetTextureID( "paintball/mask" )

hook.Add( "HUDPaint", "GMPB_HUD", function()

	if LocalPlayer():Alive() and ( LocalPlayer():Team() == TEAM_RED or LocalPlayer():Team() == TEAM_BLUE ) then
		surface.SetTexture( MaskMat )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())
	end
	
	
	
end )

local ToHide = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo" }

hook.Add( "HUDShouldDraw", "GMPB_HideHud", function( element )
	if table.HasValue( ToHide, element ) then
		return false
	end
end )