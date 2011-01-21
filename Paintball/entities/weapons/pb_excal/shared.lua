if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.PrintName			= "Paintball Gun"
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false

end

SWEP.Author					= "Panda X, TheDeuceBox & BlackOps"
SWEP.Contact				= "Steam: ZSXTAuxsom"
 
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
 
SWEP.ViewModel				= "models/paintball/weapons/v_excal/v_excal.mdl" //"models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_tmp.mdl"

SWEP.Primary.Sound			= Sound( "marker/pbfire.wav" )
SWEP.Primary.ClipSize		= 200
SWEP.Primary.DefaultClip	= 200
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Recoil			= 0.2

SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


function SWEP:Reload()	end
function SWEP:Think()   end

local align = Vector( 7, 5, -5 )

function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel("models/paintball/paintball.mdl")
end
 
function SWEP:PrimaryAttack(data)
    
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	self.Owner.lastFire = CurTime()
	self.Weapon:EmitSound(Sound( "marker/pbfire.wav" ))
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.03 )
	self:TakePrimaryAmmo(1)
	if ( !self:CanPrimaryAttack() ) then return end    

	if CLIENT then return end
 
	//self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	local pb = ents.Create("paintball")
	if pb:IsValid() then
		local v = self.Owner:GetShootPos()
		v = v + self.Owner:GetForward() * 5
		v = v + self.Owner:GetRight() * 7.5
		v = v + self.Owner:GetUp() * -2.5
		pb:SetPos(v)
		pb:SetAngles(self.Owner:GetAimVector())
		pb.Owner = self.Owner
		pb:SetOwner(self.Owner)
		pb:Spawn()

		local acuracy = 60 // The higher the number the more accurate, the lower the number it is more accurate. The number should never be below 40 or 50... unless you want a super inacurate gun..

		local PlShotDistance = (v:Distance(self.Owner:GetEyeTrace( ).HitPos)/acuracy)
		local HitPos = self.Owner:GetEyeTrace().HitPos

		local b = ents.Create( "info_target" )
		if (ValidEntity(b)) then
			local acuracy = 
			b:SetPos( HitPos + Vector(math.random(-PlShotDistance,PlShotDistance),math.random(-PlShotDistance,PlShotDistance),math.random(-PlShotDistance,PlShotDistance)))
			b:Spawn( )
			pb:PointAtEntity(b)
			b:Remove( )
		end
		local phy = pb:GetPhysicsObject()
		if phy:IsValid() then phy:ApplyForceCenter(pb:GetForward()*100000)
		end
	end
end 

function SWEP:SecondaryAttack(data)
	self:PrimaryAttack(data)
end

//Reload Function
function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
end

function SWEP:TakePrimaryAmmo( num )
	
	// Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then 
	
		if ( self:Ammo1() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	
	return end
	
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	
	
end

function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end

function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() < 0 ) then
	
		self.Weapon:EmitSound( "Weapon_Pistol.Empty" )
		self.Weapon:SetNextPrimaryFire( CurTime() + 2.0 )
		return false
		
	end

	return true

end