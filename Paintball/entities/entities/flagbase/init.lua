AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Team = TEAM_BLUE
ENT.Game = nil
ENT.Flag = nil
ENT.FlagHere = true

function ENT:Initialize()
	self.Entity:SetModel("models/props_trainstation/trainstation_post001.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE) -- base should move approximately never.
	self.Entity:SetSolid(SOLID_BBOX)
	self.Entity:SetCollisionBounds(Vector(-24,-24,0),Vector(24,24,48))
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- it's solid but it doesn't block players
	self.Entity:SetTrigger(true) -- ...but it does detect them
	
	-- no shadow, and don't collide with players
	self.Entity:DrawShadow(false)
	self.FlagHere = true
end

function ENT:Setupify(tm,flg)
	self.Flag = flg
	self.Team = tm
end

function ENT:Touch(other)
	if ValidEntity(other) and other:IsPlayer() && self.FlagHere then
		if other:Team() != self.Team then
			GAMEMODE:FlagTaken(self.Team,other)
			self.Flag:Taken(other)
		elseif other.hasflag then
			GAMEMODE:FlagCapped(self.Team,other)
		end
	end
end

function ENT:FlagTaken()
	self.FlagHere = false
end

function ENT:FlagReturned()
	self.FlagHere = true
end