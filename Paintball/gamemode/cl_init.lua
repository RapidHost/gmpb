include( "sh_player_extension.lua" )
include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_scoreboard.lua" )

killicon.Add( "paint_ball", "paintball/paintball_killicon", color_white )
killicon.Add( "flag", "paintball/vgui_rolleroff", color_white )
	
usermessage.Hook( "PlayerFlag", function( msg )

	local ply = msg:ReadEntity()
	local txt = msg:ReadString()
	
	if ( !IsValid( g_DeathNotify ) ) then return end

	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( ply )
	pnl:AddText( txt )
	pnl:AddIcon( "flag" )
	
	g_DeathNotify:AddItem( pnl )
	
end )

usermessage.Hook( "PlayerTagedPlayer", function( msg )

	local ply = msg:ReadEntity()
	local tagged = msg:ReadEntity()
	
	if ( !IsValid( g_DeathNotify ) ) then return end

	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( ply )
	pnl:AddIcon( "paint_ball" )
	pnl:AddText( tagged )
	
	g_DeathNotify:AddItem( pnl )
	
end )

function GM:GetMotionBlurValues( x, y, fwd, spin )
	if LocalPlayer():Alive() and ( LocalPlayer():Team() == TEAM_RED or LocalPlayer():Team() == TEAM_BLUE ) then
		fwd = 0.01
	end
	return x, y, fwd, spin
end

local WalkTimer = 0
local VelSmooth = 0
local ViewWobble = 0

function GM:CalcView( ply, origin, angle, fov )

	if ply:Alive() and ply:IsOnGround() then

		local vel = ply:GetVelocity()
		local ang = ply:EyeAngles()
		
		VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.45
		WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
		
		angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01
		
		if ViewWobble > 0 then
			angle.roll = angle.roll + math.sin( CurTime() * 2.5 ) * (ViewWobble * 15)
			ViewWobble = ViewWobble - 0.1 * FrameTime()
		end
		
		angle.roll = angle.roll + math.sin( WalkTimer * 0.75 ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.3 ) * VelSmooth * 0.001
	end
	
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end

function GM:Think()
	self.BaseClass:Think()
end

local MaterialBlurX = Material( "pp/blurx" )
local MaterialBlurY = Material( "pp/blury" )
local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
	["$basetexture"] = "color/white",
	["$vertexalpha"] = "1",
	["$model"] = "1",
} )
local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {
	["$basetexture"] = "_rt_FullFrameFB",
	["$additive"] = "1",
} )

local RT1 = render.GetBloomTex0()
local RT2 = render.GetBloomTex1()

/*------------------------------------
	RenderGlow()
------------------------------------*/

local meta = FindMetaTable( "Entity" )
if !meta then return end

function meta:RenderGlow( color )

	color = color or color_white

	// tell the stencil buffer we're going to write a value of one wherever the model
	// is rendered
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilReferenceValue( 1 )
	
	// this uses a small hack to render ignoring depth while not drawing color
	// i couldn't find a function in the engine to disable writing to the color channels
	// i did find one for shaders though, but I don't feel like writing a shader for this.
	cam.IgnoreZ( true )
		render.SetBlend( 0 )
			SetMaterialOverride( MaterialWhite )
				self:DrawModel()
			SetMaterialOverride()
		render.SetBlend( 1 )
	cam.IgnoreZ( false )
	
	local w, h = ScrW(), ScrH()
	
	// draw into the white texture
	local oldRT = render.GetRenderTarget()
	
	render.SetRenderTarget( RT1 )
	
		render.SetViewPort( 0, 0, RT1:GetActualWidth(), RT1:GetActualHeight() )
		
		cam.IgnoreZ( true )
		
			render.SuppressEngineLighting( true )

			render.SetColorModulation( color.r/255, color.g/255, color.b/255 )
			
				SetMaterialOverride( MaterialWhite )
					self:DrawModel()
				SetMaterialOverride()
				
			render.SetColorModulation( 1, 1, 1 )
			render.SuppressEngineLighting( false )
			
		cam.IgnoreZ( false )
		
		render.SetViewPort( 0, 0, w, h )
	render.SetRenderTarget( oldRT )
	
	// don't need this for the next pass
	render.SetStencilEnable( false )

end

/*------------------------------------
	RenderScene()
------------------------------------*/
hook.Add( "RenderScene", "ResetGlow", function( Origin, Angles )

	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( RT1 )
		render.Clear( 0, 0, 0, 255, true )
	render.SetRenderTarget( oldRT )
	
end )

/*------------------------------------
	RenderScreenspaceEffects()
------------------------------------*/
hook.Add( "RenderScreenspaceEffects", "CompositeGlow", function()

	MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 )
	MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 )
	MaterialBlurX:SetMaterialFloat( "$size", 2 )
	MaterialBlurY:SetMaterialFloat( "$size", 2 )
		
	local oldRT = render.GetRenderTarget()
	
	for i = 1, 4 do
	
		// blur horizontally
		render.SetRenderTarget( RT2 )
		render.SetMaterial( MaterialBlurX )
		render.DrawScreenQuad()

		// blur vertically
		render.SetRenderTarget( RT1 )
		render.SetMaterial( MaterialBlurY )
		render.DrawScreenQuad()
		
	end

	render.SetRenderTarget( oldRT )
	
	// tell the stencil buffer we're only going to draw
	// where the player models are not.
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	
	// composite the scene
	MaterialComposite:SetMaterialTexture( "$basetexture", RT1 )
	render.SetMaterial( MaterialComposite )
	render.DrawScreenQuad()

	// don't need this anymore
	render.SetStencilEnable( false )
	
end )