--This is where we force clients to download the content.

function resource.AddMaterial( path )
	resource.AddFile(path..".vtf")
	resource.AddFile(path..".vmt")
end

function resource.AddModel( path )
	resource.AddFile(path..".dx80.vtx")
	resource.AddFile(path..".dx90.vtx")
	resource.AddFile(path..".mdl")
	resource.AddFile(path..".phy")
	resource.AddFile(path..".sw.vtx")
	resource.AddFile(path..".vvd")
	resource.AddFile(path..".xbox.vtx")
end

RESOURCES = {}

/*--------*/
------------
--Precache--
------------
/*--------*/

util.PrecacheSound("npc/roller/remote_yes.wav")
util.PrecacheSound("ambient/alarms/klaxon1.wav")

/*---------*/
-------------
--Materials--
-------------
/*---------*/

RESOURCES.MATS = {
	"materials/paintball/paintball",
	"materials/paintball/paintball_solid",
	"materials/paintball/weapons/a51/a51",
	"materials/paintball/weapons/a51/bluearms",
	"materials/paintball/weapons/a51/hand",
	"materials/paintball/weapons/a51/hopper",
	"materials/paintball/weapons/a51/main",
	"materials/paintball/weapons/a51/pod",
	"materials/paintball/weapons/a51/redarms",
	"materials/paintball/weapons/a51/skin",
	"materials/paintball/weapons/a51/skrew",
	"materials/paintball/weapons/angel/a4barrel copy",
	"materials/paintball/weapons/angel/bluearms",
	"materials/paintball/weapons/angel/halouv1",
	"materials/paintball/weapons/angel/hand",
	"materials/paintball/weapons/angel/main",
	"materials/paintball/weapons/angel/map_1",
	"materials/paintball/weapons/angel/map2",
	"materials/paintball/weapons/angel/pod",
	"materials/paintball/weapons/angel/redarms",
	"materials/paintball/weapons/angel/skin",
	"materials/paintball/weapons/angel/skrew",
	"materials/paintball/weapons/angel/top(co2)",
	"materials/paintball/weapons/blazer/blazbarrel",
	"materials/paintball/weapons/blazer/bluearms",
	"materials/paintball/weapons/blazer/blazeruv1",
	"materials/paintball/weapons/blazer/elbow1",
	"materials/paintball/weapons/blazer/hand",
	"materials/paintball/weapons/blazer/main",
	"materials/paintball/weapons/blazer/revy2",
	"materials/paintball/weapons/blazer/pod",
	"materials/paintball/weapons/blazer/redarms",
	"materials/paintball/weapons/blazer/skin",
	"materials/paintball/weapons/blazer/skrew",
	"materials/paintball/weapons/blazer/top(co2)",
	"materials/paintball/weapons/blazer/VL",
	"materials/paintball/weapons/bush/bushybarrel",
	"materials/paintball/weapons/bush/bluearms",
	"materials/paintball/weapons/bush/bushmaster",
	"materials/paintball/weapons/bush/hand",
	"materials/paintball/weapons/bush/main",
	"materials/paintball/weapons/bush/revy2",
	"materials/paintball/weapons/bush/pod",
	"materials/paintball/weapons/bush/redarms",
	"materials/paintball/weapons/bush/skin",
	"materials/paintball/weapons/bush/skrew",
	"materials/paintball/weapons/bush/top(co2)",
	"materials/paintball/weapons/bush/VL",
	"materials/paintball/weapons/cocker/bluearms",
	"materials/paintball/weapons/cocker/bottomline",
	"materials/paintball/weapons/cocker/hand",
	"materials/paintball/weapons/cocker/main",
	"materials/paintball/weapons/cocker/pod",
	"materials/paintball/weapons/cocker/redarms",
	"materials/paintball/weapons/cocker/revy2",
	"materials/paintball/weapons/cocker/skin",
	"materials/paintball/weapons/cocker/skrew",
	"materials/paintball/weapons/cocker/top",
	"materials/paintball/weapons/cocker/trilogy copy",
	"materials/paintball/weapons/cocker/trilogybarrel",
	"materials/paintball/weapons/cocker/VL",
	"materials/paintball/weapons/dm4/bluearms",
	"materials/paintball/weapons/dm4/boomie copy",
	"materials/paintball/weapons/dm4/DM5uv copy",
	"materials/paintball/weapons/dm4/halouv1",
	"materials/paintball/weapons/dm4/hand",
	"materials/paintball/weapons/dm4/main",
	"materials/paintball/weapons/dm4/pod",
	"materials/paintball/weapons/dm4/redarms",
	"materials/paintball/weapons/dm4/skin",
	"materials/paintball/weapons/dm4/skrew",
	"materials/paintball/weapons/dm4/top(co2)",
	"materials/speedball1_beta/blackbag",
	"materials/speedball1_beta/bluebag",
	"materials/speedball1_beta/greenbag",
	"materials/speedball1_beta/redbag",
	"materials/sprites/pb"
}
for i=1, 12 do
	table.insert( RESOURCES.MATS, "materials/decals/splat"..i )
end

for k, v in pairs( RESOURCES.MATS ) do
	resource.AddMaterial( v )
end

/*------*/
----------
--Models--
----------
/*------*/

RESOURCES.MODELS = {
	"models/paintball/paintball",
	"models/paintball/paintball_solid",
	"models/paintball/paintball_solid",
	"models/paintball/weapons/v_a51/v_a51",
	"models/paintball/weapons/v_angel/v_angel",
	"models/paintball/weapons/v_blazer/v_blazer",
	"models/paintball/weapons/v_bush/v_bush",
	"models/paintball/weapons/v_cocker/v_cocker",
	"models/paintball/weapons/v_dm4/v_dm4"
}

for k, v in pairs( RESOURCES.MODELS ) do
	util.PrecacheModel( v )
	resource.AddModel( v )
end

/*------*/
----------
--Sounds--
----------
/*------*/

RESOURCES.SOUNDS = {
	"sound/marker/pbfire",
	"sound/marker/pbhit"
}

for k, v in pairs( RESOURCES.SOUNDS ) do
	util.PrecacheSound( v )
	resource.AddFile( v )
end


--Misc Files--