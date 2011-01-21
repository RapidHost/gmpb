local Window = nil
local ChosenWep = {}
ChosenWep[1] = nil
function WeaponMenu()
  if ( Window ) then return end 
  Window = {}
  Window.wind = vgui.Create( "Frame" )
  Window.wind:SetName( "vgui_loadout" )
  
  Window.check1 = vgui.Create("CheckButton", Window.wind, "CheckButton1")
  Window.check1:SetActionFunction(SelectAug)
  Window.check2 = vgui.Create("CheckButton", Window.wind, "CheckButton2")
  Window.check2:SetActionFunction(SelectSpas)
  Window.check3 = vgui.Create("CheckButton", Window.wind, "CheckButton3")
  Window.check3:SetActionFunction(SelectP90)
  Window.check4 = vgui.Create("CheckButton", Window.wind, "CheckButton4")
  Window.check4:SetActionFunction(SelectFamas)
  Window.check5 = vgui.Create("CheckButton", Window.wind, "CheckButton5")
  Window.check5:SetActionFunction(SelectDeagle)
  Window.check12 = vgui.Create("CheckButton", Window.wind, "CheckButton12")
  Window.check12:SetActionFunction(SelectGlock)
  Window.check6 = vgui.Create("CheckButton", Window.wind, "CheckButton6")
  Window.check6:SetActionFunction(SelectMedkit)
  Window.check7 = vgui.Create("CheckButton", Window.wind, "CheckButton7")
  Window.check7:SetActionFunction(SelectTripmine)
  Window.check8 = vgui.Create("CheckButton", Window.wind, "Flashlight")
  Window.check8:SetActionFunction(SelectFlashlight)
  Window.check9 = vgui.Create("CheckButton", Window.wind, "CheckButton8")
  Window.check9:SetActionFunction(SelectLaser)
  Window.check10 = vgui.Create("CheckButton", Window.wind, "CheckButton9")
  Window.check10:SetActionFunction(SelectTracker)
  Window.check11 = vgui.Create("CheckButton", Window.wind, "CheckButton10")
  Window.check11:SetActionFunction(SelectHeat)
  Window.wewt = vgui.Create("Button", Window.wind, "FieldIn")
  Window.wewt:SetActionFunction(SelectWewt)
  Window.wind:LoadControlsFromString(vgui_loadout) --File( "resource/ui/vgui_loadout.res" )
  
  Window.wind:SetMouseInputEnabled( true )
  Window.wind:SetKeyboardInputEnabled( false )
 
  Window.wind:SetPos(ScrW() / 2 - 182, ScrH() / 2 - 72)
  Window.wind:SetVisible( true )
  
 end
 
 local wep = {true, true, true}
 function SelectAug()
 	if wep[1] == true then
 		wep[1] = false
 		if ChosenWep[1] ~= "weapon_steyr" then
 			ChosenWep[1] = "weapon_steyr"
 			Window.check2:SetEnabled(false)
 			Window.check3:SetEnabled(false)
 			Window.check4:SetEnabled(false)
 		else
 			ChosenWep[1] = nil
 			Window.check2:SetEnabled(true)
 			Window.check3:SetEnabled(true)
 			Window.check4:SetEnabled(true)
 		end
 	else
 		wep[1] = true
 	end
 end 
 
 -- The following is extremely messy and probably the most inefficient VGUI ever, but we were just learning it so give us a break.
 
 function SelectSpas()
 	 if wep[1] == true then
 		wep[1] = false
 		if ChosenWep[1] ~= "weapon_spas12" then
 			ChosenWep[1] = "weapon_spas12"
 			Window.check1:SetEnabled(false)
 			Window.check3:SetEnabled(false)
 			Window.check4:SetEnabled(false)
 		else
 			ChosenWep[1] = nil
 			Window.check1:SetEnabled(true)
 			Window.check3:SetEnabled(true)
 			Window.check4:SetEnabled(true)
 		end
 	else
 		wep[1] = true
 	end
 end 
 
 function SelectP90()
   	if wep[1] == true then
 		wep[1] = false
 		if ChosenWep[1] ~= "weapon_p90" then
 			ChosenWep[1] = "weapon_p90"
 			Window.check1:SetEnabled(false)
 			Window.check2:SetEnabled(false)
 			Window.check4:SetEnabled(false)
 		else
 			ChosenWep[1] = nil
 			Window.check1:SetEnabled(true)
 			Window.check2:SetEnabled(true)
 			Window.check4:SetEnabled(true)
 		end
 	else
 		wep[1] = true
 	end
 end 
 
 function SelectFamas()
   	if wep[1] == true then
 		wep[1] = false
 		if ChosenWep[1] ~= "weapon_famas" then
 			ChosenWep[1] = "weapon_famas"
 			Window.check1:SetEnabled(false)
 			Window.check2:SetEnabled(false)
 			Window.check3:SetEnabled(false)
 		else
 			ChosenWep[1] = nil
 			Window.check1:SetEnabled(true)
 			Window.check2:SetEnabled(true)
 			Window.check3:SetEnabled(true)
 		end
 	else
 		wep[1] = true
 	end
 end 
 
  function SelectDeagle()
 	 if wep[2] == true then
 		wep[2] = false
 		if ChosenWep[2] ~= "equip_deagle" then
 			ChosenWep[2] = "equip_deagle"
 			Window.check6:SetEnabled(false)
 			Window.check7:SetEnabled(false)
 			Window.check12:SetEnabled(false)
 		else
 			ChosenWep[2] = nil
 			Window.check6:SetEnabled(true)
 			Window.check7:SetEnabled(true)
 			Window.check12:SetEnabled(true)
 		end
 	else
 		wep[2] = true
 	end
 end 
 
 function SelectGlock()
 	 if wep[2] == true then
 		wep[2] = false
 		if ChosenWep[2] ~= "equip_glock" then
 			ChosenWep[2] = "equip_glock"
 			Window.check5:SetEnabled(false)
 			Window.check6:SetEnabled(false)
 			Window.check7:SetEnabled(false)
 		else
 			ChosenWep[2] = nil
 			Window.check5:SetEnabled(true)
 			Window.check6:SetEnabled(true)
 			Window.check7:SetEnabled(true)
 		end
 	else
 		wep[2] = true
 	end
 end 
 
  function SelectMedkit()
 	 if wep[2] == true then
 		wep[2] = false
 		if ChosenWep[2] ~= "equip_medikit" then
 			ChosenWep[2] = "equip_medikit"
 			Window.check5:SetEnabled(false)
 			Window.check7:SetEnabled(false)
 			Window.check12:SetEnabled(false)
 		else
 			ChosenWep[2] = nil
 			Window.check5:SetEnabled(true)
 			Window.check7:SetEnabled(true)
 			Window.check12:SetEnabled(true)
 		end
 	else
 		wep[2] = true
 	end
 end 
 
  function SelectTripmine()
 	 if wep[2] == true then
 		wep[2] = false
 		if ChosenWep[2] ~= "equip_tripmine" then
 			ChosenWep[2] = "equip_tripmine"
 			Window.check5:SetEnabled(false)
 			Window.check6:SetEnabled(false)
 			Window.check12:SetEnabled(false)
 		else
 			ChosenWep[2] = nil
 			Window.check5:SetEnabled(true)
 			Window.check6:SetEnabled(true)
 			Window.check12:SetEnabled(true)
 		end
 	else
 		wep[2] = true
 	end
 end 
 
  function SelectFlashlight()
 	 if wep[3] == true then
 		wep[3] = false
 		if ChosenWep[3] ~= "vis_flashlight" then
 			ChosenWep[3] = "vis_flashlight"
 			Window.check9:SetEnabled(false)
 			Window.check10:SetEnabled(false)
 			Window.check11:SetEnabled(false)
 		else
 			ChosenWep[3] = nil
 			Window.check9:SetEnabled(true)
 			Window.check10:SetEnabled(true)
 			Window.check11:SetEnabled(true)
 		end
 	else
 		wep[3] = true
 	end
 end 
 
  function SelectLaser()
  	if wep[3] == true then
 		wep[3] = false
 		if ChosenWep[3] ~= "vis_laser" then
 			ChosenWep[3] = "vis_laser"
 			Window.check8:SetEnabled(false)
 			Window.check10:SetEnabled(false)
 			Window.check11:SetEnabled(false)
 		else
 			ChosenWep[3] = nil
 			Window.check8:SetEnabled(true)
 			Window.check10:SetEnabled(true)
 			Window.check11:SetEnabled(true)
 		end
 	else
 		wep[3] = true
 	end
 end 
 
  function SelectTracker()
 	if wep[3] == true then
 		wep[3] = false
 		if ChosenWep[3] ~= "vis_tracker" then
 			ChosenWep[3] = "vis_tracker"
 			Window.check8:SetEnabled(false)
 			Window.check9:SetEnabled(false)
 			Window.check11:SetEnabled(false)
 		else
 			ChosenWep[3] = nil
 			Window.check8:SetEnabled(true)
 			Window.check9:SetEnabled(true)
 			Window.check11:SetEnabled(true)
 		end
 	else
 		wep[3] = true
 	end
 end 
 
  function SelectHeat()
 	if wep[3] == true then
 		wep[3] = false
 		if ChosenWep[3] ~= "vis_heat" then
 			ChosenWep[3] = "vis_heat"
 			Window.check8:SetEnabled(false)
 			Window.check9:SetEnabled(false)
 			Window.check10:SetEnabled(false)
 		else
 			ChosenWep[3] = nil
 			Window.check8:SetEnabled(true)
 			Window.check9:SetEnabled(true)
 			Window.check10:SetEnabled(true)
 		end
 	else
 		wep[3] = true
 	end
 end 
 
  function FieldIn()
 	if ChosenWep[1] ~= nil and ChosenWep[2] ~= nil and ChosenWep[3] ~= nil then
 		Window.wind:SetVisible(false)
 		Window = nil
 		DoLoadout(ChosenWep[1], ChosenWep[2], ChosenWep[3])
 		for i=1, 3 do
 			wep[i] = true
 			ChosenWep[i] = nil
 		end
 	end
 end
 
concommand.Add( "gmpb_weapons", WeaponMenu )
 