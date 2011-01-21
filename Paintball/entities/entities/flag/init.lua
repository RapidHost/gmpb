AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include('shared.lua')

ENT.Game = nil
ENT.Holder = nil
ENT.FlagBase = nil

function ENT:Initialize()
	self.Entity:SetModel("models/roller.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	
	self.Entity:SetSolid(SOLID_NONE)
	
	util.PrecacheModel("models/roller_spikes.mdl")
	-- no shadow, and don't collide with players
	self.Entity:DrawShadow(false)
end

function ENT:Setupify(nuTeam)
	self.Team = nuTeam
	self:SetNWInt("team", self.Team)
	if nuTeam == TEAM_BLUE then
		self:SetColor( 112,160,255,255 )
	else
		self:SetColor( 255,96,56,255 )
	end
end

function ENT:SetBase(base)
	self.FlagBase = base
end

function ENT:Taken(ply)
	self.FlagBase:FlagTaken()
	self.Holder = ply
	ply.hasflag = self
	self.Entity:SetModel("models/roller_spikes.mdl")
	local eyes = ply:LookupAttachment( 'anim_attachment_head' )
	if ( eyes == 0 ) then return; end
	self.Entity:SetParent(ply)
	local attachment = ply:GetAttachment( eyes )
	local pos = attachment.Pos + Vector( 0, 0, 32 )
	self.Entity:SetPos( pos )
end

function ENT:Return()
	self.Entity:SetParent(nil)
	if self.Holder != nil then
		self.Holder.hasflag = nil
		self.Holder = nil
	end
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:SetTrigger(false)
	self.Entity:SetModel("models/roller.mdl")
	self.Entity:SetPos(self.FlagBase:GetPos()+Vector(0,0,64))
	self.FlagBase:FlagReturned()
end

function ENT:Drop(ply)

	if self.Holder and self.Holder == ply then
		GAMEMODE:FlagDropped(self.Team,ply)
		self.Holder.hasflag = nil
		self.Holder = nil
	else
		return
	end

	self.Entity:SetParent(nil)

	local op = self.Entity:GetPos()
	
	self.Entity:SetSolid(SOLID_BBOX)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetCollisionBounds(Vector(-24,-24,-40),Vector(24,24,24))
	self.Entity:SetTrigger(true)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetPos(op)
	
	local phy = self.Entity:GetPhysicsObject()
	if phy:IsValid() then
		phy:Wake()
		phy:EnableGravity(true)
		phy:EnableDrag(true)
		phy:SetMass(750)
	end
end

function ENT:Touch(other)
	if ValidEntity( other ) and other:IsPlayer() then
		if other:Team() != self.Team then
			other:PrintMessage(HUD_PRINTCENTER,"You have the flag - return to base!")
			self:Pickup(other)
		else
			self:Return()
			GAMEMODE:FlagReturned(self.Team,other)
		end
	end
end

function ENT:Reset()
	self:Return()
end

function ENT:Pickup(ply)
	self.Entity:SetSolid(SOLID_NONE)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetTrigger(false)
	self:Taken(ply)
end