if CLIENT then
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
elseif SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = false
end

SWEP.FireSound				= Sound( "paintball/pbfire.wav" )
SWEP.BarrelVelocity			= { 1950, 2150 } -- Min/Max
SWEP.Spread					= 32
SWEP.BarrelPos				= Vector( 9, -0.5, 0 )
SWEP.WalkingTrigger			= true -- Pretty much allow secondary fire to also shoot
SWEP.FireDelay 				= 0.05

SWEP.Primary.Recoil			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay			= SWEP.FireDelay or 0.1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay		= SWEP.FireDelay or 0.1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.PrintName 				= "Paintball Gun"
SWEP.Author 				= "BlackOps"
SWEP.Contact 				= "blackops7799@gmail.com"
SWEP.Purpose 				= "Shoots paintballs"
SWEP.Instructions 			= "Left" .. ( SWEP.WalkingTrigger and "/Right" or "" ) .. " click to shoot"
SWEP.Spawnable				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel				= "models/weapons/v_blazer.mdl"
SWEP.WorldModel 			= "models/weapons/w_blazer.mdl"
SWEP.HoldType				= "ar2"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SetModel( self.ViewModel )
	self.Weapon:SetModel( self.ViewModel )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	timer.Simple( self.Weapon:SequenceDuration(), function()
		if IsValid( self.Weapon ) then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
	end )
	return true
end 

function SWEP:FirePaintBall()

	if self.Owner:WaterLevel() < 3 then

		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		
		if SERVER then
		
			local PB = ents.Create( "paintball_toybox_ent" )
			
			local ShotPos = self.Owner:GetShootPos()
			local AimVec = self.Owner:GetAimVector()
			local AimAng = AimVec:Angle()
			
			ShotPos = ShotPos + self.Owner:GetRight() * self.BarrelPos.x or 0 -- Make it look like it's coming out of the barrel
			ShotPos = ShotPos + self.Owner:GetUp() * self.BarrelPos.y or 0
			ShotPos = ShotPos + self.Owner:GetForward() * self.BarrelPos.z or 0
			
			PB:SetPos( ShotPos )
			PB:SetOwner( self.Owner )
			PB:Spawn()
			
			local BarrelVelocity = math.random( unpack( self.BarrelVelocity ) )
			local RandomProjectory = AimAng:Right() * math.random( -self.Spread, self.Spread ) + AimAng:Up() * math.random( -self.Spread, self.Spread )
			
			local Phys = PB:GetPhysicsObject()
			if IsValid( Phys ) then
				Phys:SetVelocity( self.Owner:GetVelocity() + AimVec * BarrelVelocity + RandomProjectory ) -- Compensate for player movement, barrel velocity, and random spray projectory
			end
		end

		if IsFirstTimePredicted() then
			self.Owner:EmitSound( self.FireSound, 100, math.random( 80, 120 ) )
		end
	end

end

function SWEP:PrimaryAttack()
	self:FirePaintBall()
end

function SWEP:SecondaryAttack()
	if self.WalkingTrigger then
		self:FirePaintBall()
	end
end