if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.PrintName      = "Paintball Gun"
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false

end

SWEP.Author   = "Panda X and TheDeuceBox"
SWEP.Contact        = "thepanda@impulse55.net"
 
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
 
SWEP.ViewModel      = "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel   = "models/weapons/w_snip_scout.mdl"

SWEP.Primary.Sound			= Sound( "marker/pbfire.wav" )
SWEP.Primary.ClipSize      	= 10
SWEP.Primary.DefaultClip    = 50
SWEP.Primary.Automatic    	= false
SWEP.Primary.Ammo         	= "pistol"
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Recoil			= 0.2

SWEP.Secondary.ClipSize     = 0
SWEP.Secondary.DefaultClip  = 0
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"


function SWEP:Reload()	end
function SWEP:Think()   end

local align = Vector( 7, 5, -5 )

function SWEP:Precache()
    util.PrecacheSound(self.Primary.Sound)
    util.PrecacheModel("models/paintball/paintball.mdl")
end
 
function SWEP:PrimaryAttack(data)
    
      
    
    self.BaseClass.ShootEffects (self)
    self.Weapon:EmitSound(Sound( "marker/pbfire.wav" ))
    self.Weapon:SetNextPrimaryFire( CurTime() + 1.0 )
    self:TakePrimaryAmmo(1)
    if ( !self:CanPrimaryAttack() ) then return end    

    if CLIENT then return end
 
    //self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
    local pb = ents.Create("paintball")
    if pb:IsValid() then
		local v = self.Owner:GetShootPos()
		v = v + self.Owner:GetForward() * 5
		v = v + self.Owner:GetRight() * 7
		v = v + self.Owner:GetUp() * -5
        pb:SetPos(v)
        pb:SetModel("models/paintball/paintball.mdl")
        pb:Spawn()
		pb.Owner = self.Owner
		pb:SetOwner(self.Owner)
	pb:SetPhysicsAttacker(self.Owner)
        pb:Fire("kill", "", 10)
        local physobj = pb:GetPhysicsObject()
        if physobj:IsValid() then
	    physobj:Wake()
            physobj:ApplyForceCenter(self.Owner:EyeAngles():Forward() * 5000000)
	    physobj:EnableGravity(false)
	    physobj:EnableDrag(false)
        end
    end
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

function SWEP:SecondaryAttack()

   if SERVER then
	if self.Owner:GetFOV() < 80 then
            self.Owner:SetFOV( 90, 0 )
            
        else
            self.Owner:SetFOV( 45, 0 )
            
        end
   end
end

//function SWEP:Reload()
    //self.Weapon:DefaultReload( ACT_VM_RELOAD );
    //self.Owner:SetFOV( 90, 0 )
//end