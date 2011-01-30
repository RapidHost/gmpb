AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

AccessorFunc( ENT, "TeamID", "Team" )
AccessorFunc( ENT, "FlagBase", "FlagBase" )
AccessorFunc( ENT, "m_bIsAtBase", "IsAtBase" )

function ENT:Initialize()
	self:SetModel( "models/roller.mdl" )
	
	self:SetCollisions( false )
	self:SetTrigger( true )
	
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake()
	end
end

function ENT:SetCollisions( bln )
	if !bln then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	else
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	end
end

function ENT:SetUp( teamid, base )
	self:SetTeam( teamid )
	self:SetFlagBase( base )
	self:SetIsAtBase( true )
	if teamid == TEAM_BLUE then
		self:SetColor( 112, 160, 255, 255 )
	else
		self:SetColor( 237, 28, 36, 255 )
	end
end

function ENT:Return( ply, shouldcall )
	print( "Return", ply )
	if IsValid( ply ) then
		ply:SetFlag()
	end
	self:SetParent()
	self:SetOwner()
	self:SetCollisions( false )
	self:SetTrigger( true )
	self:SetIsAtBase( true )
	self:SetPos( self:GetFlagBase():GetPos() + Vector( 0, 0, 55 ) )
	self:SetAngles( angle_zero )
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
	self:SetCollisions( false )
	self:SetTrigger( false )
	self:SetIsAtBase( false )
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
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	self:SetParent()
	self:SetOwner()
	self:SetCollisions( true )
	self:SetTrigger( true )
	self:SetPos( Pos )
	self:SetAngles( Ang )
	
	local phys = self:GetPhysicsObject()
	
	if IsValid( phys ) then
		phys:Wake()
	end
	
	hook.Call( "OnPlayerFlagDropped", GAMEMODE, ply, self )
	
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() and !IsValid( ent:GetOwner() ) then
		if ent:Team() != self:GetTeam() then
			self:PlayerTake( ent )
		elseif ent:Team() == self:GetTeam() and !self:GetIsAtBase() then
			self:Return( ent, true )
		end
	end
end