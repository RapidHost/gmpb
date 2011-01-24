concommand.Add( "gmpb_buyweapon", function( ply, cmd, args )
	if args[1] then
		ply:BuyWeapon( args[1] )
	else
		ply:PrintConsole( string.format( "Invalid arguments supplied for command: %s\n\tUsage: %s <weaponclass>", cmd, cmd ) )
	end
end )