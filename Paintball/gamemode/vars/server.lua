SVAR 	   = {} -- SVAR table
SVAR.Store = {} -- Where SVARS are stored

---------------------------------------------------------------
----[ CREATE NEW SVAR ]------------------------------
---------------------------------------------------------------

function SVAR.New(Index, Value)
	local Index = string.lower(Index)
	
	SVAR.Store[Index] = SVAR.Store[Index] or Value
end

---------------------------------------------------------------
----[ GET A SVAR ]----------------------------------------
---------------------------------------------------------------

function SVAR.Request(Index)
	Index = string.lower(Index)
	
	if tonumber(SVAR.Store[Index]) then
		SVAR.Store[Index] = tonumber(SVAR.Store[Index])
	end
	
	return SVAR.Store[Index]
end

---------------------------------------------------------------
----[ UPDATE A SVAR ]----------------------------------
---------------------------------------------------------------

function SVAR.Update(Index, Value)
	Index = string.lower(Index)
	
	SVAR.Store[Index] = Value
end

---------------------------------------------------------------
----[ SVARS SAVE ]-------------------------------------
---------------------------------------------------------------

function SVAR.Save()
	local Contents = util.TableToKeyValues(SVAR.Store)
	
	file.Write("GMPB/SVARS/SVARS.txt", Contents)
end

---------------------------------------------------------------
----[ SVARS LOAD ]-------------------------------------
---------------------------------------------------------------

function SVAR.Load()
	if file.Exists("GMPB/SVARS/SVARS.txt") then
		local File = file.Read("GMPB/SVARS/SVARS.txt")
		
		if File then
			SVAR.Store = util.KeyValuesToTable(File)
		end
	end
end