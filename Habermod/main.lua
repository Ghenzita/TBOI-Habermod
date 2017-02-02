local mod = RegisterMod ("Habermod", 1)
local  funct = {}

-----------
--Cuakker--
-----------
local cuakker_item = Isaac.GetItemIdByName ("Cuakker")	--conseguir ID del objeto mediante el nombre del objeto
local customfamiliar =  Isaac.GetEntityTypeByName("testfamiliar")	--conseguir entidad mediante el nombre del familiar
local player = Isaac.GetPlayer (0)	--player var

local function RealignFamiliars()
	local lastfam = nil
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if entity.Type == EntityType.ENTITY_FAMILIAR
		and entity.Child == nil then
			if lastfam == nil then
				lastfam = entity
			else
				if lastfam.FrameCount < entity.FrameCount then
					lastfam.Parent = entity
					entity.Child = lastfam
				else
					lastfam.Child = entity
					entity.Parent = lastfam
				end
			end
		end
	end
end

function funct:use_cuaker ()
	local player = Isaac.GetPlayer (0)
	if player:GetDamageCooldown() == 0 then
		player:TakeDamage( 1, DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, 666, 0, player.Position, Vector(0,0), player)
		RealignFamiliars()
	end
end

function funct:familiarUpdate (customfamiliar)	--función update del familiar
	local player = Isaac.GetPlayer (0)					--player var
	local tearshot = false								--Forma de desbuggearlo
	local firedir = player:GetFireDirection()			--Dirección del disparo de Isaac
	local headdir = player:GetHeadDirection ()			--Dirección de la cabeza de Isaac
	local sprite = customfamiliar:GetSprite ()			--Sprite del familiar
	local playerfiredelay = player.MaxFireDelay	--Cooldown del familiar
	local game = Game()
	local room = game:GetRoom()
	
	--sinergias
	hasKnife = player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)
	hasTechnology = player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY)	--hecha
	hasTechnology2 = player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2)
	hasTech5 = player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5)
	hasTechX = player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)
	hasBrimstone = player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
	has2020 = player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
	hasTripleShot = player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
	hasQuadShot = player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
	hasDrFetus = player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)
	hasMonstrosLung = player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
	
	
	customfamiliar:FollowParent() --seguir al parent, establecido en realignfamiliars
	
	--Disparar lágrimas
	if player:HasCollectible(cuakker_item) then
		if player.FrameCount % playerfiredelay == 0 then
			if hasKnife == false and hasTechnology == false and hasTech5 == false and hasTechX == false and hasBrimstone == false and has2020 == false and hasTripleShot == false and hasQuadShot == false and hasDrFetus == false and hasMonstrosLung == false then
				if tearshot == false then
					if firedir == 0 then
							player:FireTear (customfamiliar.Position, Vector (-10,0), true, false, true)  --Disparo a la derecha
							tearshot=false
					elseif firedir == 1 then
							player:FireTear (customfamiliar.Position, Vector (0,-10), true, false, true)  --Disparo arriba
							tearshot=false
					elseif firedir == 2 then
							player:FireTear (customfamiliar.Position, Vector (10,0), true, false, true)   --Disparo a la izquierda
							tearshot=false
					elseif firedir == 3 then
							player:FireTear (customfamiliar.Position, Vector (0,10), true, false, true)   --Disparo abajo
							tearshot=false
					end
				end
			end
			
			--Technology sinergy
			if hasTechnology == true then
				if firedir == 0 then
					player:FireTechLaser (customfamiliar.Position, LaserOffset.LASER_TECH1_OFFSET, Vector(-10,0), true, false)
					tearshot = false
				elseif firedir == 1 then
					player:FireTechLaser (customfamiliar.Position, LaserOffset.LASER_TECH1_OFFSET, Vector(0,-10), true, false)
					tearshot = false
				elseif firedir == 2 then
					player:FireTechLaser (customfamiliar.Position, LaserOffset.LASER_TECH1_OFFSET, Vector(10,0), true, false)
					tearshot = false
				elseif firedir == 3 then
					player:FireTechLaser (customfamiliar.Position, LaserOffset.LASER_TECH1_OFFSET, Vector(0,10), true, false)
					tearshot = false
				end
			end
			
			--DrFetus sinergy
			if hasDrFetus == true then
				if firedir == 0 then
					player:FireBomb (customfamiliar.Position, Vector(-10,0))
					tearshot = false
				elseif firedir == 1 then
					player:FireBomb (customfamiliar.Position, Vector(0,-10))
					tearshot = false
				elseif firedir == 2 then
					player:FireBomb (customfamiliar.Position, Vector(10,0))
					tearshot = false
				elseif firedir == 3 then
					player:FireBomb (customfamiliar.Position, Vector(0,10))
					tearshot = false
				end
			end
		end
	end
	
	--animación flotar cuando no dispara
	if sprite:IsFinished("ShootRight") or sprite:IsFinished("ShootUp") or sprite:IsFinished("ShootDown") or sprite:IsFinished("ShootLeft") then
		sprite:Play("FloatDown", false)
	end
	
	--animación disparo
	if firedir == 0 then
		sprite:Play("ShootRight", false)
	elseif firedir == 1 then
		sprite:Play("ShootUp", false)
	elseif firedir == 2 then
		sprite:Play("ShootLeft", false)
	elseif firedir == 3 then
		sprite:Play("ShootDown", false)
	end
	
	--eliminar familiar al entrar en una sala
	if room:GetFrameCount() == 1 then
		customfamiliar:Remove()
		RealignFamiliars()
	end
		
end

function funct:familiarsCache (player, cacheFlag)	--realinear familiares al coger un nuevo familiar
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		RealignFamiliars()
	end
end

mod:AddCallback (ModCallbacks.MC_USE_ITEM, funct.use_cuaker, cuakker_item) --Callback spawnear familiar activo
mod:AddCallback (ModCallbacks.MC_FAMILIAR_UPDATE, funct.familiarUpdate, 666) --Callback update del familiar
mod:AddCallback (ModCallbacks.MC_EVALUATE_CACHE, funct.familiarsCache)



---------------
--BEAST BOOST--
---------------
local beastboost_item = Isaac.GetItemIdByName ("Beast Boost")
local player = Isaac.GetPlayer (0)

--beast boost update
function beastboost_passive ()
local player = Isaac.GetPlayer (0)
local game = Game()
local room = game:GetRoom()
local level = game:GetLevel()

if game:GetFrameCount() == 1 then
	local CurStage = level:GetStage()
end

if CurStage ~= level:GetStage() and player:HasCollectible(beastboost_item) then
	mscounter = 0
	dmgcounter = 0
	luckcounter = 0
	player:AddCacheFlags (CacheFlag.CACHE_SPEED)
	player:AddCacheFlags (CacheFlag.CACHE_DAMAGE)
	player:AddCacheFlags (CacheFlag.CACHE_LUCK)
	player:EvaluateItems ()
    CurStage = level:GetStage()
	stagecounter = stagecounter + 0.2
end

	--Initialize stats counter var
	if mscounter == nil then
		mscounter = 0 
	end
	
	if dmgcounter == nil then
		dmgcounter = 0 
	end
	
	if luckcounter == nil then
		luckcounter = 0
	end
	
	if stagecounter == nil then
		stagecounter = 0.9
	end
	
	if multiplier == nil then
		multiplier = math.random()
	end
	
	--random stats generator
	if player:HasCollectible(beastboost_item) then
		if room:GetFrameCount() == 1 and room:IsFirstVisit() and room:GetAliveEnemiesCount() ~= 0 then
			local roll = math.random(3)
			multiplier = math.random()
			if roll == 1 then
				player:AddCacheFlags  (CacheFlag.CACHE_SPEED)
				mscounter = mscounter + 1
				player:EvaluateItems ()
			elseif roll == 2 then
				player:AddCacheFlags (CacheFlag.CACHE_DAMAGE)
				dmgcounter = dmgcounter + 1
				player:EvaluateItems ()
			elseif roll == 3 then
				player:AddCacheFlags (CacheFlag.CACHE_LUCK)
				luckcounter = luckcounter + 1
				player:EvaluateItems ()
			end
		end
	end
	
	
end

mod:AddCallback (ModCallbacks.MC_POST_UPDATE, beastboost_passive) 

--stats update
function funct:onCache (player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_SPEED then
		if player:HasCollectible (beastboost_item) and resetstats ~= 1 then
			player.MoveSpeed = player.MoveSpeed + (0.05 * mscounter * (stagecounter - 0.1))*(1+multiplier/10)			
		end
	end
	
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible (beastboost_item) and resetstats ~= 1 then
			player.Damage = player.Damage + (0.2 * dmgcounter * stagecounter)*(1+multiplier/10)		
		end
	end
	
	if cacheFlag == CacheFlag.CACHE_LUCK then
		if player:HasCollectible (beastboost_item) and resetstats ~= 1 then
			player.Luck = player.Luck + (0.1 * luckcounter * stagecounter)*(1+multiplier/10)
		end
	end
end

mod:AddCallback (ModCallbacks.MC_EVALUATE_CACHE, funct.onCache)


----------------------
--LITTLE HORN'S HEAD--
----------------------
local hornshead_item = Isaac.GetItemIdByName ("Little Horn's Head")
local HORNS_HEAD_VARIANT = Isaac.GetEntityVariantByName ("hornsheadhole")

function funct:hornshead_passive ()
	local player = Isaac.GetPlayer (0)
	local playerfiredelay = player.MaxFireDelay
	local tearshot = false
	local firedir = player:GetFireDirection()
	local game = Game()
	local room = game:GetRoom()
	local entityhorn = Isaac.GetEntityTypeByName ("hornsheadhole")
	
	if player:HasCollectible(hornshead_item) then
	player.FireDelay = player.MaxFireDelay
		if player.FrameCount % 40 == 0 then
			if tearshot == false then
				if firedir == 0 then
					Isaac.Spawn (EntityType.ENTITY_EFFECT, HORNS_HEAD_VARIANT, 0, player.Position, Vector (-10,0), player)
					tearshot=false
				elseif firedir == 1 then
					Isaac.Spawn (EntityType.ENTITY_EFFECT, HORNS_HEAD_VARIANT, 0, player.Position, Vector (0,-10), player)
					tearshot=false
				elseif firedir == 2 then
					Isaac.Spawn (EntityType.ENTITY_EFFECT, HORNS_HEAD_VARIANT, 0, player.Position, Vector (10,0), player)
					tearshot=false
				elseif firedir == 3 then
					Isaac.Spawn (EntityType.ENTITY_EFFECT, HORNS_HEAD_VARIANT, 0, player.Position, Vector (0,10), player)
					tearshot=false
				end
			end
		end
	end
	
	
end

mod:AddCallback (ModCallbacks.MC_POST_UPDATE, funct.hornshead_passive)
--Pedestals
function funct:SpawnItems ()
local game = Game()
	if game:GetFrameCount() == 1 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, beastboost_item, Vector(320,300), Vector(0,0), nil)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, hornshead_item, Vector(390,300), Vector(0,0), nil)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, cuakker_item, Vector(250,300), Vector(0,0), nil)
	end
end

mod:AddCallback (ModCallbacks.MC_POST_UPDATE, funct.SpawnItems)
