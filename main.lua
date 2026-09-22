ToyboxMod = RegisterMod("toyboxMod", 1) ---@type ModReference

ToyboxMod.GAME = Game()
ToyboxMod.SFX = SFXManager()

--[[] ]
local ogfunc = ToyboxMod.AddCallback
function ToyboxMod:AddCallback(callbackId, callbackFn, entityId)
    ogfunc(ToyboxMod, callbackId, function(...)
        callbackFn(args)
    end, entityId)
end
--]]

--! INCLUDE SHIT
-- "external" libraries
include("scripts_toybox.util.tearflagslib.main")

include("scripts_toybox.enums")

include("scripts_toybox.custom.data")
include("scripts_toybox.custom.bombflags")

--include("scripts_toybox.custom.tearvariants")
include("scripts_toybox.custom.throwables")


-- HELPER FUNCTIONS
include("scripts_toybox.helper")

-- CONFIG
include("scripts_toybox.config")

-- SAVEDATA
include("scripts_toybox.util.savedata.save_data")
-- CALLBACKS
include("scripts_toybox.util.callbacks.post_player_bomb_detonate")
include("scripts_toybox.util.callbacks.post_player_double_tap")
include("scripts_toybox.util.callbacks.post_player_attack")
include("scripts_toybox.util.callbacks.use_active_item")
include("scripts_toybox.util.callbacks.reset_ludovico_data")
include("scripts_toybox.util.callbacks.copy_scatter_bomb_data")
include("scripts_toybox.util.callbacks.post_fire_tear")
include("scripts_toybox.util.callbacks.post_fire_bomb")
include("scripts_toybox.util.callbacks.post_player_extra_dmg")
include("scripts_toybox.util.callbacks.post_fire_aquarius")
include("scripts_toybox.util.callbacks.post_fire_rocket")
include("scripts_toybox.util.callbacks.post_new_room")
include("scripts_toybox.util.callbacks.post_room_clear")
include("scripts_toybox.util.callbacks.post_custom_champion_death")
include("scripts_toybox.util.callbacks.post_poop_damage")
include("scripts_toybox.util.callbacks.poop_spawn_drop")
include("scripts_toybox.util.callbacks.post_grid_init")
include("scripts_toybox.util.callbacks.post_poop_init")
--include("scripts_toybox.util.callbacks.post_render_minimap_room")
--include("scripts_toybox.util.callbacks.post_minimap_room_render")
-- LIBRARIES
include("scripts_toybox.util.hud_helper")
include("scripts_toybox.util.custom_object_spawn")
include("scripts_toybox.util.custom_tearflags")
include("scripts_toybox.util.throwables")
include("scripts_toybox.util.statuseffects")
include("scripts_toybox.util.overlay_effects")
-- DATA ( entity / extra / persistent )
include("scripts_toybox.util.data")
-- ACHIEVEMENTS
include("scripts_toybox.util.achievements.core")
include("scripts_toybox.util.achievements.event_counters")
-- TRANSFORMATIONS
include("scripts_toybox.misc.transformations.core")
    include("scripts_toybox.misc.transformations.effects.fancy")
    include("scripts_toybox.misc.transformations.effects.hydra")
-- STATUS EFFECTS
include("scripts_toybox.misc.status_effects.earworm")
-- TEMPORARY ITEMS
include("scripts_toybox.misc.temporary_items")
-- PILL POOL LIBRARY
include("scripts_toybox.misc.pill_pool_library")
-- CUSTOM CHAMPIONS
include("scripts_toybox.misc.champions.champion_chances")
include("scripts_toybox.misc.champions.mod_champion_logic")
    include("scripts_toybox.misc.champions.champion_effects.bouncy")
    include("scripts_toybox.misc.champions.champion_effects.drowned")
    include("scripts_toybox.misc.champions.champion_effects.fear")
include("scripts_toybox.misc.champions.champions_in_greed")
-- CUSTOM TEARFLAGS
    include("scripts_toybox.misc.tearflags.plasma")
    include("scripts_toybox.misc.tearflags.langton")
    include("scripts_toybox.misc.tearflags.musical")
    include("scripts_toybox.misc.tearflags.bloody")
-- TINTED ROOMS
include("scripts_toybox.misc.tinted_rooms.enums")
include("scripts_toybox.misc.tinted_rooms.tinted_room_logic")
include("scripts_toybox.misc.tinted_rooms.minimap_logic")
include("scripts_toybox.misc.tinted_rooms.room_effects")

include("scripts_toybox.misc.custom_card_pool")
include("scripts_toybox.misc.golden_key_logic")
include("scripts_toybox.misc.golden_bomb_logic")

include("scripts_toybox.misc.trinket_crop_offset_render")
include("scripts_toybox.misc.trinket_weights")
include("scripts_toybox.misc.parasite_trinkets")

include("scripts_toybox.misc.trinket_pedestals")

include("scripts_toybox.misc.custom_room_icons")

include("scripts_toybox.misc.custom_special_rooms.logic")
include("scripts_toybox.misc.custom_special_rooms.graveyard_room")
include("scripts_toybox.misc.custom_special_rooms.temple_room")

-- ENEMIES
include("scripts_toybox.enemies.stumpy")
include("scripts_toybox.enemies.tonsil")
include("scripts_toybox.enemies.eye_spy")
include("scripts_toybox.enemies.king_host")
include("scripts_toybox.enemies.tar_baby")

-- BOSSES
--include("scripts_toybox.bosses.stageapi")

-- ENTITIES
include("scripts_toybox.misc.entities.meteor")
include("scripts_toybox.misc.entities.flame_breath_helper")
include("scripts_toybox.misc.entities.sleepy_troll_bomb")
include("scripts_toybox.misc.entities.blue_insect_upgrades")

-- GRIDS
include("scripts_toybox.misc.grids.copper_poop")
include("scripts_toybox.misc.grids.player_only_gate")
include("scripts_toybox.misc.grids.enemy_only_gate")
include("scripts_toybox.misc.grids.block_and_plate")
include("scripts_toybox.misc.grids.grave")
include("scripts_toybox.misc.grids.nuclear_poop")

-- MILCOM
include("scripts_toybox.players.milcom.a.milcom")
include("scripts_toybox.players.milcom.a.stats")
include("scripts_toybox.players.milcom.a.character_helpers")
include("scripts_toybox.players.milcom.a.hopping_logic")
include("scripts_toybox.players.milcom.a.ink_pickup")
include("scripts_toybox.players.milcom.a.pickup_logic")
include("scripts_toybox.players.milcom.a.ink_champion_drop")
include("scripts_toybox.players.milcom.a.hud_replacement")
-- T.MILCOM
--include("scripts_toybox.players.milcom.b.milcom")
--include("scripts_toybox.players.milcom.b.stats")
--include("scripts_toybox.players.milcom.b.closet_unlock")
include("scripts_toybox.players.milcom.b.menu")

-- ATLAS
include("scripts_toybox.players.atlas.a.atlas")
include("scripts_toybox.players.atlas.a.character_helpers")
include("scripts_toybox.players.atlas.a.achievements")
include("scripts_toybox.players.atlas.a.mantle_logic")
include("scripts_toybox.players.atlas.a.mantle_spawn_logic")
include("scripts_toybox.players.atlas.a.mantle_devildeal_logic")
include("scripts_toybox.players.atlas.a.mantle_healing_logic")
include("scripts_toybox.players.atlas.a.mantle_descriptions")
include("scripts_toybox.players.atlas.a.render_health")
include("scripts_toybox.players.atlas.a.chapi_cancel")
include("scripts_toybox.players.atlas.a.horn_costumes")
include("scripts_toybox.players.atlas.a.effect_reworks")
    -- MANTLES
    include("scripts_toybox.players.atlas.a.mantles.tar")
    include("scripts_toybox.players.atlas.a.mantles.rock")
    include("scripts_toybox.players.atlas.a.mantles.poop")
    include("scripts_toybox.players.atlas.a.mantles.bone")
    include("scripts_toybox.players.atlas.a.mantles.dark")
    include("scripts_toybox.players.atlas.a.mantles.holy")
    include("scripts_toybox.players.atlas.a.mantles.salt")
    include("scripts_toybox.players.atlas.a.mantles.glass")
    include("scripts_toybox.players.atlas.a.mantles.metal")
    include("scripts_toybox.players.atlas.a.mantles.gold")
-- T.ATLAS
--include("scripts_toybox.players.atlas.b.atlas")
--include("scripts_toybox.players.atlas.b.closet_unlock")

-- JONAS
include("scripts_toybox.players.jonas.a.jonas")
include("scripts_toybox.players.jonas.a.stats")
include("scripts_toybox.players.jonas.a.character_helpers")
include("scripts_toybox.players.jonas.a.pill_bonus_logic")
include("scripts_toybox.players.jonas.a.monster_pilldrop")
-- T.JONAS
--include("scripts_toybox.players.jonas.b.jonas")
--include("scripts_toybox.players.jonas.b.closet_unlock")

-- HOMUNCULUS
include("scripts_toybox.players.homunculus.a.main")
include("scripts_toybox.players.homunculus.a.hp_item")
include("scripts_toybox.players.homunculus.a.render_item")

-- BANDIT
--include("scripts_toybox.players.bandit.a.bandit")

-- NOWHERE
--include("scripts_toybox.players.nowhere.a.nowhere")

-- CHALLENGES
include("scripts_toybox.challenges.heart_to_heart")
include("scripts_toybox.challenges.reduce_reuse_recycle")

include("scripts_toybox.challenges.safari_zone")

-- ITEMS
--PASSIVES
    include("scripts_toybox.items.passives.coconut_oil")
    include("scripts_toybox.items.passives.goat_milk")
    include("scripts_toybox.items.passives.condensed_milk")
    include("scripts_toybox.items.passives.nose_candy")
    include("scripts_toybox.items.passives.lion_skull")
    include("scripts_toybox.items.passives.caramel_apple")
    include("scripts_toybox.items.passives.painkillers")
    include("scripts_toybox.items.passives.laser_brain")
    include("scripts_toybox.items.passives.fatal_signal")
    include("scripts_toybox.items.passives.pepper_x")
    include("scripts_toybox.items.passives.meteor_shower")
    include("scripts_toybox.items.passives.blessed_ring")
    include("scripts_toybox.items.passives.eyestrain")
    include("scripts_toybox.items.passives.4_4")
    include("scripts_toybox.items.passives.evil_rock")
    include("scripts_toybox.items.passives.onyx")
    include("scripts_toybox.items.passives.sigil_of_greed")
    include("scripts_toybox.items.passives.dads_prescription")
    include("scripts_toybox.items.passives.horse_tranquilizer")
    include("scripts_toybox.items.passives.silk_bag")
    include("scripts_toybox.items.passives.rock_candy")
    include("scripts_toybox.items.passives.missing_page_3")
    include("scripts_toybox.items.passives.glass_vessel")
    include("scripts_toybox.items.passives.bone_boy")
    include("scripts_toybox.items.passives.steel_soul")
    include("scripts_toybox.items.passives.bobs_heart")
    include("scripts_toybox.items.passives.clown_phd")
    include("scripts_toybox.items.passives.giant_capsule")
    include("scripts_toybox.items.passives.jonas_mask")
    include("scripts_toybox.items.passives.love_letter")
    include("scripts_toybox.items.passives.quake_bombs")
    include("scripts_toybox.items.passives.atheism")
    include("scripts_toybox.items.passives.mayonnaise")
    include("scripts_toybox.items.passives.awesome_fruit")
    include("scripts_toybox.items.passives.bloody_map")
    include("scripts_toybox.items.passives.saltpeter")
    include("scripts_toybox.items.passives.dr_bum")
    include("scripts_toybox.items.passives.plasma_globe")
    include("scripts_toybox.items.passives.blessed_bombs")
    include("scripts_toybox.items.passives.cursed_eulogy")
    include("scripts_toybox.items.passives.haemorrhage")
    include("scripts_toybox.items.passives.fish")
    include("scripts_toybox.items.passives.bobs_thesis") -- Also includes Placeholder
    include("scripts_toybox.items.passives.asteroid_belt")
    include("scripts_toybox.items.passives.barbed_wire")
    include("scripts_toybox.items.passives.coffee_cup")
    include("scripts_toybox.items.passives.conjunctivitis")
    include("scripts_toybox.items.passives.dads_slipper")
    include("scripts_toybox.items.passives.food_stamps")
    include("scripts_toybox.items.passives.golden_calf")
    include("scripts_toybox.items.passives.last_beer")
    include("scripts_toybox.items.passives.retrofall")
    include("scripts_toybox.items.passives.brunch")
    include("scripts_toybox.items.passives.toast")
    include("scripts_toybox.items.passives.lucky_pebbles")
    include("scripts_toybox.items.passives.finger_trap")
    include("scripts_toybox.items.passives.hemolymph")
    include("scripts_toybox.items.passives.solar_panel")
    include("scripts_toybox.items.passives.surprise_egg")
    include("scripts_toybox.items.passives.colossal_orb")
    include("scripts_toybox.items.passives.baby_shoes")
    include("scripts_toybox.items.passives.sack_of_chests")
    include("scripts_toybox.items.passives.effigy")
    include("scripts_toybox.items.passives.gambling_addiction")
    include("scripts_toybox.items.passives.pyramid_scheme")
    --include("scripts_toybox.items.passives.public_works")
    include("scripts_toybox.items.passives.good_juice")
    include("scripts_toybox.items.passives.butterfly_effect")
    include("scripts_toybox.items.passives.bloodflower")
    include("scripts_toybox.items.passives.red_clover")
    include("scripts_toybox.items.passives.black_soul")
    include("scripts_toybox.items.passives.good_job")
    include("scripts_toybox.items.passives.reading_glasses")
    include("scripts_toybox.items.passives.langston_loop")
    include("scripts_toybox.items.passives.curious_carrot")
    include("scripts_toybox.items.passives.odd_onion")
    include("scripts_toybox.items.passives.garlic")
    include("scripts_toybox.items.passives.loose_bowels")
    include("scripts_toybox.items.passives.tammys_tail")
    include("scripts_toybox.items.passives.malice")
    include("scripts_toybox.items.passives.paper_plate")
    include("scripts_toybox.items.passives.trendsetter")
    include("scripts_toybox.items.passives.dissociation")
    include("scripts_toybox.items.passives.angel_dust")
    include("scripts_toybox.items.passives.ember")
    include("scripts_toybox.items.passives.conglomerate")
    --include("scripts_toybox.items.passives.chest_alien")
    include("scripts_toybox.items.passives.bodybag")
    include("scripts_toybox.items.passives.aids")
    include("scripts_toybox.items.passives.hidden_blade")
    include("scripts_toybox.items.passives.crickets_tail")
    include("scripts_toybox.items.passives.mouthpiece")
    include("scripts_toybox.items.passives.vampire_teeth")
    include("scripts_toybox.items.passives.y2k")
    include("scripts_toybox.items.passives.minds_eye")
    include("scripts_toybox.items.passives.mindflayer_baby")
    include("scripts_toybox.items.passives.yes_baby")
    include("scripts_toybox.items.passives.psycho_baby")
    include("scripts_toybox.items.passives.gimp_baby")
    include("scripts_toybox.items.passives.chicchan_serpent")
    include("scripts_toybox.items.passives.oc_dog")
    include("scripts_toybox.items.passives.etznab_knife")
    include("scripts_toybox.items.passives.imix_crocodile")
    include("scripts_toybox.items.passives.cib_vulture")
    include("scripts_toybox.items.passives.men_eagle")
    include("scripts_toybox.items.passives.caban_earth")
    include("scripts_toybox.items.passives.lamat_rabbit")
    include("scripts_toybox.items.passives.mulac_water")
    include("scripts_toybox.items.passives.ik_wind")
    include("scripts_toybox.items.passives.eb_grass")
    include("scripts_toybox.items.passives.kan_lizard")
    include("scripts_toybox.items.passives.manik_deer")
    include("scripts_toybox.items.passives.ix_jaguar")
    include("scripts_toybox.items.passives.ahau_flower")
    include("scripts_toybox.items.passives.chuen_monkey")
    include("scripts_toybox.items.passives.akbal_house")
    include("scripts_toybox.items.passives.cimi_death")
    include("scripts_toybox.items.passives.ben_reed")
    include("scripts_toybox.items.passives.cauac_storm")
    include("scripts_toybox.items.passives.krokodil")
    include("scripts_toybox.items.passives.rhubarb")
    include("scripts_toybox.items.passives.unstable_dna")
    include("scripts_toybox.items.passives.anaphylaxis")
    include("scripts_toybox.items.passives.clone")
    include("scripts_toybox.items.passives.silver_pieces")
    include("scripts_toybox.items.passives.carrion")
    include("scripts_toybox.items.passives.fertilizer")
    include("scripts_toybox.items.passives.gunpowder")
    include("scripts_toybox.items.passives.mutagen")
    include("scripts_toybox.items.passives.leatherface")
    include("scripts_toybox.items.passives.frankencat")
    include("scripts_toybox.items.passives.nanomachines")
    include("scripts_toybox.items.passives.frankincense")
    include("scripts_toybox.items.passives.elephants_foot")
    include("scripts_toybox.items.passives.crazed_bobby")
    include("scripts_toybox.items.passives.greedy_pot")
    include("scripts_toybox.items.passives.brotherhood")

    include("scripts_toybox.items.passives.the_elder_scroll") -- just the shader fo now
--ACTIVES
    include("scripts_toybox.items.actives.pliers")
    include("scripts_toybox.items.actives.blood_ritual")
    include("scripts_toybox.items.actives.sunk_costs")
    include("scripts_toybox.items.actives.bronze_bull")
    include("scripts_toybox.items.actives.ascension")
    include("scripts_toybox.items.actives.gilded_apple")
    include("scripts_toybox.items.actives.drill")
    include("scripts_toybox.items.actives.d")
    include("scripts_toybox.items.actives.pez_dispenser")
    include("scripts_toybox.items.actives.alphabet_box")
    include("scripts_toybox.items.actives.hostile_takeover")
    include("scripts_toybox.items.actives.bloody_whistle")
    include("scripts_toybox.items.actives.art_of_war")
    include("scripts_toybox.items.actives.big_bang")
    include("scripts_toybox.items.actives.chocolate_bar")
    --include("scripts_toybox.items.actives.exoricsm_kit")
    include("scripts_toybox.items.actives.delivery_box")
    include("scripts_toybox.items.actives.moms_photobook")
    include("scripts_toybox.items.actives.pythagoras_cup")
    include("scripts_toybox.items.actives.big_red_button")
    include("scripts_toybox.items.actives.oil_painting")
    include("scripts_toybox.items.actives.white_daisy")
    include("scripts_toybox.items.actives.melted_candle")
    include("scripts_toybox.items.actives.coloring_book")
    --include("scripts_toybox.items.actives.enema")
    include("scripts_toybox.items.actives.puggys_claw")
    include("scripts_toybox.items.actives.blockchain")
    include("scripts_toybox.items.actives.snake_ring")
    include("scripts_toybox.items.actives.mp3_player")
    include("scripts_toybox.items.actives.reliquary")
    include("scripts_toybox.items.actives.dads_pipe")
    include("scripts_toybox.items.actives.not_a_pipe")
    include("scripts_toybox.items.actives.prospector_pick")
    include("scripts_toybox.items.actives.tammys_body")
    include("scripts_toybox.items.actives.wooden_arm")
    include("scripts_toybox.items.actives.lab_meat")
    include("scripts_toybox.items.actives.hand_pump")
    include("scripts_toybox.items.actives.twisted_heart")
    include("scripts_toybox.items.actives.instant_gratification")
    include("scripts_toybox.items.actives.breakthrough")
    include("scripts_toybox.items.actives.xenotransfusion")
    include("scripts_toybox.items.actives.blue_whale")
--TRINKETS
    include("scripts_toybox.items.trinkets.wonder_drug")
    include("scripts_toybox.items.trinkets.antibiotics")
    include("scripts_toybox.items.trinkets.amber_fossil")
    include("scripts_toybox.items.trinkets.big_blind")
    include("scripts_toybox.items.trinkets.jonas_lock")
    include("scripts_toybox.items.trinkets.big_boy_bathwater")
    include("scripts_toybox.items.trinkets.black_rune_shard")
    include("scripts_toybox.items.trinkets.suppository")
    include("scripts_toybox.items.trinkets.divided_justice")
    include("scripts_toybox.items.trinkets.killscreen")
    include("scripts_toybox.items.trinkets.mirror_shard")
    include("scripts_toybox.items.trinkets.lucky_tooth")
    include("scripts_toybox.items.trinkets.holy_lens")
    include("scripts_toybox.items.trinkets.dark_nebula")
    include("scripts_toybox.items.trinkets.makeup_kit")
    include("scripts_toybox.items.trinkets.yellow_belt")
    include("scripts_toybox.items.trinkets.zap_cap")
    include("scripts_toybox.items.trinkets.misprint")
    include("scripts_toybox.items.trinkets.cutout")
    include("scripts_toybox.items.trinkets.gasoline")
    include("scripts_toybox.items.trinkets.lootbox")
    include("scripts_toybox.items.trinkets.nightcap")
    include("scripts_toybox.items.trinkets.spiteful_penny")
    include("scripts_toybox.items.trinkets.library_card")
    include("scripts_toybox.items.trinkets.lifetime_supply")
    include("scripts_toybox.items.trinkets.rubbing_alcohol")
    include("scripts_toybox.items.trinkets.inside_joke")
    include("scripts_toybox.items.trinkets.citrusberry")
    include("scripts_toybox.items.trinkets.slingshot")
    include("scripts_toybox.items.trinkets.catnip")
    include("scripts_toybox.items.trinkets.trail_mix")
    include("scripts_toybox.items.trinkets.earworm")
    include("scripts_toybox.items.trinkets.7th_page")
    include("scripts_toybox.items.trinkets.power_word")
    include("scripts_toybox.items.trinkets.tungsten_key")
    include("scripts_toybox.items.trinkets.swallowed_d10")
    include("scripts_toybox.items.trinkets.monocle")
    include("scripts_toybox.items.trinkets.pink_donut")
    include("scripts_toybox.items.trinkets.infestation_3")
    include("scripts_toybox.items.trinkets.fake_beard")
    include("scripts_toybox.items.trinkets.sugar_cube")
    include("scripts_toybox.items.trinkets.interest")
    include("scripts_toybox.items.trinkets.nematode")
    include("scripts_toybox.items.trinkets.lil_grub")
    include("scripts_toybox.items.trinkets.candida")
    include("scripts_toybox.items.trinkets.dewormer")
    include("scripts_toybox.items.trinkets.ladybug")
    include("scripts_toybox.items.trinkets.demodex")
    include("scripts_toybox.items.trinkets.fat_leech")
    include("scripts_toybox.items.trinkets.flukie")
    include("scripts_toybox.items.trinkets.bug_spray")
    include("scripts_toybox.items.trinkets.hatchling")
--UNUSED
    --include("scripts_toybox.items.unused.btrain")
    --include("scripts_toybox.items.unused.laser_pointer")
    --include("scripts_toybox.items.unused.scattered_tome")
    --include("scripts_toybox.items.unused.toy_gun")
    --include("scripts_toybox.items.unused.foam_bullet")
    --include("scripts_toybox.items.unused.malicious_brain")
    --include("scripts_toybox.items.unused.limit_break")
    --include("scripts_toybox.items.unused.sine_worm")
--JOKE
    include("scripts_toybox.items.troll.golden_prayer_card")
    include("scripts_toybox.items.troll.golden_schoolbag")
    include("scripts_toybox.items.troll.uranium")
    include("scripts_toybox.items.troll.zero_gravity")
    include("scripts_toybox.items.troll.super_hamburger")
    include("scripts_toybox.items.troll.cursed_d6")
    include("scripts_toybox.items.troll.so_many_options")


--PICKUPS
--MISC
    include("scripts_toybox.pickups.pickups.smorgasbord")
    include("scripts_toybox.pickups.pickups.eternal_mound")
    include("scripts_toybox.pickups.pickups.lonely_key")
    
    include("scripts_toybox.pickups.pickups.random_pickup")
    include("scripts_toybox.pickups.pickups.br_card_spawner")
--CARDS
    include("scripts_toybox.pickups.cards.prismstone")
    include("scripts_toybox.pickups.cards.foil_card")
    include("scripts_toybox.pickups.cards.poison_rain")
    include("scripts_toybox.pickups.cards.alien_mind")
    include("scripts_toybox.pickups.cards.4_starred_ladybug")
    include("scripts_toybox.pickups.cards.green_apple")
    include("scripts_toybox.pickups.cards.the_wise_men")
    include("scripts_toybox.pickups.cards.the_crypt")
    include("scripts_toybox.pickups.cards.the_dragon")
    include("scripts_toybox.pickups.cards.duality")
    include("scripts_toybox.pickups.cards.the_gate")
    include("scripts_toybox.pickups.cards.apocalypse")
    include("scripts_toybox.pickups.cards.the_reaper")
    include("scripts_toybox.pickups.cards.the_baron")
    include("scripts_toybox.pickups.cards.the_angel")

    include("scripts_toybox.pickups.cards.the_trickster") -- done
    include("scripts_toybox.pickups.cards.memory")
    include("scripts_toybox.pickups.cards.the_caravan")
    include("scripts_toybox.pickups.cards.excalibur") -- done
    include("scripts_toybox.pickups.cards.fate") -- done
    include("scripts_toybox.pickups.cards.the_phantom")
    include("scripts_toybox.pickups.cards.mirage")
    include("scripts_toybox.pickups.cards.the_idol") -- done???

    include("scripts_toybox.pickups.cards.greyhound")
    
--OBJECTS
    include("scripts_toybox.pickups.objects.mantle_rock")
    include("scripts_toybox.pickups.objects.mantle_poop")
    include("scripts_toybox.pickups.objects.mantle_bone")
    include("scripts_toybox.pickups.objects.mantle_dark")
    include("scripts_toybox.pickups.objects.mantle_holy")
    include("scripts_toybox.pickups.objects.mantle_salt")
    include("scripts_toybox.pickups.objects.mantle_glass")
    include("scripts_toybox.pickups.objects.mantle_metal")
    include("scripts_toybox.pickups.objects.mantle_gold")
    --include("scripts_toybox.pickups.objects.laurel")
    --include("scripts_toybox.pickups.objects.yanny")
--PILLS
    include("scripts_toybox.pickups.pills.i_believe_i_can_fly")
    include("scripts_toybox.pickups.pills.dyslexia")
    include("scripts_toybox.pickups.pills.dementia")
    include("scripts_toybox.pickups.pills.parasite")
    include("scripts_toybox.pickups.pills.ossification")
    include("scripts_toybox.pickups.pills.your_soul_is_mine")
    include("scripts_toybox.pickups.pills.food_poisoning")
    --include("scripts_toybox.pickups.pills.bleeegh")
    include("scripts_toybox.pickups.pills.capsule")
    include("scripts_toybox.pickups.pills.heartburn")
    include("scripts_toybox.pickups.pills.coagulant")
    include("scripts_toybox.pickups.pills.fent")
    include("scripts_toybox.pickups.pills.arthritis")
    include("scripts_toybox.pickups.pills.muscle_atrophy")
    include("scripts_toybox.pickups.pills.vitamins")
    include("scripts_toybox.pickups.pills.damage_up")
    include("scripts_toybox.pickups.pills.damage_down")

--include("scripts_toybox.funny_shaders")

-- FORTNITE FUNNIES
--include("scripts_toybox.fortnite funnies.silly healthbar")
--include("scripts_toybox.fortnite funnies.silly hearts")
include("scripts_toybox.fortnite funnies.mattman chance")
include("scripts_toybox.fortnite funnies.gold mode")
include("scripts_toybox.fortnite funnies.retro mode")
--include("scripts_toybox.fortnite funnies.yes")
--include("scripts_toybox.fortnite funnies.black_souls")
--include("scripts_toybox.fortnite funnies.deja_vu")
--include("scripts_toybox.fortnite funnies.lupustro")
--include("scripts_toybox.fortnite funnies.stupid enemy title")
include("scripts_toybox.fortnite funnies.cool title screen")
include("scripts_toybox.fortnite funnies.slop-o-meter")
include("scripts_toybox.fortnite funnies.commands")
include("scripts_toybox.fortnite funnies.kanye")

--include("scripts_toybox.fortnite funnies.image.the_devil")
--include("scripts_toybox.fortnite funnies.image.photo")
--include("scripts_toybox.fortnite funnies.image.jumble")
--include("scripts_toybox.fortnite funnies.image.testing")
--include("scripts_toybox.fortnite funnies.image.shatter")

include("scripts_toybox.fortnite funnies.trinket_collection")
include("scripts_toybox.fortnite funnies.epic_collection")


-- EID
include("scripts_toybox.modcompat.eid.core")
-- MINIMAPI
include("scripts_toybox.modcompat.minimapi.core")
-- ACCURATE BLURBS
--include("scripts_toybox.modcompat.accurate blurbs.accurate_blurbs")
-- FIEND FOLIO FUZZY PICKLE
--include("scripts_toybox.modcompat.fuzzy pickle.main")

-- IMGUI
include("scripts_toybox.toybox_imgui")

include("scripts_toybox.fortnite funnies.mayan_translation")

--[[
local circule = 8
local heeelp = false
---@param pl EntityPlayer
local function getParams(_, pl)
    if(heeelp) then return end
    heeelp = true

    print("yo")
    local params = pl:GetMultiShotParams(WeaponType.WEAPON_TEARS)
    params:SetNumTears(params:GetNumTears()*circule)
    params:SetNumEyesActive(circule)
    params:SetMultiEyeAngle(1260/circule)

    heeelp = false
    return params
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_GET_MULTI_SHOT_PARAMS, getParams)
--]]

--[[

local rot = 90

local function getrotation(player)
    local headrot = player:GetHeadDirection()
    local rotation = ((headrot==Direction.LEFT or headrot==Direction.UP) and -1 or 1)*rot
    if(headrot==Direction.LEFT or headrot==Direction.RIGHT) then rotation = rotation*0.7 end

    return rotation
end

---@param pl EntityPlayer
local function postRenderHead(_, pl, renderpos)
    local rotation = getrotation(pl)
    pl:GetSprite().Rotation = rotation
    return renderpos+(Vector(0,-10)-Vector(0,-10):Rotated(rotation))
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, postRenderHead)

---@param pl EntityPlayer
local function prePlayerRender(_, pl, offset)
    local cLayers = pl:GetCostumeLayerMap()
    local cost = pl:GetCostumeSpriteDescs()

    pl:GetSprite().Rotation = 0

    --rot = math.sin(math.rad(pl.FrameCount)*18)*30

    local activeHeadCostumidx = {}
    for _, data in ipairs(cLayers) do
        if(not data.isBodyLayer and data.costumeIndex~=-1) then table.insert(activeHeadCostumidx, data.costumeIndex+1) end
    end

    local rotation = getrotation(pl)
    for _, idx in ipairs(activeHeadCostumidx) do
        local sp = cost[idx]:GetSprite()
        sp.Rotation = rotation
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, prePlayerRender)

--]]

--[[] ]
local bleh = ToyboxMod:generateRng()
local FRAMES_TO_SPIN = 150
local NUM_SHADOWS = 3
local DIST = 4
local zorking = false

---@param rock GridEntity
local function darkRedRegen(_, rock, off)
    if(zorking) then return end
    zorking = true

    local oldCol = rock:GetSprite().Color
    local col = Color(oldCol.R,oldCol.G,oldCol.B,oldCol.A,oldCol.RO,oldCol.GO,oldCol.BO)

    rock:GetSprite().Color = Color(col.R,col.G,col.B,col.A*0.4,col.RO,col.GO,col.BO)
    for i=0,NUM_SHADOWS-1 do
        local ang = ToyboxMod.GAME:GetFrameCount()/FRAMES_TO_SPIN*360+i/NUM_SHADOWS*360

        rock:Render(Vector.FromAngle(ang)*DIST)
    end
    rock:GetSprite().Color = col

    zorking = false
    --return false
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_RENDER, darkRedRegen)
--]]

--[[
■■■■■■■■■■■■■■■■■■■■■
■     ■       ■     ■
■■■■■ ■■■ ■■■■■ ■ ■■■
■   ■   ■ ■   ■ ■   ■
■ ■■■■■ ■ ■ ■ ■ ■■■ ■
■     ■ ■   ■   ■   ■
■ ■■■ ■ ■■■■■■■■■ ■■■
■   ■   ■       ■   ■
■■■ ■■■■■ ■■■■■ ■ ■ ■
■ ■ ■     ■   ■ ■ ■ ■
■ ■ ■ ■■■ ■ ■ ■ ■■■ ■
■   ■   ■ ■ ■ ■     ■
■ ■■■ ■■■ ■ ■ ■■■■■ ■
■ ■ ■ ■   ■ ■     ■ ■
■ ■ ■ ■ ■■■ ■■■ ■■■ ■
■ ■   ■   ■   ■   ■ ■
■ ■■■■■ ■ ■■■ ■■■ ■ ■
■     ■ ■ ■ ■   ■   ■
■■■■■ ■■■ ■ ■■■ ■■■■■
■         ■         ■
■■■■■■■■■■■■■■■■■■■■■
--]]

--[[

local PILLBONUS_FONT = Font()
PILLBONUS_FONT:Load("font/pftempestasevencondensed.fnt")

---@param slot EntitySlot
local function reSlotUpdate(_, slot, offset)
    ToyboxMod:setEntityData(slot, "MAX_TIMEOUT", math.max(ToyboxMod:getEntityData(slot, "MAX_TIMEOUT") or 0, slot:GetTimeout()))

    local tb = {}

    table.insert(tb, {NAME="STATE", VAL=slot:GetState()})
    table.insert(tb, {NAME="TIMEOUT", VAL=slot:GetTimeout()})
    table.insert(tb, {NAME="MAX TIMEOUT", VAL=(ToyboxMod:getEntityData(slot, "MAX_TIMEOUT") or 0)})
    table.insert(tb, {NAME="PRIZE TYPE", VAL=slot:GetPrizeType()})
    table.insert(tb, {NAME="DONATION VALUE", VAL=slot:GetDonationValue()})
    table.insert(tb, {NAME="ANIMATION", VAL=slot:GetSprite():GetAnimation()})
    table.insert(tb, {NAME="WILL EXPLODE?", VAL=false})

    ToyboxMod:setEntityData(slot, "SLOT_RENDERS", tb)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_SLOT_UPDATE, reSlotUpdate)

---@param slot EntitySlot
local function postSlotUpdate(_, slot, offset)
    local oldTb = ToyboxMod:getEntityData(slot, "SLOT_RENDERS")

    oldTb[1].VAL = tostring(oldTb[1].VAL).." / "..slot:GetState()
    oldTb[2].VAL = tostring(oldTb[2].VAL).." / "..slot:GetTimeout()
    oldTb[4].VAL = tostring(oldTb[4].VAL).." / "..slot:GetPrizeType()
    oldTb[5].VAL = tostring(oldTb[5].VAL).." / "..slot:GetDonationValue()
    oldTb[6].VAL = tostring(oldTb[6].VAL).." / "..slot:GetSprite():GetAnimation()
    oldTb[7].VAL = tostring(slot:GetDropRNG():RandomInt(50)==0)

    ToyboxMod:setEntityData(slot, "SLOT_RENDERS", oldTb)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, postSlotUpdate)

---@param slot EntitySlot
local function postSlotRender(_, slot, offset)

    local off = 7
    local pos = Isaac.WorldToRenderPosition(slot.Position)+offset+Vector(0,off)
    local renders = ToyboxMod:getEntityData(slot, "SLOT_RENDERS") or {}

    for _, renderData in ipairs(renders) do
        PILLBONUS_FONT:DrawStringScaled(renderData.NAME..": "..renderData.VAL, pos.X, pos.Y, 0.5,0.5, KColor(1,1,1,1))

        pos.Y = pos.Y+off
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_RENDER, postSlotRender)

function ToyboxMod:test()
    local slot = Isaac.FindByType(6)[1]
    if(not slot) then return end
    slot = slot:ToSlot()

    slot:SetState(2)
end

local shitFound = {
    NOTHING = 0,

    BOMB = 0,
    KEY = 0,
    HEART = 0,
    ONE_COIN = 0,
    TWO_COIN = 0,
    PILL = 0,
    FLY = 0,
    PRETTY_FLY = 0,
    DOLLAR = 0,

    EXPLOSION = 0,
}
local renderOrder = {
    "NOTHING",
    "BOMB" ,
    "KEY",
    "HEART",
    "ONE_COIN",
    "TWO_COIN",
    "PILL",
    "FLY",
    "PRETTY_FLY",
    "DOLLAR",
    "EXPLOSION",
}


function ToyboxMod:triggerSlot(prizetype)
    local slot = Isaac.Spawn(6,1,0,ToyboxMod.GAME:GetRoom():GetCenterPos(),Vector.Zero,nil):ToSlot()

    slot:SetState(2)
    slot:GetSprite():SetFrame("WiggleEnd", 6)

    slot:Update()
    slot:Update()
    slot:Update()

    local foundThings = {BOMB=0, KEY=0, HEART=0, PILL=0, COIN=0, FLY=0, PFLY=0, ITEM=0, BOOM=0, POOF=0}
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if(ent.FrameCount==0) then
            if(ent.Type==EntityType.ENTITY_FAMILIAR) then
                foundThings.PFLY = foundThings.PFLY+1
            elseif(ent.Type==EntityType.ENTITY_FLY) then
                foundThings.FLY = foundThings.FLY+1
            elseif(ent.Type==EntityType.ENTITY_PICKUP) then
                if(ent.Variant==PickupVariant.PICKUP_BOMB) then
                    foundThings.BOMB = foundThings.BOMB+1
                elseif(ent.Variant==PickupVariant.PICKUP_KEY) then
                    foundThings.KEY = foundThings.KEY+1
                elseif(ent.Variant==PickupVariant.PICKUP_HEART) then
                    foundThings.HEART = foundThings.HEART+1
                elseif(ent.Variant==PickupVariant.PICKUP_PILL) then
                    foundThings.PILL = foundThings.PILL+1
                elseif(ent.Variant==PickupVariant.PICKUP_COIN) then
                    foundThings.COIN = foundThings.COIN+1
                elseif(ent.Variant==PickupVariant.PICKUP_COLLECTIBLE) then
                    foundThings.ITEM = foundThings.ITEM+1
                end
            elseif(ent.Type==EntityType.ENTITY_BOMB) then
                foundThings.BOMB = foundThings.BOMB+1
            elseif(ent.Type==EntityType.ENTITY_EFFECT) then
                if(ent.Variant==1) then
                    foundThings.BOOM = foundThings.BOOM+1
                elseif(ent.Variant==15) then
                    foundThings.POOF = foundThings.POOF+1
                end
            end
            ent:Remove()
        end
    end

    if(foundThings.BOOM~=0 and foundThings.ITEM==0) then
        shitFound.EXPLOSION = shitFound.EXPLOSION+1
    elseif(foundThings.ITEM~=0 and foundThings.POOF~=0) then
        shitFound.DOLLAR = shitFound.DOLLAR+1
    else
        if(foundThings.BOMB~=0) then
            shitFound.BOMB = shitFound.BOMB+1
        elseif(foundThings.KEY~=0) then
            shitFound.KEY = shitFound.KEY+1
        elseif(foundThings.HEART~=0) then
            shitFound.HEART = shitFound.HEART+1
        elseif(foundThings.COIN~=0) then
            if(foundThings.COIN==1) then
                shitFound.ONE_COIN = shitFound.ONE_COIN+1
            elseif(foundThings.COIN==2) then
                shitFound.TWO_COIN = shitFound.TWO_COIN+1
            end
        elseif(foundThings.PILL~=0) then
            shitFound.PILL = shitFound.PILL+1
        elseif(foundThings.PFLY~=0) then
            shitFound.PRETTY_FLY = shitFound.PRETTY_FLY+1
        elseif(foundThings.FLY~=0) then
            shitFound.FLY = shitFound.FLY+1
        else
            shitFound.NOTHING = shitFound.NOTHING+1
        end
    end

    slot:Remove()
end

local function renderResults()
    if(Isaac.GetPlayer().FrameCount>30 and not ToyboxMod.GAME:IsPaused()) then
        ToyboxMod:triggerSlot()
    end

    local renderPos = Vector(130,40)

    local totalFound = 0
    for key, val in pairs(shitFound) do
        totalFound = totalFound+val
    end

    PILLBONUS_FONT:DrawStringScaled("TOTAL FOUND: "..tostring(totalFound), renderPos.X, renderPos.Y, 0.5, 0.5, KColor(1,1,1,1))

    for i, key in ipairs(renderOrder) do
        local curPos = renderPos+i*Vector(0,7)
        PILLBONUS_FONT:DrawStringScaled(tostring(key)..": "..tostring(shitFound[key]), curPos.X, curPos.Y, 0.5, 0.5, KColor(1,1,1,1))

        local perc = (shitFound[key]/totalFound)*100
        perc = math.floor(perc*100)/100

        PILLBONUS_FONT:DrawStringScaled(tostring(perc).."%", curPos.X+100, curPos.Y, 0.5, 0.5, KColor(1,1,1,1))
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, renderResults)

--]]

--[[
---@param pickup EntityPickup
local function postCollectableUpdate(_, pickup)
    if pickup.SubType ~= 0 then return end
    if pickup:GetData().AlreadyChecked then return end

    local nearby_pickup_num = 0
    for _, other in ipairs(Isaac.FindByType(5)) do
        if other.FrameCount==1 and other.Position:DistanceSquared(pickup.Position)<3*3 then
            nearby_pickup_num = nearby_pickup_num+1
        end
    end

    if(nearby_pickup_num>0) then
        for _, other in ipairs(Isaac.FindByType(5)) do
            if other.FrameCount==1 and other.Position:DistanceSquared(pickup.Position)<3*3 then
                other:Remove()
            end
        end
    end

    pickup:GetData().AlreadyChecked = true
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, postCollectableUpdate, PickupVariant.PICKUP_COLLECTIBLE)
--]]

--[[
local function postNewRoom()
    local room = ToyboxMod.GAME:GetRoom()
    --if(not room:IsFirstVisit()) then return end
    
    for _, slot in pairs(DoorSlot) do
        local door = room:GetDoor(slot)
        if(door) then
            local doorNormal = (door.Position-room:GetClampedPosition(door.Position, 0)):Normalized()

            local newIdx = room:GetGridIndex(door.Position+doorNormal:Rotated(90)*80)

            room:RemoveGridEntityImmediate(newIdx, 0, false)
            room:SpawnGridEntity(newIdx, door:GetSaveState())

            local newDoor = room:GetGridEntity(newIdx)
            if(newDoor and newDoor:ToDoor()) then
                newDoor = newDoor:ToDoor() ---@cast newDoor GridEntityDoor

                newDoor:Init(newDoor:GetSaveState().SpawnSeed)

                newDoor.CollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                newDoor.TargetRoomIndex = door.TargetRoomIndex
                newDoor.TargetRoomType = door.TargetRoomType

                newDoor:GetSaveState().VarData = slot+100

                newDoor:Update()

                print(newDoor:GetSaveState().VarData)
            end

            print(door.CollisionClass)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postNewRoom)

---@param door GridEntityDoor
local function postGridEntityDoorRender(_, door, offset)
    local slot = door:GetSaveState().VarData-100
    if(slot<0) then return end

    local ogDoor = ToyboxMod.GAME:GetRoom():GetDoor(slot)
    ogDoor:GetSprite():Render(Isaac.WorldToRenderPosition(door.Position))
    Isaac.RenderText("PENOR", Isaac.WorldToRenderPosition(door.Position).X, Isaac.WorldToRenderPosition(door.Position).Y,1,1,1,1)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, postGridEntityDoorRender)

---@param ent GridEntity?
local function collideithgrid(_, pl, idx, ent)
    if(ent and ent:ToWall()) then return true end

    if(not (ent and ent:ToDoor())) then return end
    local slot = ent:GetSaveState().VarData-100
    if(slot<0) then return end

    return true
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_GRID_COLLISION, collideithgrid)
--]]

--[[

ToyboxMod.DARK_UPGRADE = true
local hadDarkArts = false
local darkArtsMult = 10

---@param pl EntityPlayer
local function playerUpdate(_, pl)
    if(not ToyboxMod.DARK_UPGRADE) then return end

    local hasDarkArts = pl:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS)

    if(hasDarkArts and not hadDarkArts) then
        pl.SizeMulti = pl.SizeMulti*darkArtsMult
    elseif(hadDarkArts and not hasDarkArts) then
        pl.SizeMulti = pl.SizeMulti/darkArtsMult
    end


    hadDarkArts = hasDarkArts
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, playerUpdate)

local function postPlayerRender(_, pl)
    local c = Capsule(pl.Position, pl.SizeMulti, 0, pl.Size)
    local sh = DebugRenderer.Get(1000, true)
    sh:Capsule(c)
    sh:SetTimeout(1)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, postPlayerRender)

--]]

--[[
---@param ent GridEntity
local function kysbitch(_, ent, offset)
    local c = Capsule(ent.Position, Vector(1,1), 0, 11)
    local sh = DebugRenderer.Get(1005+ent:GetSaveState().SpawnSeed, true)
    sh:Capsule(c)
    sh:SetTimeout(1)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPIKES_RENDER, kysbitch)

function ToyboxMod:testSpikeFireHitboxes(spikeidx, fireidx)
    local room = ToyboxMod.GAME:GetRoom()

    for i=-1, 1 do
        for j=-1, 1 do
            if(not (i==j and i~=-1)) then
                room:SpawnGridEntity(room:GetGridIndex(room:GetGridPosition(spikeidx)+Vector(i,j)*40), GridEntityType.GRID_SPIKES)
            end
        end
    end

    for i=-1, 1 do
        for j=-1, 1 do
            if(not (i==j and i~=-1)) then
                Isaac.Spawn(33,0,0,room:GetGridPosition(fireidx)+Vector(i,j)*40,Vector.Zero,nil)
            end
        end
    end
end
--]]

--[[ -- i fucking hate modding this game
local timer = 0
local timeswitch = 15
local frame = 0

local hiddenWhenLocked = {
    [PlayerType.PLAYER_BLUEBABY] = 0,
    [PlayerType.PLAYER_THELOST] = 0,
    [PlayerType.PLAYER_THEFORGOTTEN] = 0,
    [PlayerType.PLAYER_KEEPER] = 0,
}

local function getid(pid)
    local milcomID = 0
    for i=0, pid do
        local pl = EntityConfig.GetPlayer(i)
        if(pl and not pl:IsTainted() and not pl:IsHidden()) then
            local ach = pl:GetAchievementID()
            if(not hiddenWhenLocked[i] or (hiddenWhenLocked[i] and ach>0 and Isaac.GetPersistentGameData():Unlocked(ach))) then
                milcomID = milcomID+1
            end
        end
    end
    return milcomID
end

local function prerendercustomcharactermenu(_)
    --print(CharacterMenu.GetCharacterPortraitSprite():GetAnimation())
    --print(CharacterMenu.GetSelectedCharacterID(), getid(ToyboxMod.PLAYER_MILCOM_A))
    if(CharacterMenu.GetSelectedCharacterID()==getid(ToyboxMod.PLAYER_MILCOM_A) and CharacterMenu.GetSelectedCharacterMenu()==1) then
        --print("hi")
        timer = timer+1
        if(timer>=timeswitch) then
            timer = 0
            frame = 1-frame
        end

        local pconf = EntityConfig.GetPlayer(ToyboxMod.PLAYER_MILCOM_B)
        local sp = pconf:GetModdedMenuPortraitSprite()
        sp.Scale = Vector(1,1)
        sp.Color = Color(1,1,1,1)

        sp:Play("Milcom", true)
        sp:SetFrame(frame*2+(CharacterMenu.GetIsCharacterUnlocked() and 0 or 1))

        local rpos = Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, Vector(0,0))+Vector(256,130)
        sp:Render(rpos)
    else
        timer = 0
        frame = 0
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, prerendercustomcharactermenu)
--]]

--[[] ]
function ToyboxMod:getRealFamiliar(t,v,s)
    local hash = (t<<16) | (v<<8) | s

    local rt = (hash>>16) & 255
    local rv = (hash>>8) & 255
    local rs = hash & 255

    local famName = nil
    for key, val in pairs(FamiliarVariant) do
        if(val==rv) then
            famName = key
            break
        end
    end

    print(tostring(t).."."..tostring(v).."."..tostring(s), "->", tostring(rt).."."..tostring(rv).."."..tostring(rs), famName)
end

function ToyboxMod:getBits(t,v,s)
    t = t<<16
    v = v<<8

    local st = ""
    local sv = ""
    local ss = ""
    for i=23,0,-1 do
        st = st..((t & (1<<i) == 0) and "0" or "1")
        sv = sv..((v & (1<<i) == 0) and "0" or "1")
        ss = ss..((s & (1<<i) == 0) and "0" or "1")

        if(i==16 or i==8) then
            st = st.." "
            sv = sv.." "
            ss = ss.." "
        end
    end

    print("T", st)
    print("V", sv)
    print("S", ss)
end
--]]

--[[] ]
local function dkjdjs(_, sss)
    local enum = nil
    for key, val in pairs(SoundEffect) do
        if(val==sss) then enum=key; break end
    end
    print(sss, enum)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SFX_PLAY, dkjdjs)
--]]

--[ [

--]]

--[[
---@param pl EntityPlayer
local function postRenderHead(_, pl, renderpos)
    local time = pl.FrameCount/30
    local stime = math.sin(math.rad(pl.FrameCount))
    --pl:GetSprite().Offset = Vector.Zero
    pl:GetSprite().Scale = Vector(1,1)
    return renderpos+Vector(3.5,1.5)+Vector.FromAngle(1.5*time*360)*3
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, postRenderHead)

---@param pl EntityPlayer
local function postRenderHead(_, pl, renderpos)
    local time = math.sin(math.rad(pl.FrameCount*18))
    --pl:GetSprite().Offset = Vector.Zero
    pl:GetSprite().Scale = Vector(1+(time-1)/2*0.15,1+(-time)*0.1)
    return renderpos
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_BODY, postRenderHead)

---@param pl EntityPlayer
local function prePlayerRender(_, pl, offset)
    local cLayers = pl:GetCostumeLayerMap()
    local cost = pl:GetCostumeSpriteDescs()

    pl:GetSprite().Rotation = 0
    pl:GetSprite().Offset = Vector.Zero
    pl:GetSprite().Scale = Vector(1,1)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, prePlayerRender)
--]]

--[[
local results = {}

function ToyboxMod:trySpawnCard()
    local card = Isaac.Spawn(5,300,0,Vector(200,200),Vector.Zero,nil):ToPickup()

    local id = card.SubType
    local conf = Isaac.GetItemConfig():GetCard(id)
    if(conf and conf.CardType) then
        results[conf.CardType] = (results[conf.CardType] or 0)+1
    end

    card:Remove()
end

function ToyboxMod:printResults()
    for i, val in pairs(results) do
        local finalkey = nil
        for key, id in pairs(ItemConfig) do
            if(string.find(key, "CARDTYPE_") and i==id) then
                finalkey = key
                break
            end
        end

        print(finalkey, ":", val)
    end
end
--]]
--[[
function ToyboxMod:printStatMults()
    local pl = Isaac.GetPlayer()

    local lowest = nil
    local lowestStat = 10000000
    local stats = {
        {"SPEED", (pl.MoveSpeed/1.)^1.793},
        {"FIRE RATE", ToyboxMod:toTps(pl.MaxFireDelay)/ToyboxMod:toTps(10.)},
        {"DAMAGE", pl.Damage/3.5},
        {"RANGE", pl.TearRange/(6.5*40)},
        --{"SHOT SPEED", pl.ShotSpeed/1.},
    }

    print("STAT MULTS:")
    for _, data in ipairs(stats) do
        if(data[2]<lowestStat) then
            lowest = data[1]
            lowestStat = data[2]
        end
        print("    ", data[1]..":", data[2])
    end
    print("LOWEST STAT MULT:", lowest, "|", lowestStat)
end

function ToyboxMod:givePrizes(speed)
    local pl = Isaac.GetPlayer()

    for _=1, 5 do
        pl:AddCollectible(CollectibleType.COLLECTIBLE_CONSOLATION_PRIZE)
    end

    pl.MoveSpeed = speed
    ToyboxMod:printStatMults()

    pl:AddCollectible(CollectibleType.COLLECTIBLE_CONSOLATION_PRIZE)
end


]]

--[[] ]
---@param sss EntityEffect
local function dkjdjs(_, sss)
    local enum = nil
    for key, val in pairs(EffectVariant) do
        if(val==sss.Variant) then enum=key; break end
    end
    print(sss.Variant, sss.SubType, sss.State, enum)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, dkjdjs)
--]]

--[[] ]
local forceNonCollectible = false

local function preGetCollectible()
    if(forceNonCollectible) then
        return 0
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, preGetCollectible)

---@param pickup EntityPickup
local function giveExtraOption(pickup)
    forceNonCollectible = true

    pickup:Morph(5,150,0,true,false,true)
end
--]]

--[[ PERHAPS for a future shop Options item (i loooove the idea of an item that cycles the whole shop between 2 stocks)


local cancelPickupInit = false

local function getRandomShopItemData()
    local roomDesc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    local prevIdx = roomDesc.ShopItemIdx

    roomDesc.ShopItemIdx = -1

    cancelPickupInit = true

    local pickup = Isaac.Spawn(5,150,0,Vector.Zero,Vector.Zero,nil):ToPickup()
    pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    cancelPickupInit = false

    roomDesc.ShopItemIdx = prevIdx

    local data = {
        pickup.Variant,
        pickup.SubType,
    }
    pickup:Remove()

    return data
end

---@param pickup EntityPickup
local function pickupInit(_, pickup)
    if(cancelPickupInit) then return end
    if(not pickup:IsShopItem()) then return end

    local data = ToyboxMod:getExtraDataTable()
    data.SHOP_ALT_STOCK = data.SHOP_ALT_STOCK or {}

    if(not data.SHOP_ALT_STOCK[tostring(pickup.ShopItemId)]) then
        local idData = getRandomShopItemData(pickup.InitSeed)
        data.SHOP_ALT_STOCK[tostring(pickup.ShopItemId)] = {
            Variant = idData[1],
            Subtype = idData[2],
        }
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, pickupInit)

---@param pickup EntityPickup
local function pickupUpdate(_, pickup)
    if(not pickup:IsShopItem()) then return end

    local data = ToyboxMod:getExtraDataTable()
    data.SHOP_ALT_STOCK = data.SHOP_ALT_STOCK or {}

    local idData = data.SHOP_ALT_STOCK[tostring(pickup.ShopItemId)]
    local cycleLen = 41
    if(ToyboxMod.GAME:GetRoom():GetFrameCount()%cycleLen==(cycleLen-1) and idData) then
        cancelPickupInit = true

        local oldData = {
            pickup.Variant,
            pickup.SubType
        }

        pickup:Morph(5,idData.Variant,idData.Subtype,true,true,true)

        data.SHOP_ALT_STOCK[tostring(pickup.ShopItemId)] = {
            Variant = oldData[1],
            Subtype = oldData[2],
        }

        cancelPickupInit = false
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, pickupUpdate)



local mango = false

---@param pickup EntityPickup
local function pickupInit(_, pickup)
    if(mango) then return end
    if(not pickup:IsShopItem()) then return end

    mango = true

    local roomDesc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    local prevIdx = roomDesc.ShopItemIdx

    roomDesc.ShopItemIdx = -1

    cancelPickupInit = true

    local newPickup = Isaac.Spawn(5,150,0,pickup.Position-Vector(0,40),Vector.Zero,nil):ToPickup()
    newPickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    newPickup.Price = 0
    newPickup.ShopItemId = 0
    newPickup:MakeShopItem(pickup.ShopItemId)

    cancelPickupInit = false

    roomDesc.ShopItemIdx = prevIdx

    mango = false
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, pickupInit)

]]