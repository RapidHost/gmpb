local MaskMat = surface.GetTextureID( "paintball/mask" )

hook.Add( "HUDPaint", "GMPB_HUD", function()

	if LocalPlayer():Alive() and ( LocalPlayer():Team() == TEAM_RED or LocalPlayer():Team() == TEAM_BLUE ) then
		surface.SetTexture( MaskMat )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())
		
		surface.CreateFont ("Trebuchet", 24, 400, true, false, "T24")
		draw.RoundedBox(0, ScrW() / 2 - 32, 32, 64, 32, Color(255, 165, 0, 191))
		draw.SimpleText("$" ..LocalPlayer():GetNetworkedFloat("GMPBMoney"), "T24", ScrW() / 2 - 1, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.RoundedBoxEx(6, ScrW() / 2 - 64, 32, 32, 32, team.GetColor(1), false, false, true, false)
		draw.SimpleText(tostring(team.GetScore(1)), "T24", ScrW() / 2 - 48, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.RoundedBoxEx(6, ScrW() / 2 + 32, 32, 32, 32, team.GetColor(2), false, false, false, true)
		draw.SimpleText(tostring(team.GetScore(2)), "T24", ScrW() / 2 + 48, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
end )

local ToHide = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo" }

hook.Add( "HUDShouldDraw", "GMPB_HideHud", function( element )
	if table.HasValue( ToHide, element ) then
		return false
	end
end )