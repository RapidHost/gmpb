

local CLASS = {}

CLASS.DisplayName			= "Blue Class"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 600
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.PlayerModel			= "models/player.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the Blue spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking
CLASS.FullRotation			= false // Allow the player's model to rotate upwards, etc etc

function CLASS:Loadout( pl )

	if pl:Team() == TEAM_BLUE || pl:Team() == TEAM_Blue then
		if pl:GetNetworkedString("GMPBWeapon", "pb_blazer" ) == "pb_blazer" then
			pl:Give("pb_blazer")
			pl:SetNetworkedString("GMPBWeapon", "pb_blazer")
			pl:SetNetworkedBool("GMPBHasWeapon", true)
		else
			pl:Give( pl:GetNetworkedString("GMPBWeapon") )
		end
	end

end

function CLASS:OnSpawn( pl )
	local modelname = "models/player/barney.mdl"
	pl:SetModel( modelname )
end

function CLASS:OnDeath( pl, attacker, dmginfo )
end

function CLASS:Think( pl )
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:ShouldDrawLocalPlayer( pl )
	return false
end

function CLASS:CalcView( ply, origin, angles, fov )
end

player_class.Register( "Blue", CLASS )