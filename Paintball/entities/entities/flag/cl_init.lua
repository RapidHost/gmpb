include('shared.lua')

local glowMat = Material("sprites/light_glow02_add")

ENT.spriteColor = Color(255,255,255,255)

function ENT:Initialize()
	self.Setup = true
	self.team = self:GetNWInt("team")
end

function ENT:Draw()
	if !self.Setup then return end
	/*if self.team == TEAM_BLUE then
		--self:SetColor(112,160,255,255)
		self.spriteColor = Color(128,160,255,255)
	elseif self.team == TEAM_RED then
		--self:SetColor(255,96,56,255)
		self.spriteColor = Color(255,96,64,255)
	else return end*/
	local r,g,b,a = self:GetColor()
	render.SetMaterial(glowMat)
	render.DrawSprite(self:GetPos(),56,56,Color( r,g,b,a ))
	self.Entity:DrawModel()
end