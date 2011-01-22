local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.WalkSpeed 			= 255
CLASS.CrouchedWalkSpeed 	= 0.35
CLASS.RunSpeed				= 255
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight     	= false

function CLASS:OnSpawn( ply )
	ply:Give( "weapon_paintballgun" )
end

player_class.Register( CLASS.DisplayName, CLASS )