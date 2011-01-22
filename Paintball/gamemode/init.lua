AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "player_extension.lua" )

include( "shared.lua" )
include( "downloads.lua" )
include( "player_extension.lua" )

function GM:InitPostEntity()
	self.BaseClass:InitPostEntity()
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

function GM:SetUpFlags()
	for _,ent in pairs( ents.FindByClass("info_target") ) do
		if ent:GetName() == "redflag" then
			local FlagBase = ents.Create( "flagbase" )
			FlagBase:SetPos( ent:GetPos() + Vector( 0, 0, -12 ) )
			FlagBase:Spawn()
			FlagBase:SetUp( TEAM_RED )
		elseif ent:GetName() == "blueflag" then
			local FlagBase = ents.Create( "flagbase" )
			FlagBase:SetPos( ent:GetPos() + Vector( 0, 0, -12 ) )
			FlagBase:Spawn()
			FlagBase:SetUp( TEAM_BLUE )
		end
	end
end

function GM:OnPreRoundStart( num )
	
	for k,v in pairs( player.GetAll() ) do --Each round we start fresh.
		v:SetFrags( 0 )
		v:SetDeaths( 0 )
	end
	
	self.BaseClass:OnPreRoundStart( num )
	
	self:SetUpFlags()
	
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
			ply:ConCommand( "playgamesound misc/freeze_cam.wav" )
			ply:SpectateEntity( attacker )
			ply:Spectate( OBS_MODE_FREEZECAM )
		end
	end )
	ply:Kill() -- Temp.
end

function GM:OnPlayerFlagTake( ply, flag )

end

function GM:OnPlayerFlagCapture( ply, flag )

end

function GM:OnPlayerFlagReturned( ply, flag )

end

function GM:OnPlayerFlagDropped( ply, flag )

end

function GM:PlayerDeath( ply, inflictor, attacker )
	self.BaseClass:PlayerDeath( ply, inflictor, attacker )
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