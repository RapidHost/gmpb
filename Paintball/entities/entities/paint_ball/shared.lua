ENT.Type 				= "anim"
ENT.Base 				= "base_anim"
ENT.PrintName			= "Paint Ball"
ENT.Author				= "BlackOps7799"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.PBHitSound = Sound( "paintball/pbhit.wav" )

function ENT:OnRemove() -- Predicted and whatnot
	self:EmitSound( self.PBHitSound, 100, math.random( 90, 110 ) )
end