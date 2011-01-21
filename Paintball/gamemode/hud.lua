resource.AddFile("materials/paintball/mask.vtf")
resource.AddFile("materials/paintball/mask.vmt")

local ToggleMask = true

function GMPB_HUD()
	if !LocalPlayer():Alive() then return end

	if ToggleMask == true then
		surface.SetTexture( surface.GetTextureID( "paintball/mask" ))
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())
	end
	
	draw.RoundedBox(4, ScrW() / 2 - 128, ScrH() - 48, 64, 48, Color(0, 128, 255, 128))
	draw.RoundedBox(4, ScrW() / 2 + 64, ScrH() - 48, 64, 48, Color(255, 0, 0, 128))
	draw.SimpleText("Blue", "ScoreboardText", ScrW() / 2 - 110, ScrH() - 48, Color(255, 255, 255, 255), 0, 0)
	draw.SimpleText("Red", "ScoreboardText", ScrW() / 2 + 84, ScrH() - 48, Color(255, 255, 255, 255), 0, 0)
	draw.SimpleText(tostring(GetGlobalInt(team.GetName (1) .. "Score")), "ScoreboardHead", ScrW() / 2 - 96, ScrH() - 38, Color(255, 255, 255, 255), 1, 0)
	draw.SimpleText(tostring(GetGlobalInt(team.GetName (2) .. "Score")), "ScoreboardHead", ScrW() / 2 + 96, ScrH() - 38, Color(255, 255, 255, 255), 1, 0)

	draw.RoundedBox(4, ScrW() / 2 - 64, ScrH() - 48, 128, 48, Color(225,126,0,128))
	draw.SimpleText("Credits", "ScoreboardText", ScrW() / 2 - 24, ScrH() - 48, Color(255, 255, 255, 255), 0, 0)
	draw.SimpleText(LocalPlayer():GetNetworkedFloat("GMPBMoney"), "ScoreboardHead", ScrW() / 2 - 2,ScrH() - 38, Color(255, 255, 255, 255), 1, 0)
end 
hook.Add("HUDPaint", "GMPB_HUD", GMPB_HUD)

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudSecondaryAmmo"} do
		if name == v then return false
	end
	
	return true
end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)

function togglemask()
	if ToggleMask == true then return false
	else return true
	end
end
concommand.Add("gmpb_togglemask", togglemask)