local meta = FindMetaTable( "Player" )
if !meta then return end

function meta:SetFlag( ent )
	if IsValid( ent ) then
		self:SetNWBool( "HasFlag", true )
		self.FlagEntity = ent
	else
		self:SetNWBool( "HasFlag", false )
		self.FlagEntity = nil
	end
end

function meta:HasFlag()
	return self:GetNWBool( "HasFlag", false )
end

function meta:GetFlag()
	return self.FlagEntity
end

function meta:DropFlag()
	if self:HasFlag() then
		self:GetFlag():PlayerDropped( self )
	end
end

function meta:PlayGameSound( snd )
	if SERVER then
		self:SendLua( string.format( "surface.PlaySound(\"%s\")", snd ) )
	else
		surface.PlaySound( snd )
	end
end

function meta:SetMoney( amt )
	self:SetNWInt( "Mny", amt )
end

function meta:GetMoney( amt )
	return self:GetNWInt( "Mnt" )
end