local function TiltView()
	if (input.IsKeyDown(27)) then
		local Vec1 = Vector( 15, 15, 35 )
		local Vec2 = pl:GetShootPos()
		local Ang = (Vec1 - Vec2):Angle()
		LocalPlayer():SetEyeAngles( Ang )
		LocalPlayer():ChatPrint("Test")
	end
end

 
KeyEvents = {}
//0=KeyUp
//1=KeyPressed
//2=KeyDown
//3=KeyReleased
//set this to false to stop sending messages
KeyEventsDebug=true
//set this to true to send messages about every keys state.
KeyEventsDebugChaty=false
local function KeyThink()
 
	for i=1, 130 do
		if( input.IsKeyDown(i)) then
			if(KeyEvents[i]==0) then KeyEvents[i] = 1
			elseif(KeyEvents[i]==1) then KeyEvents[i] = 2
			elseif(KeyEvents[i]==2) then KeyEvents[i] = 2
			elseif(KeyEvents[i]==3) then KeyEvents[i] = 1 end
		else
			if(KeyEvents[i]==0) then KeyEvents[i] = 0
			elseif(KeyEvents[i]==1) then KeyEvents[i] = 3
			elseif(KeyEvents[i]==2) then KeyEvents[i] = 3
			elseif(KeyEvents[i]==3) then KeyEvents[i] = 0 end
		end
		if(KeyEventsDebug) then
			if(KeyEvents[i]==1) then LocalPlayer():ChatPrint("You pressed key " .. i)
			elseif(KeyEvents[i]==3) then LocalPlayer():ChatPrint("You released key " .. i) end
		end
		if(KeyEventsDebug&&KeyEventsDebugChaty) then
			if(KeyEvents[i]==0) then LocalPlayer():ChatPrint("You are not pressing key " .. i)
			elseif(KeyEvents[i]==2) then LocalPlayer():ChatPrint("You are hpressing key " .. i) end
		end
	end
end