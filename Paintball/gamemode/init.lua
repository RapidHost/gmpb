AddCSLuaFile( "sh_gamevars.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player_extension.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )

include( "shared.lua" )
include( "sh_player_extension.lua" )
include( "sv_downloads.lua" )
include( "sv_commands.lua" )
include( "vars/client.lua" )
include( "vars/server.lua" )

-- General game settings
GM.Settings = {
	StartMoney = 500,
	MaxMoney = 10000,
	MoneyPerKill = 10,
	MoneyPerDeath = -5,
	MoneyPerDrop = -15,
	MoneyPerReturn = 15,
	MoneyPerTake = 10,
	MoneyPerCapture = 50,
	MoneyPerCaptureAssist = 25, -- Player returns the flag x seconds before another player captures
	PointsPerFlagTake = 1,
	PointsPerFlagCap = 2,
	PointsPerFlagDrop = -1,
	PointsPerFlagReturn = 1,
	DefaultWeapon = "pb_blazer",
}

function GM:GetSetting( setting )
	return self.Settings[ setting ] or ""
end

-- Weapon pricing
GM.WeaponsAndPricing = { 
	pb_blazer = 500,
	pb_angel = 1000,
}

function GM:GetWeaponCost( weap )
	return self.WeaponsAndPricing[ weap ] or 0
end

function GM:Initialize()
	
	// If we're round based, wait 5 seconds before the first round starts
	if ( self.RoundBased ) then
		timer.Simple( 10, function()
			self:StartRoundBasedGame()
		end )
	end
	
	timer.Create( "CheckTeamBalance", 30, 0, function()
		if GetConVar( "gmpb_autoteambalnce" ):GetBool() then
			self:CheckTeamBalance()
		end
	end )
	
end

function GM:InitPostEntity()
	self.BaseClass:InitPostEntity()
	
	local settings = physenv.GetPerformanceSettings()

	settings.MaxVelocity = 20000 -- Raised max physics velocity
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
	ply.CurUsedWeapon = self:GetSetting( "DefaultWeapon" )
	
	CVAR.Load( ply )
	CVAR.Create( ply )
	CVAR.New( ply , "name", ply:Nick() )
	
	if !( CVAR.Request(ply, "money") == nil ) then
		if CVAR.Request(ply, "money") > 0 then
			ply:SetMoney( CVAR.Request( ply, "money" ) )
		else
			CVAR.New( ply, "money", 0 )
		end
	end
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
	
	for k,v in pairs( player.GetAll() ) do
		v:SetFlag()
	end
	
	game.CleanUpMap( false, { "flag", "flagbase", } )
	
	for k,v in pairs( ents.FindByClass( "flag" ) ) do
		if v.Return then
			v:Return()
		end
	end
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
end

function GM:GetRoundLimit()
	return GetConVar( "gmpb_roundlimit" ):GetInt()
end

function GM:GetRoundTime( roundnum )
	return GetConVar( "gmpb_roundlength" ):GetFloat()
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
	if ( ply:Team() == attacker:Team() and !self.NoPlayerTeamDamage ) or ply:Team() != attacker:Team() then
		timer.Simple( 2, function()
			if IsValid( ply ) and IsValid( attacker )and  ply:IsPlayer() and attacker:IsPlayer() and ply != attacker then
				ply:PlayGameSound( "misc/freeze_cam.wav" )
				ply:SpectateEntity( attacker )
				ply:Spectate( OBS_MODE_FREEZECAM )
			end
		end )
	
		umsg.Start( "PlayerTagedPlayer" )
			umsg.Entity( attacker )
			umsg.Entity( ply )
		umsg.End()
		
		attacker:AddFrags( 1 )
		attacker:AddTags( 1 )
		ply:AddOuts( 1 )
		
		attacker:AddMoney( self:GetSetting( "MoneyPerKill" ) )
		ply:AddMoney( self:GetSetting( "MoneyPerDeath" ) )
		
		ply:KillSilent() -- Temp
		ply:CreateRagdoll()
		ply:DropFlag()
	end
end

function GM:PlayerLoadout( ply )
	ply:Give( ply.CurUsedWeapon )
end

-- Player buying is currently setup for the purchasing of a weapon then the disguarding of their old, like css. Change or leave?
function GM:OnPlayerBoughtWeapon( ply, weap, success, spent ) -- Handles player purchases
	if success then -- success will be true when they have enough money to buy the weapon
		ply.CurUsedWeapon = weap
		if ply:Alive() then
			ply:StripWeapons()
			ply:Give( weap )
		end
		ply:TakeMoney( spent )
	end
end

function GM:OnPlayerFlagTake( ply, flag )
	ply:AddFrags( self:GetSetting( "PointsPerFlagTake" ) )
	ply:AddMoney( self:GetSetting( "MoneyPerTake" ) )
	ply:AddTakes( 1 )
	self:PlayGameSound( "ambient/alarms/klaxon1.wav" )
	umsg.Start( "PlayerFlag" )
		umsg.Entity( ply )
		umsg.String( "took" )
	umsg.End()
end

function GM:OnPlayerFlagCapture( ply, flag )
	self:RoundEndWithResult( ply:Team() ) -- Round should end
	ply:AddFrags( self:GetSetting( "PointsPerFlagCap" ) )
	ply:AddMoney( self:GetSetting( "MoneyPerCapture" ) )
	ply:AddCaptures( 1 )
	team.AddScore( ply:Team(), 1 )
	umsg.Start( "PlayerFlag" )
		umsg.Entity( ply )
		umsg.String( "captured" )
	umsg.End()
end

function GM:OnPlayerFlagReturned( ply, flag )
	ply:AddFrags( self:GetSetting( "PointsPerFlagReturn" ) )
	ply:AddMoney( self:GetSetting( "MoneyPerReturn" ) )
	ply:AddReturns( 1 )
	self:PlayGameSound( "hl1/fvox/bell.wav" )
	umsg.Start( "PlayerFlag" )
		umsg.Entity( ply )
		umsg.String( "returned" )
	umsg.End()
end

function GM:OnPlayerFlagDropped( ply, flag )
	ply:AddFrags( self:GetSetting( "PointsPerFlagDrop" ) )
	ply:AddMoney( self:GetSetting( "MoneyPerDrop" ) )
	ply:AddDrops( 1 )
	self:PlayGameSound( "npc/roller/code2.wav" )
	umsg.Start( "PlayerFlag" )
		umsg.Entity( ply )
		umsg.String( "dropped" )
	umsg.End()
end

function GM:PlayerDeath( ply, inflictor, attacker )
	-- Use OnPlayerTagged event for handling "kills", not this
	self.BaseClass:PlayerDeath( ply, inflictor, attacker )
	ply:DropFlag()
end

function GM:PlayerDeathSound()
	return true --Disables the default beeping death sound
end

function GM:GetFallDamage( ply, vel ) --REAL realistic fall damage silly garry
	if GAMEMODE.RealisticFallDamage then
		vel = vel - 526.5
		return vel * ( 100 / ( 922.5 - 526.5 ) )
	else
		return 10
	end
end