AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

AccessorFunc( ENT, "TeamID", "Team" )
AccessorFunc( ENT, "FlagBase", "FlagBase" )

function ENT:Initialize()
	self:SetModel( "models/roller.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetTrigger( true )
	
	util.PrecacheModel( "models/roller_spikes.mdl" )
end

function ENT:SetUp( teamid, base )
	self:SetTeam( teamid )
	self:SetFlagBase( base )
	if teamid == TEAM_BLUE then
		self:SetColor( 112, 160, 255, 255 )
	else
		self:SetColor( 237, 28, 36, 255 )
	end
end

function ENT:Return( ply, shouldcall )
	self:SetParent()
	self:SetOwner()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetTrigger( true )
	self:SetModel( "models/roller.mdl" )
	self:SetPos( self:GetFlagBase():GetPos() + Vector( 0, 0, 55 ) )
	if shouldcall then
		hook.Call( "OnPlayerFlagReturned", GAMEMODE, ply, self )
	end
end

function ENT:PlayerCapture( ply )
	self:Return( ply, false )
	hook.Call( "OnPlayerFlagCapture", GAMEMODE, ply, self )
end

function ENT:PlayerTake( ply )
	ply:SetFlag( self )
	self:SetOwner( ply )
	self:SetParent( ply )
	self:SetModel( "models/roller_spikes.mdl" )
	self:SetTrigger( false )
	local eyes = ply:LookupAttachment( "anim_attachment_head" )
	if eyes != 0 then
		self:SetPos( ply:GetAttachment( eyes ).Pos + vector_up * 32 )
	else
		self:SetPos( ply:GetPos() + vector_up * 78 )
	end
	hook.Call( "OnPlayerFlagTake", GAMEMODE, ply, self )
end

function ENT:PlayerDropped( ply )
	ply:SetFlag()
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetCollisionBounds( Vector( -24, -24, -40 ), Vector( 24, 24, 24 ) )
	self:SetTrigger( true )
	self:SetParent()
	self:SetOwner()
	self:PhysWake()
	hook.Call( "OnPlayerFlagDropped", GAMEMODE, ply, self )
end

function ENT:StartTouch( ent )
	print( self, ent )
	if ent:IsPlayer() and !IsValid( ent:GetOwner() ) then
		if ent:Team() != self:GetTeam() then
			self:PlayerTake( ent )
		elseif ent:Team() == self:GetTeam() then
			self:Return( ent, true )
		end
	end
end