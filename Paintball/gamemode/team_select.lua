resource.AddFile("materials/paintball/vgui_rolleron.vtf")
resource.AddFile("materials/paintball/vgui_rolleron.vmt")
resource.AddFile("materials/paintball/vgui_rolleroff.vtf")
resource.AddFile("materials/paintball/vgui_rolleroff.vmt")

if CLIENT then

	function team_select( )

		if (TeamChanger and TeamChanger:IsValid()) then TeamChanger:Remove() TeamChanger = nil return end

		local Frame = vgui.Create( "DFrame" );
		Frame:SetName( "Team Selection" );
		Frame:SetTitle( "Select a team..." );
		Frame:SetSize( 512, 176 );
		Frame:SetPos( ScrW()*0.5 - Frame:GetWide()*0.5, ScrH() - Frame:GetTall() - 20);
		Frame:SetVisible( true );
		Frame:MakePopup( );

		TeamChanger = Frame

		local Blue = vgui.Create( "TeamButton", Frame );
		Blue:SetTeam( TEAM_BLUE )
		Blue:SetPos( 32, 32 )
		Blue:SetSize( 128, 128 )

		local Red = vgui.Create( "TeamButton", Frame );
		Red:SetTeam( TEAM_RED )
		Red:SetPos( 192, 32 )
		Red:SetSize( 128, 128 )

		local Spec = vgui.Create( "TeamButton", Frame );
		Spec:SetTeam( TEAM_SPEC )
		Spec:SetPos( 352, 32 )
		Spec:SetSize( 128, 128 )

		--local Rand = vgui.Create( "TeamButton", Frame );
		--Rand:SetTeam( TEAM_SPEC )
		--Rand:SetPos( 352, 32 )
		--Rand:SetSize( 128, 64 )

	end
	concommand.Add( "change_team", team_select );
	
	PANEL = {}

	function PANEL:DoClick( )
		RunConsoleCommand("gmpb_go_team", self.Team)
		TeamChanger:Remove()
		TeamChanger = nil
	end

	function PANEL:SetTeam( id )
		self.Team = tonumber( id )
		self.Text = team.GetName( id )
		self.bgColor = team.GetColor( id )
	end
	
	function PANEL:Paint()
		local x, y = self:GetPos()
		local parentx, parenty = self:GetParent():GetPos()
		x, y = x + parentx, y + parenty
		local mx, my = gui.MousePos()
		local wid, hei = self:GetSize()
		self.Armed = false
		if mx >= x and mx <= x + wid and my >= y and my <= y + hei then self.Armed = true end

		local fgColor = Color( 250, 250, 250, 0 )
		local texImg = surface.GetTextureID("paintball/vgui_rolleroff")
		if self.Armed then
			texImg = surface.GetTextureID("paintball/vgui_rolleron")
			fgColor = Color( 250, 250, 250, 50 )
		end

		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), self.bgColor)
		draw.RoundedBox(4, 2, 2, self:GetWide()-4, self:GetTall()-4, fgColor)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( texImg )
		surface.DrawTexturedRect( 0, 0, 128, 128 )
		if self.Team == TEAM_SPEC then
			surface.SetFont("Default")
			local w, h = surface.GetTextSize( self.Text )
			draw.SimpleText(self.Text, "Default", self:GetWide()*0.5+1, self:GetTall()*0.5-h*0.5+1, Color(0,0,0,255), 1)
			draw.SimpleText(self.Text, "Default", self:GetWide()*0.5, self:GetTall()*0.5-h*0.5, Color(255,255,255,200), 1)
		end
		return true
	end

	vgui.Register( "TeamButton", PANEL, "Button" )

end

if SERVER then
	function TeamReady( id )
		if id == TEAM_SPEC then return true end
		local id2
		if id == TEAM_BLUE then id2 = TEAM_RED else id2 = TEAM_BLUE end
		if team.NumPlayers( id ) + team.NumPlayers( id + 3 ) <= team.NumPlayers( id2 ) + team.NumPlayers( id2 + 3 ) then
			return true
		else
			return false
		end
	end

	local function Go_Team( ply, command, args )
		if ply:Team() == tonumber(args[1]) then
			ply:ChatPrint("You're already on this team!")
		elseif TeamReady( tonumber(args[1]) ) then
			ply:SetTeam(args[1])
			ply:SetNWBool("dead",true)
			ply:KillSilent()

			local models = {}
			if args[1] == "1.00" then
				models = {"alyx","barney","eli","monk","mossman","odessa"}
			elseif args[1] == "2.00" then
				models = {"police"}
			elseif args[1] == "3.00" then
				models = {"kleiner"}
			end
	
			local modelname = "models/player/" .. models[math.random(1,#models)] .. ".mdl"
			util.PrecacheModel( modelname )
			ply:SetModel( modelname )
			ply:PrintMessage( HUD_PRINTCONSOLE, "Model Changed to "..modelname.."!" )
		else
			ply:ChatPrint("This team has too many players!")
			ply:ConCommand( "change_team" )
		end
	end
	concommand.Add( "gmpb_go_team", Go_Team )
end
