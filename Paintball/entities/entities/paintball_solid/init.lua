AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
 
 

function ENT:SpawnFunction( ply, tr )
 
    if ( !tr.Hit ) then return end
   
    local SpawnPos = tr.HitPos + tr.HitNormal * .5
   
    local ent = ents.Create( "paintball" )
        ent:SetPos( SpawnPos )
    ent:Spawn()
    ent:Activate()
   
    return ent
   
end
 
 
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
 
    // Temp Paintball Model
    self.Entity:SetModel( "models/paintball/paintball_solid.mdl" )
   
    // Sphere it.
    self.Entity:PhysicsInitSphere( 1, "" )
   
    // Wake the physics object up. It's time to have fun!
	

    // Wake up!
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS ) 
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetColor( math.random(0,255), math.random(0,255), math.random(0,255), 255 )
    
	// Set collision bounds exactly
    self.Entity:SetCollisionBounds( Vector( 1, 1, 1 ), Vector( 1, 1, 1 ) )
   
end
 
/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
	
	util.Decal("Blood", data.HitPos + data.HitNormal , data.HitPos - data.HitNormal) 
	//physobj:EnableMotion( bool )
	self.Entity:SetColor( 255, 255, 255, 0 )
	self.Entity:EmitSound( "Rubber.BulletImpact" )
	self.Entity:Remove()
	
end

// function ENT:Touch( hitEnt )
//  if hitEnt:IsValid() && hitEnt:IsPlayer() then
//  hitEnt:SetHealth( 0 )
//  self.Entity:Remove()
  
// end
//end