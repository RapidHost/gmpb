concommand.Add( "gmpb_buyweapon", function( ply, cmd, args )
	if args[1] then
		ply:BuyWeapon( args[1] )
	else
		ply:PrintConsole( string.format( "Invalid arguments supplied for command: %s\n\tUsage: %s <weaponclass>", cmd, cmd ) )
	end
end )

concommand.Add( "gmpb_stats", function( ply, cmd )
	if ply:IsValid() then
		ply:PrintConsole( string.format( "Captures:\t" ..ply:GetCaptures().. "\nTakes:\t\t" ..ply:GetTakes().. "\nReturns:\t" ..ply:GetReturns().. "\nDrops:\t\t" ..ply:GetDrops().. "\nOuts:\t\t" ..ply:GetOuts().. "\nTags:\t\t" ..ply:GetTags().. "\nScore:\t\t" ..ply:Frags()) )
	end
end )