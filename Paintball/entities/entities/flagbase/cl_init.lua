include( "shared.lua" )

local GlowingMat = Material( "models/props_combine/tprings_globe" )
local ShaderDudv = Material( "models/shadertest/shader3_dudv" )
local ShaderNorm = Material( "models/shadertest/shader3_normal" )

hook.Add( "Initialize", "ChangeTextures", function()
	GlowingMat:SetMaterialString( "$refracttinttexture", "" )
	GlowingMat:SetMaterialTexture( "$dudvmap", ShaderDudv:GetMaterialTexture( "$basetexture" ) )
	GlowingMat:SetMaterialTexture( "$normalmap", ShaderNorm:GetMaterialTexture( "$basetexture" ) )
	GlowingMat:SetMaterialInt( "$model", 1 )
	GlowingMat:SetMaterialFloat( "$bluramount", 0.5 )
	GlowingMat:SetMaterialFloat( "$refractamount", 0.05 )
end )

function ENT:Initialize()
	self.EffectModel = ClientsideModel( "models/props_combine/breentp_rings.mdl", RENDERGROUP_BOTH ) -- ents.Create( "prop_physics" )
	self.EffectModel:SetModel( "models/props_combine/breentp_rings.mdl" )
	self.EffectModel:Spawn()
	self.EffectModel:SetModelScale( Vector( 0.5, 0.5, 0.5 ) )
	local r,g,b,a = self:GetColor()
	self.EffectModel:SetColor( r, g, b, a )
	self.EffectModel:SetPos( self:GetPos() + vector_up * 55 )
end

function ENT:OnRemove()
	if IsValid( self.EffectModel ) then
		SafeRemoveEntity( self.EffectModel )
	end
end

function ENT:Draw()
	self:DrawModel()
	if IsValid( self.EffectModel ) then
		local ang = self:GetAngles()
		ang:RotateAroundAxis( ang:Up(), RealTime() * 60 )		
		self.EffectModel:SetPos( self:GetPos() + vector_up * 55 )
		self.EffectModel:SetAngles( ang )
	end
end