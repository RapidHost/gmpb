/*
	init.lua - Server Component
	-----------------------------------------------------
	The entire server side bit of Fretta starts here.
	
	WARNING: Code layout is god awful for the time being. Nothing's in order and it's scattered everywhere. I appologize.
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( 'skin.lua' )
AddCSLuaFile( 'player_class.lua' )
AddCSLuaFile( 'classes/red_class.lua' )
AddCSLuaFile( 'classes/blue_class.lua' )
AddCSLuaFile( 'classes/spec_class.lua' )
AddCSLuaFile( 'cl_splashscreen.lua' )
AddCSLuaFile( 'cl_selectscreen.lua' )
AddCSLuaFile( 'cl_gmchanger.lua' )
AddCSLuaFile( 'cl_help.lua' )
AddCSLuaFile( 'player_extension.lua' )
AddCSLuaFile( 'vgui/vgui_hudlayout.lua' )
AddCSLuaFile( 'vgui/vgui_hudelement.lua' )
AddCSLuaFile( 'vgui/vgui_hudbase.lua' )
AddCSLuaFile( 'vgui/vgui_hudcommon.lua' )
AddCSLuaFile( 'vgui/vgui_gamenotice.lua' )
AddCSLuaFile( 'vgui/vgui_scoreboard.lua' )
AddCSLuaFile( 'vgui/vgui_scoreboard_team.lua' )
AddCSLuaFile( 'vgui/vgui_scoreboard_small.lua' )
AddCSLuaFile( 'vgui/vgui_vote.lua' )
AddCSLuaFile( 'cl_hud.lua' )
AddCSLuaFile( 'cl_deathnotice.lua' )
AddCSLuaFile( 'cl_scores.lua' )
AddCSLuaFile( 'cl_notify.lua' )
AddCSLuaFile( 'player_colours.lua' )
AddCSLuaFile( 'team_select.lua' )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_buymenu.lua" )
AddCSLuaFile( "cl_killicons.lua" )

include( "shared.lua" )
include( "sv_gmchanger.lua" )
include( "sv_spectator.lua" )
include( "round_controller.lua" )
include( "utility.lua" )
include( "vars/client.lua" )
include( "vars/server.lua" )
include( "mapcycle.lua" )
include( "team_select.lua" )
include( 'concommands.lua' )
include( 'player.lua' )
include( "maps/"..game.GetMap()..".lua" )

resource.AddFile("materials/paintball/mask.vtf")
resource.AddFile("materials/paintball/mask.vmt")

resource.AddFile("materials/paintball/pb_killicon_v2.vtf")
resource.AddFile("materials/paintball/pb_killicon_v2.vmt")

GM.ReconnectedPlayers = {}

if !ConVarExists( "mp_winlimit" ) then
	CreateConVar( "mp_winlimit", 10, FCVAR_NOTIFY )
end
/*if !ConVarExists( "mp_startmoney" ) then
	CreateConVar( "mp_startmoney", 0, FCVAR_NOTIFY )
end*/

GM.redFlag = nil
GM.redBase = nil
GM.bluFlag = nil
GM.bluBase = nil

GM.bluScore = 0
GM.redScore = 0

GM.StartMoney = nil
GM.MoneyPerKill = 10
GM.MoneyLossPerDeath = 5
GM.MoneyPerFlagCap = 25
GM.RoundsToWin = 10

SetGlobalBool("RESET",false)


function GM:Announce(id,str)
	for _, p in pairs(player.GetAll()) do
		p:PrintMessage(HUD_PRINTCENTER,team.GetName(id).." "..str)
	end
end

function GM:AnnounceWinner(str)
	for _, p in pairs(player.GetAll()) do
		p:PrintMessage(HUD_PRINTCENTER, str)
	end
end

function team.GetScore( id )
	return GetGlobalInt(team.GetName(id).."Score")
end

function team.NumPlayingPlayers( id )
	local num = 0
	for _, pl in pairs( team.GetPlayers( id ) ) do
		if ValidEntity( pl ) and pl:IsPlayer() and !pl:IsOut() then
			num = num + 1
		end
	end
	return num
end

function GM:FlagCapped(id,ply)
	ply.hasflag:Reset()
	ply:AddFrags(4)
	ply:SetNetworkedInt("GMPBMoney", ply:GetNetworkedInt("GMPBMoney")+self.MoneyPerFlagCap)
	SaveData(ply)
	SetGlobalBool(team.GetName(id) .. "Taken",false,true)
	ply:SetNWBool("HasFlag",false,true)
	umsg.Start( "FlagEvent" )
	
		umsg.String( ply:Nick() )
		umsg.String( "captured the " ..team.GetName(id).. " flag (Bug init.lua:121)" )
	
	umsg.End()
	self:EndRound( id )
end

function GM:FlagTaken(id,ply)
	self:Announce(id, "flag taken")
	SetGlobalBool(team.GetName(id) .. "Taken",true,true)
	ply:SetNWBool("HasFlag",true,true)
	ply:AddFrags(1)
	ply:EmitSound("ambient/alarms/klaxon1.wav", 100, 100);
	umsg.Start( "FlagEvent" )
	
		umsg.String( ply:Nick() )
		umsg.String( "took the " ..team.GetName(id).. " flag" )
	
	umsg.End()
end

function GM:FlagDropped(id,ply)
	self:Announce(id, "flag dropped")
	SetGlobalBool(team.GetName(id) .. "Taken",false,true)
	ply:SetNWBool("HasFlag",false,true)
	ply:EmitSound("npc/roller/code2.wav", 100, 100);
	umsg.Start( "FlagEvent" )
	
		umsg.String( ply:Nick() )
		umsg.String( "dropped the " ..team.GetName(id).. " flag" )
	
	umsg.End()
end

function GM:FlagReturned(id,ply)
	self:Announce(id,"flag returned")
	SetGlobalBool(team.GetName(id) .. "Taken",false,true)
	ply:AddFrags(1)
	ply:SetNetworkedInt("GMPBMoney", ply:GetNetworkedInt("GMPBMoney")+self.MoneyPerFlagCap)
	SaveData(ply)
	ply:EmitSound("hl1/fvox/bell.wav", 100, 100);
	umsg.Start( "FlagEvent" )
	
		umsg.String( ply:Nick() )
		umsg.String( "returned the " ..team.GetName(id).. " flag" )
	
	umsg.End()
end

function GM:Initialize()

	/*
	// Disabled - causes games to end in the middle of a round - we don't want that to happen!
	// ::Think takes care of this anyway.
	
	if ( GAMEMODE.GameLength > 0 ) then
		timer.Simple( GAMEMODE.GameLength * 60, function() GAMEMODE:EndOfGame( true ) end )
		SetGlobalFloat( "GameEndTime", CurTime() + GAMEMODE.GameLength * 60 )
	end
	*/
	RunConsoleCommand("mp_winlimit", GAMEMODE.RoundsToWin)
	// If we're round based, wait 5 seconds before the first round starts
	if ( GAMEMODE.RoundBased ) then
		timer.Simple( 10, function() GAMEMODE:StartRoundBasedGame() end )
	end
	
	if ( GAMEMODE.AutomaticTeamBalance ) then
		timer.Create( "CheckTeamBalance", 30, 0, function() GAMEMODE:CheckTeamBalance() end )
	end
	
	//GMPB Code
	SVAR.Load()
	SVAR.New("bluewins", 0)
	SVAR.New("redwins", 0)
	SetGlobalInt("BlueWins", SVAR.Request("bluewins"))
	SetGlobalInt("RedWins", SVAR.Request("redwins"))
	SetGlobalInt("BlueScore",0)
	SetGlobalInt("RedScore",0)
	SetGlobalBool("BlueTaken",false)
	SetGlobalBool("RedTaken",false)
	
end

function GM:StartRound()

	local function loadout( pl )
		if ValidEntity(pl:GetActiveWeapon()) then
			//CVAR.Update( pl, "paintballs", pl:GetActiveWeapon():Ammo1() )
			//CVAR.Update( pl, "clipsize", pl:GetActiveWeapon():Clip1() )
		end
		pl:ShouldDropWeapon(false)

		pl:SetNWBool("dead",false)
		pl.forcedspawn = nil
		pl:Spawn()
		pl:Freeze(true)
	end

	for _, pl in pairs(team.GetPlayers(TEAM_RED)) do
		loadout(pl)
	end

	for _, pl in pairs(team.GetPlayers(TEAM_BLUE)) do
		loadout(pl)
	end

	for _, flag in pairs( ents.FindByClass("flag") ) do
		flag:Reset()
	end

	local function unlock()
		SetGlobalBool("RESET",false)
		for _, pl in pairs( player.GetAll() ) do
			if ValidEntity( pl ) then
				pl:Freeze(false)
			end
		end
	end
	timer.Simple(3, unlock)

end

function GM:InitPostEntity()
	
	self.Spawns = {}
	self.Spawns[ TEAM_RED ] = {}
	self.Spawns[ TEAM_RED ] = table.Add( self.Spawns[ TEAM_RED ], ents.FindByClass( "red_team" ) )
	self.Spawns[ TEAM_RED ] = table.Add( self.Spawns[ TEAM_RED ], ents.FindByClass( "info_player_combine" ) )
	self.Spawns[ TEAM_RED ] = table.Add( self.Spawns[ TEAM_RED ], ents.FindByClass( "info_player_terrorist" ) )
	self.Spawns[ TEAM_RED ] = table.Add( self.Spawns[ TEAM_RED ], ents.FindByClass( "info_player_axis" ) )

	self.Spawns[ TEAM_BLUE ] = {}
	self.Spawns[ TEAM_BLUE ] = table.Add( self.Spawns[ TEAM_BLUE ], ents.FindByClass( "blue_team" ) )
	self.Spawns[ TEAM_BLUE ] = table.Add( self.Spawns[ TEAM_BLUE ], ents.FindByClass( "info_player_rebel" ) )
	self.Spawns[ TEAM_BLUE ] = table.Add( self.Spawns[ TEAM_BLUE ], ents.FindByClass( "info_player_counterterrorist" ) )
	self.Spawns[ TEAM_BLUE ] = table.Add( self.Spawns[ TEAM_BLUE ], ents.FindByClass( "info_player_allies" ) )

	self.Spawns[ TEAM_SPEC ] = {}
	self.Spawns[ TEAM_SPEC ] = ents.FindByClass( "info_player_start" )
	self.Spawns[ TEAM_SPEC ] = table.Add( self.Spawns[ TEAM_SPEC ], ents.FindByClass( "spec_team" ) )
	
	local targs = ents.FindByClass("info_target")
	FLAGS = {}
	for _,t in pairs(targs) do
		if t:GetName() == "redflag" && !FLAGS[TEAM_RED] then
			FLAGS[TEAM_RED] = {}
			FLAGS[TEAM_RED].flag = ents.Create("flag")
			FLAGS[TEAM_RED].flag:SetPos(t:GetPos()+Vector(0,0,48))
			FLAGS[TEAM_RED].flag:Spawn()
			FLAGS[TEAM_RED].flag:SetNWInt("team",TEAM_RED)
			FLAGS[TEAM_RED].flag:Setupify(TEAM_RED,self)
			
			FLAGS[TEAM_RED].base = ents.Create("flagbase")
			FLAGS[TEAM_RED].base:SetPos(t:GetPos()+Vector(0,0,-12))
			FLAGS[TEAM_RED].base:Spawn()
			FLAGS[TEAM_RED].base:Setupify(TEAM_RED,FLAGS[TEAM_RED].flag,self)
			
			FLAGS[TEAM_RED].flag:SetBase(FLAGS[TEAM_RED].base)
		end
		if t:GetName() == "blueflag" && !FLAGS[TEAM_BLUE] then
			FLAGS[TEAM_BLUE] = {}
			FLAGS[TEAM_BLUE].flag = ents.Create("flag")
			FLAGS[TEAM_BLUE].flag:SetPos(t:GetPos()+Vector(0,0,48))
			FLAGS[TEAM_BLUE].flag:Spawn()
			FLAGS[TEAM_BLUE].flag:SetNWInt("team", TEAM_BLUE)
			FLAGS[TEAM_BLUE].flag:Setupify(TEAM_BLUE,self)
			
			FLAGS[TEAM_BLUE].base = ents.Create("flagbase")
			FLAGS[TEAM_BLUE].base:SetPos(t:GetPos()+Vector(0,0,-12))
			FLAGS[TEAM_BLUE].base:Spawn()
			FLAGS[TEAM_BLUE].base:Setupify(TEAM_BLUE,FLAGS[TEAM_BLUE].flag,self)
			
			FLAGS[TEAM_BLUE].flag:SetBase(FLAGS[TEAM_BLUE].base)
		end
	end

	if PROPS then
		if PROPS.specs then
			for k, v in pairs( PROPS.specs ) do
				for _, pos in pairs( v.spawns ) do
					local prop = ents.Create("spec_spawn")
					prop:SetPos( pos )
					prop.index = k
					prop:Spawn()
					prop:Activate()
				end
				local prop = ents.Create("spec_entrance")
				prop:SetPos( v.pos )
				prop:SetAngles( v.ang )
				prop.index = k
				prop:Spawn()
				prop:Activate()
			end
		end
	end
	
	if #ents.FindByClass( "spec_entrance" ) > 0 then
		self.NPCSpectate = true
	end
end

/*---------------------------------------------------------
   Name: gamemode:CanPlayerSuicide( Player ply )
   Desc: Is the player allowed to commit suicide?
---------------------------------------------------------*/
function GM:CanPlayerSuicide( ply )

	if( ply:Team() == TEAM_UNASSIGNED || ply:Team() == TEAM_SPECTATOR ) then
		return false // no suicide in spectator mode
	end

	if ply:IsOut() then
		return false
	elseif GetGlobalBool("RESET") then
		return false
	end
	return true
	
end 

/*---------------------------------------------------------
   Name: gamemode:PlayerSwitchFlashlight( Player ply, Bool on )
   Desc: Can we turn our flashlight on or off?
---------------------------------------------------------*/
function GM:PlayerSwitchFlashlight( ply, on ) 

	if ( ply:Team() == TEAM_SPECTATOR || ply:Team() == TEAM_UNASSIGNED || ply:Team() == TEAM_CONNECTING ) then
		return not on
	end

	return ply:CanUseFlashlight()
	
end

function GM:Think()

end

/*---------------------------------------------------------
   Name: gamemode:PlayerInitialSpawn( Player ply )
   Desc: Our very first spawn in the game.
---------------------------------------------------------*/
function GM:PlayerInitialSpawn( pl )

	//pl:SetTeam( TEAM_UNASSIGNED )
	//pl:SetPlayerClass( "Spectator" )
	pl.m_bFirstSpawn = true
	//pl:UpdateNameColor()
	
	GAMEMODE:CheckPlayerReconnected( pl )
	
	Msg("Blue: "..team.NumPlayers(TEAM_BLUE).."\nRed: " .. team.NumPlayers(TEAM_RED) .. "\n")
	
	pl:SetTeam(TEAM_SPEC)
	pl:ConCommand( "change_team" )
	pl:SetModel( "models/player/kleiner.mdl" )

	CVAR.Load(pl)
	CVAR.Create(pl)
	CVAR.New(pl, "name", pl:Nick())
	
	CVAR.New(pl, "clipsize", 100)
	
	if !((CVAR.Request(pl, "money")) == nil) then
		if (CVAR.Request(pl, "money") > 0) then
			pl:SetNetworkedInt("GMPBMoney", CVAR.Request(pl, "money"))
		else
			CVAR.New(pl, "money", 0)
		end
	end
	
	if !((CVAR.Request(pl, "weapon")) == nil) then
		pl:Give(CVAR.Request(pl, "weapon"))
		pl:SetNetworkedString("GMPBWeapon", (CVAR.Request(pl, "weapon")))
		pl:SetNetworkedBool("GMPBHasWeapon", true)
	else
		CVAR.New(pl, "weapon", "pb_blazer")
	end
	
	if !((CVAR.Request(pl, "paintballs")) == nil) then
		pl:StripAmmo()
		pl:SetAmmo(CVAR.Request(pl, "paintballs"), "Pistol")
	else
		CVAR.New(pl, "paintballs", 500)
	end
	
	CVAR.Update(pl, "name", pl:Nick())

end

function GM:CheckPlayerReconnected( pl )

	if table.HasValue( GAMEMODE.ReconnectedPlayers, pl:UniqueID() ) then
		GAMEMODE:PlayerReconnected( pl )
	end

end

/*---------------------------------------------------------
   Name: gamemode:PlayerReconnected( Player ply )
   Desc: Called if the player has appeared to have reconnected.
---------------------------------------------------------*/
function GM:PlayerReconnected( pl )

	// Use this hook to do stuff when a player rejoins and has been in the server previously

end

function GM:PlayerDisconnected( pl )

	table.insert( GAMEMODE.ReconnectedPlayers, pl:UniqueID() )

	self.BaseClass:PlayerDisconnected( pl )
	
	SaveData(pl)
	self:DropFlag(pl)

end  

function GM:ShowHelp( pl )

	pl:ConCommand( "buy_menu" )
	
end

function GM:EndRound( winner )
	if GetGlobalBool("RESET") then return end
	SetGlobalInt(team.GetName(winner).."Score", team.GetScore( winner ) + 1)
	if team.GetScore( winner ) >= self.RoundsToWin then
		local nextmap = MAPS.GetNextMap()
		for _, pl in pairs( player.GetAll() ) do
			pl:ChatPrint(team.GetName(winner).." Team has won the match!")
			pl:ChatPrint("We're now on our way to: "..nextmap.title)
		end
		SetGlobalInt(team.GetName(winner).."Score", 0)
		SetGlobalInt(team.GetName(winner).."Wins" , GetGlobalInt( team.GetName( winner ).."Wins" ) + 1)
		SVAR.Update( string.lower(team.GetName(winner)).."wins", SVAR.Request( string.lower(team.GetName(winner)).."wins" ) + 1 )
		SVAR.Save()
		local function change( map )
			game.ConsoleCommand("changelevel "..map.."\n")
		end
		timer.Simple( 12, change, nextmap.name )
		return
	end
	self:Announce(winner, "Team Scores - Round Resetting...")
	SetGlobalBool("RESET",true)
	timer.Simple(4, GAMEMODE.StartRound, GAMEMODE)
end

function GM:DropFlag(pl)
	if pl.hasflag then
		pl.hasflag:Drop(pl)
	end
end

function GM:ShutDown( )
	for _, pl in pairs( player.GetAll() ) do
		CVAR.Update(pl, "money", ply:GetNetworkedInt("GMPBMoney"))
		SaveData(pl)
	end
	SVAR.Save()
end

function GM:PlayerSpawn( pl )

	pl:UpdateNameColor()

	// The player never spawns straight into the game in Fretta
	// They spawn as a spectator first (during the splash screen and team picking screens)
	if ( pl.m_bFirstSpawn ) then
	
		pl.m_bFirstSpawn = nil
		
		if ( pl:IsBot() ) then
		
			GAMEMODE:AutoTeam( pl )
			
			// The bot doesn't send back the 'seen splash' command, so fake it.
			if ( !GAMEMODE.TeamBased && !GAMEMODE.NoAutomaticSpawning ) then
				pl:Spawn()
			end
	
		else
		
			pl:StripWeapons()
			GAMEMODE:PlayerSpawnAsSpectator( pl )
			
			// Follow a random player until we join a team
			if ( #player.GetAll() > 1 ) then
				pl:Spectate( OBS_MODE_CHASE )
				pl:SpectateEntity( table.Random( player.GetAll() ) )
			end
			
		end
	
		return
		
	end
		
	pl:CheckPlayerClassOnSpawn()
		
	if ( GAMEMODE.TeamBased && ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) ) then

		GAMEMODE:PlayerSpawnAsSpectator( pl )
		return
	
	end
	
	// Stop observer mode
	pl:UnSpectate()

	// Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, pl )
	
	// Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, pl )
	
	// Call class function
	pl:OnSpawn()
	
	if pl.spec then
		pl.spec:Remove()
		pl:SpectateEntity( nil )
		pl:UnSpectate()
		pl.spec = nil
	end
	if pl.spawnangle then
		pl:SetAngles( pl.spawnangle )
		pl.spawnangle = nil
	end
	pl:SetNetworkedBool("HasFlag",false,true)
	pl:SetHealth(100)
	pl:SetNetworkedBool("GMPBHasWeapon", false)
	SaveData(pl)
	if !pl:IsOut() and pl:Team() != TEAM_SPEC then
		self:PlayerLoadout( pl )
	else
		pl:StripWeapons()
	end
	if GetGlobalBool("RESET") and !pl:IsOut() then
		pl:Freeze(true)
	end
end


function GM:PlayerLoadout( pl )

	pl:CheckPlayerClassOnSpawn()

	pl:OnLoadout()
	
	// Switch to prefered weapon if they have it
	local cl_defaultweapon = pl:GetInfo( "cl_defaultweapon" )
	
	if ( pl:HasWeapon( cl_defaultweapon )  ) then
		pl:SelectWeapon( cl_defaultweapon ) 
	end
	
	if pl:IsOut() then return end
	if pl:Team() == TEAM_BLUE || pl:Team() == TEAM_RED then
		if pl:GetNetworkedString("GMPBWeapon", "pb_blazer" ) == "pb_blazer" then
			pl:Give("pb_blazer")
			pl:SetNetworkedString("GMPBWeapon", "pb_blazer")
			pl:SetNetworkedBool("GMPBHasWeapon", true)
		else
			pl:Give( pl:GetNetworkedString("GMPBWeapon") )
		end
	end
end


function GM:PlayerSetModel( pl )

	pl:OnPlayerModel()
	
end


function GM:AutoTeam( pl )

	if ( !GAMEMODE.AllowAutoTeam ) then return end
	if ( !GAMEMODE.TeamBased ) then return end
	
	GAMEMODE:PlayerRequestTeam( pl, team.BestAutoJoinTeam() )

end

concommand.Add( "autoteam", function( pl, cmd, args ) hook.Call( "AutoTeam", GAMEMODE, pl ) end )


function GM:PlayerRequestClass( ply, class, disablemessage )
	
	local Classes = team.GetClass( ply:Team() )
	if (!Classes) then return end
	
	local RequestedClass = Classes[ class ]
	if (!RequestedClass) then return end
	
	if ( ply:Alive() && SERVER ) then
	
		if ( ply.m_SpawnAsClass && ply.m_SpawnAsClass == RequestedClass ) then return end
	
		ply.m_SpawnAsClass = RequestedClass
		
		if ( !disablemessage ) then
			ply:ChatPrint( "Your class will change to '".. player_class.GetClassName( RequestedClass ) .. "' when you respawn" )
		end
		
	else
		self:PlayerJoinClass( ply, RequestedClass )
		ply.m_SpawnAsClass = nil
	end
	
end

concommand.Add( "changeclass", function( pl, cmd, args ) hook.Call( "PlayerRequestClass", GAMEMODE, pl, tonumber(args[1]) ) end )


local function SeenSplash( ply )

	if ( ply.m_bSeenSplashScreen ) then return end
	ply.m_bSeenSplashScreen = true
	
	if ( !GAMEMODE.TeamBased && !GAMEMODE.NoAutomaticSpawning ) then
		ply:KillSilent()
	end
	
end

concommand.Add( "seensplash", SeenSplash )


function GM:PlayerJoinTeam( ply, teamid )
	
	local iOldTeam = ply:Team()
	
	if ( ply:Alive() ) then
		if ( iOldTeam == TEAM_SPECTATOR || (iOldTeam == TEAM_UNASSIGNED && GAMEMODE.TeamBased) ) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end
	
	ply:SetTeam( teamid )
	ply.LastTeamSwitch = RealTime()
	
	local Classes = team.GetClass( teamid )
	
	
	// Needs to choose class
	if ( Classes && #Classes > 1 ) then
	
		if ( ply:IsBot() || !GAMEMODE.SelectClass ) then
	
			GAMEMODE:PlayerRequestClass( ply, math.random( 1, #Classes ) )
	
		else

			ply.m_fnCallAfterClassChoose = function() 
												ply.DeathTime = CurTime()
												GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid ) 
												ply:EnableRespawn() 
											end

			ply:SendLua( "GAMEMODE:ShowClassChooser( ".. teamid .." )" )
			ply:DisableRespawn()
			ply:SetRandomClass() // put the player in a VALID class in case they don't choose and get spawned
			return
					
		end
		
	end
	
	// No class, use default
	if ( !Classes || #Classes == 0 ) then
		ply:SetPlayerClass( "Default" )
	end
	
	// Only one class, use that
	if ( Classes && #Classes == 1 ) then
		GAMEMODE:PlayerRequestClass( ply, 1 )
	end
	
	GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid )
	
end

function GM:PlayerJoinClass( ply, classname )

	ply.m_SpawnAsClass = nil
	ply:SetPlayerClass( classname )
	
	if ( ply.m_fnCallAfterClassChoose ) then
	
		ply.m_fnCallAfterClassChoose()
		ply.m_fnCallAfterClassChoose = nil
		
	end

end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	// Here's an immediate respawn thing by default. If you want to 
	// re-create something more like CS or some shit you could probably
	// change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then
	
		// If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )
		
	elseif ( oldteam == TEAM_SPECTATOR ) then
	
		// If we're changing from spectator, join the game
		if ( !GAMEMODE.NoAutomaticSpawning ) then
			ply:Spawn()
		end
	
	else
	
		// If we're straight up changing teams just hang
		//  around until we're ready to respawn onto the 
		//  team that we chose
		
	end
	
	//PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )
	
	// Send umsg for team change
    local rf = RecipientFilter();
    rf:AddAllPlayers();
 
    umsg.Start( "fretta_teamchange", rf );
		umsg.Entity( ply );
		umsg.Short( oldteam );
		umsg.Short( newteam );
    umsg.End();
	
end

function GM:CheckTeamBalance()

	local highest
	local notice

	for id, tm in pairs( team.GetAllTeams() ) do
		if ( id > 0 && id < 1000 && team.Joinable( id ) ) then
			if ( !highest || team.NumPlayers( id ) > team.NumPlayers( highest ) ) then
			
				highest = id
				
			elseif team.NumPlayers( id ) < team.NumPlayers( highest ) then
				while team.NumPlayers( id ) < team.NumPlayers( highest ) - 1 do
				
					local ply = GAMEMODE:FindLeastCommittedPlayerOnTeam( highest )

					ply:Kill()
					ply:SetTeam( id )

					// Todo: Notify player 'you have been swapped'
					// This is a placeholder
					ply:ChatPrint( "You have been swapped to "..team.GetName( id ).." for team balance" )
					
					notice = true
					
				end
			end
		end
	end
	
	if !notice then return end
	
	// Send a notice to every player here - Use chatprint? Something else?
	
end

//
// Todo before release: Move this to team module
//
function GM:FindLeastCommittedPlayerOnTeam( teamid )

	local worst = nil

	for k,v in pairs( team.GetPlayers( teamid ) ) do

		// Todo.. least time on team too
		if ( !worst || v:Frags() < worst:Frags() ) then
			worst = v
		end

	end
	
	return worst
	
end

function GM:OnEndOfGame()

	for k,v in pairs( player.GetAll() ) do

		v:Freeze(true)
		v:ConCommand( "+showscores" )
		
	end
	
end

// Override OnEndOfGame to do any other stuff. like winning music.
function GM:EndOfGame( bGamemodeVote )

	if GAMEMODE.IsEndOfGame then return end

	GAMEMODE.IsEndOfGame = true
	SetGlobalBool( "IsEndOfGame", true );
	
	GAMEMODE:OnEndOfGame();
	
	if ( bGamemodeVote ) then
	
		MsgN( "Starting gamemode voting..." )
		PrintMessage( HUD_PRINTTALK, "Starting gamemode voting..." );
		timer.Simple( GAMEMODE.VotingDelay, function() GAMEMODE:StartGamemodeVote() end )
		
	end

end

function GM:GetWinningFraction()
	if ( !GAMEMODE.GMVoteResults ) then return end
	return GAMEMODE.GMVoteResults.Fraction
end

function GM:PlayerShouldTakeDamage( ply, attacker )

	if ( GAMEMODE.NoPlayerSelfDamage && IsValid( attacker ) && ply == attacker ) then return false end
	if ( GAMEMODE.NoPlayerDamage ) then return false end
	
	if ( GAMEMODE.NoPlayerTeamDamage && IsValid( attacker ) ) then
		if ( attacker.Team && ply:Team() == attacker:Team() && ply != attacker ) then return false end
	end
	
	if ( IsValid( attacker ) && attacker:IsPlayer() && GAMEMODE.NoPlayerPlayerDamage ) then return false end
	if ( IsValid( attacker ) && !attacker:IsPlayer() && GAMEMODE.NoNonPlayerPlayerDamage ) then return false end
	
	return true

end


/*function GM:PlayerDeathThink( pl )

	pl.DeathTime = pl.DeathTime or CurTime()
	local timeDead = CurTime() - pl.DeathTime
	
	// If we're in deathcam mode, promote to a generic spectator mode
	if ( GAMEMODE.DeathLingerTime > 0 && timeDead > GAMEMODE.DeathLingerTime && ( pl:GetObserverMode() == OBS_MODE_FREEZECAM || pl:GetObserverMode() == OBS_MODE_DEATHCAM ) ) then
		GAMEMODE:BecomeObserver( pl )
	end
	
	// If we're in a round based game, player NEVER spawns in death think
	if ( GAMEMODE.NoAutomaticSpawning ) then return end
	
	// The gamemode is holding the player from respawning.
	// Probably because they have to choose a class..
	if ( !pl:CanRespawn() ) then return end

	// Don't respawn yet - wait for minimum time...
	if ( GAMEMODE.MinimumDeathLength ) then 
	
		pl:SetNWFloat( "RespawnTime", pl.DeathTime + GAMEMODE.MinimumDeathLength )
		
		if ( timeDead < pl:GetRespawnTime() ) then
			return
		end
		
	end

	// Force respawn
	if ( pl:GetRespawnTime() != 0 && GAMEMODE.MaximumDeathLength != 0 && timeDead > GAMEMODE.MaximumDeathLength ) then
		pl:Spawn()
		return
	end

	// We're between min and max death length, player can press a key to spawn.
	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
		pl:Spawn()
	end
	
end*/

function GM:PlayerDeathThink( pl )
	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end
	pl:Spawn()
end

function GM:GetFallDamage( ply, flFallSpeed )
	
	if ( GAMEMODE.RealisticFallDamage ) then
		return flFallSpeed / 8
	end
	
	return 10
	
end

function GM:PostPlayerDeath( ply, Inflictor, Attacker )

	// Note, this gets called AFTER DoPlayerDeath.. AND it gets called
	// for KillSilent too. So if Freezecam isn't set by DoPlayerDeath, we
	// pick up the slack by setting DEATHCAM here.
	
	//if ( ply:GetObserverMode() == OBS_MODE_NONE ) then
	//	ply:Spectate( OBS_MODE_DEATHCAM )
	//end	
	
	//ply:OnDeath()

end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:SetNWBool("dead",true)
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
		
			if ( GAMEMODE.TakeFragOnSuicide ) then
			
				attacker:AddFrags( -1 )
				
				if ( GAMEMODE.TeamBased && GAMEMODE.AddFragsToTeamScore ) then
					team.AddScore( attacker:Team(), -1 )
				end
			
			end
			
		else
		
			attacker:AddFrags( 1 )
			attacker:SetNetworkedInt("GMPBMoney", attacker:GetNetworkedInt("GMPBMoney")+self.MoneyPerKill)
			ply:SetNetworkedInt("GMPBMoney", ply:GetNetworkedInt("GMPBMoney")-self.MoneyLossPerDeath)
			SaveData(attacker)
			SaveData(ply)
			ply:SetNetworkedFloat("GMPBHasWeapon", false)
			
			if ( GAMEMODE.TeamBased && GAMEMODE.AddFragsToTeamScore ) then
				team.AddScore( attacker:Team(), 1 )
			end
			
		end
		
	end
	
	if ( GAMEMODE.EnableFreezeCam && IsValid( attacker ) && attacker != ply ) then
	
		ply:SpectateEntity( attacker )
		ply:Spectate( OBS_MODE_FREEZECAM )
		
	end
	
end

function GM:PlayerDeath(pl, Inflictor, Attacker)

	pl.NextSpawnTime = CurTime() + 1

	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
	
		Inflictor = Inflictor:GetActiveWeapon()
		if ( Inflictor == NULL ) then Inflictor = Attacker end
	
	end

	if ( Attacker:IsPlayer() and pl != Attacker ) then

		if self.NPCSpectate and !pl.spec then
			pl.NextSpawnTime = CurTime() + 60
			local NPC = InternalSpawnNPC( pl, pl:GetForward():Angle(), pl:GetPos(), pl:GetUp() )
			if ValidEntity( NPC ) then
				local nearest = ents.FindByClass("spec_entrance")[1]
				local distance;
				for _, ent in pairs( ents.FindByClass("spec_entrance") ) do
					if !distance or ent:GetPos():Distance(pl:GetPos()) < distance then
						nearest = ent
						distance = ent:GetPos():Distance(pl:GetPos())
					end
				end
				NPC:SetLastPosition( nearest:GetPos() )
				timer.Simple(1,NPC.SetSchedule,NPC,SCHED_FORCED_GO_RUN)
				pl:Spectate( OBS_MODE_IN_EYE )
				pl:SpectateEntity( NPC )
				pl.spec = NPC
				NPC.spec = pl
				timer.Simple(.2,pl.SendLua,pl,"ents.GetByIndex("..NPC:EntIndex().."):SetColor(0,0,0,0)")
			end
		end

		umsg.Start( "PlayerKilledByPlayer" )
		
			umsg.Entity( pl )
			umsg.String( Inflictor:GetClass() )
			umsg.Entity( Attacker )
		
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " killed " .. pl:Nick() .. " using " .. Inflictor:GetClass() .. "\n" )
	
	end

	self:DropFlag(pl)

	if GetGlobalBool("RESET") then return end
	if team.NumPlayingPlayers(TEAM_BLUE) == 0 then
		self:EndRound( TEAM_RED )
	elseif team.NumPlayingPlayers(TEAM_RED) == 0 then
		self:EndRound( TEAM_BLUE )
	end

end

function InternalSpawnNPC( Player, Angles, Position, Normal )

	Position = Position + Normal * 8
	
	// Create NPC
	local NPC = ents.Create( "npc_citizen" )
	if !ValidEntity( NPC ) then return end
	
	NPC:SetPos( Position )
	NPC:SetAngles( Angles )
	NPC:SetModel( string.gsub( Player:GetModel(), "player/", "" ) )
	NPC:SetKeyValue( "citizentype", 4 )
	
	NPC:Spawn()
	NPC:Activate()
	
	NPC:DropToFloor()
	return NPC
	
end

function GM:PlayerSpawnedNPC( pl, npc )
	return
end

function GM:StartSpectating( ply )

	if ( !GAMEMODE:PlayerCanJoinTeam( ply ) ) then return end
	
	ply:StripWeapons();
	GAMEMODE:PlayerJoinTeam( ply, TEAM_SPECTATOR )
	GAMEMODE:BecomeObserver( ply )

end


function GM:EndSpectating( ply )

	if ( !GAMEMODE:PlayerCanJoinTeam( ply ) ) then return end

	GAMEMODE:PlayerJoinTeam( ply, TEAM_UNASSIGNED )
	
	ply:KillSilent()

end

/*---------------------------------------------------------
   Name: gamemode:PlayerRequestTeam()
		Player wants to change team
---------------------------------------------------------*/
function GM:PlayerRequestTeam( ply, teamid )

	if ( !GAMEMODE.TeamBased && GAMEMODE.AllowSpectating ) then
	
		if ( teamid == TEAM_SPECTATOR ) then
			GAMEMODE:StartSpectating( ply )
		else
			GAMEMODE:EndSpectating( ply )
		end
	
		return
	
	end
	
	return self.BaseClass:PlayerRequestTeam( ply, teamid )

end

local function TimeLeft( ply )

	local tl = GAMEMODE:GetGameTimeLeft()
	if ( tl == -1 ) then return end
	
	local Time = string.ToMinutesSeconds( tl )
	
	if ( IsValid( ply ) ) then
		ply:PrintMessage( HUD_PRINTCONSOLE, Time )
	else
		MsgN( Time )
	end
	
end

concommand.Add( "timeleft", TimeLeft )

local function SetStartMoney(ply, cmd, arg)
	if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
	local amount = tonumber( arg[1] )
	if type( amount ) != "number" then return end
	if amount <= 160000 then
		GAMEMODE.StartMoney = amount
		RunConsoleCommand( "mp_startmoney", amount )
	end
end

concommand.Add( "mp_startmoney", SetStartMoney)

local function SetWinRounds(ply, cmd, arg)
	if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
	local amount = tonumber( arg[1] )
	if type( amount ) != "number" then return end
	if amount <= 50 then
		GAMEMODE.RoundsToWin = amount
		RunConsoleCommand( "mp_winlimit", amount )
	end
end

concommand.Add( "mp_winninground", SetWinRounds)

local function ClearServerScore(ply)
	if ply:IsAdmin() then
		SVAR.Update( "bluewins", 0 )
		SVAR.Update( "redwins", 0 )
		SetGlobalInt("BlueWins", SVAR.Request("bluewins"))
		SetGlobalInt("RedWins", SVAR.Request("redwins"))
		SetGlobalInt("BlueScore",0)
		SetGlobalInt("RedScore",0)
	end
end

concommand.Add( "mp_resetscore", ClearServerScore)

function GetCVARData(pl)
	local weapon = pl:GetActiveWeapon()
	CVAR.Update(pl, "weapon", weapon:GetClass())
	pl:PrintMessage( HUD_PRINTCONSOLE, CVAR.Request(pl, "money"))
	pl:PrintMessage( HUD_PRINTCONSOLE, CVAR.Request(pl, "weapon"))
end

concommand.Add( "gmpb_getdata", GetCVARData )

function SetCVARData(pl, cmd, arg)
	if pl:IsAdmin() then
		local money = arg[1] or 0
		CVAR.Update(pl, "money", money)
		pl:SetNetworkedInt("GMPBMoney", money)
	end
end

concommand.Add( "gmpb_setmoney", SetCVARData )

function SaveData(pl)
	if !pl:IsOut() and pl:Team() != TEAM_SPEC then
		local weapon = pl:GetActiveWeapon()
		CVAR.Update(pl, "weapon", weapon:GetClass())
		CVAR.Update(pl, "paintballs", pl:GetActiveWeapon():Ammo1())
		CVAR.Update(pl, "clipsize", pl:GetActiveWeapon():Clip1())
		CVAR.Update(pl, "money", pl:GetNetworkedInt("GMPBMoney"))
		CVAR.Save(pl)
	end
end

concommand.Add( "gmpb_savedata", SaveData)