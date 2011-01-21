MAPS = {}

MAPS.List = {
	{
		title = " The Valley",
		name = "gmpb_valley"
	},
	{
		title = "New Facility",
		name = "gmpb_facility2"
	},
	--{
	--	title = "The Woods",
	--	name = "gmpb_woods",
	--	minplayers = 5,
	--	maxplayers = 30
	--},
	--{
	--	title = "The Bridges",
	--	name = "gmpb_2bridges"
	--},
	{
		title = "Black",
		name = "gmpb_black",
		minplayers = 10
	},
	{
		title = "Swamp Gullie",
		name = "gmpb_gullie",
		minplayers = 10
	},
	{
		title = "Speed Ball Arena",
		name = "gmpb_speedball",
		minplayers = 0
	},
	{
		title = "Test Map",
		name = "gmpb2_ai_node",
		minplayers = 64
	}
}

function MAPS.GetNextMap()
	local PLAYERS = #player.GetAll()
	local NEXTMAP = MAPS.List[1]
	local curmap = game.GetMap()
	local num = 0
	local foundmap = false
	for index, map in pairs( MAPS.List ) do
		if map.name == curmap then
			curmap = index
			num = index + 1
			if num > #MAPS.List then num = 1 end
		end
	end
	while( !foundmap ) do
		if MAPS.IsAvailable( MAPS.List[num], PLAYERS ) then
			NEXTMAP = MAPS.List[num]
			foundmap = true
		elseif num + 1 == curmap then
			NEXTMAP = MAPS.List[1]
			foundmap = true
		elseif num + 1 > #MAPS.List then
			num = 1
		else
			num = num + 1
		end
	end
	return NEXTMAP
end

function MAPS.IsAvailable( map, players )
	if map.minplayers and players < map.minplayers then
		return false
	elseif map.maxplayers and players > map.maxplayers then
		return false
	end
	return true
end