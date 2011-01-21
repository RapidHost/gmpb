ENT.Type = "point"

function ENT:Initialize()
	self.spawns = {}
	for _, ent in pairs( ents.FindByClass( "spec_spawn" ) ) do
		if ent.index == self.index then
			table.insert( self.spawns, ent )
		end
	end
end

function ENT:Think()
	local pos = self:GetPos()
	for _, ent in pairs( ents.FindByClass("npc_*") ) do
		if ent.spec then
			if ent:GetPos():Distance(pos) < 10 then
				local spawn = self.spawns[1]
				for _, Spawnpoint in rpairs( self.spawns ) do
					local blocked = false
					for _, ent in pairs( ents.FindInSphere( Spawnpoint:GetPos(), 24 ) ) do
						if ValidEntity( ent ) and ent:IsPlayer() and ent:Alive() then
							blocked = true
						end
					end
					if !blocked then
						spawn = Spawnpoint
						break
					end
				end
				ent.spec.forcedspawn = spawn
				ent.spec.spawnangle = ent:GetForward():Angle()
				ent.spec.NextSpawnTime = CurTime()
			end
		end
	end
end

function ENT:KeyValue(key, value)
	self[key] = tonumber(value)
end