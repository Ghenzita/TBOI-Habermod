local mod = RegisterMod("demon", 1)
local funct = {}

local char = Isaac.GetPlayerTypeByName("demon")
local soulhearts;
local isHuman;

function funct:PostPlayerInit (player) 
	if player:GetPlayerType() == char then --demon init
		 if Game():GetFrameCount() < 5 then --new run
			Isaac.RemoveModData(mod)
			soulhearts = 4
		else --continued run
			soulhearts = tonumber(Isaac.LoadModData(mod))
		end
	if type(soulhearts) ~= "number" then soulhearts = 0 end 
	
	isHuman = 1
    end
end

function funct:demonUpdate () 
	local player = Isaac.GetPlayer (0)
	
	if player:GetPlayerType() == char then
	
	--counter for the soul hearts (also works for black hearts)
		if isHuman == 1 then
			sh_add = player:GetSoulHearts ()
			soulhearts = soulhearts + sh_add
			Isaac.SaveModData(mod, tostring(soulhearts)) 
			if sh_add > 0 then
				player:AddSoulHearts (-sh_add)			
			end
			--Max hp
			if player:GetMaxHearts() > 6 then
				player:AddMaxHearts (-(player:GetMaxHearts() - 6), false)
			end
		end
	end
end

function funct:HeartHud () --ui for the heart
local player = Isaac.GetPlayer (0)
local game = Game()
if soulhearts == nil then soulhearts = 0 end

	if player:GetPlayerType() == char then
		local h_hud = Sprite(); h_hud:Load("gfx/ui/hudheart.anm2", true); h_hud:Play("Sprite", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(130,11), Vector(0,0), Vector(0,0)); --heart sprite
		
		if soulhearts < 10 then
			local text = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(soulhearts, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0)); --text 1-9
		elseif soulhearts >= 10 and soulhearts < 20 then --text 10-19
			local second_digit = soulhearts - 10
			local text10 = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play("1", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
			local textsecond_digit = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(second_digit, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(150,11), Vector(0,0), Vector(0,0));
		elseif soulhearts >= 20 and soulhearts < 24 then --text 20-23
			local second_digit = soulhearts - 20
			local text20 = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play("2", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
			local textsecond_digit = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(second_digit, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(151,11), Vector(0,0), Vector(0,0));
		elseif soulhearts >= 24 then --text 24+
			local text10 = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play("2", true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(145,11), Vector(0,0), Vector(0,0));
			local textsecond_digit = Sprite(); h_hud:Load("gfx/ui/hudtext.anm2", true); h_hud:Play(4, true); h_hud.Color = Color(1,1,1,1,0,0,0); h_hud:Render(Vector(151,11), Vector(0,0), Vector(0,0));
			soulhearts = 24
		end
		
		
	end
end

function funct:Transformation()
local player = Isaac.GetPlayer(0);

	if player:GetPlayerType() == char then
		if Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0) then
			if isHuman == 1 then
				isHuman = 0
				player:AddMaxHearts (-6)
				player:AddSoulHearts (soulhearts)
				soulhearts = 0
			elseif isHuman == 0 then
				isHuman = 1
				soulhearts = player:GetSoulHearts()
				player:AddSoulHearts (-soulhearts)
				player:AddMaxHearts (6)
			end
		end
	end
end 


--Player init
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, funct.PostPlayerInit)
--Counter for soulhearts
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, funct.demonUpdate)
--Hud
mod:AddCallback(ModCallbacks.MC_POST_RENDER, funct.HeartHud)
--Transformation
mod:AddCallback(ModCallbacks.MC_POST_RENDER, funct.Transformation)