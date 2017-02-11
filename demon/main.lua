local mod = RegisterMod("demon", 1)
local funct = {}

local char = Isaac.GetPlayerTypeByName("demon")


function funct:PostPlayerInit (player) 
	if player:GetPlayerType() == char then
		
	end
	soulhearts = 0 
	blackhearts = 0
end

function funct:HeartCounter ()
	local player = Isaac.GetPlayer (0)
	
	if player:GetPlayerType() == char then
		sh_add = player:GetSoulHearts ()
		soulhearts = soulhearts + sh_add
		if sh_add > 0 then
			player:AddSoulHearts (-sh_add)
		end
	end
end

function funct:HeartHud ()
local player = Isaac.GetPlayer (0)

	if player:GetPlayerType() == char then
		local h_hud = Sprite(); h_hud:Load("gfx/ui/hudheart.anm2", true); h_hud:Play("Sprite", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(130,11), Vector(0,0), Vector(0,0));
		local text = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(soulhearts, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, funct.PostPlayerInit)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, funct.HeartCounter)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, funct.HeartHud)