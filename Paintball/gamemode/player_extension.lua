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

function meta:PlayeGameSound( snd )
	self:SendLua( string.format( "surface.PlaySound(\"%s\")", snd ) )
end