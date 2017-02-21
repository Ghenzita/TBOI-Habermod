local mod = RegisterMod("demon", 1)
local funct = {}

local char = Isaac.GetPlayerTypeByName("aamon")
local soulhearts;
local isHuman;
local redhp_human;
local max_hp;

function SaveState()
	local player = Isaac.GetPlayer (0)
	local SaveData = ""
	if soulhearts < 10 then
		SaveData = SaveData .. "0"
	end
	SaveData = SaveData .. soulhearts
	if redhp_human < 10 then
		SaveData = SaveData .. "0"
	end
	SaveData = SaveData .. redhp_human
	SaveData = SaveData .. isHuman
	SaveData = SaveData .. max_hp
	mod:SaveData(SaveData)
end
	
function funct:demonUpdate () 
	local player = Isaac.GetPlayer (0)
	local game = Game()
	
	if game:GetFrameCount() == 1 then
		soulhearts = 4
		redhp_human = 6
		max_hp = 6
		isHuman = 1
		mod:RemoveData()
	elseif player.FrameCount == 1 and mod:HasData() then
		local ModData = mod:LoadData()
		soulhearts = tonumber(ModData:sub(1,2))
		redhp_human = tonumber(ModData:sub(3,4))
		isHuman = tonumber(ModData:sub(5,5))
		max_hp = tonumber(ModData:sub(6,6))
	end
	
	
	if player:GetPlayerType() == char then
	
	--hps up when demon
		if isHuman == 0 and player:GetMaxHearts() > 1 then
			player:AddBlackHearts(player:GetMaxHearts())
			player:AddMaxHearts (-(player:GetMaxHearts()), false)
		end
		
	--counter for the soul hearts (also works for black hearts)
		if isHuman == 1 then
			sh_add = player:GetSoulHearts ()
			soulhearts = soulhearts + sh_add
			if sh_add > 0 then
				player:AddBlackHearts (-sh_add)		
				SaveState()				
			end
			--Max hp
			if player:GetMaxHearts() > 6 then
				player:AddSoulHearts(player:GetMaxHearts()-6)
				player:AddMaxHearts (-(player:GetMaxHearts() - 6), false)
			end
		end
		
		if isHuman == 0 then
			game:Darken(1, 2)
		end
	end
end

function funct:HeartHud () --ui for the heart
local player = Isaac.GetPlayer (0)
local game = Game()
if soulhearts == nil then soulhearts = 0 end

	if player:GetPlayerType() == char and isHuman == 1 then
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

function funct:Transformation()	--Transformation trigger
local player = Isaac.GetPlayer(0);
local game = Game()
local SFXManager = SFXManager()

	if player:GetPlayerType() == char then
		if Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0) then	--It is set to the control button so controller players can transform as well
			if isHuman == 1 then	--if human form
				redhp_human = player:GetHearts()	--store red hp
				isHuman = 0	--change it to demon form
				max_hp = player:GetMaxHearts()
				player:AddMaxHearts (-max_hp)	--delete red containers
				player:AddBlackHearts (soulhearts)	--add soulhearts
				soulhearts = 0	--set counter to 0
				for _, i in pairs(Isaac.GetRoomEntities()) do	--fear
					if i:IsVulnerableEnemy() then
						i:AddFear(EntityRef(player), 15)
					end
				end
				
				--transformation sound
				local sound_roll = math.random(4)
				if sound_roll == 1 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_0, 2.0, 0, false, 0.5)
				elseif sound_roll == 2 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_1, 2.0, 0, false, 0.5)
				elseif sound_roll == 3 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_2, 2.0, 0, false, 0.5)
				elseif sound_roll == 4 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_3, 2.0, 0, false, 0.5)
				end
				
				game:ShakeScreen (8)	
				SaveState()	--save data
				
			elseif isHuman == 0 then	--if demon form
				isHuman = 1	--change it to human form
				soulhearts = player:GetSoulHearts()	--store soulhearts
				player:AddBlackHearts (-soulhearts)	--delete soulhearts
				player:AddMaxHearts (max_hp)	--add red containers
				player:AddHearts (redhp_human)	--add red hp
				
				--transformation sound
				local sound_roll = math.random(4)
				if sound_roll == 1 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_0, 2.0, 0, false, 1.2)
				elseif sound_roll == 2 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_1, 2.0, 0, false, 1.2)
				elseif sound_roll == 3 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_2, 2.0, 0, false, 1.2)
				elseif sound_roll == 4 then
					SFXManager:Play(SoundEffect.SOUND_MONSTER_ROAR_3, 2.0, 0, false, 1.2)
				end
				
				game:ShakeScreen (8)	
				SaveState()	--save data
			end
		end
	end
end 



--Counter for soulhearts
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, funct.demonUpdate)
--Hud
mod:AddCallback(ModCallbacks.MC_POST_RENDER, funct.HeartHud)
--Transformation
mod:AddCallback(ModCallbacks.MC_POST_RENDER, funct.Transformation)