include( "shared.lua" )

function ENT:Initialize()
end

local glowMat = Material( "sprites/light_glow02_add" )

function ENT:Draw()

	local r,g,b,a = self:GetColor()
	local clr = Color( r,g,b,a )
	render.SetMaterial( glowMat )
	render.DrawSprite( self:GetPos(), 56, 56, clr )
	
	self:DrawModel()
	
	cam.Start3D( EyePos(), EyeAngles() )
		self:RenderGlow( clr )
	cam.End3D()
	
end