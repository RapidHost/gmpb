CVAR       = {} -- CVAR table
CVAR.Store = {} -- Where CVARS are stored

function CVAR.New(pl, Index, Value)
	local Identity = pl:SteamID()
	
	Index = string.lower(Index)
	
	CVAR.Store[Identity][Index] = CVAR.Store[Identity][Index] or Value
	pl:SetNetworkedString(Index, CVAR.Store[Identity][Index])
end

function CVAR.Create(pl)

	local Identity = pl:SteamID()
	
	CVAR.Store[Identity] = CVAR.Store[Identity] or {}

end

function CVAR.Request(pl, Index)
	local Identity = pl:SteamID()

	Index = string.lower(Index)

	if tonumber(CVAR.Store[Identity][Index]) then
		CVAR.Store[Identity][Index] = tonumber(CVAR.Store[Identity][Index])
	end

	pl:SetNetworkedString(Index, CVAR.Store[Identity][Index])
	return CVAR.Store[Identity][Index]
	
end

function CVAR.Update(pl, Index, Value)

	if !(ValidEntity( pl ) and pl:IsPlayer()) then return end

	local Identity = pl:SteamID()
	
	Index = string.lower(Index)

	pl:SetNWString(Index, CVAR.Store[Identity][Index])
	CVAR.Store[Identity][Index] = Value
	
end

function CVAR.Dump( pl, Index )
	local Identity = pl:SteamID()
	
	Index = string.lower(Index)

	CVAR.Store[Identity][Index] = nil
end

function CVAR.Clear(pl)
	local Identity = pl:SteamID()
	
	CVAR.Store[Identity] = nil
end

function CVAR.Save(pl)
	local Identity = pl:SteamID()
	if !pl:IsPlayer() then return end
	if !CVAR.Store[Identity] then return end
	
	local Contents = util.TableToKeyValues(CVAR.Store[Identity])
	for k,v in pairs(CVAR.Store[Identity]) do
		pl:SetNetworkedString(k, v)
	end
	
	local Save = string.gsub(Identity, ":", "-")
	
	file.Write("GMPB/CVARS/"..Save..".txt", Contents)
end

function CVAR.Load(pl)
	local Identity = pl:SteamID()
	if !pl:IsPlayer() then return end
	
	local Save = string.gsub(Identity, ":", "-")
	
	if file.Exists("GMPB/CVARS/"..Save..".txt") then
		local File = file.Read("GMPB/CVARS/"..Save..".txt")
		if File then
			CVAR.Store[Identity] = util.KeyValuesToTable(File)
			for k,v in pairs(CVAR.Store[Identity]) do
				pl:SetNetworkedString(k, v)
			end
		end
	end
end