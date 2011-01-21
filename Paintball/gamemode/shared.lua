/*
	shared.lua - Shared Component
	-----------------------------------------------------
	This is the shared component of your gamemode, a lot of the game variables
	can be changed from here.
*/

include( "player_class.lua" )
include( "player_extension.lua" )
//include( "class_default.lua" )
include( 'classes/red_class.lua' )
include( 'classes/blue_class.lua' )
include( 'classes/spec_class.lua' )
include( "player_colours.lua" )

fretta_voting = CreateConVar( "fretta_voting", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE } )

GM.Name 	= "Paintball"
GM.Author 	= "The Deuce Box, Panda X, BlackOps & Sassafrass"
GM.Email 	= ""
GM.Website 	= "www.facepunch.com"
GM.Help		= "No Help Available"

GM.TeamBased = true					// Team based game or a Free For All game?
GM.AllowAutoTeam = true				// Allow auto-assign?
GM.AllowSpectating = false			// Allow people to spectate during the game?
GM.SecondsBetweenTeamSwitches = 10	// The minimum time between each team change?
GM.GameLength = 0					// The overall length of the game
GM.RoundLimit = -1					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = false			// Set to true if players should not be allowed to commit suicide.
GM.NoPlayerDamage = false			// Set to true if players should not be able to damage each other.
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = true			// -1 frag on suicide

GM.MaximumDeathLength = 0			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 2			// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     // Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false		// Set to true if you want realistic fall damage instead of the fix 10 damage.
GM.AddFragsToTeamScore = false		// Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = true		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = false				// Round based, like CS
GM.RoundLength = 30					// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 8				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = true	// CS Style rules

GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 4				// The time between you dying and it going into spectator mode, 0 disables

GM.SelectModel = true               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)

GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"			// The Derma skin to use for the HUD components
GM.SuicideString = "died"			// The string to append to the player's name when they commit suicide.
GM.DeathNoticeDefaultColor = Color( 255, 128, 0 ); // Default colour for entity kills
GM.DeathNoticeTextColor = color_white; // colour for text ie. "died", "killed"

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING } // The spectator modes that are allowed
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate, players being the obvious default choice.
GM.CanOnlySpectateOwnTeam = true; // you can only spectate players on your own team

DeriveGamemode( "base" )

TEAM_JOINING	= 0
TEAM_BLUE		= 1
TEAM_RED		= 2
TEAM_SPEC		= 3

GM.huddata = {}

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Set up all your teams here. Note - HAS to be shared.
---------------------------------------------------------*/
function GM:Think()
	self.BaseClass:Think()
	
	for k,v in pairs( player.GetAll() ) do
	
		local Class = v:GetPlayerClass()
		if ( !Class ) then return end
		
		v:CallClassFunction( "Think" )
		
	end

	// Game time related
	if( !GAMEMODE.IsEndOfGame && ( !GAMEMODE.RoundBased || ( GAMEMODE.RoundBased && GAMEMODE:CanEndRoundBasedGame() ) ) && CurTime() >= GAMEMODE.GetTimeLimit() ) then
		//GAMEMODE:EndOfGame( true )
	end
	
	self.huddata.gmFlagRed = (GetGlobalBool("RedTaken") and 1 or 0)
	self.huddata.gmFlagBlue = (GetGlobalBool("BlueTaken") and 1 or 0)
	self.huddata.gmBlueScore = GetGlobalInt("BlueScore")
	self.huddata.gmRedScore = GetGlobalInt("RedScore")
	self.huddata.gmHasFlag = (LocalPlayer():GetNetworkedBool("HasFlag") and 1 or 0)
end

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_BLUE, "Blue", Color( 62, 192, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, "info_player_counterterrorist" ) // The list of entities can be a table
	team.SetClass( TEAM_BLUE, { "Blue" } )
	
	team.SetUp( TEAM_RED, "Red", Color( 255, 87, 96 ) )
	team.SetSpawnPoint( TEAM_RED, "info_player_terrorist" )
	team.SetClass( TEAM_RED, { "Red" } )
	
	team.SetUp( TEAM_SPEC, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPEC, "info_player_start" )
	team.SetClass( TEAM_SPEC, { "Spec" } )

end

function GM:InGamemodeVote()
	return GetGlobalBool( "InGamemodeVote", false )
end

/*---------------------------------------------------------
   Name: gamemode:TeamHasEnoughPlayers( Number teamid )
   Desc: Return true if the team has too many players.
		 Useful for when forced auto-assign is on.
---------------------------------------------------------*/
function GM:TeamHasEnoughPlayers( teamid )

	local PlayerCount = team.NumPlayers( teamid )

	// Don't let them join a team if it has more players than another team
	if ( GAMEMODE.ForceJoinBalancedTeams ) then
	
		for id, tm in pairs( team.GetAllTeams() ) do
			if ( id > 0 && id < 1000 && team.NumPlayers( id ) < PlayerCount && team.Joinable(id) ) then return true end
		end
		
	end

	return false
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerCanJoinTeam( Player ply, Number teamid )
   Desc: Are we allowed to join a team? Return true if so.
---------------------------------------------------------*/
function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( GAMEMODE:TeamHasEnoughPlayers( teamid ) ) then
		ply:ChatPrint( "That team is full!" )
		return false
	end
	
	return true
	
end

/*---------------------------------------------------------
   Name: gamemode:Move( Player ply, CMoveData mv )
   Desc: Setup Move, this also calls the player's class move
		 function.
---------------------------------------------------------*/
function GM:Move( ply, mv )

	if ( ply:CallClassFunction( "Move", mv ) ) then return true end

end

/*---------------------------------------------------------
   Name: gamemode:KeyPress( Player ply, Number key )
   Desc: Player presses a key, this also calls the player's class
		 OnKeyPress function.
---------------------------------------------------------*/
function GM:KeyPress( ply, key )

	if ( ply:CallClassFunction( "OnKeyPress", key ) ) then return true end

end

/*---------------------------------------------------------
   Name: gamemode:KeyRelease( Player ply, Number key )
   Desc: Player releases a key, this also calls the player's class
		 OnKeyRelease function.
---------------------------------------------------------*/
function GM:KeyRelease( ply, key )

	if ( ply:CallClassFunction( "OnKeyRelease", key ) ) then return true end

end

/*---------------------------------------------------------
   Name: gamemode:PlayerFootstep( Player ply, Vector pos, Number foot, String sound, Float volume, CReceipientFilter rf )
   Desc: Player's feet makes a sound, this also calls the player's class Footstep function.
		 If you want to disable all footsteps set GM.NoPlayerFootsteps to true.
		 If you want to disable footsteps on a class, set Class.DisableFootsteps to true.
---------------------------------------------------------*/
function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 

	if( GAMEMODE.NoPlayerFootsteps || !ply:Alive() || ply:Team() == TEAM_SPECTATOR || ply:IsObserver() ) then
		return true;
	end
	
	local Class = ply:GetPlayerClass();
	if( !Class ) then return end
	
	if( Class.DisableFootsteps ) then // rather than using a hook, we can just do this to override the function instead.
		return true;
	end
	
	if( Class.Footstep ) then
		return Class:Footstep( ply, pos, foot, sound, volume, rf ); // Call footstep function in class, you can use this to make custom footstep sounds
	end
	
end

/*---------------------------------------------------------
   Name: gamemode:CalcView( Player ply, Vector origin, Angles angles, Number fov )
   Desc: Calculates the players view. Also calls the players class
		 CalcView function, as well as GetViewModelPosition and CalcView
		 on the current weapon. Returns a table.
---------------------------------------------------------*/
function GM:CalcView( ply, origin, angles, fov )

	local view = ply:CallClassFunction( "CalcView", origin, angles, fov ) or { ["origin"] = origin, ["angles"] = angles, ["fov"] = fov };
	
	origin = view.origin or origin
	angles = view.angles or angles
	fov = view.fov or fov
		
	local wep = ply:GetActiveWeapon()
	if ( ValidEntity( wep ) ) then
	
		local func = wep.GetViewModelPosition
		if ( func ) then view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 ) end
		
		local func = wep.CalcView
		if ( func ) then view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov ) end
	
	end

	return view
	
end

/*---------------------------------------------------------
   Name: gamemode:GetTimeLimit()
   Desc: Returns the time limit of a game in seconds, so you could
		 make it use a cvar instead. Return -1 for unlimited.
		 Unlimited length games can be changed using vote for
		 change.
---------------------------------------------------------*/
function GM:GetTimeLimit()

	if( GAMEMODE.GameLength > 0 ) then
		return GAMEMODE.GameLength * 60;
	end
	
	return -1;
	
end

/*---------------------------------------------------------
   Name: gamemode:GetGameTimeLeft()
   Desc: Get the remaining time in seconds.
---------------------------------------------------------*/
function GM:GetGameTimeLeft()

	local EndTime = GAMEMODE:GetTimeLimit();
	if ( EndTime == -1 ) then return -1 end
	
	return EndTime - CurTime()

end

/*---------------------------------------------------------
   Name: gamemode:PlayerNoClip( player, bool )
   Desc: Player pressed the noclip key, return true if
		  the player is allowed to noclip, false to block
---------------------------------------------------------*/
function GM:PlayerNoClip( pl, on )
	
	// Allow noclip if we're in single player or have cheats enabled
	if ( GAMEMODE.PlayerCanNoClip || SinglePlayer() || GetConVar( "sv_cheats" ):GetBool() ) then return true end
	
	// Don't if it's not.
	return false
	
end


// This function includes /yourgamemode/player_class/*.lua
// And AddCSLuaFile's each of those files.
// You need to call it in your derived shared.lua IF you have files in that folder
// and want to include them!

function IncludePlayerClasses()

	local Folder = string.Replace( GM.Folder, "gamemodes/", "" );

	for c,d in pairs(file.FindInLua(Folder.."/gamemode/player_class/*.lua")) do
		include( Folder.."/gamemode/player_class/"..d )
		AddCSLuaFile( Folder.."/gamemode/player_class/"..d )
	end

end

IncludePlayerClasses()		

//GMPB Code

local META = FindMetaTable( "Player" )

function META:GetEyeTrace()
	
	if ( self:GetTable().LastPlayertTrace == CurTime() ) then
		return self:GetTable().PlayerTrace
	end

	self:GetTable().PlayerTrace = util.TraceLine( util.GetPlayerTrace( self, self:GetCursorAimVector() ) )
	self:GetTable().LastPlayertTrace = CurTime()
	
	return self:GetTable().PlayerTrace

end

function META:IsOut()
	return self:GetNWBool("dead")
end

META = nil

function rpairs( t )
	local keys = {}
	for k,_ in pairs( t ) do table.insert( keys, k ) end
	
	return function()
	
		if #keys == 0 then return nil end

		local i = math.random( 1, #keys )
		local k = keys[ i ]
		local v = t[ k ]

		table.remove( keys, i )
		return k, v
	end
end