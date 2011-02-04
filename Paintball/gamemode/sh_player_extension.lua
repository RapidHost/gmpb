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

-- Money

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

-- Captures

function meta:AddCaptures( amt )
	self:SetCaptures( self:GetCaptures() + amt )
end

function meta:SetCaptures( amt )
	self:SetNWInt( "Cap", amt )
end

function meta:GetCaptures()
	return self:GetNWInt( "Cap" )
end

-- Returns

function meta:AddReturns( amt )
	self:SetReturns( self:GetReturns() + amt )
end

function meta:SetReturns( amt )
	self:SetNWInt( "Rtn", amt )
end

function meta:GetReturns()
	return self:GetNWInt( "Rtn" )
end

-- Outs

function meta:AddOuts( amt )
	self:SetOuts( self:GetOuts() + amt )
end

function meta:SetOuts( amt )
	self:SetNWInt( "Out", amt )
end

function meta:GetOuts()
	return self:GetNWInt( "Out" )
end

-- Tags (Like Frags but for PvP kills only instead of caps, returns, etc)

function meta:AddTags( amt )
	self:SetTags( self:GetTags() + amt )
end

function meta:SetTags( amt )
	self:SetNWInt( "Tag", amt )
end

function meta:GetTags()
	return self:GetNWInt( "Tag" )
end

-- Drops

function meta:AddDrops( amt )
	self:SetDrops( self:GetDrops() + amt )
end

function meta:SetDrops( amt )
	self:SetNWInt( "Drop", amt )
end

function meta:GetDrops()
	return self:GetNWInt( "Drop" )
end

-- Takes

function meta:AddTakes( amt )
	self:SetTakes( self:GetTakes() + amt )
end

function meta:SetTakes( amt )
	self:SetNWInt( "Take", amt )
end

function meta:GetTakes()
	return self:GetNWInt( "Take" )
end