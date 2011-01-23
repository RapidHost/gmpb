include("shared.lua")

ENT.PaintBallMat = Material( "paintball/sprites/ball" )
	
ENT.Colors = {
	Color( 255, 0, 0, 255 ),
	Color( 0, 255, 0, 255 ),
	Color( 255, 255, 0, 255 ),
	Color( 0, 0, 255, 255 ),
}

function ENT:Initialize()
	self:SetModelScale( Vector( 0.05, 0.05, 0.05 ) )
	self.Color = table.Random( self.Colors )
end

local length = 32 -- Blur length
local factor = 0.55 -- Blur fade factor

function ENT:Draw()		
	render.SetMaterial( self.PaintBallMat )
	
	local lcolor = render.GetLightColor( self:GetPos() ) * 2
	lcolor.x = self.Color.r * math.Clamp( lcolor.x, 0, 1 )
	lcolor.y = self.Color.g * math.Clamp( lcolor.y, 0, 1 )
	lcolor.z = self.Color.b * math.Clamp( lcolor.z, 0, 1 )
	lcolor = Color( lcolor.x, lcolor.y, lcolor.z )
	
	local velocity = self:GetVelocity()
	local speed = math.Clamp( velocity:Length(), 0, length )
	
	if speed > 0 then
		for i=1, length do
			local alpha = ( factor * ( length - i ) / length ) * 255
			if alpha > 0 then
				lcolor.a = alpha
				render.DrawSprite( self:GetPos() + velocity * ( i * - 0.001 ), 2, 2, lcolor )
			end
		end			
	end
end