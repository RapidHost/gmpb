if CLIENT then
	function GMPBWeapon_Menu()
		local PBAmount
		local PBColor
		local PBName
		local PB
		local PBPanel
		local DM5Clip
		local DM5Force
		local DM5BPM
		local DM5Acc
		local DM5Price
		local DM5Name
		local DM5
		local DM5Panel
		local BushClip
		local BushForce
		local BushBPM
		local BushAcc
		local BushPrice
		local BushName
		local Bush
		local BushPanel
		local CockerClip
		local CockerForce
		local CockerBPM
		local CockerAcc
		local CockerPrice
		local CockerName
		local Cocker
		local CockerPanel
		local AngelClip
		local AngelForce
		local AngelBPM
		local AngelAcc
		local AngelPrice
		local AngelName
		local Angel
		local AngelPanel
		local A5Clip
		local A5Force
		local A5BPM
		local A5Acc
		local A5Price
		local A5Name
		local A5
		local A5Panel
		local DFrame1

		DFrame1 = vgui.Create('DFrame')
		DFrame1:SetVisible(true);
		DFrame1:SetSize(737, 252)
		DFrame1:Center()
		DFrame1:SetTitle('Buy Menu')
		DFrame1:SetDeleteOnClose(false)
		DFrame1:MakePopup()

		A5Panel = vgui.Create('DPanel')
		A5Panel:SetParent(DFrame1)
		A5Panel:SetSize(100, 100)
		A5Panel:SetPos(10, 32)

		A5 = vgui.Create('DImageButton')
		A5:SetParent(A5Panel)
		A5:SetSize(84, 84)
		A5:SetPos(8, 8)
		A5:SetImage('paintball/preview_missing')
		A5:SizeToContents()
		A5.DoClick = function() 
			LocalPlayer():ConCommand("buy pb_a51\n");
			DFrame1:SetVisible(false);
			LocalPlayer():ConCommand("gmpb_savedata");
		end

		A5Name = vgui.Create('DLabel')
		A5Name:SetParent(DFrame1)
		A5Name:SetPos(120, 32)
		A5Name:SetText('Tippman A5')
		A5Name:SizeToContents()

		A5Price = vgui.Create('DLabel')
		A5Price:SetParent(DFrame1)
		A5Price:SetPos(120, 58)
		A5Price:SetText('Price: $225')
		A5Price:SizeToContents()

		A5Acc = vgui.Create('DLabel')
		A5Acc:SetParent(DFrame1)
		A5Acc:SetPos(120, 73)
		A5Acc:SetText('Accuracy: 50 (Medium)')
		A5Acc:SizeToContents()

		A5BPM = vgui.Create('DLabel')
		A5BPM:SetParent(DFrame1)
		A5BPM:SetPos(120, 88)
		A5BPM:SetText('Firerate: 6.25 BPS (Medium)')
		A5BPM:SizeToContents()

		A5Force = vgui.Create('DLabel')
		A5Force:SetParent(DFrame1)
		A5Force:SetPos(120, 103)
		A5Force:SetText('Fire Force: 10000')
		A5Force:SizeToContents()

		A5Clip = vgui.Create('DLabel')
		A5Clip:SetParent(DFrame1)
		A5Clip:SetPos(120, 118)
		A5Clip:SetText('Hopper: 100 Paintballs')
		A5Clip:SizeToContents()

		AngelPanel = vgui.Create('DPanel')
		AngelPanel:SetParent(DFrame1)
		AngelPanel:SetSize(100, 100)
		AngelPanel:SetPos(260, 32)

		Angel = vgui.Create('DImageButton')
		Angel:SetParent(AngelPanel)
		Angel:SetSize(84, 84)
		Angel:SetPos(8, 8)
		Angel:SetImage('paintball/preview_missing')
		Angel:SizeToContents()
		Angel.DoClick = function() 
			LocalPlayer():ConCommand("buy pb_angel\n");
			DFrame1:SetVisible(false);
			LocalPlayer():ConCommand("gmpb_savedata");
		end

		AngelName = vgui.Create('DLabel')
		AngelName:SetParent(DFrame1)
		AngelName:SetPos(370, 32)
		AngelName:SetText('WDP Angel A4')
		AngelName:SizeToContents()

		AngelPrice = vgui.Create('DLabel')
		AngelPrice:SetParent(DFrame1)
		AngelPrice:SetPos(370, 58)
		AngelPrice:SetText('Price: $575')
		AngelPrice:SizeToContents()

		AngelAcc = vgui.Create('DLabel')
		AngelAcc:SetParent(DFrame1)
		AngelAcc:SetPos(370, 73)
		AngelAcc:SetText('Accuracy: 63 (High)')
		AngelAcc:SizeToContents()

		AngelBPM = vgui.Create('DLabel')
		AngelBPM:SetParent(DFrame1)
		AngelBPM:SetPos(370, 88)
		AngelBPM:SetText('Firerate: 8.3 BPS (Fast)')
		AngelBPM:SizeToContents()

		AngelForce = vgui.Create('DLabel')
		AngelForce:SetParent(DFrame1)
		AngelForce:SetPos(370, 103)
		AngelForce:SetText('Fire Force: 10000')
		AngelForce:SizeToContents()

		AngelClip = vgui.Create('DLabel')
		AngelClip:SetParent(DFrame1)
		AngelClip:SetPos(370, 118)
		AngelClip:SetText('Hopper: 100 Paintballs')
		AngelClip:SizeToContents()

		CockerPanel = vgui.Create('DPanel')
		CockerPanel:SetParent(DFrame1)
		CockerPanel:SetSize(100, 100)
		CockerPanel:SetPos(510, 32)

		Cocker = vgui.Create('DImageButton')
		Cocker:SetParent(CockerPanel)
		Cocker:SetSize(84, 84)
		Cocker:SetPos(8, 8)
		Cocker:SetImage('paintball/preview_missing')
		Cocker:SizeToContents()
		Cocker.DoClick = function() 
			LocalPlayer():ConCommand("buy pb_cocker\n");
			DFrame1:SetVisible(false);
			LocalPlayer():ConCommand("gmpb_savedata");
		end

		CockerName = vgui.Create('DLabel')
		CockerName:SetParent(DFrame1)
		CockerName:SetPos(620, 32)
		CockerName:SetText('Cocker')
		CockerName:SizeToContents()

		CockerPrice = vgui.Create('DLabel')
		CockerPrice:SetParent(DFrame1)
		CockerPrice:SetPos(620, 58)
		CockerPrice:SetText('Price: $550')
		CockerPrice:SizeToContents()

		CockerAcc = vgui.Create('DLabel')
		CockerAcc:SetParent(DFrame1)
		CockerAcc:SetPos(620, 73)
		CockerAcc:SetText('Accuracy: 60 (High)')
		CockerAcc:SizeToContents()

		CockerBPM = vgui.Create('DLabel')
		CockerBPM:SetParent(DFrame1)
		CockerBPM:SetPos(620, 88)
		CockerBPM:SetText('Firerate: Medium')
		CockerBPM:SizeToContents()

		CockerForce = vgui.Create('DLabel')
		CockerForce:SetParent(DFrame1)
		CockerForce:SetPos(620, 103)
		CockerForce:SetText('Force: 10000')
		CockerForce:SizeToContents()

		CockerClip = vgui.Create('DLabel')
		CockerClip:SetParent(DFrame1)
		CockerClip:SetPos(620, 118)
		CockerClip:SetText('Hopper: 100 Paintballs')
		CockerClip:SizeToContents()

		BushPanel = vgui.Create('DPanel')
		BushPanel:SetParent(DFrame1)
		BushPanel:SetSize(100, 100)
		BushPanel:SetPos(10, 142)

		Bush = vgui.Create('DImageButton')
		Bush:SetParent(BushPanel)
		Bush:SetSize(84, 84)
		Bush:SetPos(8, 8)
		Bush:SetImage('paintball/preview_missing')
		Bush:SizeToContents()
		Bush.DoClick = function() 
			LocalPlayer():ConCommand("buy pb_bush\n");
			DFrame1:SetVisible(false);
			LocalPlayer():ConCommand("gmpb_savedata");
		end

		BushName = vgui.Create('DLabel')
		BushName:SetParent(DFrame1)
		BushName:SetPos(120, 142)
		BushName:SetText('Bush')
		BushName:SizeToContents()

		BushPrice = vgui.Create('DLabel')
		BushPrice:SetParent(DFrame1)
		BushPrice:SetPos(120, 168)
		BushPrice:SetText('Price: $620')
		BushPrice:SizeToContents()

		BushAcc = vgui.Create('DLabel')
		BushAcc:SetParent(DFrame1)
		BushAcc:SetPos(120, 183)
		BushAcc:SetText('Accurancy: 60 (High)')
		BushAcc:SizeToContents()

		BushBPM = vgui.Create('DLabel')
		BushBPM:SetParent(DFrame1)
		BushBPM:SetPos(120, 198)
		BushBPM:SetText('Firerate: 10.5 BPS (High)')
		BushBPM:SizeToContents()

		BushForce = vgui.Create('DLabel')
		BushForce:SetParent(DFrame1)
		BushForce:SetPos(120, 213)
		BushForce:SetText('Fire Force: 10000')
		BushForce:SizeToContents()

		BushClip = vgui.Create('DLabel')
		BushClip:SetParent(DFrame1)
		BushClip:SetPos(120, 228)
		BushClip:SetText('Hopper: 100 Paintballs')
		BushClip:SizeToContents()

		DM5Panel = vgui.Create('DPanel')
		DM5Panel:SetParent(DFrame1)
		DM5Panel:SetSize(100, 100)
		DM5Panel:SetPos(260, 142)

		DM5 = vgui.Create('DImageButton')
		DM5:SetParent(DM5Panel)
		DM5:SetSize(84, 84)
		DM5:SetPos(8, 8)
		DM5:SetImage('paintball/preview_missing')
		DM5:SizeToContents()
		DM5.DoClick = function() 
			LocalPlayer():ConCommand("buy pb_dm5\n");
			DFrame1:SetVisible(false);
			LocalPlayer():ConCommand("gmpb_savedata");
		end

		DM5Name = vgui.Create('DLabel')
		DM5Name:SetParent(DFrame1)
		DM5Name:SetPos(370, 142)
		DM5Name:SetText('Dye DM5')
		DM5Name:SizeToContents()

		DM5Price = vgui.Create('DLabel')
		DM5Price:SetParent(DFrame1)
		DM5Price:SetPos(370, 168)
		DM5Price:SetText('Price: $750')
		DM5Price:SizeToContents()

		DM5Acc = vgui.Create('DLabel')
		DM5Acc:SetParent(DFrame1)
		DM5Acc:SetPos(370, 183)
		DM5Acc:SetText('Accuracy: 70 (High)')
		DM5Acc:SizeToContents()

		DM5BPM = vgui.Create('DLabel')
		DM5BPM:SetParent(DFrame1)
		DM5BPM:SetPos(370, 198)
		DM5BPM:SetText('Firerate: 13.3 BPS (Fast)')
		DM5BPM:SizeToContents()

		DM5Force = vgui.Create('DLabel')
		DM5Force:SetParent(DFrame1)
		DM5Force:SetPos(370, 213)
		DM5Force:SetText('Fire Force: 10000')
		DM5Force:SizeToContents()

		DM5Clip = vgui.Create('DLabel')
		DM5Clip:SetParent(DFrame1)
		DM5Clip:SetPos(370, 228)
		DM5Clip:SetText('Hopper: 100 Paintballs')
		DM5Clip:SizeToContents()

		PBPanel = vgui.Create('DPanel')
		PBPanel:SetParent(DFrame1)
		PBPanel:SetSize(100, 100)
		PBPanel:SetPos(510, 142)

		PB = vgui.Create('DImageButton')
		PB:SetParent(PBPanel)
		PB:SetSize(84, 84)
		PB:SetPos(8, 8)
		PB:SetImage('paintball/preview_missing')
		PB:SizeToContents()
		PB.DoClick = function() 
			LocalPlayer():ConCommand("buy paintballs " ..PBAmount.GetValue())
			LocalPlayer():ChatPrint("String Test (4): Arguement 1: " ..PBAmount.GetValue())
			DFrame1:SetVisible(false)
			LocalPlayer():ConCommand("gmpb_savedata")
		end

		PBName = vgui.Create('DLabel')
		PBName:SetParent(DFrame1)
		PBName:SetPos(620, 142)
		PBName:SetText('Paintballs')
		PBName:SizeToContents()

		PBColor = vgui.Create('DLabel')
		PBColor:SetParent(DFrame1)
		PBColor:SetPos(620, 168)
		PBColor:SetText('Color: Multi')
		PBColor:SizeToContents()
		
		PBAmount = vgui.Create('DLabel')
		PBAmount:SetParent(DFrame1)
		PBAmount:SetPos(620, 183)
		PBAmount:SetText('Amount: 100')
		PBAmount:SizeToContents()

		--[[ PBAmount = vgui.Create('DNumSlider')
		PBAmount:SetSize(110, 40)
		PBAmount:SetParent(DFrame1)
		PBAmount:SetPos(617, 180)
		PBAmount:SetDecimals(0)
		PBAmount.OnMouseReleased = function() end
		PBAmount.OnValueChanged = function() end
		PBAmount:SetText('Amount :')
		PBAmount:SetValue(1)
		PBAmount:SetMinMax(1, 200) ]]
	end
end
concommand.Add( "buy_menu", GMPBWeapon_Menu )