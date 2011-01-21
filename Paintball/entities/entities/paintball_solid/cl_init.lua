
include('shared.lua')

local matBall = Material( "paintball/paintball" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	local i = math.random( 0, 0 )
	
	if ( i == 0 ) then
		self.Color = Color( 255, 0, 0, 255 )
	elseif ( i == 1 ) then
		self.Color = Color( 0, 255, 0, 255 )
	elseif ( i == 2 ) then
		self.Color = Color( 255, 255, 0, 255 )
	else
		self.Color = Color( 0, 0, 255, 255 )
	end
	
end
