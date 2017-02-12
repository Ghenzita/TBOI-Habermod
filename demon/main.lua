local mod = RegisterMod("demon", 1)
local funct = {}

local char = Isaac.GetPlayerTypeByName("demon")

local soulhearts;

function funct:PostPlayerInit (player) 
	if player:GetPlayerType() == char then
  
    end

  if Game():GetFrameCount() < 5 then --new run
    Isaac.RemoveModData(mod)
	soulhearts = 0
	player:AddCoins (5)
  else --continued run
    soulhearts = tonumber(Isaac.LoadModData(mod))
  end
	if type(soulhearts) ~= "number" then soulhearts = 0 end 
	
end

function funct:HeartCounter ()
	local player = Isaac.GetPlayer (0)
	
	if player:GetPlayerType() == char then
		sh_add = player:GetSoulHearts ()
		soulhearts = soulhearts + sh_add
        Isaac.SaveModData(mod, tostring(soulhearts)) 
		if sh_add > 0 then
			player:AddSoulHearts (-sh_add)			
		end
	end
end

function funct:HeartHud ()
local player = Isaac.GetPlayer (0)
local game = Game()
if soulhearts == nil then soulhearts = 0 end

	if player:GetPlayerType() == char then
		local h_hud = Sprite(); h_hud:Load("gfx/ui/hudheart.anm2", true); h_hud:Play("Sprite", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(130,11), Vector(0,0), Vector(0,0));
		
		if soulhearts < 10 then
			local text = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(soulhearts, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
		elseif soulhearts >= 10 and soulhearts < 20 then
			local second_digit = soulhearts - 10
			local text10 = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play("1", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
			local textsecond_digit = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(second_digit, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(150,11), Vector(0,0), Vector(0,0));
		elseif soulhearts >= 20 and soulhearts < 24 then
			local second_digit = soulhearts - 20
			local text20 = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play("2", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
			local textsecond_digit = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(second_digit, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(151,11), Vector(0,0), Vector(0,0));
		elseif soulhearts >= 24 then
			local text10 = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play("2", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
			local textsecond_digit = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(4, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(151,11), Vector(0,0), Vector(0,0));
			soulhearts = 24
		end
		
		
	end
end


mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, funct.PostPlayerInit)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, funct.HeartCounter)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, funct.HeartHud)