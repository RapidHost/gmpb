local meta = FindMetaTable( "Player" )
if !meta then return end

function meta:SetFlag( ent )
	print( self, "SetFlag", ent )
	self.FlagEntity = ent
end

function meta:HasFlag()
	return IsValid( self.FlagEntity )
end

function meta:GetFlag()
	return self.FlagEntity
end

function meta:DropFlag()
	if self:HasFlag() then
		self:GetFlag():PlayerDropped( self )
	end
end

function meta:PrintConsole( txt ) -- Easier to remember..
	self:PrintMessage( HUD_PRINTCONSOLE, txt )
end

function meta:BuyWeapon( weap )
	local cost = GAMEMODE:GetWeaponCost( weap )
	hook.Call( "OnPlayerBoughtWeapon", GAMEMODE, self, weap, ( cost and self:GetMoney() >= cost ), cost )
end

function meta:PlayGameSound( snd )
	if SERVER then
		self:SendLua( string.format( "surface.PlaySound(\"%s\")", snd ) )
	else
		surface.PlaySound( snd )
	end
end

function meta:AddMoney( amt )
	self:SetMoney( self:GetMoney() + amt )
	if SERVER then
		CVAR.Update( self, "money", self:GetMoney() )
		CVAR.Save( self )
	end
end

function meta:SubtractMoney( amt )
	self:SetMoney( self:GetMoney() - amt )
	if SERVER then
		CVAR.Update( self, "money", self:GetMoney() )
		CVAR.Save( self )
	end
end

function meta:SetMoney( amt )
	self:SetNWInt( "Mny", amt )
	if SERVER then
		CVAR.Update( self, "money", self:GetMoney() )
		CVAR.Save( self )
	end
end

function meta:GetMoney()
	return self:GetNWInt( "Mny" )
end