
function ENT:Initialize()
end

local glowMat = Material( "sprites/light_glow02_add" )

function ENT:Draw()

	local r,g,b,a = self:GetColor()
	render.SetMaterial( glowMat )
	render.DrawSprite( self:GetPos(), 56, 56, Color( r,g,b,a ) )
	
	self:DrawModel()
	self:RenderGlow()
	
end