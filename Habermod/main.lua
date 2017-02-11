local mod = RegisterMod ("Habermod", 1)
local  funct = {}

TearFlags = {
	FLAG_NO_EFFECT = 0,
	FLAG_SPECTRAL = 1,
	FLAG_PIERCING = 1<<1,
	FLAG_HOMING = 1<<2,
	FLAG_SLOWING = 1<<3,
	FLAG_POISONING = 1<<4,
	FLAG_FREEZING = 1<<5,
	FLAG_COAL = 1<<6,
	FLAG_PARASITE = 1<<7,
	FLAG_MAGIC_MIRROR = 1<<8,
	FLAG_POLYPHEMUS = 1<<9,
	FLAG_WIGGLE_WORM = 1<<10,
	FLAG_UNK1 = 1<<11, --No noticeable effect
	FLAG_IPECAC = 1<<12,
	FLAG_CHARMING = 1<<13,
	FLAG_CONFUSING = 1<<14,
	FLAG_ENEMIES_DROP_HEARTS = 1<<15,
	FLAG_TINY_PLANET = 1<<16,
	FLAG_ANTI_GRAVITY = 1<<17,
	FLAG_CRICKETS_BODY = 1<<18,
	FLAG_RUBBER_CEMENT = 1<<19,
	FLAG_FEAR = 1<<20,
	FLAG_PROPTOSIS = 1<<21,
	FLAG_FIRE = 1<<22,
	FLAG_STRANGE_ATTRACTOR = 1<<23,
	FLAG_UNK2 = 1<<24, --Possible worm?
	FLAG_PULSE_WORM = 1<<25,
	FLAG_RING_WORM = 1<<26,
	FLAG_FLAT_WORM = 1<<27,
	FLAG_UNK3 = 1<<28, --Possible worm?
	FLAG_UNK4 = 1<<29, --Possible worm?
	FLAG_UNK5 = 1<<30, --Possible worm?
	FLAG_HOOK_WORM = 1<<31,
	FLAG_GODHEAD = 1<<32,
	FLAG_UNK6 = 1<<33, --No noticeable effect
	FLAG_UNK7 = 1<<34, --No noticeable effect
	FLAG_EXPLOSIVO = 1<<35,
	FLAG_CONTINUUM = 1<<36,
	FLAG_HOLY_LIGHT = 1<<37,
	FLAG_KEEPER_HEAD = 1<<38,
	FLAG_ENEMIES_DROP_BLACK_HEARTS = 1<<39,
	FLAG_ENEMIES_DROP_BLACK_HEARTS2 = 1<<40,
	FLAG_GODS_FLESH = 1<<41,
	FLAG_UNK8 = 1<<42, --No noticeable effect
	FLAG_TOXIC_LIQUID = 1<<43,
	FLAG_OUROBOROS_WORM = 1<<44,
	FLAG_GLAUCOMA = 1<<45,
	FLAG_BOOGERS = 1<<46,
	FLAG_PARASITOID = 1<<47,
	FLAG_UNK9 = 1<<48, --No noticeable effect
	FLAG_SPLIT = 1<<49,
	FLAG_DEADSHOT = 1<<50,
	FLAG_MIDAS = 1<<51,
	FLAG_EUTHANASIA = 1<<52,
	FLAG_JACOBS_LADDER = 1<<53,
	FLAG_LITTLE_HORN = 1<<54,
	FLAG_GHOST_PEPPER = 1<<55
}

-----------
--Cuakker--
-----------
local cuakker_item = Isaac.GetItemIdByName ("Cuakker")	
local customfamiliar =  Isaac.GetEntityTypeByName("testfamiliar")	
local player = Isaac.GetPlayer (0)	
local Dir = {
	[Direction.UP] = 270,
	[Direction.DOWN] = 90,
	[Direction.LEFT] = 180,
	[Direction.RIGHT] = 0,
}
local LASER_THIN_RED = 1

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

function funct:familiarUpdate (customfamiliar)	
	local player = Isaac.GetPlayer (0)					
	local tearshot = false								
	local firedir = player:GetFireDirection()			
	local headdir = player:GetHeadDirection ()			
	local sprite = customfamiliar:GetSprite ()			
	local playerfiredelay = player.MaxFireDelay	
	local game = Game()
	local room = game:GetRoom()
	local data = customfamiliar:GetData()
	if charge == nil then charge = 0 end
	if cooldown == nil then cooldown = 0 end
	local brimstonecharge = player.MaxFireDelay
	local brimstonecooldown = player.MaxFireDelay - 1
	
	
	hasKnife = player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)
	hasTechnology = player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY)	
	hasTechnology2 = player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2)
	hasTech5 = player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5)
	hasTechX = player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)
	hasBrimstone = player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
	has2020 = player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
	hasTripleShot = player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
	hasQuadShot = player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
	hasDrFetus = player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)
	hasMonstrosLung = player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
	
	
	customfamiliar:FollowParent() 
	
	
	if player:HasCollectible(cuakker_item) then
		if player.FrameCount % playerfiredelay == 0 then
			if hasKnife == false and hasTechnology == false and hasTech5 == false and hasTechX == false and hasBrimstone == false and has2020 == false and hasTripleShot == false and hasQuadShot == false and hasDrFetus == false and hasMonstrosLung == false then
				if tearshot == false then
					if firedir == 0 then
							player:FireTear (customfamiliar.Position, Vector (-10,0), true, false, true)  
							tearshot=false
					elseif firedir == 1 then
							player:FireTear (customfamiliar.Position, Vector (0,-10), true, false, true)  
							tearshot=false
					elseif firedir == 2 then
							player:FireTear (customfamiliar.Position, Vector (10,0), true, false, true)   
							tearshot=false
					elseif firedir == 3 then
							player:FireTear (customfamiliar.Position, Vector (0,10), true, false, true)   
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
		
		
		--Brimstone
		if hasBrimstone == true then		
			if firedir == Direction.NO_DIRECTION or cooldown > 0 then
				if charge == brimstonecharge then
					customfamiliar:SetColor(Color(1,1,1,1,0,0,0),0,0,false,false)
					local cooldown = brimstonecooldown
					local charge = 0
					
					local laser = EntityLaser.ShootAngle(LASER_THIN_RED, customfamiliar.Position, Dir[data.firedir], 13, Vector(0,0), customfamiliar)
					laser.TearFlags = player.TearFlags
					laser.CollisionDamage = player.Damage
					
					if firedir == 0 then
						sprite:Play("ShootRight", false)
					elseif firedir == 1 then
						sprite:Play("ShootUp", false)
					elseif firedir == 2 then
						sprite:Play("ShootLeft", false)
					elseif firedir == 3 then
						sprite:Play("ShootDown", false)
					end
				elseif cooldown == 0 then
				sprite:Play("FloatDown", false)
				end
				
				if cooldown > 0 then cooldown = cooldown - 1 end
			else
				if charge < brimstonecharge then
					charge = charge + 1
					if firedir == 0 then
						sprite:Play("ChargeRight", false)
					elseif firedir == 1 then
						sprite:Play("ChargeUp", false)
					elseif firedir == 2 then
						sprite:Play("ChargeLeft", false)
					elseif firedir == 3 then
						sprite:Play("ChargeDown", false)
					end
					
				else
					if firedir == 0 then
						sprite:SetFrame("ChargeRight", charge)
					elseif firedir == 1 then
						sprite:SetFrame("ChargeUp", charge)
					elseif firedir == 2 then
						sprite:SetFrame("ChargeLeft", charge)
					elseif firedir == 3 then
						sprite:SetFrame("ChargeDown", charge)
					end
					
					if customfamiliar.FrameCount % 4 == 0 then
						customfamiliar:SetColor(Color(1,0.6,0.6,1,20,0,0),0,0, false, false)
					elseif customfamiliar.FrameCount % 4 == 2 then
						customfamiliar:SetColor(Color(1,1,1,1,0,0,0),0,0,false,false)
					end
				end
				data.firedir = firedir
			end
		end
	end
	
	
	if sprite:IsFinished("ShootRight") or sprite:IsFinished("ShootUp") or sprite:IsFinished("ShootDown") or sprite:IsFinished("ShootLeft") then
		sprite:Play("FloatDown", false)
	end
	
	
	if firedir == 0 then
		sprite:Play("ShootRight", false)
	elseif firedir == 1 then
		sprite:Play("ShootUp", false)
	elseif firedir == 2 then
		sprite:Play("ShootLeft", false)
	elseif firedir == 3 then
		sprite:Play("ShootDown", false)
	end
	
	
	if room:GetFrameCount() == 1 then
		customfamiliar:Remove()
		RealignFamiliars()
	end
end


function funct:familiarsCache (player, cacheFlag)	
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		RealignFamiliars()
	end
end

mod:AddCallback (ModCallbacks.MC_USE_ITEM, funct.use_cuaker, cuakker_item) 
mod:AddCallback (ModCallbacks.MC_FAMILIAR_UPDATE, funct.familiarUpdate, 666) 
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
	
	if flag == nil then
		statshorn = 0
	end
	
	if player:HasCollectible(hornshead_item) then
		if flagDelay == nil then
			flagDelay = true
		end
		
		if flagDelay == true then
			flagDelay = false
			player.MaxFireDelay = player.MaxFireDelay + 20
		end
			
		for _, tear in pairs(Isaac.GetRoomEntities()) do
			if tear.Type == EntityType.ENTITY_TEAR and tear.Variant ~= HORNS_HEAD_VARIANT then
				tear:ToTear():ChangeVariant(HORNS_HEAD_VARIANT)
				tear:ToTear().FallingSpeed = 0
				tear:ToTear().FallingAcceleration = 0
				tear:ToTear().TearFlags = tear:ToTear().TearFlags | TearFlags.FLAG_SPECTRAL
				tear:ToTear().TearFlags = tear:ToTear().TearFlags | TearFlags.FLAG_PIERCING
				tear:ToTear().TearFlags = tear:ToTear().TearFlags | TearFlags.FLAG_STRANGE_ATTRACTOR
			end
			if tear.Type == EntityType.ENTITY_TEAR then
				tear:ToTear().FallingSpeed = 0
				tear:ToTear().FallingAcceleration = 0
			end
		end
	end
	

end


mod:AddCallback (ModCallbacks.MC_POST_UPDATE, funct.hornshead_passive)
function funct:onCacheHorn (player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED  then
		if player:HasCollectible(hornshead_item) then
			player.ShotSpeed = player.ShotSpeed / 2
		end
	end
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		flagDelay = true
	end
end

mod:AddCallback (ModCallbacks.MC_EVALUATE_CACHE, funct.onCacheHorn)





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


--stats update
function funct:onCache (player, cacheFlag)
	if player:HasCollectible (beastboost_item) and resetstats ~= 1 then
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + (0.05 * mscounter * (stagecounter - 0.1))*(1+multiplier/10)			
		end
	end

	if player:HasCollectible (beastboost_item) and resetstats ~= 1 then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + (0.2 * dmgcounter * stagecounter)*(1+multiplier/10)
		end
	end
	
	if player:HasCollectible (beastboost_item) and resetstats ~= 1 then
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + (0.1 * luckcounter * stagecounter)*(1+multiplier/10)
		end
	end
	
	if player:HasCollectible(hornshead_item) then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			--player.MaxFireDelay = player.MaxFireDelay + 20
			player.Damage = player.Damage + 7.5
		end
	end
end

mod:AddCallback (ModCallbacks.MC_EVALUATE_CACHE, funct.onCache)
