AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

AccessorFunc( ENT, "TeamID", "Team" )

function ENT:Initialize()
	self:SetModel( "models/props_combine/combine_mine01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetTrigger( true )
end

function ENT:SetUp( teamid )
	self:SetTeam( teamid )
	if teamid == TEAM_BLUE then
		self:SetColor( 112, 160, 255, 255 )
	else
		self:SetColor( 237, 28, 36, 255 )
	end
	local Flag = ents.Create( "flag" )
	Flag:SetMoveType( MOVETYPE_NONE )
	Flag:SetSolid( SOLID_NONE )
	Flag:SetTrigger( true )
	Flag:SetPos( self:GetPos() + Vector( 0, 0, 55 ) )
	Flag:SetUp( teamid, self )
	Flag:Spawn()
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() and ent:HasFlag() and ent:Team() == self:GetTeam() then
		ent:GetFlag():PlayerCapture( ent )
	end
end

function ENT:KeyValue( key, value )
	if !self.KeyValues then
		self.KeyValues = {}
	end
	self.KeyValues[ key ] = value
	if key == "teamid" then
		self:SetUp( tonumber( value ) )
	end
end