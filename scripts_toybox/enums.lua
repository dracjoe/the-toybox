
local sfx = SFXManager()

ToyboxMod.DATA_LOADED = false

--#region PLAYER TYPE

ToyboxMod.PLAYER_MILCOM_A = Isaac.GetPlayerTypeByName("Milcom", false)
ToyboxMod.PLAYER_ATLAS_A = Isaac.GetPlayerTypeByName("Atlas", false)
ToyboxMod.PLAYER_ATLAS_A_TAR = Isaac.GetPlayerTypeByName("The Tar", false)
ToyboxMod.PLAYER_JONAS_A = Isaac.GetPlayerTypeByName("Jonas", false)
ToyboxMod.PLAYER_MILCOM_B = Isaac.GetPlayerTypeByName("Milcom", true)
ToyboxMod.PLAYER_ATLAS_B = Isaac.GetPlayerTypeByName("Atlas", true)
ToyboxMod.PLAYER_JONAS_B = Isaac.GetPlayerTypeByName("Jonas", true)

ToyboxMod.PLAYER_HOMUNCULUS_A = Isaac.GetPlayerTypeByName("Homunculus", false)
ToyboxMod.PLAYER_HOMUNCULUS_B = Isaac.GetPlayerTypeByName("Homunculus", true)

ToyboxMod.PLAYER_NOWHERE_A = Isaac.GetPlayerTypeByName("Nowhere", false)
--#endregion
--#region ACHIEVEMENT

--- ACHIEVEMENTS - Players
ToyboxMod.ACHIEVEMENT_HOMUNCULUS = Isaac.GetAchievementIdByName("Homunculus")
ToyboxMod.ACHIEVEMENT_MILCOM_B = Isaac.GetAchievementIdByName("The Drawn (Tainted Milcom)")
ToyboxMod.ACHIEVEMENT_ATLAS_B = Isaac.GetAchievementIdByName("The Fractured (Tainted Atlas)")
ToyboxMod.ACHIEVEMENT_JONAS_B = Isaac.GetAchievementIdByName("The Demented (Tainted Jonas)")
ToyboxMod.ACHIEVEMENT_HOMUNCULUS_B = Isaac.GetAchievementIdByName("The Flayed (Tainted Homunculus)")
--- ACHIEVEMENTS - Challenges
ToyboxMod.ACHIEVEMENT_SCIENTOLOGY = Isaac.GetAchievementIdByName("Scientology Challenge")
ToyboxMod.ACHIEVEMENT_HEART_TO_HEART = Isaac.GetAchievementIdByName("Heart to Heart Challenge")
ToyboxMod.ACHIEVEMENT_REDUCE_REUSE_RECYCLE = Isaac.GetAchievementIdByName("Reduce Reuse Recycle Challenge")
--- ACHIEVEMENTS - Misc.
ToyboxMod.ACHIEVEMENT_WONDER_DRUG = Isaac.GetAchievementIdByName("Wonder Drug")
ToyboxMod.ACHIEVEMENT_HORSE_TRANQUILIZER = Isaac.GetAchievementIdByName("Horse Tranquilizer")
ToyboxMod.ACHIEVEMENT_GASOLINE = Isaac.GetAchievementIdByName("Gasoline")
ToyboxMod.ACHIEVEMENT_INSIDE_JOKE = Isaac.GetAchievementIdByName("Inside Joke")
ToyboxMod.ACHIEVEMENT_VAMPIRE_TEETH = Isaac.GetAchievementIdByName("Vampire Teeth")
ToyboxMod.ACHIEVEMENT_FERTILIZER = Isaac.GetAchievementIdByName("Fertilizer")
--- ACHIEVEMENTS - Atlas
ToyboxMod.ACHIEVEMENT_PRISMSTONE = Isaac.GetAchievementIdByName("Prismstone")
ToyboxMod.ACHIEVEMENT_GLASS_VESSEL = Isaac.GetAchievementIdByName("Glass Vessel")
ToyboxMod.ACHIEVEMENT_STEEL_SOUL = Isaac.GetAchievementIdByName("Steel Soul")
ToyboxMod.ACHIEVEMENT_HOSTILE_TAKEOVER = Isaac.GetAchievementIdByName("Hostile Takeover")
ToyboxMod.ACHIEVEMENT_ROCK_CANDY = Isaac.GetAchievementIdByName("Rock Candy")
ToyboxMod.ACHIEVEMENT_MISSING_PAGE_3 = Isaac.GetAchievementIdByName("Missing Page 3")
ToyboxMod.ACHIEVEMENT_GILDED_APPLE = Isaac.GetAchievementIdByName("Gilded Apple")
ToyboxMod.ACHIEVEMENT_SALTPETER = Isaac.GetAchievementIdByName("Saltpeter")
ToyboxMod.ACHIEVEMENT_AMBER_FOSSIL = Isaac.GetAchievementIdByName("Amber Fossil")
ToyboxMod.ACHIEVEMENT_BONE_BOY = Isaac.GetAchievementIdByName("Bone Boy!")
ToyboxMod.ACHIEVEMENT_ASCENSION = Isaac.GetAchievementIdByName("Ascension")
--ToyboxMod.ACHIEVEMENT_MANTLES = Isaac.GetAchievementIdByName("Mantles")
ToyboxMod.ACHIEVEMENT_CONGLOMERATE = Isaac.GetAchievementIdByName("Conglomerate")
ToyboxMod.ACHIEVEMENT_MIRACLE_MANTLE = Isaac.GetAchievementIdByName("Miracle Mantle")
--- ACHIEVEMENTS - Jonas
ToyboxMod.ACHIEVEMENT_GIANT_CAPSULE = Isaac.GetAchievementIdByName("Giant Capsule")
ToyboxMod.ACHIEVEMENT_FOOD_STAMPS = Isaac.GetAchievementIdByName("Food Stamps")
ToyboxMod.ACHIEVEMENT_DADS_PRESCRIPTION = Isaac.GetAchievementIdByName("Dad's Prescription")
ToyboxMod.ACHIEVEMENT_CANDY_DISPENSER = Isaac.GetAchievementIdByName("Candy Dispenser")
ToyboxMod.ACHIEVEMENT_DR_BUM = Isaac.GetAchievementIdByName("Dr. Bum")
ToyboxMod.ACHIEVEMENT_JONAS_MASK = Isaac.GetAchievementIdByName("Jonas' Mask")
ToyboxMod.ACHIEVEMENT_ANTIBIOTICS = Isaac.GetAchievementIdByName("Antibiotics")
ToyboxMod.ACHIEVEMENT_FOIL_CARD = Isaac.GetAchievementIdByName("Foil Card")
ToyboxMod.ACHIEVEMENT_CLOWN_PHD = Isaac.GetAchievementIdByName("Clown PHD")
ToyboxMod.ACHIEVEMENT_JONAS_LOCK = Isaac.GetAchievementIdByName("Jonas' Lock")
--ToyboxMod.ACHIEVEMENT_PILLS = Isaac.GetAchievementIdByName("Pill Diversity!")
ToyboxMod.ACHIEVEMENT_DADS_PIPE = Isaac.GetAchievementIdByName("Dad's Pipe")
ToyboxMod.ACHIEVEMENT_DRILL = Isaac.GetAchievementIdByName("Drill")
--- ACHIEVEMENTS - Milcom
ToyboxMod.ACHIEVEMENT_DELIVERY_BOX = Isaac.GetAchievementIdByName("Delivery Box")
ToyboxMod.ACHIEVEMENT_OIL_PAINTING = Isaac.GetAchievementIdByName("Oil Painting")
ToyboxMod.ACHIEVEMENT_DIVIDED_JUSTICE = Isaac.GetAchievementIdByName("Divided Justice")
ToyboxMod.ACHIEVEMENT_PAPER_PLATE = Isaac.GetAchievementIdByName("Paper Plate")
ToyboxMod.ACHIEVEMENT_MISPRINT = Isaac.GetAchievementIdByName("Misprint")
ToyboxMod.ACHIEVEMENT_ATHEISM = Isaac.GetAchievementIdByName("Atheism")
ToyboxMod.ACHIEVEMENT_GOLDEN_CALF = Isaac.GetAchievementIdByName("Golden Calf")
ToyboxMod.ACHIEVEMENT_GREEN_APPLE = Isaac.GetAchievementIdByName("Green Apple")
ToyboxMod.ACHIEVEMENT_EFFIGY = Isaac.GetAchievementIdByName("Effigy")
ToyboxMod.ACHIEVEMENT_CUTOUT = Isaac.GetAchievementIdByName("Cutout")
ToyboxMod.ACHIEVEMENT_MALICE = Isaac.GetAchievementIdByName("Malice")
--ToyboxMod.ACHIEVEMENT_CHAMPIONS = Isaac.GetAchievementIdByName("More Champions!")
ToyboxMod.ACHIEVEMENT_COLORING_BOOK = Isaac.GetAchievementIdByName("Coloring Book")
--- ACHIEVEMENTS - Homunculus
ToyboxMod.ACHIEVEMENT_UNSTABLE_DNA = Isaac.GetAchievementIdByName("Unstable DNA")
ToyboxMod.ACHIEVEMENT_LAB_MEAT = Isaac.GetAchievementIdByName("Lab Meat")
ToyboxMod.ACHIEVEMENT_INFESTATION_3 = Isaac.GetAchievementIdByName("Infestation 3")
ToyboxMod.ACHIEVEMENT_TWISTED_HEART = Isaac.GetAchievementIdByName("Twisted Heart")
ToyboxMod.ACHIEVEMENT_ELEPHANTS_FOOT = Isaac.GetAchievementIdByName("Elephant's Foot")
ToyboxMod.ACHIEVEMENT_KROKODIL = Isaac.GetAchievementIdByName("Krokodil")
ToyboxMod.ACHIEVEMENT_MUTAGEN = Isaac.GetAchievementIdByName("Mutagen")
ToyboxMod.ACHIEVEMENT_FRANKENCAT = Isaac.GetAchievementIdByName("Frankencat")
ToyboxMod.ACHIEVEMENT_XENOTRANSFUSION = Isaac.GetAchievementIdByName("Xenotransfusion")
ToyboxMod.ACHIEVEMENT_CLONE = Isaac.GetAchievementIdByName("Clone")
ToyboxMod.ACHIEVEMENT_GREYHOUND = Isaac.GetAchievementIdByName("Greyhound")
ToyboxMod.ACHIEVEMENT_SPITEFUL_PENNY = Isaac.GetAchievementIdByName("Spiteful Penny")
--#endregion
--#region CHALLENGE

ToyboxMod.CHALLENGE_SCIENTOLOGY = Isaac.GetChallengeIdByName("I - Scientology")
ToyboxMod.CHALLENGE_HEART_TO_HEART = Isaac.GetChallengeIdByName("II - Heart to Heart")
ToyboxMod.CHALLENGE_REDUCE_REUSE_RECYCLE = Isaac.GetChallengeIdByName("III - Reduce Reuse Recycle")
--#endregion
--#region ITEMPOOL

ToyboxMod.POOL_GRAVEYARD = Isaac.GetPoolIdByName("toybox-graveyard")
ToyboxMod.POOL_TEMPLE = Isaac.GetPoolIdByName("toybox-temple")
--#endregion
--#region COLLECTIBLE

ToyboxMod.COLLECTIBLE_COCONUT_OIL = Isaac.GetItemIdByName("Coconut Oil")
ToyboxMod.COLLECTIBLE_CONDENSED_MILK = Isaac.GetItemIdByName("Condensed Milk")
ToyboxMod.COLLECTIBLE_EYESTRAIN = Isaac.GetItemIdByName("Eyestrain")
ToyboxMod.COLLECTIBLE_SNOWCONE = Isaac.GetItemIdByName("Snowcone")
ToyboxMod.COLLECTIBLE_EVIL_ROCK = Isaac.GetItemIdByName("Evil Rock")
ToyboxMod.COLLECTIBLE_GOAT_MILK = Isaac.GetItemIdByName("Goat Milk")
ToyboxMod.COLLECTIBLE_LOOSE_BOWELS = Isaac.GetItemIdByName("Loose Bowels")
ToyboxMod.COLLECTIBLE_PLIERS = Isaac.GetItemIdByName("Pliers")
ToyboxMod.COLLECTIBLE_NOSE_CANDY = Isaac.GetItemIdByName("Nose Candy")
ToyboxMod.COLLECTIBLE_LION_SKULL = Isaac.GetItemIdByName("Lion Skull")
ToyboxMod.COLLECTIBLE_DADS_SLIPPER = Isaac.GetItemIdByName("Dad's Slipper")
ToyboxMod.COLLECTIBLE_GOOD_JOB = Isaac.GetItemIdByName("Good Job")
ToyboxMod.COLLECTIBLE_ODD_ONION = Isaac.GetItemIdByName("Odd Onion")
ToyboxMod.COLLECTIBLE_CARAMEL_APPLE = Isaac.GetItemIdByName("Caramel Apple")
ToyboxMod.COLLECTIBLE_BLOOD_RITUAL = Isaac.GetItemIdByName("Blood Ritual")
ToyboxMod.COLLECTIBLE_TECH_IX = Isaac.GetItemIdByName("Laser Brain")
ToyboxMod.COLLECTIBLE_PAINKILLERS = Isaac.GetItemIdByName("Painkillers")
ToyboxMod.COLLECTIBLE_SILK_BAG = Isaac.GetItemIdByName("Silk Bag")
ToyboxMod.COLLECTIBLE_BRAINFREEZE = Isaac.GetItemIdByName("Brainfreeze")
ToyboxMod.COLLECTIBLE_FATAL_SIGNAL = Isaac.GetItemIdByName("Fatal Signal")
ToyboxMod.COLLECTIBLE_METEOR_SHOWER = Isaac.GetItemIdByName("Meteor Shower")
ToyboxMod.COLLECTIBLE_BLESSED_RING = Isaac.GetItemIdByName("Blessed Ring")
ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED = Isaac.GetItemIdByName("Sigil of Greed")
ToyboxMod.COLLECTIBLE_PEPPER_X = Isaac.GetItemIdByName("Pepper X")
ToyboxMod.COLLECTIBLE_SUNK_COSTS = Isaac.GetItemIdByName("Sunk Costs")
ToyboxMod.COLLECTIBLE_GILDED_APPLE = Isaac.GetItemIdByName("Gilded Apple")
ToyboxMod.COLLECTIBLE_ONYX = Isaac.GetItemIdByName("Onyx")
ToyboxMod.COLLECTIBLE_DADS_PRESCRIPTION = Isaac.GetItemIdByName("Dad's Prescription")
ToyboxMod.COLLECTIBLE_HORSE_TRANQUILIZER = Isaac.GetItemIdByName("Horse Tranquilizer")
ToyboxMod.COLLECTIBLE_BOBS_HEART = Isaac.GetItemIdByName("Bob's Heart")
ToyboxMod.COLLECTIBLE_GLASS_VESSEL = Isaac.GetItemIdByName("Glass Vessel")
ToyboxMod.COLLECTIBLE_BONE_BOY = Isaac.GetItemIdByName("Bone Boy")
ToyboxMod.COLLECTIBLE_HOSTILE_TAKEOVER = Isaac.GetItemIdByName("Hostile Takeover")
ToyboxMod.COLLECTIBLE_STEEL_SOUL = Isaac.GetItemIdByName("Steel Soul")
ToyboxMod.COLLECTIBLE_ROCK_CANDY = Isaac.GetItemIdByName("Rock Candy")
ToyboxMod.COLLECTIBLE_GIANT_CAPSULE = Isaac.GetItemIdByName("Giant Capsule")
ToyboxMod.COLLECTIBLE_PEZ_DISPENSER = Isaac.GetItemIdByName("Candy Dispenser")
ToyboxMod.COLLECTIBLE_MISSING_PAGE_3 = Isaac.GetItemIdByName("Missing Page 3")
ToyboxMod.COLLECTIBLE_ASCENSION = Isaac.GetItemIdByName("Ascension")
ToyboxMod.COLLECTIBLE_4_4 = Isaac.GetItemIdByName("4 4")
ToyboxMod.COLLECTIBLE_DR_BUM = Isaac.GetItemIdByName("Dr. Bum")
ToyboxMod.COLLECTIBLE_JONAS_MASK = Isaac.GetItemIdByName("Jonas' Mask")
ToyboxMod.COLLECTIBLE_CLOWN_PHD = Isaac.GetItemIdByName("Clown PHD")
ToyboxMod.COLLECTIBLE_DRILL = Isaac.GetItemIdByName("Drill")
ToyboxMod.COLLECTIBLE_ALPHABET_BOX = Isaac.GetItemIdByName("Alphabet Box")
ToyboxMod.COLLECTIBLE_LOVE_LETTER = Isaac.GetItemIdByName("Love Letter")
ToyboxMod.COLLECTIBLE_QUAKE_BOMBS = Isaac.GetItemIdByName("Quake Bombs")
ToyboxMod.COLLECTIBLE_ATHEISM = Isaac.GetItemIdByName("Atheism")
ToyboxMod.COLLECTIBLE_MAYONAISE = Isaac.GetItemIdByName("A Spoonful of Mayonnaise")
ToyboxMod.COLLECTIBLE_AWESOME_FRUIT = Isaac.GetItemIdByName("Awesome Fruit")
ToyboxMod.COLLECTIBLE_SALTPETER = Isaac.GetItemIdByName("Saltpeter")
ToyboxMod.COLLECTIBLE_PLASMA_GLOBE = Isaac.GetItemIdByName("Plasma Globe")
ToyboxMod.COLLECTIBLE_CURSED_EULOGY = Isaac.GetItemIdByName("Cursed Eulogy")
ToyboxMod.COLLECTIBLE_BLESSED_BOMBS = Isaac.GetItemIdByName("Blessed Bombs")
ToyboxMod.COLLECTIBLE_BLOODY_WHISTLE = Isaac.GetItemIdByName("Bloody Whistle")
ToyboxMod.COLLECTIBLE_HEMORRHAGE = Isaac.GetItemIdByName("Haemorrhage")
ToyboxMod.COLLECTIBLE_FISH = Isaac.GetItemIdByName("Fish")
ToyboxMod.COLLECTIBLE_BOBS_THESIS = Isaac.GetItemIdByName("Bob's Thesis")
ToyboxMod.COLLECTIBLE_PLACEHOLDER = Isaac.GetItemIdByName("Placeholder")
ToyboxMod.COLLECTIBLE_ART_OF_WAR = Isaac.GetItemIdByName("Art of War")
ToyboxMod.COLLECTIBLE_ASTEROID_BELT = Isaac.GetItemIdByName("Asteroid Belt")
ToyboxMod.COLLECTIBLE_BARBED_WIRE = Isaac.GetItemIdByName("Barbed Wire")
ToyboxMod.COLLECTIBLE_BIG_BANG = Isaac.GetItemIdByName("Big Bang")
ToyboxMod.COLLECTIBLE_COFFEE_CUP = Isaac.GetItemIdByName("Coffee Cup")
ToyboxMod.COLLECTIBLE_LAST_BEER = Isaac.GetItemIdByName("Beer Can")
ToyboxMod.COLLECTIBLE_CHOCOLATE_BAR = Isaac.GetItemIdByName("Chocolate Bar")
ToyboxMod.COLLECTIBLE_CONJUNCTIVITIS = Isaac.GetItemIdByName("Conjunctivitis")
ToyboxMod.COLLECTIBLE_FOOD_STAMPS = Isaac.GetItemIdByName("Food Stamps")
ToyboxMod.COLLECTIBLE_GOLDEN_CALF = Isaac.GetItemIdByName("Golden Calf")
ToyboxMod.COLLECTIBLE_RETROFALL = Isaac.GetItemIdByName("RETROFALL")
ToyboxMod.COLLECTIBLE_D = Isaac.GetItemIdByName("D")
ToyboxMod.COLLECTIBLE_BRUNCH = Isaac.GetItemIdByName("Brunch")
ToyboxMod.COLLECTIBLE_TOAST = Isaac.GetItemIdByName("Toast")
ToyboxMod.COLLECTIBLE_DELIVERY_BOX = Isaac.GetItemIdByName("Delivery Box")
ToyboxMod.COLLECTIBLE_LUCKY_PEBBLES = Isaac.GetItemIdByName("Lucky Pebbles")
ToyboxMod.COLLECTIBLE_MOMS_PHOTOBOOK = Isaac.GetItemIdByName("Mom's Photobook")
ToyboxMod.COLLECTIBLE_FINGER_TRAP = Isaac.GetItemIdByName("Finger Trap")
ToyboxMod.COLLECTIBLE_HEMOLYMPH = Isaac.GetItemIdByName("Hemolymph")
ToyboxMod.COLLECTIBLE_SOLAR_PANEL = Isaac.GetItemIdByName("Solar Panel")
ToyboxMod.COLLECTIBLE_SURPRISE_EGG = Isaac.GetItemIdByName("Surprise Egg")
ToyboxMod.COLLECTIBLE_COLOSSAL_ORB = Isaac.GetItemIdByName("Colossal Orb")
ToyboxMod.COLLECTIBLE_SACK_OF_CHESTS = Isaac.GetItemIdByName("Sack of Chests")
ToyboxMod.COLLECTIBLE_BABY_SHOES = Isaac.GetItemIdByName("Baby Shoes")
ToyboxMod.COLLECTIBLE_EFFIGY = Isaac.GetItemIdByName("Effigy")
ToyboxMod.COLLECTIBLE_GAMBLING_ADDICTION = Isaac.GetItemIdByName("Gambling Addiction")
ToyboxMod.COLLECTIBLE_PYRAMID_SCHEME = Isaac.GetItemIdByName("Pyramid Scheme")
ToyboxMod.COLLECTIBLE_PYTHAGORAS_CUP = Isaac.GetItemIdByName("Pythagoras' Cup")
ToyboxMod.COLLECTIBLE_PYTHAGORAS_CUP_PASSIVE = Isaac.GetItemIdByName("Pythagoras' Cup ")
ToyboxMod.COLLECTIBLE_GOOD_JUICE = Isaac.GetItemIdByName("The Good Juice")
ToyboxMod.COLLECTIBLE_BUTTERFLY_EFFECT = Isaac.GetItemIdByName("Butterfly Effect")
ToyboxMod.COLLECTIBLE_BLOODFLOWER = Isaac.GetItemIdByName("Bloodflower")
ToyboxMod.COLLECTIBLE_RED_CLOVER = Isaac.GetItemIdByName("Red Clover")
ToyboxMod.COLLECTIBLE_BLACK_SOUL = Isaac.GetItemIdByName("Black Soul")
ToyboxMod.COLLECTIBLE_BIG_RED_BUTTON = Isaac.GetItemIdByName("Big Red Button")
ToyboxMod.COLLECTIBLE_OIL_PAINTING = Isaac.GetItemIdByName("Oil Painting")
ToyboxMod.COLLECTIBLE_READING_GLASSES = Isaac.GetItemIdByName("Reading Glasses")
ToyboxMod.COLLECTIBLE_LANGTON_LOOP = Isaac.GetItemIdByName("Langton Loop")
ToyboxMod.COLLECTIBLE_CURIOUS_CARROT = Isaac.GetItemIdByName("Curious Carrot")
ToyboxMod.COLLECTIBLE_GARLIC = Isaac.GetItemIdByName("Garlic")
ToyboxMod.COLLECTIBLE_WHITE_DAISY = Isaac.GetItemIdByName("White Daisy")
ToyboxMod.COLLECTIBLE_MELTED_CANDLE = Isaac.GetItemIdByName("Melted Candle")
ToyboxMod.COLLECTIBLE_TAMMYS_TAIL = Isaac.GetItemIdByName("Tammy's Tail")
ToyboxMod.COLLECTIBLE_MALICE = Isaac.GetItemIdByName("Malice")
ToyboxMod.COLLECTIBLE_PAPER_PLATE = Isaac.GetItemIdByName("Paper Plate")
ToyboxMod.COLLECTIBLE_TRENDSETTER = Isaac.GetItemIdByName("Trendsetter")
ToyboxMod.COLLECTIBLE_COLORING_BOOK = Isaac.GetItemIdByName("Coloring Book")
ToyboxMod.COLLECTIBLE_CONGLOMERATE = Isaac.GetItemIdByName("Conglomerate")
ToyboxMod.COLLECTIBLE_EMBER = Isaac.GetItemIdByName("Ember")
ToyboxMod.COLLECTIBLE_DISSOCIATION = Isaac.GetItemIdByName("Dissociation")
ToyboxMod.COLLECTIBLE_ANGEL_DUST = Isaac.GetItemIdByName("Angel Dust")
ToyboxMod.COLLECTIBLE_PUGGYS_CLAW = Isaac.GetItemIdByName("Puggy's Claw")
ToyboxMod.COLLECTIBLE_BLOCKCHAIN = Isaac.GetItemIdByName("Blockchain")
ToyboxMod.COLLECTIBLE_BODYBAG = Isaac.GetItemIdByName("Bodybag")
ToyboxMod.COLLECTIBLE_AIDS = Isaac.GetItemIdByName("AIDS")
ToyboxMod.COLLECTIBLE_HIDDEN_BLADE = Isaac.GetItemIdByName("Hidden Blade")
ToyboxMod.COLLECTIBLE_SNAKE_RING = Isaac.GetItemIdByName("Snake Ring")
ToyboxMod.COLLECTIBLE_CRICKETS_TAIL = Isaac.GetItemIdByName("Cricket's Tail")
ToyboxMod.COLLECTIBLE_MP3_PLAYER = Isaac.GetItemIdByName("MP3 Player")
ToyboxMod.COLLECTIBLE_MOUTHPIECE = Isaac.GetItemIdByName("Mouthpiece")
ToyboxMod.COLLECTIBLE_RELIQUARY = Isaac.GetItemIdByName("Reliquary")
ToyboxMod.COLLECTIBLE_DADS_PIPE = Isaac.GetItemIdByName("Dad's Pipe")
ToyboxMod.COLLECTIBLE_NOT_A_PIPE = Isaac.GetItemIdByName("Not a Pipe")
ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH = Isaac.GetItemIdByName("Vampire Teeth")
ToyboxMod.COLLECTIBLE_PROSPECTORS_PICK = Isaac.GetItemIdByName("Prospector Pick")
ToyboxMod.COLLECTIBLE_Y2K = Isaac.GetItemIdByName("Y2K")
ToyboxMod.COLLECTIBLE_MINDS_EYE = Isaac.GetItemIdByName("Mind's Eye")
ToyboxMod.COLLECTIBLE_MINDFLAYER_BABY = Isaac.GetItemIdByName("Flayer Baby")
ToyboxMod.COLLECTIBLE_YES_BABY = Isaac.GetItemIdByName("Yes Baby")
ToyboxMod.COLLECTIBLE_PSYCHO_BABY = Isaac.GetItemIdByName("Psycho Baby")
ToyboxMod.COLLECTIBLE_GIMP_BABY = Isaac.GetItemIdByName("Gimp Baby")
ToyboxMod.COLLECTIBLE_CHICCHAN_SERPENT = Isaac.GetItemIdByName("Chicchan")
ToyboxMod.COLLECTIBLE_ETZNAB_KNIFE = Isaac.GetItemIdByName("Etznab")
ToyboxMod.COLLECTIBLE_OC_DOG = Isaac.GetItemIdByName("Oc")
ToyboxMod.COLLECTIBLE_IMIX_CROCODILE = Isaac.GetItemIdByName("Imix")
ToyboxMod.COLLECTIBLE_CIB_VULTURE = Isaac.GetItemIdByName("Cib")
ToyboxMod.COLLECTIBLE_MEN_EAGLE = Isaac.GetItemIdByName("Men")
ToyboxMod.COLLECTIBLE_CABAN_EARTH = Isaac.GetItemIdByName("Caban")
ToyboxMod.COLLECTIBLE_LAMAT_RABBIT = Isaac.GetItemIdByName("Lamat")
ToyboxMod.COLLECTIBLE_MULAC_WATER = Isaac.GetItemIdByName("Mulac")
ToyboxMod.COLLECTIBLE_IK_WIND = Isaac.GetItemIdByName("Ik")
ToyboxMod.COLLECTIBLE_EB_GRASS = Isaac.GetItemIdByName("Eb")
ToyboxMod.COLLECTIBLE_KAN_LIZARD = Isaac.GetItemIdByName("Kan")
ToyboxMod.COLLECTIBLE_MANIK_DEER = Isaac.GetItemIdByName("Manik")
ToyboxMod.COLLECTIBLE_IX_JAGUAR = Isaac.GetItemIdByName("Ix")
ToyboxMod.COLLECTIBLE_AHAU_FLOWER = Isaac.GetItemIdByName("Ahau")
ToyboxMod.COLLECTIBLE_CHUEN_MONKEY = Isaac.GetItemIdByName("Chuen")
ToyboxMod.COLLECTIBLE_AKBAL_HOUSE = Isaac.GetItemIdByName("Akbal")
ToyboxMod.COLLECTIBLE_CIMI_DEATH = Isaac.GetItemIdByName("Cimi")
ToyboxMod.COLLECTIBLE_BEN_REED = Isaac.GetItemIdByName("Ben")
ToyboxMod.COLLECTIBLE_CAUAC_STORM = Isaac.GetItemIdByName("Cauac")
ToyboxMod.COLLECTIBLE_TAMMYS_BODY = Isaac.GetItemIdByName("Tammy's Body")
ToyboxMod.COLLECTIBLE_KROKODIL = Isaac.GetItemIdByName("Krokodil")
ToyboxMod.COLLECTIBLE_WOODEN_ARM = Isaac.GetItemIdByName("Wooden Arm")
ToyboxMod.COLLECTIBLE_RHUBARB = Isaac.GetItemIdByName("Rhubarb")
ToyboxMod.COLLECTIBLE_UNSTABLE_DNA = Isaac.GetItemIdByName("Unstable DNA")
ToyboxMod.COLLECTIBLE_LAB_MEAT = Isaac.GetItemIdByName("Lab Meat")
ToyboxMod.COLLECTIBLE_ANAPHYLAXIS = Isaac.GetItemIdByName("Anaphylaxis")
ToyboxMod.COLLECTIBLE_CLONE = Isaac.GetItemIdByName("Clone")
ToyboxMod.COLLECTIBLE_HAND_PUMP = Isaac.GetItemIdByName("Hand Pump")
ToyboxMod.COLLECTIBLE_SILVER_PIECES = Isaac.GetItemIdByName("Silver Pieces")
ToyboxMod.COLLECTIBLE_TWISTED_HEART = Isaac.GetItemIdByName("Twisted Heart")
ToyboxMod.COLLECTIBLE_CARRION = Isaac.GetItemIdByName("Carrion")
ToyboxMod.COLLECTIBLE_FERTILIZER = Isaac.GetItemIdByName("Fertilizer")
ToyboxMod.COLLECTIBLE_GUNPOWDER = Isaac.GetItemIdByName("Gunpowder")
ToyboxMod.COLLECTIBLE_INSTANT_GRATIFICATION = Isaac.GetItemIdByName("Instant Gratification")
ToyboxMod.COLLECTIBLE_MUTAGEN = Isaac.GetItemIdByName("Mutagen")
ToyboxMod.COLLECTIBLE_LEATHERFACE = Isaac.GetItemIdByName("Leatherface")
ToyboxMod.COLLECTIBLE_FRANKENCAT = Isaac.GetItemIdByName("Frankencat")
ToyboxMod.COLLECTIBLE_NANOMACHINES = Isaac.GetItemIdByName("Nanomachines")
ToyboxMod.COLLECTIBLE_BREAKTHROUGH = Isaac.GetItemIdByName("Breakthrough")
ToyboxMod.COLLECTIBLE_FRANKINCENSE = Isaac.GetItemIdByName("Frankincense")
ToyboxMod.COLLECTIBLE_ELEPHANTS_FOOT = Isaac.GetItemIdByName("Elephant's Foot")
ToyboxMod.COLLECTIBLE_XENOTRANSFUSION = Isaac.GetItemIdByName("Xenotransfusion")
ToyboxMod.COLLECTIBLE_CRAZED_BOBBY = Isaac.GetItemIdByName("Crazed Bobby")
ToyboxMod.COLLECTIBLE_JAM = Isaac.GetItemIdByName("Jam")
ToyboxMod.COLLECTIBLE_GREEDY_POT = Isaac.GetItemIdByName("Greedy Pot")
ToyboxMod.COLLECTIBLE_BLUE_WHALE = Isaac.GetItemIdByName("The Blue Whale")
ToyboxMod.COLLECTIBLE_BROTHERHOOD = Isaac.GetItemIdByName("Brotherhood")

ToyboxMod.COLLECTIBLE_TMTAMER = Isaac.GetItemIdByName("TMTAMER")

ToyboxMod.COLLECTIBLE_URANIUM = Isaac.GetItemIdByName("Uranium")
ToyboxMod.COLLECTIBLE_GOLDEN_PRAYER_CARD = Isaac.GetItemIdByName("Golden Prayer Card")
ToyboxMod.COLLECTIBLE_GOLDEN_SCHOOLBAG = Isaac.GetItemIdByName("Golden Schoolbag")
ToyboxMod.COLLECTIBLE_ZERO_GRAVITY = Isaac.GetItemIdByName("Zero-Gravity")
ToyboxMod.COLLECTIBLE_SUPER_HAMBURGER = Isaac.GetItemIdByName("Super Hamburger")
ToyboxMod.COLLECTIBLE_CURSED_D6 = Isaac.GetItemIdByName("Cursed D6")
ToyboxMod.COLLECTIBLE_PORTABLE_TELLER = Isaac.GetItemIdByName("Portable Teller")
ToyboxMod.COLLECTIBLE_SO_MANY_OPTIONS = Isaac.GetItemIdByName("So Many Options")

--ToyboxMod.COLLECTIBLE_LASER_POINTER = Isaac.GetItemIdByName("Laser Pointer")          --*UNUSED (i dont like the item)
--ToyboxMod.COLLECTIBLE_TOY_GUN = Isaac.GetItemIdByName("Toy Gun")                      --*UNUSED (same as above)
--ToyboxMod.COLLECTIBLE_MALICIOUS_BRAIN = Isaac.GetItemIdByName("Malicious Brain")      --*UNUSED (same)
--ToyboxMod.COLLECTIBLE_ENEMA = Isaac.GetItemIdByName("Enema")                          --*UNUSED (same as above)
--#endregion
--#region TRINKET

ToyboxMod.TRINKET_ANTIBIOTICS = Isaac.GetTrinketIdByName("Antibiotics")
ToyboxMod.TRINKET_WONDER_DRUG = Isaac.GetTrinketIdByName("Wonder Drug")
ToyboxMod.TRINKET_AMBER_FOSSIL = Isaac.GetTrinketIdByName("Amber Fossil")
ToyboxMod.TRINKET_JONAS_LOCK = Isaac.GetTrinketIdByName("Jonas' Lock")
ToyboxMod.TRINKET_BIG_BLIND = Isaac.GetTrinketIdByName("Big Blind")
ToyboxMod.TRINKET_BATH_WATER = Isaac.GetTrinketIdByName("Bath Water")
ToyboxMod.TRINKET_BLACK_RUNE_SHARD = Isaac.GetTrinketIdByName("Black Rune Shard")
ToyboxMod.TRINKET_YELLOW_BELT = Isaac.GetTrinketIdByName("Yellow Belt")
ToyboxMod.TRINKET_SUPPOSITORY = Isaac.GetTrinketIdByName("Suppository")
ToyboxMod.TRINKET_DIVIDED_JUSTICE = Isaac.GetTrinketIdByName("Divided Justice")
ToyboxMod.TRINKET_KILLSCREEN = Isaac.GetTrinketIdByName("Killscreen")
ToyboxMod.TRINKET_MIRROR_SHARD = Isaac.GetTrinketIdByName("Mirror Shard")
ToyboxMod.TRINKET_LUCKY_TOOTH = Isaac.GetTrinketIdByName("Lucky Tooth")
ToyboxMod.TRINKET_HOLY_LENS = Isaac.GetTrinketIdByName("Holy Lens")
ToyboxMod.TRINKET_DARK_NEBULA = Isaac.GetTrinketIdByName("Dark Nebula")
ToyboxMod.TRINKET_MAKEUP_KIT = Isaac.GetTrinketIdByName("Make-Up Kit")
ToyboxMod.TRINKET_ZAP_CAP = Isaac.GetTrinketIdByName("Zap Cap")
ToyboxMod.TRINKET_MISPRINT = Isaac.GetTrinketIdByName("Misprint")
ToyboxMod.TRINKET_CUTOUT = Isaac.GetTrinketIdByName("Cutout")
ToyboxMod.TRINKET_GASOLINE = Isaac.GetTrinketIdByName("Gasoline")
ToyboxMod.TRINKET_NIGHTCAP = Isaac.GetTrinketIdByName("Nightcap")
ToyboxMod.TRINKET_LOOTBOX = Isaac.GetTrinketIdByName("Lootbox")
ToyboxMod.TRINKET_SPITEFUL_PENNY = Isaac.GetTrinketIdByName("Spiteful Penny")
ToyboxMod.TRINKET_LIBRARY_CARD = Isaac.GetTrinketIdByName("Library Card")
ToyboxMod.TRINKET_LIFETIME_SUPPLY = Isaac.GetTrinketIdByName("Lifetime Supply")
ToyboxMod.TRINKET_RUBBING_ALCOHOL = Isaac.GetTrinketIdByName("Rubbing Alcohol")
ToyboxMod.TRINKET_INSIDE_JOKE = Isaac.GetTrinketIdByName("Inside Joke")
ToyboxMod.TRINKET_CITRUSBERRY = Isaac.GetTrinketIdByName("Citrusberry")
    ToyboxMod.TRINKET_CITRUSBERRY_CONSUMED = Isaac.GetTrinketIdByName("Citrusberry ")
ToyboxMod.TRINKET_SLINGSHOT = Isaac.GetTrinketIdByName("Slingshot")
ToyboxMod.TRINKET_CATNIP = Isaac.GetTrinketIdByName("Catnip")
ToyboxMod.TRINKET_TRAIL_MIX = Isaac.GetTrinketIdByName("Trail Mix")
ToyboxMod.TRINKET_EARWORM = Isaac.GetTrinketIdByName("Earworm")
ToyboxMod.TRINKET_7TH_PAGE = Isaac.GetTrinketIdByName("The 7th Page")
ToyboxMod.TRINKET_POWER_WORD = Isaac.GetTrinketIdByName("Power Word")
ToyboxMod.TRINKET_TUNGSTEN_KEY = Isaac.GetTrinketIdByName("Tungsten Key")
ToyboxMod.TRINKET_SWALLOWED_D10 = Isaac.GetTrinketIdByName("Swallowed D10")
ToyboxMod.TRINKET_MONOCLE = Isaac.GetTrinketIdByName("Monocle")
ToyboxMod.TRINKET_PINK_DONUT = Isaac.GetTrinketIdByName("Pink Donut")
ToyboxMod.TRINKET_INFESTATION_3 = Isaac.GetTrinketIdByName("Infestation 3")
ToyboxMod.TRINKET_FAKE_BEARD = Isaac.GetTrinketIdByName("Fake Beard")
ToyboxMod.TRINKET_SUGAR_CUBE = Isaac.GetTrinketIdByName("Sugar Cube")
ToyboxMod.TRINKET_INTEREST = Isaac.GetTrinketIdByName("Interest")
ToyboxMod.TRINKET_NEMATODE = Isaac.GetTrinketIdByName("Nematode")
ToyboxMod.TRINKET_LIL_GRUB = Isaac.GetTrinketIdByName("Lil Grub")
ToyboxMod.TRINKET_CANDIDA = Isaac.GetTrinketIdByName("Candida")
ToyboxMod.TRINKET_DEWORMER = Isaac.GetTrinketIdByName("Dewormer")
ToyboxMod.TRINKET_LADYBUG = Isaac.GetTrinketIdByName("Ladybug")
ToyboxMod.TRINKET_DEMODEX = Isaac.GetTrinketIdByName("Demodex")
ToyboxMod.TRINKET_FAT_LEECH = Isaac.GetTrinketIdByName("Fat Leech")

ToyboxMod.TRINKET_FLUKIE = Isaac.GetTrinketIdByName("Flukie")
ToyboxMod.TRINKET_HATCHLING = Isaac.GetTrinketIdByName("Hatchling")


--ToyboxMod.TRINKET_LIMIT_BREAK = Isaac.GetTrinketIdByName("LIMIT BREAK")               --*UNUSED
--ToyboxMod.TRINKET_FOAM_BULLET = Isaac.GetTrinketIdByName("Foam Bullet")               --*UNUSED
--ToyboxMod.TRINKET_SINE_WORM = Isaac.GetTrinketIdByName("Sine Worm")                   --*UNUSED
--#endregion
--#region CARD

ToyboxMod.CARD_PRISMSTONE = Isaac.GetCardIdByName("Prismstone")
ToyboxMod.CARD_FOIL_CARD = Isaac.GetCardIdByName("Foil Card")
ToyboxMod.CARD_ALIEN_MIND = Isaac.GetCardIdByName("Alien Mind")
ToyboxMod.CARD_POISON_RAIN = Isaac.GetCardIdByName("Poison Rain")
ToyboxMod.CARD_FOUR_STARRED_LADYBUG = Isaac.GetCardIdByName("4-Starred Ladybug")
ToyboxMod.CARD_DARK_EXPLOSION = Isaac.GetCardIdByName("Dark Explosion")
ToyboxMod.CARD_ENDLESS_CHAOS = Isaac.GetCardIdByName("Endless Chaos")
ToyboxMod.CARD_CHAIN_REACTION = Isaac.GetCardIdByName("Chain Reaction")
--[[
ToyboxMod.CARD_TALISMAN = Isaac.GetCardIdByName("Talisman")
ToyboxMod.CARD_GRIM = Isaac.GetCardIdByName("Grim")
ToyboxMod.CARD_FAMILIAR = Isaac.GetCardIdByName("Familiar")
ToyboxMod.CARD_SIGIL = Isaac.GetCardIdByName("Sigil")
ToyboxMod.CARD_ECTOPLASM = Isaac.GetCardIdByName("Ectoplasm")
ToyboxMod.CARD_TRANCE = Isaac.GetCardIdByName("Trance")
ToyboxMod.CARD_DEJA_VU = Isaac.GetCardIdByName("Deja Vu")
]]
ToyboxMod.CARD_GREEN_APPLE = Isaac.GetCardIdByName("Green Apple")
ToyboxMod.CARD_MANTLE_ROCK = Isaac.GetCardIdByName("Mantle - Rock")
ToyboxMod.CARD_MANTLE_POOP = Isaac.GetCardIdByName("Mantle - Poop")
ToyboxMod.CARD_MANTLE_BONE = Isaac.GetCardIdByName("Mantle - Bone")
ToyboxMod.CARD_MANTLE_DARK = Isaac.GetCardIdByName("Mantle - Dark")
ToyboxMod.CARD_MANTLE_HOLY = Isaac.GetCardIdByName("Mantle - Holy")
ToyboxMod.CARD_MANTLE_SALT = Isaac.GetCardIdByName("Mantle - Salt")
ToyboxMod.CARD_MANTLE_GLASS = Isaac.GetCardIdByName("Mantle - Glass")
ToyboxMod.CARD_MANTLE_METAL = Isaac.GetCardIdByName("Mantle - Metal")
ToyboxMod.CARD_MANTLE_GOLD = Isaac.GetCardIdByName("Mantle - Gold")
--ToyboxMod.CARD_LAUREL = Isaac.GetCardIdByName("Laurel")
--ToyboxMod.CARD_YANNY = Isaac.GetCardIdByName("Yanny")
ToyboxMod.CARD_THE_WISE_MEN = Isaac.GetCardIdByName("S - The Wise Men")
ToyboxMod.CARD_THE_ANGEL = Isaac.GetCardIdByName("IS - The Angel")
ToyboxMod.CARD_THE_GATE = Isaac.GetCardIdByName("IIS - The Gate")
ToyboxMod.CARD_APOCALYPSE = Isaac.GetCardIdByName("IIIS - Apocalypse")
ToyboxMod.CARD_THE_CRYPT = Isaac.GetCardIdByName("IVS - The Crypt")
ToyboxMod.CARD_THE_REAPER = Isaac.GetCardIdByName("VS - The Reaper")
ToyboxMod.CARD_THE_DRAGON = Isaac.GetCardIdByName("VIS - The Dragon")
ToyboxMod.CARD_DUALITY = Isaac.GetCardIdByName("VIIS - Duality")
ToyboxMod.CARD_THE_BARON = Isaac.GetCardIdByName("VIIIS - The Baron")

ToyboxMod.CARD_THE_TRICKSTER = Isaac.GetCardIdByName("IXS - The Trickster")
ToyboxMod.CARD_MEMORY = Isaac.GetCardIdByName("XS - Memory")
ToyboxMod.CARD_THE_CARAVAN = Isaac.GetCardIdByName("XIS - The Caravan")
ToyboxMod.CARD_EXCALIBUR = Isaac.GetCardIdByName("XIIS - Excalibur")
ToyboxMod.CARD_FATE = Isaac.GetCardIdByName("XIIIS - Fate")
ToyboxMod.CARD_THE_PHANTOM = Isaac.GetCardIdByName("XIVS - The Phantom")
ToyboxMod.CARD_MIRAGE = Isaac.GetCardIdByName("XVS - Mirage")
ToyboxMod.CARD_THE_IDOL = Isaac.GetCardIdByName("XVIS - The Idol")
ToyboxMod.CARD_GREYHOUND = Isaac.GetCardIdByName("Greyhound")
--#endregion
--#region PILL EFFECT

ToyboxMod.PILL_I_BELIEVE = Isaac.GetPillEffectByName("I Believe I Can Fly!")
ToyboxMod.PILL_DYSLEXIA = Isaac.GetPillEffectByName("Dyslexia")
ToyboxMod.PILL_DMG_UP = Isaac.GetPillEffectByName("Damage Up")
ToyboxMod.PILL_DMG_DOWN = Isaac.GetPillEffectByName("Damage Down")
ToyboxMod.PILL_DEMENTIA = Isaac.GetPillEffectByName("Dementia")
ToyboxMod.PILL_PARASITE = Isaac.GetPillEffectByName("Parasite!")
ToyboxMod.PILL_FENT = Isaac.GetPillEffectByName("Fent")
ToyboxMod.PILL_YOUR_SOUL_IS_MINE = Isaac.GetPillEffectByName("Your Soul is Mine")
ToyboxMod.PILL_ARTHRITIS = Isaac.GetPillEffectByName("Arthritis")
ToyboxMod.PILL_OSSIFICATION = Isaac.GetPillEffectByName("Ossification")
--ToyboxMod.PILL_BLEEEGH = Isaac.GetPillEffectByName("Bleeegh!")
ToyboxMod.PILL_VITAMINS = Isaac.GetPillEffectByName("Vitamins!")
ToyboxMod.PILL_COAGULANT = Isaac.GetPillEffectByName("Coagulant")
ToyboxMod.PILL_FOOD_POISONING = Isaac.GetPillEffectByName("Food Poisoning")
ToyboxMod.PILL_HEARTBURN = Isaac.GetPillEffectByName("Heartburn")
ToyboxMod.PILL_MUSCLE_ATROPHY = Isaac.GetPillEffectByName("Muscle Atrophy")
ToyboxMod.PILL_CAPSULE = Isaac.GetPillEffectByName("Capsule")
--#endregion
--#region FAMILIAR
--#region FAMILIAR VARIANT

ToyboxMod.FAMILIAR_HYPNOS = Isaac.GetEntityVariantByName("Malicious Brain") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_SILK_BAG = Isaac.GetEntityVariantByName("Silk Bag") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_BONE_BOY = Isaac.GetEntityVariantByName("Bone Boy") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_EVIL_SHADOW = Isaac.GetEntityVariantByName("Black Shadow") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_VIRUS = Isaac.GetEntityVariantByName("Virus Baby") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_MASK_SHADOW = Isaac.GetEntityVariantByName("Shadow Fly") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_DR_BUM = Isaac.GetEntityVariantByName("Dr Bum") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_BATH_WATER = Isaac.GetEntityVariantByName("Bath Water") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_SACK_OF_CHESTS = Isaac.GetEntityVariantByName("Sack of Chests") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_EFFIGY = Isaac.GetEntityVariantByName("Effigy") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_PYTHAGORAS_CUP = Isaac.GetEntityVariantByName("Pythagoras' Cup") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_GOOD_JOB_STAR = Isaac.GetEntityVariantByName("Good Job Star") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_DECOY = Isaac.GetEntityVariantByName("Cardboard Decoy") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_PAPER_PLATE = Isaac.GetEntityVariantByName("Paper Plate") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_WISE_MEN_STAR = Isaac.GetEntityVariantByName("Wise Men Star") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_TRINKET_WISP = Isaac.GetEntityVariantByName("Trinket Wisp Familiar") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_MINDS_EYE = Isaac.GetEntityVariantByName("Mind's Eye Follower") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_MINDFLAYER_BABY = Isaac.GetEntityVariantByName("Flayer Baby") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_YES_BABY = Isaac.GetEntityVariantByName("Yes Baby") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_PSYCHO_BABY = Isaac.GetEntityVariantByName("Psycho Baby") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_GIMP_BABY = Isaac.GetEntityVariantByName("Gimp Baby") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_CRAZED_BOBBY = Isaac.GetEntityVariantByName("Crazed Bobby") ---@type FamiliarVariant
ToyboxMod.FAMILIAR_LIL_POT = Isaac.GetEntityVariantByName("Lil Pot") ---@type FamiliarVariant
--#endregion
--#region FAMILIAR SUBTYPE

ToyboxMod.FAMILIAR_VIRUS_RED = 0
ToyboxMod.FAMILIAR_VIRUS_YELLOW_1 = 1
ToyboxMod.FAMILIAR_VIRUS_BLUE = 2
ToyboxMod.FAMILIAR_VIRUS_MAGENTA = 3
ToyboxMod.FAMILIAR_VIRUS_YELLOW_2 = 4
ToyboxMod.FAMILIAR_VIRUS_CYAN = 5
ToyboxMod.FAMILIAR_VIRUS_GREEN = 6
ToyboxMod.FAMILIAR_VIRUS_LIGHT_BLUE = 7
ToyboxMod.FAMILIAR_VIRUS_PINK = 8
ToyboxMod.FAMILIAR_VIRUS_PURPLE = 9

ToyboxMod.FAMILIAR_MASK_SHADOW_FLY = Isaac.GetEntitySubTypeByName("Shadow Fly")
ToyboxMod.FAMILIAR_MASK_SHADOW_URCHIN = Isaac.GetEntitySubTypeByName("Shadow Urchin")
ToyboxMod.FAMILIAR_MASK_SHADOW_CRAWLER = Isaac.GetEntitySubTypeByName("Shadow Crawler")
--#endregion
--#endregion
--#region BOMB

ToyboxMod.BOMB_SLEEPY_TROLL_BOMB = Isaac.GetEntityVariantByName("Sleepy Troll Bomb") ---@type BombVariant
--#endregion
--#region SLOT

ToyboxMod.SLOT_PYRAMID_DONATION = Isaac.GetEntityVariantByName("Pyramid Donation Machine") ---@type SlotVariant
ToyboxMod.SLOT_JUICE_FOUNTAIN = Isaac.GetEntityVariantByName("Juice Fountain") ---@type SlotVariant
--#endregion
--#region EFFECT (and GRID)
--#region EFFECT VARIANT

ToyboxMod.EFFECT_BLOOD_RITUAL_PENTAGRAM = Isaac.GetEntityVariantByName("Blood Ritual Pentagram") ---@type EffectVariant
ToyboxMod.EFFECT_METEOR_TEAR_EXPLOSION = Isaac.GetEntityVariantByName("Meteor Tear Explosion") ---@type EffectVariant
ToyboxMod.EFFECT_GOLDMANTLE_BREAK = Isaac.GetEntityVariantByName("Gold Mantle Shatter") ---@type EffectVariant
ToyboxMod.EFFECT_GREED_SIGIL_CHARGEBAR = Isaac.GetEntityVariantByName("Greed Sigil Chargebar") ---@type EffectVariant
ToyboxMod.EFFECT_ASCENSION_PLAYER_DEATH = Isaac.GetEntityVariantByName("Ascension Dead Player") ---@type EffectVariant
ToyboxMod.EFFECT_AURA = Isaac.GetEntityVariantByName("Enemy Fear Aura") ---@type EffectVariant
ToyboxMod.EFFECT_VESSEL_BREAK = Isaac.GetEntityVariantByName("Glass Vessel Break") ---@type EffectVariant
ToyboxMod.EFFECT_BARBED_WIRE_HALO = Isaac.GetEntityVariantByName("Barbed Wire Halo (TOYBOX)") ---@type EffectVariant
ToyboxMod.EFFECT_DRILL = Isaac.GetEntityVariantByName("Drill") ---@type EffectVariant
ToyboxMod.EFFECT_PYTHAGORAS_CUP_SPILL = Isaac.GetEntityVariantByName("Pythagoras' Cup Spill") ---@type EffectVariant
ToyboxMod.EFFECT_KILLSCREEN_GLITCH = Isaac.GetEntityVariantByName("Killscreen Glitch") ---@type EffectVariant
ToyboxMod.EFFECT_JUICE_TRAIL = Isaac.GetEntityVariantByName("Good Juice Trail") ---@type EffectVariant
ToyboxMod.EFFECT_METEOR = Isaac.GetEntityVariantByName("Meteor") ---@type EffectVariant
ToyboxMod.EFFECT_SMOKE_TRAIL = Isaac.GetEntityVariantByName("Smoke Trail") ---@type EffectVariant
ToyboxMod.EFFECT_FLAME_BREATH_HELPER = Isaac.GetEntityVariantByName("Flame Breath Helper") ---@type EffectVariant
ToyboxMod.EFFECT_FEAR_LIGHT = Isaac.GetEntityVariantByName("Enemy Fear Light") ---@type EffectVariant
ToyboxMod.EFFECT_APOCALYPSE_HELPER = Isaac.GetEntityVariantByName("Apocalypse Helper") ---@type EffectVariant
ToyboxMod.EFFECT_PIPE_SMOKE = Isaac.GetEntityVariantByName("Pipe Smoke") ---@type EffectVariant
ToyboxMod.EFFECT_PIPE_BOOMERANG = Isaac.GetEntityVariantByName("Pipe Boomerang") ---@type EffectVariant
ToyboxMod.EFFECT_TEMPLE_SLAB = Isaac.GetEntityVariantByName("Temple Slab") ---@type EffectVariant
ToyboxMod.EFFECT_BLOOD_COLLECT = Isaac.GetEntityVariantByName("Blood Coin Collect") ---@type EffectVariant
ToyboxMod.EFFECT_MINDS_EYE = Isaac.GetEntityVariantByName("Watching Eye") ---@type EffectVariant
ToyboxMod.EFFECT_FLOWER_PATCH = Isaac.GetEntityVariantByName("Flower Patch") ---@type EffectVariant
ToyboxMod.EFFECT_NOWHERE_RIFT = Isaac.GetEntityVariantByName("Nowhere Tears Rift") ---@type EffectVariant
ToyboxMod.EFFECT_WOODEN_ARM = Isaac.GetEntityVariantByName("Wooden Arm") ---@type EffectVariant
ToyboxMod.EFFECT_SWITCH_BLOCK_RENDER_HELPER = Isaac.GetEntityVariantByName("Switch Block Render Helper") ---@type EffectVariant
ToyboxMod.EFFECT_ITEM_AFTERIMAGE = Isaac.GetEntityVariantByName("Item Afterimage") ---@type EffectVariant

ToyboxMod.EFFECT_ZERO_GRAV_CROSSHAIR = Isaac.GetEntityVariantByName("Zero-Gravity Crosshair") ---@type EffectVariant
ToyboxMod.EFFECT_KANYE = Isaac.GetEntityVariantByName("Kanye West") ---@type EffectVariant

ToyboxMod.EFFECT_GRID_HELPER = Isaac.GetEntityVariantByName("Toybox Grid Helper") ---@type EffectVariant
--#endregion
--#region EFFECT SUBTYPE (and GRIDS)

ToyboxMod.EFFECT_AURA_ENEMY_FEAR = Isaac.GetEntitySubTypeByName("Enemy Fear Aura")
ToyboxMod.EFFECT_AURA_BOMB_BLESSED = Isaac.GetEntitySubTypeByName("Bomb Blessed Aura")
ToyboxMod.EFFECT_AURA_DARK_MANTLE = Isaac.GetEntitySubTypeByName("Dark Mantle Aura")
ToyboxMod.EFFECT_AURA_HOLY_MANTLE = Isaac.GetEntitySubTypeByName("Holy Mantle Aura")
ToyboxMod.EFFECT_AURA_44 = Isaac.GetEntitySubTypeByName("4 4 Aura")
ToyboxMod.EFFECT_AURA_MINDFLAYER = Isaac.GetEntitySubTypeByName("Mindflayer Aura")

ToyboxMod.GRID_COPPER_POOP = Isaac.GetEntitySubTypeByName("Copper Poop")
ToyboxMod.GRID_PLAYERONLY_BLOCK = Isaac.GetEntitySubTypeByName("Player-Only Block")
ToyboxMod.GRID_ENEMYONLY_BLOCK = Isaac.GetEntitySubTypeByName("Enemy-Only Block")
ToyboxMod.GRID_SWITCH_BLOCK_1 = Isaac.GetEntitySubTypeByName("Switch Block (1)")
ToyboxMod.GRID_SWITCH_BLOCK_2 = Isaac.GetEntitySubTypeByName("Switch Block (2)")
ToyboxMod.GRID_SWITCH_BLOCK_3 = Isaac.GetEntitySubTypeByName("Switch Block (3)")
ToyboxMod.GRID_SWITCH_BLOCK_4 = Isaac.GetEntitySubTypeByName("Switch Block (4)")
ToyboxMod.GRID_SWITCH_BLOCK_INACTIVE_1 = Isaac.GetEntitySubTypeByName("Switch Block (Inactive) (1)")
ToyboxMod.GRID_SWITCH_BLOCK_INACTIVE_2 = Isaac.GetEntitySubTypeByName("Switch Block (Inactive) (2)")
ToyboxMod.GRID_SWITCH_BLOCK_INACTIVE_3 = Isaac.GetEntitySubTypeByName("Switch Block (Inactive) (3)")
ToyboxMod.GRID_SWITCH_BLOCK_INACTIVE_4 = Isaac.GetEntitySubTypeByName("Switch Block (Inactive) (4)")
ToyboxMod.GRID_SWITCH_PLATE_1 = Isaac.GetEntitySubTypeByName("Switch Plate (1)")
ToyboxMod.GRID_SWITCH_PLATE_2 = Isaac.GetEntitySubTypeByName("Switch Plate (2)")
ToyboxMod.GRID_SWITCH_PLATE_3 = Isaac.GetEntitySubTypeByName("Switch Plate (3)")
ToyboxMod.GRID_SWITCH_PLATE_4 = Isaac.GetEntitySubTypeByName("Switch Plate (4)")
ToyboxMod.GRID_GRAVE_EMPTY = Isaac.GetEntitySubTypeByName("Tombstone (Empty)")
ToyboxMod.GRID_GRAVE_RANDOM = Isaac.GetEntitySubTypeByName("Tombstone (Random)")
ToyboxMod.GRID_NUCLEAR_POOP = Isaac.GetEntitySubTypeByName("Nuclear Poop")
--ToyboxMod.GRID_DEATH_SPIKES_HELPER = Isaac.GetEntitySubTypeByName("Death Sacrifice Spike Helper")
--#endregion
--#endregion
--#region TEAR

ToyboxMod.TEAR_COOL = Isaac.GetEntityVariantByName("Cool Tear") ---@type TearVariant
ToyboxMod.TEAR_AIDS = Isaac.GetEntityVariantByName("AIDS Tear") ---@type TearVariant
ToyboxMod.TEAR_YES = Isaac.GetEntityVariantByName("Yes Tear") ---@type TearVariant
--ToyboxMod.TEAR_METEOR = Isaac.GetEntityVariantByName("Meteor Tear") ---@type TearVariant
--ToyboxMod.TEAR_BULLET = Isaac.GetEntityVariantByName("Foam Bullet Tear") ---@type TearVariant
--ToyboxMod.TEAR_SOUNDWAVE = Isaac.GetEntityVariantByName("Soundwave Tear") ---@type TearVariant
--ToyboxMod.TEAR_PAPER = Isaac.GetEntityVariantByName("Tome Paper Tear") ---@type TearVariant
--#endregion
--#region PICKUP
--#region PICKUP VARIANT

ToyboxMod.PICKUP_SMORGASBORD = Isaac.GetEntityVariantByName("Smorgasbord") ---@type PickupVariant
ToyboxMod.PICKUP_ETERNAL_MOUND = Isaac.GetEntityVariantByName("Eternal Mound") ---@type PickupVariant
ToyboxMod.PICKUP_LONELY_KEY = Isaac.GetEntityVariantByName("Lonely Key") ---@type PickupVariant

ToyboxMod.PICKUP_RANDOM_SELECTOR = Isaac.GetEntityVariantByName("Toybox Random Mantle") ---@type PickupVariant
ToyboxMod.PICKUP_CARD_SPAWNER = Isaac.GetEntityVariantByName("Toybox Card Spawner") ---@type PickupVariant
--#endregion
--#region PICKUP SUBTYPE

ToyboxMod.PICKUP_COIN_INK_1 = Isaac.GetEntitySubTypeByName("Ink (1)") ---@type CoinSubType
ToyboxMod.PICKUP_COIN_INK_2 = Isaac.GetEntitySubTypeByName("Ink (2)") ---@type CoinSubType
ToyboxMod.PICKUP_COIN_INK_5 = Isaac.GetEntitySubTypeByName("Ink (5)") ---@type CoinSubType

ToyboxMod.PICKUP_RANDOM_MANTLE = Isaac.GetEntitySubTypeByName("Toybox Random Mantle")
ToyboxMod.PICKUP_RANDOM_MANTLE_NOBIAS = Isaac.GetEntitySubTypeByName("Toybox Random Mantle (No Bias)")
ToyboxMod.PICKUP_RANDOM_ALT_TAROT = Isaac.GetEntitySubTypeByName("Toybox Random Alt Tarot Card")
ToyboxMod.PICKUP_RANDOM_YU_GI_OH = Isaac.GetEntitySubTypeByName("Toybox Random Yu-Gi-Oh! Card")
--#endregion
--#endregion
--#region NPC

ToyboxMod.NPC_DUMMY_NPC = Isaac.GetEntityTypeByName("Toybox Dummy NPC")
ToyboxMod.NPC_ENEMY = Isaac.GetEntityTypeByName("Stumpy")

ToyboxMod.NPC_STUMPY = Isaac.GetEntityVariantByName("Stumpy")
ToyboxMod.NPC_TONSIL = Isaac.GetEntityVariantByName("Tonsil")
ToyboxMod.NPC_EYE_SPY = Isaac.GetEntityVariantByName("Eye Spy")
ToyboxMod.NPC_KING_HOST = Isaac.GetEntityVariantByName("King Host")
ToyboxMod.NPC_TAR_BABY = Isaac.GetEntityVariantByName("Tar Baby")
--#endregion
--#region SFX

ToyboxMod.SFX_ATLASA_ROCKCRACK = Isaac.GetSoundIdByName("(TOYBOX) Rock Crack")
ToyboxMod.SFX_ATLASA_ROCKBREAK = Isaac.GetSoundIdByName("(TOYBOX) Rock Break")
ToyboxMod.SFX_ATLASA_METALBLOCK = Isaac.GetSoundIdByName("(TOYBOX) Metal Block")
ToyboxMod.SFX_ATLASA_METALBREAK = Isaac.GetSoundIdByName("(TOYBOX) Metal Break")
ToyboxMod.SFX_ATLASA_GLASSBREAK = Isaac.GetSoundIdByName("(TOYBOX) Glass Break")
ToyboxMod.SFX_FOUR_FOUR_SCREAM = Isaac.GetSoundIdByName("(TOYBOX) 4 4 Scream")
ToyboxMod.SFX_SILK_BAG_SHIELD = Isaac.GetSoundIdByName("(TOYBOX) Silk Bag Shield")
ToyboxMod.SFX_TOY_GUN_RELOAD = Isaac.GetSoundIdByName("(TOYBOX) Gun Reload")
ToyboxMod.SFX_BULLET_FIRE = Isaac.GetSoundIdByName("(TOYBOX) Bullet Shoot")
ToyboxMod.SFX_BULLET_HIT = Isaac.GetSoundIdByName("(TOYBOX) Bullet Hit")
ToyboxMod.SFX_POWERUP = Isaac.GetSoundIdByName("(TOYBOX) Powerup")
ToyboxMod.SFX_POWERDOWN = Isaac.GetSoundIdByName("(TOYBOX) Powerdown")
ToyboxMod.SFX_VIRUS_SPAWN = Isaac.GetSoundIdByName("(TOYBOX) Virus Spawn")
ToyboxMod.SFX_VIRUS_SHOOT = Isaac.GetSoundIdByName("(TOYBOX) Virus Shoot")
ToyboxMod.SFX_VIRUS_DIE = Isaac.GetSoundIdByName("(TOYBOX) Virus Die")
ToyboxMod.SFX_SHADOW_SCREAM = Isaac.GetSoundIdByName("(TOYBOX) Shadow Scream")
ToyboxMod.SFX_BLOODY_WHISTLE = Isaac.GetSoundIdByName("(TOYBOX) Whistle")
ToyboxMod.SFX_SLIPPER_WHIP = Isaac.GetSoundIdByName("(TOYBOX) Whip")
ToyboxMod.SFX_COLOSSAL_ORB_SHOCKWAVE = Isaac.GetSoundIdByName("(TOYBOX) Colossal Orb Shockwave")
ToyboxMod.SFX_BURP = Isaac.GetSoundIdByName("(TOYBOX) Burp")
ToyboxMod.SFX_WATER_LOOP = Isaac.GetSoundIdByName("(TOYBOX) Water Loop (Copy)")
ToyboxMod.SFX_HYPNOSIS = Isaac.GetSoundIdByName("(TOYBOX) Hypnosis")
ToyboxMod.SFX_HAZE = Isaac.GetSoundIdByName("(TOYBOX) Haze")
ToyboxMod.SFX_DRILL = Isaac.GetSoundIdByName("(TOYBOX) Drill")
ToyboxMod.SFX_MEOW = Isaac.GetSoundIdByName("(TOYBOX) Meow")
ToyboxMod.SFX_POOF = Isaac.GetSoundIdByName("(TOYBOX) Poof")
ToyboxMod.SFX_ROCK_SCRAPE = Isaac.GetSoundIdByName("(TOYBOX) Rock Scrape")
ToyboxMod.SFX_POISON = Isaac.GetSoundIdByName("(TOYBOX) Poison")
ToyboxMod.SFX_STAR_SPAWN = Isaac.GetSoundIdByName("(TOYBOX) Star Spawn")
ToyboxMod.SFX_STAR_TRANSFORM = Isaac.GetSoundIdByName("(TOYBOX) Star Transform")
ToyboxMod.SFX_BREATH = Isaac.GetSoundIdByName("(TOYBOX) Breath")
ToyboxMod.SFX_WATER_NOISE = Isaac.GetSoundIdByName("(TOYBOX) Water Noise")
ToyboxMod.SFX_ROAR = Isaac.GetSoundIdByName("(TOYBOX) Roar")
ToyboxMod.SFX_RETRO_COIN = Isaac.GetSoundIdByName("(TOYBOX) Blockchain Coin")
ToyboxMod.SFX_RETRO_UPGRADE = Isaac.GetSoundIdByName("(TOYBOX) Blockchain Upgrade")
ToyboxMod.SFX_RETRO_FAIL = Isaac.GetSoundIdByName("(TOYBOX) Blockchain Fail")
ToyboxMod.SFX_MP3_PLAYER = Isaac.GetSoundIdByName("(TOYBOX) MP3 Player")
ToyboxMod.SFX_EVIL = Isaac.GetSoundIdByName("(TOYBOX) Evil Sound")
ToyboxMod.SFX_REWIND = Isaac.GetSoundIdByName("(TOYBOX) Rewind")
ToyboxMod.SFX_BELL = Isaac.GetSoundIdByName("(TOYBOX) Bell")
ToyboxMod.SFX_ARM_ABSORB = Isaac.GetSoundIdByName("(TOYBOX) Arm Absorb")
ToyboxMod.SFX_ARM_ATTACK = Isaac.GetSoundIdByName("(TOYBOX) Arm Attack")
ToyboxMod.SFX_CRUNCH = Isaac.GetSoundIdByName("(TOYBOX) Crunch")
ToyboxMod.SFX_DEFLATE = Isaac.GetSoundIdByName("(TOYBOX) Deflate")
ToyboxMod.SFX_SHATTER_REVERSE = Isaac.GetSoundIdByName("(TOYBOX) Shield Shatter Reversed")
ToyboxMod.SFX_EUREKA = Isaac.GetSoundIdByName("(TOYBOX) Eureka")
ToyboxMod.SFX_EUREKA_DISCHARGE = Isaac.GetSoundIdByName("(TOYBOX) Eureka Discharge")
ToyboxMod.SFX_EQUIP = Isaac.GetSoundIdByName("(TOYBOX) Equip")
ToyboxMod.SFX_SPRAY = Isaac.GetSoundIdByName("(TOYBOX) Spray")

ToyboxMod.SFX_SLIDE_WHISTLE = Isaac.GetSoundIdByName("(TOYBOX) Slide Whistle")
ToyboxMod.SFX_MR_KRABS_WALK = Isaac.GetSoundIdByName("(TOYBOX) Mr Krabs Walk")

for name, soundEffect in pairs(ToyboxMod) do
    if(string.sub(name, 1,4)=="SFX_") then
        sfx:Preload(soundEffect)
    end
end
--#endregion
--#region BACKDROP

ToyboxMod.BACKDROP_GRAVEYARD = Isaac.GetBackdropIdByName("Graveyard")
ToyboxMod.BACKDROP_TEMPLE = Isaac.GetBackdropIdByName("Temple")
ToyboxMod.BACKDROP_DEATH_SACRIFICE = Isaac.GetBackdropIdByName("Death Sacrifice")
--#endregion
--#region GIANTBOOK

ToyboxMod.GIANTBOOK_BIG_BANG = Isaac.GetGiantBookIdByName("Big Bang (TOYBOX)")
ToyboxMod.GIANTBOOK_MOMS_PHOTOBOOK = Isaac.GetGiantBookIdByName("Mom's Photobook")
ToyboxMod.GIANTBOOK_THE_ANGEL = Isaac.GetGiantBookIdByName("The Angel")
--#endregion
--#region SHADER

ToyboxMod.SHADER_EMPTY = "ToyboxEmptyShader" ---@type ShaderType
ToyboxMod.SHADER_BLOOM = "ToyboxBloomShader" ---@type ShaderType
ToyboxMod.SHADER_ASCENSION = "ToyboxAscensionShader" ---@type ShaderType
--#endregion

ToyboxMod.TEARFLAGS = {
    MUSICAL = TearFlagsLib.RegisterTearFlag("TOYBOX_MUSICAL"),
    PLASMA = TearFlagsLib.RegisterTearFlag("TOYBOX_PLASMA"),
    LANGTON = TearFlagsLib.RegisterTearFlag("TOYBOX_LANGTON"),
    BLOODY = TearFlagsLib.RegisterTearFlag("TOYBOX_BLOODY"),

    BOMB_QUAKE = TearFlagsLib.RegisterTearFlag("TOYBOX_BOMB_QUAKE"),
    BOMB_BLESSED = TearFlagsLib.RegisterTearFlag("TOYBOX_BOMB_BLESSED"),
}
ToyboxMod.TEAR_COPYING_FAMILIARS = {
    [FamiliarVariant.INCUBUS] = true,
    [FamiliarVariant.SPRINKLER] = true,
    [FamiliarVariant.TWISTED_BABY] = true,
    [FamiliarVariant.BLOOD_BABY] = true,
    [FamiliarVariant.UMBILICAL_BABY] = true,
    [FamiliarVariant.CAINS_OTHER_EYE] = true,
    --[FamiliarVariant.FATES_REWARD] = true,
}
ToyboxMod.RED_HEART_SUBTYPES = {
    [HeartSubType.HEART_HALF] = true,
    [HeartSubType.HEART_FULL] = true,
    [HeartSubType.HEART_DOUBLEPACK] = true,
    [HeartSubType.HEART_SCARED] = true,

    --[HeartSubType.HEART_ROTTEN] = true,
    --[HeartSubType.HEART_BLENDED] = true,
}
ToyboxMod.PARASITE_TRINKETS = {
    [ToyboxMod.TRINKET_NEMATODE] = true,
    [ToyboxMod.TRINKET_LIL_GRUB] = true,
    [ToyboxMod.TRINKET_CANDIDA] = true,
    [ToyboxMod.TRINKET_DEMODEX] = true,
    [ToyboxMod.TRINKET_LADYBUG] = true,

    [TrinketType.TRINKET_TICK] = false,
}

ToyboxMod.CHEST_PICKER = WeightedOutcomePicker()
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_CHEST,        1)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_LOCKEDCHEST,  1)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_REDCHEST,     0.5)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_BOMBCHEST,    0.5)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_ETERNALCHEST, 0.1)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_SPIKEDCHEST,  0.1)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_MIMICCHEST,   0.1)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_WOODENCHEST,  0.5)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_MEGACHEST,    0.01)
    ToyboxMod.CHEST_PICKER:AddOutcomeFloat(PickupVariant.PICKUP_HAUNTEDCHEST, 0.1)


---@type CallbackID[]
ToyboxMod.CUSTOM_CALLBACKS = {
    PRE_ATLAS_LOSE_MANTLE = "TOYBOX_PRE_ATLAS_LOSE_MANTLE",
    POST_ATLAS_LOSE_MANTLE = "TOYBOX_POST_ATLAS_LOSE_MANTLE",
    POST_ATLAS_ADD_MANTLE = "TOYBOX_POST_ATLAS_ADD_MANTLE",
    POST_PLAYER_BOMB_DETONATE = "TOYBOX_POST_PLAYER_BOMB_DETONATE",
    POST_PLAYER_ATTACK = "TOYBOX_POST_PLAYER_ATTACK",
    USE_THROWABLE_ACTIVE = "TOYBOX_USE_THROWABLE_ACTIVE",
    POST_PLAYER_DOUBLE_TAP = "TOYBOX_POST_PLAYER_DOUBLE_TAP",
    USE_ACTIVE_ITEM = "TOYBOX_USE_ACTIVE_ITEM",
    POST_FIRE_TEAR = "TOYBOX_POST_FIRE_TEAR",
    RESET_LUDOVICO_DATA = "TOYBOX_RESET_LUDOVICO_DATA",
    POST_FIRE_BOMB = "TOYBOX_POST_FIRE_BOMB",
    COPY_SCATTER_BOMB_DATA = "TOYBOX_COPY_SCATTER_BOMB_DATA",
    POST_PLAYER_EXTRA_DMG = "TOYBOX_POST_PLAYER_EXTRA_DMG",
    POST_FIRE_AQUARIUS = "TOYBOX_POST_FIRE_AQUARIUS",
    POST_FIRE_ROCKET = "TOYBOX_POST_FIRE_ROCKET",
    ROCKET_COPY_TARGET_DATA = "TOYBOX_ROCKET_COPY_TARGET_DATA",
    POST_ROCKET_EXPLODE = "TOYBOX_POST_ROCKET_EXPLODE",
    POST_NEW_ROOM = "TOYBOX_POST_NEW_ROOM",
    POST_ROOM_CLEAR = "TOYBOX_POST_ROOM_CLEAR",
    POST_CUSTOM_CHAMPION_DEATH = "TOYBOX_POST_CUSTOM_CHAMPION_DEATH",
    POST_CUSTOM_CHAMPION_INIT = "TOYBOX_POST_CUSTOM_CHAMPION_INIT",
    POST_POOP_DAMAGE = "TOYBOX_POST_POOP_DAMAGE",
    POOP_SPAWN_DROP = "TOYBOX_POOP_SPAWN_DROP",
    POST_GRID_INIT = "TOYBOX_POST_GRID_INIT",
    POST_POOP_INIT = "TOYBOX_POST_POOP_INIT",
    POST_RENDER_MINIMAP_ROOM = "TOYBOX_POST_RENDER_MINIMAP_ROOM",
    POST_NEW_ROOM_TINTED = "TOYBOX_POST_NEW_ROOM_TINTED",
    POST_GET_CUSTOM_TRANSFORMATION = "TOYBOX_POST_GET_CUSTOM_TRANSFORMATION",
    POST_LOSE_CUSTOM_TRANSFORMATION = "TOYBOX_POST_LOSE_CUSTOM_TRANSFORMATION",
    APPLY_CUSTOM_TEARFLAG = "TOYBOX_APPLY_CUSTOM_TEARFLAG",
    ADD_PEDESTAL_TRINKETS = "TOYBOX_ADD_PEDESTAL_TRINKETS",
}

ToyboxMod.DAMAGE_TYPE = {
    KNIFE = 1<<0,
    LASER = 1<<1,
    DARK_ARTS = 1<<2,
    ABYSS_LOCUST = 1<<3,
    BOMB = 1<<4,
    AQUARIUS = 1<<5,
    ROCKET = 1<<6,
    TEAR = 1<<7,
}

ToyboxMod.COMBAT_ACTIVES = {
    [CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = true,
    [CollectibleType.COLLECTIBLE_NECRONOMICON] = true,
    [CollectibleType.COLLECTIBLE_MR_BOOM] = true,
    [CollectibleType.COLLECTIBLE_TAMMYS_HEAD] = true,
    [CollectibleType.COLLECTIBLE_MOMS_BRA] = true,
    [CollectibleType.COLLECTIBLE_KAMIKAZE] = true,
    [CollectibleType.COLLECTIBLE_MOMS_PAD] = true,
    [CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD] = true,
    [CollectibleType.COLLECTIBLE_DOCTORS_REMOTE] = true,
    [CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = true,
    [CollectibleType.COLLECTIBLE_LEMON_MISHAP] = true,
    [CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = true,
    [CollectibleType.COLLECTIBLE_HOURGLASS] = true,
    [CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = true,
    [CollectibleType.COLLECTIBLE_THE_NAIL] = true,
    [CollectibleType.COLLECTIBLE_MONSTROS_TOOTH] = true,
    [CollectibleType.COLLECTIBLE_GAMEKID] = true,
    [CollectibleType.COLLECTIBLE_PINKING_SHEARS] = true,
    [CollectibleType.COLLECTIBLE_BEAN] = true,
    [CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = true,
    [CollectibleType.COLLECTIBLE_RAZOR_BLADE] = true,
    [CollectibleType.COLLECTIBLE_PONY] = true,
    [CollectibleType.COLLECTIBLE_BEST_FRIEND] = true,
    [CollectibleType.COLLECTIBLE_GUPPYS_HEAD] = true,
    [CollectibleType.COLLECTIBLE_CRACK_THE_SKY] = true,
    [CollectibleType.COLLECTIBLE_CANDLE] = true,
    [CollectibleType.COLLECTIBLE_SPIDER_BUTT] = true,
    [CollectibleType.COLLECTIBLE_WHITE_PONY] = true,
    [CollectibleType.COLLECTIBLE_BLOOD_RIGHTS] = true,
    [CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = true,
    [CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS] = true,
    [CollectibleType.COLLECTIBLE_RED_CANDLE] = true,
    [CollectibleType.COLLECTIBLE_FLUSH] = true,
    [CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS] = true,
    [CollectibleType.COLLECTIBLE_BUTTER_BEAN] = true,
    [CollectibleType.COLLECTIBLE_MAGIC_FINGERS] = true,
    [CollectibleType.COLLECTIBLE_ISAACS_TEARS] = true,
    [CollectibleType.COLLECTIBLE_SCISSORS] = true,
    [CollectibleType.COLLECTIBLE_BOOMERANG] = true,
    [CollectibleType.COLLECTIBLE_MEGA_BEAN] = true,
    [CollectibleType.COLLECTIBLE_GLASS_CANNON] = true,
    [CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS] = true,
    [CollectibleType.COLLECTIBLE_FRIEND_BALL] = true,
    [CollectibleType.COLLECTIBLE_TEAR_DETONATOR] = true,
    [CollectibleType.COLLECTIBLE_KIDNEY_BEAN] = true,
    [CollectibleType.COLLECTIBLE_MINE_CRAFTER] = true,
    [CollectibleType.COLLECTIBLE_JAR_OF_FLIES] = true,
    [CollectibleType.COLLECTIBLE_MEGA_BLAST] = true,
    [CollectibleType.COLLECTIBLE_PAUSE] = true,
    [CollectibleType.COLLECTIBLE_WAIT_WHAT] = true,
    [CollectibleType.COLLECTIBLE_BROWN_NUGGET] = true,
    [CollectibleType.COLLECTIBLE_SHARP_STRAW] = true,
    [CollectibleType.COLLECTIBLE_DELIRIOUS] = true,
    [CollectibleType.COLLECTIBLE_BLACK_HOLE] = true,
    [CollectibleType.COLLECTIBLE_SPRINKLER] = true,
    [CollectibleType.COLLECTIBLE_TELEKINESIS] = true,
    [CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = true,
    [CollectibleType.COLLECTIBLE_GOLDEN_RAZOR] = true,
    [CollectibleType.COLLECTIBLE_SULFUR] = true,
    [CollectibleType.COLLECTIBLE_FREE_LEMONADE] = true,
    [CollectibleType.COLLECTIBLE_WAVY_CAP] = true,
    [CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = true,
    [CollectibleType.COLLECTIBLE_SCOOPER] = true,
    [CollectibleType.COLLECTIBLE_LARYNX] = true,
    [CollectibleType.COLLECTIBLE_SHARP_KEY] = true,
    [CollectibleType.COLLECTIBLE_MEGA_MUSH] = true,
    [CollectibleType.COLLECTIBLE_MEAT_CLEAVER] = true,
    [CollectibleType.COLLECTIBLE_ERASER] = true,
    [CollectibleType.COLLECTIBLE_URN_OF_SOULS] = true,
    [CollectibleType.COLLECTIBLE_PLUM_FLUTE] = true,
    [CollectibleType.COLLECTIBLE_VADE_RETRO] = true,
    [CollectibleType.COLLECTIBLE_SPIN_TO_WIN] = true,
    [CollectibleType.COLLECTIBLE_JAR_OF_WISPS] = true,
    [CollectibleType.COLLECTIBLE_FRIEND_FINDER] = true,
    [CollectibleType.COLLECTIBLE_BERSERK] = true,
    [CollectibleType.COLLECTIBLE_DARK_ARTS] = true,
    [CollectibleType.COLLECTIBLE_SUPLEX] = true,
    [CollectibleType.COLLECTIBLE_ANIMA_SOLA] = true,
    [CollectibleType.COLLECTIBLE_GELLO] = true,
    [CollectibleType.COLLECTIBLE_DECAP_ATTACK] = true,
}
for key, id in pairs(ToyboxMod) do
    if(string.find(key, "COLLECTIBLE_")) then
        local conf = Isaac.GetItemConfig():GetCollectible(id)
        if(conf and conf:HasCustomTag("combat")) then
            ToyboxMod.COMBAT_ACTIVES[id] = true
        end
    end
end

ToyboxMod.WEAPONFLAGS_NO_COLOR = {
    [TearFlagsLib.WeaponFlag.LASER] = true,
    [TearFlagsLib.WeaponFlag.KNIFE] = true,
    [TearFlagsLib.WeaponFlag.BRIMSTONE_BALL] = true,
    [TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER] = true,
    [TearFlagsLib.WeaponFlag.UMBILICAL_WHIP] = true,
}

--#region ATLAS

ToyboxMod.MANTLE_DATA = {
    NONE = {
        ID = 0,
        HP = 0,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_ROCK,
        SHARD_COLOR = Color(0,0,0,0),
        ANIM = "Empty",
        HURT_SFX = 0,
        BREAK_SFX = 0,
    },
    DEFAULT = {
        ID = 1,
        HP = 2,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_ROCK,
        SHARD_COLOR = Color(153/255,139/255,136/255,1),
        ANIM = "RockMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_ROCKBREAK,
                
        ATLAS_DESC = "Useless",
        REG_DESC = "Rock and roll",

        TRANSF_NAME = "Rock!",
        TRANSF_DESC = "Useless",

        WEIGHT = 1,
    },
    POOP = {
        ID = 2,
        HP = 2,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_POOP,
        SHARD_COLOR = Color(124/255,86/255,52/255,1),
        ANIM = "PoopMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_ROCKBREAK,
                
        ATLAS_DESC = "Flies on room clear + more poops",
        REG_DESC = "On-command diarrhea",

        TRANSF_NAME = "Poop!",
        TRANSF_DESC = "Poop healing + better poop drops",
        
        WEIGHT = 1,
    },
    BONE = {
        ID = 3,
        HP = 3,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_BONE,
        SHARD_COLOR = Color(95/255,112/255,121/255,1),
        ANIM = "BoneMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_ROCKBREAK,
                
        ATLAS_DESC = "Bones on kill + bones when lost",
        REG_DESC = "Bone buddy + bones on kill",

        TRANSF_NAME = "Bone!",
        TRANSF_DESC = "Panic = sorrow",
        
        WEIGHT = 1,
    },
    DARK = {
        ID = 4,
        HP = 2,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_DARK,
        SHARD_COLOR = Color(59/255,59/255,59/255,1),
        ANIM = "DarkMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_ROCKBREAK,

        ATLAS_DESC = "DMG up + room damage when lost",
        REG_DESC = "Mass floor damage",

        TRANSF_NAME = "Dark!",
        TRANSF_DESC = "Dark aura",
        
        WEIGHT = 1,
    },
    HOLY = {
        ID = 5,
        HP = 2,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_HOLY,
        FLIGHT_COSTUME = Isaac.GetCostumeIdByPath("gfx_tb/characters/costume_atlas_wings.anm2"),
        SHARD_COLOR = Color(190/255,190/255,190/255,1),
        ANIM = "HolyMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_ROCKBREAK,
                
        ATLAS_DESC = "Range up + sacred tears",
        REG_DESC = "Eternity + \"god\" tears",

        TRANSF_NAME = "Holy!",
        TRANSF_DESC = "Flight + holy aura",
        
        WEIGHT = 1,
    },
    SALT = {
        ID = 6,
        HP = 2,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_SALT,
        CHARIOT_COSTUME = Isaac.GetCostumeIdByPath("gfx_tb/characters/costume_atlas_salt.anm2"),
        SHARD_COLOR = Color(1,1,1,1),
        ANIM = "SaltMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_ROCKBREAK,
                
        ATLAS_DESC = "Tears up",
        REG_DESC = "Temporary sorrow",

        TRANSF_NAME = "Salt!",
        TRANSF_DESC = "On-command salt chariot",
        
        WEIGHT = 1,
    },
    GLASS = {
        ID = 7,
        HP = 1,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_GLASS,
        SHARD_COLOR = Color(1,1,1,1),
        ANIM = "GlassMantle",
        HURT_SFX = 0,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_GLASSBREAK,
                
        ATLAS_DESC = "DMG + shotspeed up + brittle protection",
        REG_DESC = "DMG up + fragility up",

        TRANSF_NAME = "Glass!",
        TRANSF_DESC = "DMG up + brittler protection",
        
        WEIGHT = 1,
    },
    METAL = {
        ID = 8,
        HP = 3,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_METAL,
        SHARD_COLOR = Color(147/255,147/255,147/255,1),
        ANIM = "MetalMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_METALBREAK,
                
        ATLAS_DESC = "Speed down + defense up",
        REG_DESC = "Tough skin",

        TRANSF_NAME = "Metal!",
        TRANSF_DESC = "Better defense",
        
        WEIGHT = 1,
    },
    GOLD = {
        ID = 9,
        HP = 2,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_GOLD,
        SHARD_COLOR = Color(205/255,181/255,60/255,1),
        ANIM = "GoldMantle",
        HURT_SFX = ToyboxMod.SFX_ATLASA_ROCKCRACK,
        BREAK_SFX = ToyboxMod.SFX_ATLASA_METALBREAK,
                
        ATLAS_DESC = "Luck up + gild when lost",
        REG_DESC = "Microtransactions",

        TRANSF_NAME = "Gold!",
        TRANSF_DESC = "Penny tears",
        
        WEIGHT = 1,
    },

    TAR = {
        ID = 1024,
        HP = 0,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_ROCK,
        SHARD_COLOR = Color(0,0,0,1),
        ANIM = "TarMantle",
        HURT_SFX = 0,
        BREAK_SFX = 0,
    },
    UNKNOWN = {
        ID = 1000,
        HP = 0,
        CONSUMABLE_SUBTYPE = ToyboxMod.CARD_MANTLE_ROCK,
        SHARD_COLOR = Color(0,0,0,0),
        ANIM = "Unknown",
        HURT_SFX = 0,
        BREAK_SFX = 0,
    }
}

ToyboxMod.MANTLE_ID_TO_NAME = {
    [ToyboxMod.MANTLE_DATA.NONE.ID] = "NONE",
    [ToyboxMod.MANTLE_DATA.DEFAULT.ID] = "DEFAULT",
    [ToyboxMod.MANTLE_DATA.POOP.ID] = "POOP",
    [ToyboxMod.MANTLE_DATA.BONE.ID] = "BONE",
    [ToyboxMod.MANTLE_DATA.DARK.ID] = "DARK",
    [ToyboxMod.MANTLE_DATA.HOLY.ID] = "HOLY",
    [ToyboxMod.MANTLE_DATA.SALT.ID] = "SALT",
    [ToyboxMod.MANTLE_DATA.GLASS.ID] = "GLASS",
    [ToyboxMod.MANTLE_DATA.METAL.ID] = "METAL",
    [ToyboxMod.MANTLE_DATA.GOLD.ID] = "GOLD",
    [ToyboxMod.MANTLE_DATA.TAR.ID] = "TAR",
}

-- PICKING MANTLES ENUMS
ToyboxMod.SAME_MANTLE_BIAS = {
    [0]=1,
    [1]=7.5,
    [2]=25,
    [3]=1,
}
ToyboxMod.MANTLE_PICKER = {
    {OUTCOME=ToyboxMod.MANTLE_DATA.DEFAULT.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.POOP.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.BONE.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.DARK.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.HOLY.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.SALT.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.GLASS.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.METAL.ID, WEIGHT=1},
    {OUTCOME=ToyboxMod.MANTLE_DATA.GOLD.ID, WEIGHT=1},
}

-- MANTLE HP RENDER ENUMS
ToyboxMod.MANTLE_SHARD_GRAVITY = 7

--#endregion

ToyboxMod.CUSTOM_CHAMPIONS = {
    FEAR = {
        Idx = 1,
        Color = Color(0.8,0.8,0.8,1,0.1,0,0.1,1,0,1,1),
        HPMult = 1.5,
    },
    ETERNAL = {
        Idx = 2,
        Color = Color(0.8,0.8,0.8,1,0.1,0,0.1,1,0,1,1),
        HPMult = 1,
    },
    DROWNED = {
        Idx = 3,
        Color = Color(0.5,0.9,1,1,0,0,0,0,1,1,1),
        HPMult = 2,
    },
    SPIDERS = {
        Idx = 4,
        Color = Color(0.8,0.8,0.8,1,0.1,0,0.1,1,0,1,1),
        HPMult = 1,
    },
    GOLDEN = {
        Idx = 5,
        Color = Color(0.8,0.8,0.8,1,0.1,0,0.1,1,0,1,1),
        HPMult = 1,
    },
    JELLY = {
        Idx = 6,
        Color = Color(1,1.3,1,1,0,0,0,0.3,1,0,1),
        HPMult = 2,
    },
}
ToyboxMod.CUSTOM_CHAMPION_IDX_TO_NAME = {
    "FEAR",
    "ETERNAL",
    "DROWNED",
    "SPIDERS",
    "GOLDEN",
    "JELLY",
}

ToyboxMod.CUSTOM_CHAMPION_PICKER = WeightedOutcomePicker()
ToyboxMod.CUSTOM_CHAMPION_PICKER:AddOutcomeFloat(1, 100, 1000)
ToyboxMod.CUSTOM_CHAMPION_PICKER:AddOutcomeFloat(2, 1, 1000)
ToyboxMod.CUSTOM_CHAMPION_PICKER:AddOutcomeFloat(3, 100, 1000)
ToyboxMod.CUSTOM_CHAMPION_PICKER:AddOutcomeFloat(4, 1, 1000)
ToyboxMod.CUSTOM_CHAMPION_PICKER:AddOutcomeFloat(5, 1, 1000)
ToyboxMod.CUSTOM_CHAMPION_PICKER:AddOutcomeFloat(6, 100, 1000)