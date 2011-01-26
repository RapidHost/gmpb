GameCvar = {}

function GameCvar:Create( name, defaultvalue, flags, valuetoupdate, vartype ) -- Creates a convar that will update a specific variable when the cvar is changed
	if name and defaultvalue and flags and valuetoupdate and vartype then
		local var = CreateConVar( name, defaultvalue, flags )
		cvars.AddChangeCallback( name, function( cvar, prev, new )
			valuetoupdate = vartype( new )
		end )
		return var
	else
		error( "Improper arguments passed to function: GameCvar:Create" )
	end
end

-- tobool, tonumber, tostring
GameCvar:Create( "gmpb_autoteambalnce", 0, { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, GAMEMODE.AutomaticTeamBalance, tobool )
GameCvar:Create( "gmpb_roundlength", 180, { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, GAMEMODE.RoundLength, tonumber )
GameCvar:Create( "gmpb_roundlimit", 20, { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY }, GAMEMODE.RoundLimit, tonumber )