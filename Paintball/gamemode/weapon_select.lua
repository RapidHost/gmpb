if CLIENT then
	function weapon_select( )

		local Frame = vgui.Create( "Frame" );
		Frame:SetName( "Select a weapon..." );
		Frame:SetSize( 350, 130 );
		Frame:SetPos( 500, 850 );
		Frame:SetVisible( true );
		Frame:MakePopup( );

		local A5 = vgui.Create( "Button", Frame );
		A5:SetText( "Tippmann A5" );
		A5:SetPos( 32, 15 );
	
		local Angel = vgui.Create( "Button", Frame );
		Angel:SetText( "WDP Angel" )
		Angel:SetPos( 128, 15 )

		function A5:DoClick( )
			LocalPlayer():ConCommand("gmpb_purchase_a5\n");
		end

		function Angel:DoClick( )
			LocalPlayer():ConCommand("gmpb_purchase_angel\n");
		end
	end
	//concommand.Add( "change_weapon", weapon_select );
end

if SERVER then
	local function Purchase_A5( ply, command, arguments )
		ply:Give("pb_a51");
	end
	//concommand.Add( "gmpb_purchase_a5", Purchase_A5 )
	
	local function Purchase_Angel( ply, command, arguments )
		ply:Give("pb_angel");
	end
	//concommand.Add( "gmpb_purchase_angel", Purchase_Angel )
end
