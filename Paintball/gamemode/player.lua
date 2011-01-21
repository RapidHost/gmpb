function GM:PlayerSelectSpawn( pl )

	if pl.forcedspawn then
		local spawn = pl.forcedspawn
		pl.forcedspawn = false
		return spawn
	end
	
	local SpawnTable = self.Spawns[ pl:Team() ]
	if pl:IsOut() then SpawnTable = self.Spawns[ TEAM_SPEC ] end

	if ( SpawnTable ) then

		for _,Spawnpoint in rpairs( SpawnTable ) do
			local blocked = false
			for _, ent in pairs( ents.FindInSphere( Spawnpoint:GetPos(), 24 ) ) do
				if ValidEntity( ent ) and ent:IsPlayer() and ent:Alive() then
					blocked = true
				end
			end
			if !blocked then return Spawnpoint end
		end

	end

	// In case there's no spawnpoints available use an info_player_start.
	return self.Spawns[ TEAM_SPEC ][ 1 ]
end

function GM:PlayerDeathThink( pl )
	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end
	pl:Spawn()
end

/*function GM:SetupMove( ply, move )

	if !( ValidEntity(ply) and ply:Alive() ) then return end

	local speed = 200

	if ply:KeyDown( IN_SPEED ) then
		speed = 300
	elseif ply:GetVelocity():Length() > 10 then
		speed = 200
	end

	if ply:Crouching() then
		speed = 150
	end

	if ply.lastFire and ply.lastFire >= CurTime() - 0.5 then
		speed = speed * 0.5
	end

	move:SetMaxClientSpeed( speed )
	return true;

end*/