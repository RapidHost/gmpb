AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

resource.AddFile("materials/sprites/pb.vmt")
resource.AddFile("materials/sprites/pb.vtf")

resource.AddFile("materials/paintball/splats/modelsplat_b_1.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_b_2.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_b_3.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_b_4.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_b_5.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_g_1.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_g_2.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_g_3.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_g_4.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_g_5.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_o_1.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_o_2.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_o_3.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_o_4.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_o_5.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_p_1.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_p_2.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_p_3.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_p_4.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_p_5.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_r_1.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_r_2.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_r_3.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_r_4.vmt")
resource.AddFile("materials/paintball/splats/modelsplat_r_5.vmt")

resource.AddFile("materials/paintball/splats/splat_b_1.vmt")
resource.AddFile("materials/paintball/splats/splat_b_1.vtf")
resource.AddFile("materials/paintball/splats/splat_b_2.vmt")
resource.AddFile("materials/paintball/splats/splat_b_2.vtf")
resource.AddFile("materials/paintball/splats/splat_b_3.vmt")
resource.AddFile("materials/paintball/splats/splat_b_3.vtf")
resource.AddFile("materials/paintball/splats/splat_b_4.vmt")
resource.AddFile("materials/paintball/splats/splat_b_4.vtf")
resource.AddFile("materials/paintball/splats/splat_b_5.vmt")
resource.AddFile("materials/paintball/splats/splat_b_5.vtf")

resource.AddFile("materials/paintball/splats/splat_g_1.vmt")
resource.AddFile("materials/paintball/splats/splat_g_1.vtf")
resource.AddFile("materials/paintball/splats/splat_g_2.vmt")
resource.AddFile("materials/paintball/splats/splat_g_2.vtf")
resource.AddFile("materials/paintball/splats/splat_g_3.vmt")
resource.AddFile("materials/paintball/splats/splat_g_3.vtf")
resource.AddFile("materials/paintball/splats/splat_g_4.vmt")
resource.AddFile("materials/paintball/splats/splat_g_4.vtf")
resource.AddFile("materials/paintball/splats/splat_g_5.vmt")
resource.AddFile("materials/paintball/splats/splat_g_5.vtf")

resource.AddFile("materials/paintball/splats/splat_o_1.vmt")
resource.AddFile("materials/paintball/splats/splat_o_1.vtf")
resource.AddFile("materials/paintball/splats/splat_o_2.vmt")
resource.AddFile("materials/paintball/splats/splat_o_2.vtf")
resource.AddFile("materials/paintball/splats/splat_o_3.vmt")
resource.AddFile("materials/paintball/splats/splat_o_3.vtf")
resource.AddFile("materials/paintball/splats/splat_o_4.vmt")
resource.AddFile("materials/paintball/splats/splat_o_4.vtf")
resource.AddFile("materials/paintball/splats/splat_o_5.vmt")
resource.AddFile("materials/paintball/splats/splat_o_5.vtf")

resource.AddFile("materials/paintball/splats/splat_p_1.vmt")
resource.AddFile("materials/paintball/splats/splat_p_1.vtf")
resource.AddFile("materials/paintball/splats/splat_p_2.vmt")
resource.AddFile("materials/paintball/splats/splat_p_2.vtf")
resource.AddFile("materials/paintball/splats/splat_p_3.vmt")
resource.AddFile("materials/paintball/splats/splat_p_3.vtf")
resource.AddFile("materials/paintball/splats/splat_p_4.vmt")
resource.AddFile("materials/paintball/splats/splat_p_4.vtf")
resource.AddFile("materials/paintball/splats/splat_p_5.vmt")
resource.AddFile("materials/paintball/splats/splat_p_5.vtf")

resource.AddFile("materials/paintball/splats/splat_r_1.vmt")
resource.AddFile("materials/paintball/splats/splat_r_1.vtf")
resource.AddFile("materials/paintball/splats/splat_r_2.vmt")
resource.AddFile("materials/paintball/splats/splat_r_2.vtf")
resource.AddFile("materials/paintball/splats/splat_r_3.vmt")
resource.AddFile("materials/paintball/splats/splat_r_3.vtf")
resource.AddFile("materials/paintball/splats/splat_r_4.vmt")
resource.AddFile("materials/paintball/splats/splat_r_4.vtf")
resource.AddFile("materials/paintball/splats/splat_r_5.vmt")
resource.AddFile("materials/paintball/splats/splat_r_5.vtf")

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
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
	
	self.Entity:SetModel( "models/paintball/paintball.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	 
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableDrag(false)
	end
		  
	local i = math.random(0,3)
		  
	if  i == 0  then
		self.Entity:SetColor( 255, 0, 0, 255 )
	elseif  i == 1  then
		self.Entity:SetColor( 0, 255, 0, 255 )
	elseif  i == 2  then
		self.Entity:SetColor( 255, 255, 0, 255 )
	else
		self.Entity:SetColor( 255, 100, 0, 255 )
	end
end


/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
	self.Entity:TakePhysicsDamage( dmginfo )
end

function ENT:PhysicsCollide(data,phy)
	self.Entity:KillShit(data)
end

function ENT:KillShit(data)
	local trace = {}
	trace.filter = {self.Entity}
	data.HitNormal = data.HitNormal * -1
	local start = data.HitPos + data.HitNormal
	local endpos = data.HitPos - data.HitNormal

	--util.Decal("Impact.BloodyFlesh",start,endpos)
	util.Decal("pbsplat"..math.random(1,25),start,endpos)
	self.Entity:EmitSound( "physics/rubber/rubber_tire_impact_soft2.wav", 100, 100 )

	if 
		( data.HitEntity:IsValid() && data.HitEntity:IsPlayer() ) then data.HitEntity:TakeDamage( 100, self.Owner ) 
	end
	self.Entity:Fire("kill", "", 0)
end

function ENT:Touch(ent)
if ent:IsValid() then	
	self.Entity:Fire("kill", "", 0)
	end
end

/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )

end

function ENT:Think()
end