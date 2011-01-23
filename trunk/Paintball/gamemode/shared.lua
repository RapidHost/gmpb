GM.Name 	= "PaintBall"
GM.Author 	= ""
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= "Play some paintball"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 5
GM.SelectClass = false
GM.GameLength = 30

GM.NoPlayerSuicide = true
GM.NoPlayerDamage = true
GM.NoPlayerSelfDamage = true		
GM.NoPlayerTeamDamage = true		
GM.NoPlayerPlayerDamage = true 	
GM.NoNonPlayerPlayerDamage = false 	

GM.EnableFreezeCam = false				// TF2 Style Freezecam
GM.DeathLingerTime = 5					// The time between you dying and it going into spectator mode, 0 disables

GM.MaximumDeathLength = 5				// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5				// Player has to be dead for at least this long
GM.AutomaticTeamBalance = true     		// Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = true		// Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true			// Break their fucking legs

GM.NoAutomaticSpawning = true			// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true					// Round based, like CS
GM.RoundLength = 120					// Round length, in seconds
GM.RoundEndsWhenOneTeamAlive = true 	// CS Style rules

GM.SpectateAllPlayers = true			// When true, when a player is assigned to a team, it allows them to spec any player

TEAM_RED = 1
TEAM_BLUE = 2

GM.PlayerModels = {
	[ TEAM_RED ] = {
		"models/player/eli.mdl",
		"models/player/odessa.mdl",
		"models/player/barney.mdl",
		"models/player/alyx.mdl",
		"models/player/monk.mdl",
	},
	[ TEAM_BLUE ] = {
		"models/player/combine_soldier.mdl",
		"models/player/police.mdl",
		"models/player/combine_soldier_prisonguard.mdl",
		"models/player/soldier_stripped.mdl",
		"models/player/combine_super_soldier.mdl",
	},
}

function GM:GetRandomTeamModel( teamid )
	return table.Random( self.PlayerModels[ teamid ] )
end

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RED, "Red Team", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_terrorist", } )
	team.SetClass( TEAM_RED, { "Default" } )
	
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, { "info_player_counterterrorist", } )
	team.SetClass( TEAM_BLUE, { "Default" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start" } )

end

function GM:ShouldCollide( ent1, ent2 )
	return true
end