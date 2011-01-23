AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "player_extension.lua" )

include( "shared.lua" )
include( "downloads.lua" )
include( "player_extension.lua" )

GM.Settings = {
	StartMoney = 500,
	MaxMoney = 10000,
	PointsPerFlagCap = 2,
}

function GM:GetSetting( setting )
	return self.Settings[ setting ] or ""
end

function GM:InitPostEntity()
	self.BaseClass:InitPostEntity()
	
	local settings = physenv.GetPerformanceSettings()

	settings.MaxVelocity = 10000 -- Raised max physics velocity
	settings.MaxAngularVelocity = 3600
	settings.MinFrictionMass = 10
	settings.MaxFrictionMass = 2500
	settings.MaxCollisionsPerObjectPerTimestep = 10
	settings.MaxCollisionChecksPerTimestep = 250

	physenv.SetPerformanceSettings( settings )
	
	self:SetUpFlags()
end

function GM:PlayerHurt( ply, attacker, healthleft, healthtaken ) 
	self.BaseClass:PlayerHurt( ply, attacker, healthleft, healthtaken )
end

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
end

hook.Add( "SetupPlayerVisibility", "AddFlagToVis", function( ply, viewent )
	for k,v in ipairs( ents.GetAll() ) do
		if v:GetClass() == "flag" then
			AddOriginToPVS( v:GetPos() )
		end
	end
end )

function GM:Think()
	self.BaseClass:Think()
end

function GM:PlayGameSound( snd )
	BroadcastLua( string.format( "surface.PlaySound(\"%s\")", snd ) )
end

local function GetGroundPos( ent )
	local tracedata = {
		start = ent:GetPos() + vector_up * 64,
		endpos = ent:GetPos() + vector_up * -512,
		filter = ent,
	}
	return util.TraceLine( tracedata ).HitPos
end

function GM:SetUpFlags()
	for _,ent in pairs( ents.FindByClass("info_target") ) do
		if ent:GetName() == "redflag" then
			local FlagBase = ents.Create( "flagbase" )
			FlagBase:SetPos( GetGroundPos( ent ) )
			FlagBase:SetUp( TEAM_RED )
			FlagBase:Spawn()
		elseif ent:GetName() == "blueflag" then
			local FlagBase = ents.Create( "flagbase" )
			FlagBase:SetPos( GetGroundPos( ent ) )
			FlagBase:SetUp( TEAM_BLUE )
			FlagBase:Spawn()
		end
	end
end

function GM:OnPreRoundStart( num )
	
	for k,v in pairs( player.GetAll() ) do --Each round we start fresh.
		v:SetFrags( 0 )
		v:SetDeaths( 0 )
	end
	
	game.CleanUpMap( false, { "flag", "flagbase", } )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
end

function GM:PlayerSetModel( ply )
	local modelname = self:GetRandomTeamModel( ply:Team() )
	util.PrecacheModel( modelname )
	ply:SetModel( modelname )
end

function GM:PlayerDisconnected( ply )
	ply:DropFlag()
end

function GM:RoundEnd( t )
	self.BaseClass:RoundEnd()
end

function GM:RoundTimerEnd()
	self.BaseClass:RoundTimerEnd()
end

function GM:OnPlayerTagged( ply, paintball, attacker )
	timer.Simple( 2, function()
		if IsValid( ply ) and IsValid( attacker )and  ply:IsPlayer() and attacker:IsPlayer() and ply != attacker then
			ply:PlayGameSound( "misc/freeze_cam.wav" )
			ply:SpectateEntity( attacker )
			ply:Spectate( OBS_MODE_FREEZECAM )
		end
	end )
	ply:Kill() -- Temp.
end

function GM:OnPlayerFlagTake( ply, flag )
	self:PlayGameSound( "ambient/alarms/klaxon1.wav" )
end

function GM:OnPlayerFlagCapture( ply, flag )
	
end

function GM:OnPlayerFlagReturned( ply, flag )
	self:PlayGameSound( "hl1/fvox/bell.wav" )
end

function GM:OnPlayerFlagDropped( ply, flag )
	self:PlayGameSound( "npc/roller/code2.wav" )
end

function GM:PlayerDeath( ply, inflictor, attacker )
	self.BaseClass:PlayerDeath( ply, inflictor, attacker )
	ply:DropFlag()
end

function GM:PlayerDeathSound()
	return true --FUCK YOU
end

function GM:GetFallDamage( ply, vel ) --REAL realistic fall damage silly garry
	if GAMEMODE.RealisticFallDamage then
		vel = vel - 526.5
		return vel * ( 100 / ( 922.5 - 526.5 ) )
	else
		return 10
	end
end