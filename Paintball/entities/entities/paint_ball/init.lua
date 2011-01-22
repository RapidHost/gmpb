AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	self:PhysicsInitSphere( 1, "plastic" )
	self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
	self:PhysWake()
	self:Fire( "Kill", "", 30 ) -- Auto cleanup if it never broke.. Can happen
end

function ENT:OnTakeDamage( dmginfo )
	--self:TakePhysicsDamage( dmginfo )
end

local function VectorAngle( vec1, vec2 ) -- Returns difference in degrees of two normal vectors
	local costheta = vec1:Dot( vec2 ) / ( vec1:Length() *  vec2:Length() )
	local theta = math.acos( costheta )
	return math.deg( theta )
end

function ENT:PhysicsCollide( data, phys )
	
	local AngOfHit = VectorAngle( data.HitNormal, self:GetVelocity():GetNormal() )
	
	if AngOfHit <= 91.45 and AngOfHit >= 90 and data.DeltaTime > 0.2 and ( math.random( 1, 10 ) >= 4 ) then -- Very low angle of ricochet plus a small chance of it breaking anyway
		self:EmitSound( self.PBHitSound, 100, math.random( 190, 250 ) ) -- Ricochet sound
		local Speed = data.OurOldVelocity:Length()
		local DotProduct = data.HitNormal:Dot( data.OurOldVelocity * -1 ) --reflect the bounce
		local Dir = ( 2 * data.HitNormal * DotProduct ) + data.OurOldVelocity -- Moar bounce
		Dir:Normalize()
		phys:SetVelocity( Dir * ( Speed * 0.8 ) ) -- Apply the new velocity a little slower than before
	else
		if data.HitEntity then
			if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
				--[[local dmginfo = DamageInfo()
				dmginfo:SetDamage( 1 )
				dmginfo:SetDamageType( DMG_BULLET ) --Bullet damage
				dmginfo:SetAttacker( self:GetOwner() )
				dmginfo:SetDamageForce( self:GetVelocity():GetNormal() * 5 )
				dmginfo:SetDamagePosition( self:GetPos() )
				--dmginfo:SetInflictor() -- Figure out a way to register the weapon?
				data.HitEntity:TakeDamageInfo( dmginfo )]]
				hook.Call( "OnPlayerTagged", GAMEMODE, data.HitEntity, self, self:GetOwner() )
			else
				data.HitNormal = data.HitNormal * -1
				local start = data.HitPos + data.HitNormal
				local endpos = data.HitPos - data.HitNormal
				util.Decal( "pbsplat" .. math.random( 1, 25 ), start, endpos )
			end
		end
		SafeRemoveEntity( self )
	end
end

function ENT:Touch( ent )
end