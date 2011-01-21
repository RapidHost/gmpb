if !SERVER then return end

local function equip( pl, cost, item )
	if !(ValidEntity(pl) and pl:IsPlayer()) then return end
	pl:SetNWInt("GMPBMoney", pl:GetNWInt("GMPBMoney")-cost)
	pl:SetNWString("GMPBWeapon", item)
	pl:StripWeapons()
	pl:Give(item)
	pl:SelectWeapon(item)
end

local weapons = {
	{
		id = "pb_a51",
		cost = 225
	},
	{
		id = "pb_angel",
		cost = 575
	},
	{
		id = "pb_bush",
		cost = 620
	},
	{
		id = "pb_cocker",
		cost = 550
	},
	{
		id = "pb_dm5",
		cost = 750
	},
	{
		id = "pb_blazer",
		cost = 150
	}
}

local function PurchaseItem(pl, cmd, arg)

	local item = arg[1]
	local amount = tonumber(arg[2]) or 1
	
	if !item then return end
	
	if amount != tonumber(amount) then return end
	if amount < 0 then return end
	amount = math.floor( amount )
	
	if pl:Team() == TEAM_SPEC then return end
	if pl:IsOut() then return end

	for _, wep in pairs( weapons ) do
		if item == wep.id then
			if pl:GetNWInt("GMPBMoney") >= wep.cost then
				equip( pl, wep.cost, wep.id )
			else
				pl:PrintMessage( HUD_PRINTCONSOLE, "Insufficient Funds!" )
			end
			return
		end
	end

	if item == "paintballs" then
		if pl:GetNWInt("GMPBMoney") >= math.ceil(amount*0.5) then
			pl:SetNWInt("GMPBMoney", pl:GetNWInt("GMPBMoney")-math.ceil(amount*0.5))
			pl:GiveAmmo( tonumber(amount), "pistol" );
		end
		return
	end
	
	pl:PrintMessage( HUD_PRINTCONSOLE, "Invalid GMPB weapon "..arg[1].."!" )
	
end

concommand.Add( "buy", PurchaseItem)