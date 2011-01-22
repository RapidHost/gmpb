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
	self:RenderGlow( clr )
	
end