
local enums = require("scripts_toybox.modcompat.eid.stored")

--- ITEMS ---

enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_COCONUT_OIL,
    Name = "Coconut Oil",
    Description = {
        "\1 +0.5 Tears",
        "\2 -0.25 Speed",
        "Your friction is decreased, effectively increasing your movespeed",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CONDENSED_MILK,
    Name = "Condensed Milk",
    Description = {
        "\1 x1.2 Firerate",
        "Your {{Damage}} damage cannot go above or below 3.5, instead all damage modifiers get funneled into your {{Tears}} tears",
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LIBRA)
            end,
            ToModify = {
                "{{Collectible304}} Stats are distributed more towards tears and not at all towards damage",
            },
        },
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM)
            end,
            ToModify = {
                "{{Collectible562}} Damage remains unchangeable",
            },
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GOAT_MILK,
    Name = "Goat Milk",
    Description = {
        "\1 +0.5 Tears",
        "Everytime you fire, your fire delay is randomized",
    },
    StackModifiers = {
        {
            ToModify = {
                "Fire delay randomization is more extreme",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_NOSE_CANDY,
    Name = "Nose Candy",
    Description = {
        "At the start of every floor:",
        "\1 +0.2 Speed",
        "\1 Increase to a random non-Speed stat",
        "\2 Decrease to a random non-Speed stat",
    },
    StackModifiers = {
        {
            ToModify = {
                "All stat increases/decreases from this item are amplified",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LION_SKULL,
    Name = "Lion Skull",
    Description = {
        "\1 +0.15 Damage on room clear",
        "\2 On hit, -0.15 Damage for each room cleared since the last time you got hit",
        "The damage down will wear off as you clear rooms",
    },
    StackModifiers = {
        {
            ToModify = {
                "+/-0.15 Damage granted per stack",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CARAMEL_APPLE,
    Name = "Caramel Apple",
    Description = {
        "\1 +1 Health",
        "{{HalfHeart}} Turns half Red Hearts and half Soul Hearts into their full counterparts",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PAINKILLERS,
    Name = "Painkillers",
    Description = {
        "\2 Invincibility frames after taking damage are 90% shorter",
        "\1 15% chance to block damage and get 2.5 seconds of invincibility",
        "{{Luck}} 50% chance at 30 luck",
    },
    StackModifiers = {
        {
            ToModify = {
                "Invincibility frames are completely removed",
                "+10% block chance for every copy of the item, maximum chance is capped at 50%",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_TECH_IX,
    Name = "Laser Brain",
    Description = {
        "While firing, you get a green laser ring around you",
        "The ring slowly grows in size and damage as you fire, and dissipates when you stop firing",
    },
    StackModifiers = {
        {
            ToModify = {
                "+50% laser damage",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FATAL_SIGNAL,
    Name = "Fatal Signal",
    Description = {
        "\1 +1 Health",
        "{{SoulHeart}} +1 Soul Heart",
        "Items that modify your Red, Soul or Black Hearts are rerolled",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PEPPER_X,
    Name = "Pepper X",
    Description = {
        "5% chance to shoot out a spectral stream of flames that block enemy shots and deal contact damage",
        "{{Luck}} 50% chance at 20 luck",
        "The stream of flames lasts for 1 second and can be controlled by shooting/movement inputs",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_METEOR_SHOWER,
    Name = "Meteor Shower",
    Description = {
        "In active rooms, every 2-4 seconds a meteor falls from the sky",
        "{{Burning}} When landing, the meteor explodes, dealing 35 damage and burning nearby enemies",
        "!!! The meteors can also hurt you",
    },
    StackModifiers = {
        {
            ToModify = {
                "Meteors fall more often",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLESSED_RING,
    Name = "Blessed Ring",
    Description = {
        "In active rooms, every 7 seconds 2 random enemies are struck by a beam of light",
    },
    StackModifiers = {
        {
            ToModify = {
                "Spawns beams twice as fast",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_4_4,
    Name = "4 4",
    Description = {
        "\1 +0.5 Tears",
        "{{Confusion}} Confuses enemies in a small radius around Isaac",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_EYESTRAIN,
    Name = "Eyestrain",
    Description = {
        "\1 +0.7 Tears",
        "\1 +1 Luck",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED,
    Name = "Sigil of Greed",
    Description = {
        "{{Chargeable}} Firing for 6.66 seconds charges up a golden sigil",
        "Upon release, the sigil expands and deals 66.6 damage to all nearby enemies",
        "{{Collectible202}} 25% chance for the sigil to petrify enemies and turn them to gold for 2 seconds",
        "{{Coin}} Killing a golden enemy spawns coins"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_EVIL_ROCK,
    Name = "Evil Rock",
    Description = {
        "Tinted rocks are darker and easier to see",
        "Drops from tinted rocks are changed:",
        "{{SoulHeart}} Soul Hearts > Black Hearts",
        "{{Key}} Keys > Troll Bombs/Pills",
        "{{Chest}} Chests > Red Chests",
        "{{Collectible90}} The Small Rock > {{ColorYellow}}???{{CR}}",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ONYX,
    Name = "Onyx",
    Description = {
        "\1 +1.2 Damage",
        "\1 +0.5 Tears",
        "\1 +0.2 Speed",
        "{{BlackHeart}} +1 Black Heart",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DADS_PRESCRIPTION,
    Name = "Dad's Prescription",
    Description = {
        "{{Pill}} Entering a special room spawns a pill",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_HORSE_TRANQUILIZER,
    Name = "Horse Tranquilizer",
    Description = {
        enums.CONSTANTS.Icon_HorsePill .. " Spawns a horse pill",
        "Picking up an item uses a random horse pill",
        "Higher quality items make you use worse pills",
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SILK_BAG,
    Name = "Silk Bag",
    Description = {
        "{{SoulHeart}} +1 Soul Heart",
        "Doubles invincibility frames",
        "Converts invincibility frames into a protective shield"
    },
    StackModifiers = {
        {
            ToModify = {
                "Further increases invincibility frames",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ROCK_CANDY,
    Name = "Rock Candy",
    Description = {
        "\1 +0.7 Damage",
        "\1 +0.16 Shotspeed",
        enums.CONSTANTS.Icon_CardMantleRock .. " Spawns a random Mantle consumable",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MISSING_PAGE_3,
    Name = "Missing Page 3",
    Description = {
        "{{DeathMark}} A random enemy every room will become a Skull champion",
        --"{{Blank}} {{ColorGray}}Skull champions have 2x health and trigger {{Collectible35}} The Necronomicon effect on death{{CR}}",
        "{{BlackHeart}} Skull champions have a 16% chance to drop a black heart on death",
    },
    StackModifiers = {
        {
            ToModify = {
                "Skull champions spawned by this item don't have increased health",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GLASS_VESSEL,
    Name = "Glass Vessel",
    Description = {
        "Grants a glass shield that negates one hit",
        "{{Heart}} When the shield is broken, you can recharge it by picking up a red heart, which will consume the heart in the process",
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            end,
            ToModify = {
                "{{Collectible"..CollectibleType.COLLECTIBLE_HOLY_MANTLE.."}} This blocks damage before Holy Mantle",
            }
        },
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER) or PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B)
            end,
            ToModify = {
                "{{Player14}} With coin health, picking up a coin recharges the shield",
            }
        },
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BONE_BOY,
    Name = "Bone Boy",
    Description = {
        "{{DeathMark}} Grants a Bony familiar that loves to party!",
        "He chases nearby enemies and throws bones at them",
        "He blocks projectiles and can die after 5 hits, turning into an immobile pile of bones that revives after 15 seconds"
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD)
            end,
            ToModify = {
                "{{Collectible545}} On use, Book of the Dead revives any dead Bony familiars",
            },
        },
        {
            Condition = function(descObj)
                return false--PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_HALLOWED_GROUND)
            end,
            ToModify = {
                "{{Collectible543}} When the Bony enters a Hallowed Ground aura, it levels up, gaining more HP and firing arced bones that leave behind flames on impact",
                "{{Collectible543}} On death, the Bony levels back down into a normal bony",
            },
        },
    },
    BFFSModifiers = {
        {
            ToModify = {
                "Grants a Black Bony that fires a barrage of 3 bones less frequently",
                "On death, the Black Bony creates an explosion that can't hurt you"
            },
        },
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_STEEL_SOUL,
    Name = "Steel Soul",
    Description = {
        "{{SoulHeart}} +1 Soul Heart",
        "Any full Soul/Black Hearts gained have a metal shield that can block 1 additional damage",
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BOBS_HEART,
    Name = "Bob's Heart",
    Description = {
        "Grants immunity to explosions",
        "Taking damage spawns a cloud of poisonous gas and makes you explode",
        "The explosion inherits bomb effects"
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CLOWN_PHD,
    Name = "Clown PHD",
    Description = {
        "{{Pill}} When used, pills have a random effect",
        "Converts negative pills into positive ones",
        "Pills can no longer be identified",
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GIANT_CAPSULE,
    Name = "Giant Capsule",
    Description = {
        "Using a consumable spawns a virus familiar that lasts 60 seconds",
        "Viruses follow you and shoot tears with different effects based on their color",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LOVE_LETTER,
    Name = "Love Letter",
    Description = {
        "{{Charm}} 10% chance to shoot charming tears",
        "Charmed enemies take 50% more damage",
        "Charmed enemies and their projectiles cannot damage you",
    },
    StackModifiers = {
        {
            ToModify = {
                "+25% extra damage to charmed enemies",
                "+5% chance to charm enemies",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_QUAKE_BOMBS,
    Name = "Quake Bombs",
    Description = {
        "{{Bomb}} +5 Bombs",
        "Bombs explode additional connected rocks up to 3 tiles away",
        "Rocks destroyed by your bombs have doubled drops"
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ATHEISM,
    Name = "Atheism",
    Description = {
        "{{AngelDevilChance}} +15% Devil/Angel deal chance",
        "{{AngelDevilChance}} Devil/Angel deals are replaced by {{TreasureRoom}} Treasure rooms which contain a choice between 2 items",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MAYONAISE,
    Name = "A Spoonful of Mayonnaise",
    Description = {
        "\1 +0.15 Shotspeed",
        "{{EternalHeart}} +1 Eternal Heart",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_AWESOME_FRUIT,
    Name = "Awesome Fruit",
    Description = {
        "\1 +1 Health",
        "{{HealingRed}} Heals 1 heart",
        "\1 +1 progress for all Transformations",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_JONAS_MASK,
    Name = "Jonas' Mask",
    Description = {
        "Gives 1 of 3 shadow familiars:",
        "{{Blank}} \7 Fly that bounces around the room and screams at enemies",
        "{{Blank}} \7 Spider that crawls around and pounces on enemies",
        "{{Blank}} \7 Urchin that orbits you and blocks projectiles",
        "Every floor the familiar is rerolled"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SALTPETER,
    Name = "Saltpeter",
    Description = {
        "\1 +1.5 Range",
        "\2 x0.7 Range",
        "When enemies take damage, nearby enemies take 50% of that damage",
        "The radius of this effect scales with your range"
    },
    StackModifiers = {
        {
            ToModify = {
                "+40% AOE damage",
            },
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DR_BUM,
    Name = "Dr. Bum",
    Description = {
        "{{Card}} Picks up cards, runes, and objects and turns them into {{Pill}} pills",
        "Pills spawned by this are more likely to be positive or neutral"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PLASMA_GLOBE,
    Name = "Plasma Globe",
    Description = {
        "\2 -0.2 Shotspeed",
        "While flying, your tears fire electric lasers at nearby enemies",
        "The lasers deal 25% of the tear's damage",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CURSED_EULOGY,
    Name = "Cursed Eulogy",
    Description = {
        "{{BlackHeart}} +1 Black Heart",
        "\2 Items have a 20% chance to spawn as a Curse Room or Red Chest item",
    },
    StackModifiers = {
        {
            ToModify = {
                "+20% chance to replace items",
            },
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLESSED_BOMBS,
    Name = "Blessed Bombs",
    Description = {
        "{{Bomb}} +5 Bombs",
        "Bombs take twice as long to explode",
        "While fused, bombs have a holy aura that grants:",
        "\1 x3 Tears",
        "\1 x2 Damage",
        "Homing tears",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_HEMORRHAGE,
    Name = "Haemorrhage",
    Description = {
        "{{EmptyBoneHeart}} +1 Bone Heart",
        "{{EmptyBoneHeart}} When a heart container is emptied, removes it and grants a Bone Heart",
        "Taking damage gives a large fading tears up",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FISH,
    Name = "Fish",
    Description = {
        "\1 Doubles all blue fly/spider spawns",
        "Taking damage spawns 1 blue fly and blue spider",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BOBS_THESIS,
    Name = "Bob's Thesis",
    Description = {
        "All item spawns are replaced by {{Collectible"..ToyboxMod.COLLECTIBLE_PLACEHOLDER.."}} Placeholder",
        --"{{Blank}} {{ColorGray}}Placeholder gives an all stats up, but turns into a random item at the start of next floor{{CR}}",
        "Placeholder gives an all stats up, but turns into a random item at the start of next floor",
    },
    StackModifiers = {
        {
            ToModify = {
                "Placeholder's stat-ups are doubled",
                "Placeholder gives better items",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PLACEHOLDER,
    Name = "Placeholder",
    Description = {
        "\1 +0.15 Speed",
        "\1 +0.5 Tears",
        "\1 +0.5 Damage",
        "\1 +1 Range",
        "\1 +0.1 Shotspeed",
        "\1 +1 Luck",
        "At the start of next floor, will turn into an item from the itempool it was obtained froom"
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = function(descObj)
                local lastPool = ToyboxMod.GAME:GetItemPool():GetLastPool()
                local poolName = EID:getDescriptionEntry("itemPoolNames")[lastPool]
                local poolIcon = (EID.ItemPoolTypeToMarkup[lastPool] or "{{ItemPoolTreasure}}")

                return string.gsub(descObj.Description, "itempool it was obtained froom", poolIcon.." {{ColorSilver}}"..poolName.."{{CR}} itempool")
            end
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PLIERS,
    Name = "Pliers",
    Description = {
        "\1 +1 Fire rate for the room",
        "!!! Deals half a heart of damage to Isaac",
        "{{Heart}} Removes Red Hearts first",
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            IgnoreMarkup = true,
            ToModify = {
                "{{Collectible356}} No effect for Car Battery"
            }
        },
    },
    WispProperties = {
        Layer = 1,
        Amount = 1,
        HP = 6,
        Damage = 2,
        Description = {
            "Fires twice as often",
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLOOD_RITUAL,
    Name = "Blood Ritual",
    Description = {
        "Spawns 3 {{DevilChanceSmall}} evil familiars for the room that orbit around you",
        "Additional uses in a room only spawn 1 familiar",
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 {{DevilChanceSmall}} evil familiars", "5 {{DevilChanceSmall}} evil familiars"},
                {"1 familiar", "2 familiars"},
            }
        },
    },
    WispProperties = {
        Layer = 0,
        Amount = 3,
        HP = 1,
        Damage = 3,
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SUNK_COSTS,
    Name = "Sunk Costs",
    Description = {
        "{{Coin}} +5 coins",
        "\1 Pay 5 {{Coin}} coins and get +1 Fire rate for the room",
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            IgnoreMarkup = true,
            ToModify = {
                "{{Collectible356}} No effect for Car Battery"
            }
        },
    },
    WispProperties = {
        Layer = 1,
        Amount = 1,
        HP = 2,
        Damage = 3,
        Description = {
            "Tears have a 15% chance to turn enemies to gold"
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ASCENSION,
    Name = "Ascension",
    Description = {
        "{{Timer}} For the next 3 seconds: gain flight and spectral tears",
        "When time is up, get teleported back to where you used the item and gain 1 second of invincibility",
        "You can end the effect early by using the item again"
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 seconds", "6 seconds"},
            }
        },
    },
    WispProperties = {
        Layer = 2,
        Amount = 1,
        HP = 3,
        Damage = 1,
        Description = {
            "Wisps deal 5x damage while Ascension is active",
            "Wisps disappear on new room",
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GILDED_APPLE,
    Name = "Gilded Apple",
    Description = {
        "{{GoldenHeart}} +1 Golden Heart",
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+1 Golden Heart", "+2 Golden Hearts"},
            }
        },
    },
    WispProperties = {
        Layer = 1,
        Amount = 1,
        HP = 4,
        Damage = 3,
        Description = {
            "When destroyed, drops 1-3 coins and turns nearby enemies to gold"
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PEZ_DISPENSER,
    Name = "Candy Dispenser",
    Description = {
        "{{Card}} Can store up to 3 consumables of any type",
        "Swap between stored consumables by pressing the Drop key ({{ButtonRT}})",
        "When activated, puts the selected stored consumable into your consumable slot",
        
        --"Hold the Map key ({{ButtonSelect}}) to see the frontmost stored consumable's name"
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
            end,
            ToModify = {
                "{{Collectible63}} {{BlinkYellowGreen}}Can store an extra consumable{{CR}}",
            }
        },
    },
    CarBatteryModifiers = {
        {
            ToModify = {
                "Can store an extra consumable",
            }
        },
    },
    WispProperties = {
        Layer = 1,
        Amount = 1,
        HP = 2,
        Damage = 3,
        Description = {
            "Instantly uses stored consumable",
            "Wisp depends on the consumable used: poison tears, variable damage, homing tears, or confusing tears",
            "When destroyed, 33% chance to drop a consumable of the same type as the wisp"
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ALPHABET_BOX,
    Name = "Alphabet Box",
    Description = {
        "Rerolls all items in the room into the next item in alphabetical order",
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"next item", "second next item"},
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_HOSTILE_TAKEOVER,
    Name = "Hostile Takeover",
    Description = {
        "{{Timer}} For the room:",
        "Gives stats that wear off over 10 seconds:",
        "{{Blank}} \1 +0.2 Speed",
        "{{Blank}} \1 +2 Damage",
        "{{Blank}} \1 +1 Tears",
        "On death, enemies spawn puddles of slowing tar",
        "Touching a puddle absorbs it and extends the temporary stats"
    },
    CarBatteryModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.2", "+0.3"},
                {"+2", "+3"},
                {"+1", "+1.5"},
            }
        },
    },
    WispProperties = {
        Layer = 1,
        Amount = 1,
        HP = 3,
        Damage = 3,
        Description = {
            "While {{Collectible"..ToyboxMod.COLLECTIBLE_HOSTILE_TAKEOVER.."}} is active, the wisp's damage and firerate scales with the effect's temporary stats"
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLOODY_WHISTLE,
    Name = "Bloody Whistle",
    Description = {
        "Spawns a pool of blood creep",
        "The creep deals 21 damage per second",
        "The creep spawns blood tears that deal 7 damage"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_D,
    Name = "D",
    Description = {
        "{{Timer}} Adds anywhere from +3 minutes to -3 minutes to the game's timer",
    },
    WispProperties = {
        Layer = 2,
        Amount = 1,
        HP = 2,
        Damage = 3,
        Description = {
            "Rewinds the timer by 15 seconds when destroyed"
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ASTEROID_BELT,
    Name = "Asteroid Belt",
    Description = {
        "Gain 8 orbital rocks that block projectiles and deal 1 damage",
        "Killing an enemy grants another rocks",
        "Clearing a room gives 5 rocks",
        "Can have up to 20 rocks orbiting you",
    },
    StackModifiers = {
        {
            ToModify = {
                "Can have 20 more rocks orbiting you"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BARBED_WIRE,
    Name = "Barbed Wire",
    Description = {
        "When a projectile gets near you, the enemy who fired it takes 5 damage",
    },
    StackModifiers = {
        {
            ToModify = {
                "+5 damage dealt"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_COFFEE_CUP,
    Name = "Coffee Cup",
    Description = {
        "\1 +0.2 Speed",
        "\1 +0.5 Tears",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LAST_BEER,
    Name = "Beer Can",
    Description = {
        "{{Timer}} +10% chance to fire an additional tear for each enemy killed in the room",
        "Guaranteed after 10 kills"
    },
    StackModifiers = {
        {
            ToModify = {
                "+1 additional tear fired"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CONJUNCTIVITIS,
    Name = "Conjunctivitis",
    Description = {
        "\1 +0.5 Damage for the right eye",
        "\2 -0.2 Shotspeed for the right eye",
        "{{Poison}} Tears from right eye have a 25% chance to inflict poison"
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FOOD_STAMPS,
    Name = "Food Stamps",
    Description = {
        "{{Heart}} All future Boss Room items give +1 Health",
        "{{HealingRed}} All future items heal 3 hearts",
    },
    StackModifiers = {
        {
            ToModify = {
                "Boss Room items grant +1 Health and all items heal +3 hearts per stack"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GOLDEN_CALF,
    Name = "Golden Calf",
    Description = {
        "{{Charm}} On death, enemies have a 10% chance to respawn as a friendly copy with halved health",
        "Works on bosses at a much lower chance"
    },
    StackModifiers = {
        {
            ToModify = {
                "Multiple copies have no additional effect"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ART_OF_WAR,
    Name = "Art of War",
    Description = {
        "{{Timer}} Grants a random tear replacement item for the room",
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return true
            end,
            ToModify = function(descObj)
                local s = "Picks items from the following list:#{{Blank}} "
                for _, item in ipairs(ToyboxMod.TEAR_REPLACEMENT_ITEMS) do
                    s = s.."{{Collectible"..item[1].."}} "
                end

                return s
            end,
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BIG_BANG,
    Name = "Big Bang",
    Description = {
        "!!! SINGLE USE !!!",
        "Resets all item pools",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CHOCOLATE_BAR,
    Name = "Chocolate Bar",
    Description = {
        "{{Timer}} +1 Health for the room",
        "Heals friendly enemies for 30 HP"
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return (ToyboxMod.GAME:GetNumPlayers()>1)
            end,
            ToModify = {
                "Heals other players for half a heart",
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_RETROFALL,
    Name = "RETROFALL",
    Description = {
        "{{Collectible105}} All non-timed active items have 6 charges and trigger the effect of The D6",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BRUNCH,
    Name = "Brunch",
    Description = {
        "\1 +1 Heart container",
        "{{RottenHeart}} +1 Rotten Heart",
        "{{Trinket114}} Gives 1 poison locust",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_TOAST,
    Name = "Toast",
    Description = {
        "{{Heart}} +1 Health",
        "{{BlackHeart}} +1 Black Heart",

    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER)
            end,
            ToModify = {
                {"1 heart", "{{BlinkGreen}}2{{CR}} hearts"}
            }
        },
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER)
            end,
            ToModify = {
                "{{Collectible664}} \1 +0.5 Tears",
                "{{Collectible664}} \1 +1 Damage",
                "{{Collectible664}} \1 Temporary +3.6 damage",
                "{{Collectible664}} \2 -0.03 Speed",
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DELIVERY_BOX,
    Name = "Delivery Box",
    Description = {
        "{{Coin}} Pay 3 coins to spawn a {{Bomb}} Bomb or {{Key}} Key",
        "The pickup you have less of is more common",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LUCKY_PEBBLES,
    Name = "Lucky Pebbles",
    Description = {
        "\1 +1 Health",
        "{{HealingRed}} Heals 1 heart",
        "\1 +1 Luck"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MOMS_PHOTOBOOK,
    Name = "Mom's Photobook",
    Description = {
        "{{Confusion}} Confuses all enemies in the room for 7 seconds",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FINGER_TRAP,
    Name = "Finger Trap",
    Description = {
        "\1 +0.7 Damage",
        "\2 -0.16 Shotspeed",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_HEMOLYMPH,
    Name = "Hemolymph",
    Description = {
        "If you have full health, you may pick up Red Hearts to:",
        "{{SoulHeart}} Replenish half Soul/Black Hearts",
        "{{HalfSoulHeart}} Get a half Soul Heart, if you have no Soul/Black Hearts"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SOLAR_PANEL,
    Name = "Solar Panel",
    Description = {
        "\1 +0.16 Speed",
        "{{Battery}} Entering a non-hostile room for the first time adds 1 active charge",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SURPRISE_EGG,
    Name = "Surprise Egg",
    Description = {
        "\1 +1 Health",
        "{{Pill}} Forces you to eat a Capsule, and adds it to the pill pool",
        "Capsule grants a random smelted trinket"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_COLOSSAL_ORB,
    Name = "Colossal Orb",
    Description = {
        "{{HealingRed}} +1 Health",
        "\1 +1 Damage",
        "\2 -0.2 Speed",
        "Size up",
        "{{Confusion}} On room entry, all enemies are confused for 4 seconds"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BABY_SHOES,
    Name = "Baby Shoes",
    Description = {
        "\1 +0.2 Speed",
        "+0.5 Speed if room is clear",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SACK_OF_CHESTS,
    Name = "Sack of Chests",
    Description = {
        "{{Chest}} Spawns a random chest every 9-10 rooms",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_EFFIGY,
    Name = "Effigy",
    Description = {
        "On room entry, tries to turn into a champion copy of a random enemy in the room",
        "Champions spawned by this have a 50% chance of dropping a random pickup when killed"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GAMBLING_ADDICTION,
    Name = "Gambling Addiction",
    Description = {
        "Upon killing an enemy, 25% chance to spawn one of the following:",
        "Nothing",
        "{{Coin}} 1-3 coins",
        "{{Key}} 1 key",
        "{{Bomb}} 1 bomb",
        "{{Heart}} 1-2 hearts",
        "{{Pill}} 1 pill",
        "1-2 blue flies",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PYRAMID_SCHEME,
    Name = "Pyramid Scheme",
    Description = {
        "{{TreasureRoom}} In Treasure Rooms, a special donation machine will spawn",
        "Donating has a 7.5% chance to explode it and drop 1-3 Coins",
        "{{Coin}} Exploding it manually makes it drop 2x the Coins donated to it"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PYTHAGORAS_CUP,
    Name = "Pythagoras' Cup",
    Description = {
        "!!! SINGLE USE !!!",
        "Gives a cup that makes item pedestals cycle through 3 choices",
        "Picking up more than 3 items on the same floor makes the cup spill, removing itself and all items picked up after using this"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PYTHAGORAS_CUP_PASSIVE,
    Name = "Pythagoras' Cup",
    Description = {
        "Gives a cup that makes item pedestals cycle through 3 choices",
        "Picking up more than 3 items on the same floor makes the cup spill, removing itself and all items picked up after using this"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DADS_SLIPPER,
    Name = "Dad's Slipper",
    Description = {
        "\1 +0.16 Shotspeed",
        "Non-boss enemies that hurt you are instantly killed",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GOOD_JUICE,
    Name = "The Good Juice",
    Description = {
        enums.CONSTANTS.Icon_Juice .. " Enemies drop Juice on death equal to their max health",
        "You can trade Juice in the starting room for pickups and stats",
        "{{Blank}} {{ColorSilver}}(Hold the {{ButtonSelect}} Map button to view your Juice){{CR}}"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BUTTERFLY_EFFECT,
    Name = "Butterfly Effect",
    Description = {
        "\1 +0.2 flat Damage",
        "\1 x1.2 Damage",
        "\1 ^1.2 Damage",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLOODFLOWER,
    Name = "Bloodflower",
    Description = {
        "{{HealingRed}} +1 Health",
        "{{Heart}} Heal 1 Red Heart when total boss HP in the room reaches 50%",
        "{{HalfSoulHeart}} Heal 1 half Soul Heart if health is full"
    },
    StackModifiers = {
        {
            ToModify = {
                "Heal an additional time"
            }
        }
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = function(descObj)
                return (ToyboxMod.GAME:GetNumPlayers()>1)
            end,
            ToModify = {
                {"Heal 1 Red Heart", "All players heal 1 Red Heart"},
                {"Heal 1 half Soul Heart", "Players heal 1 half Soul Heart"}
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_RED_CLOVER,
    Name = "Red Clover",
    Description = {
        "\1 +1 Luck",
        "\1 40% of Luck is added to Damage",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLACK_SOUL,
    Name = "Black Soul",
    Description = {
        "On hit, spawn a Shadow that follows you on a 0.5 second delay",
        "Can have up to 5 Shadows",
        "Shadows deal 50 damage per second",
        "Shadows disappear on new floor"
    },
    StackModifiers = {
        {
            ToModify = {
                "+1 max Shadow"
            }
        }
    },
    BFFSModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50 damage", "100 damage"},
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GOOD_JOB,
    Name = "Good Job",
    Description = {
        "{{BossRoom}} Clearing a Boss Room without taking damage gives:",
        "\1 +0.1 Speed",
        "\1 +0.5 Damage",
        "\1 +1 Luck",
        "{{Chest}} A Chest",
    },
    StackModifiers = {
        {
            ToModify = {
                "Stat-ups are 50% better"
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BIG_RED_BUTTON,
    Name = "Big Red Button",
    Description = {
        "Hold up a throwable Giga Rocket",
        "When the rocket lands:",
        "{{Collectible483}} Deals 100 damage to all enemies in the room",
        "{{Poison}} Poisons all enemies in the room",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_OIL_PAINTING,
    Name = "Oil Painting",
    Description = {
        "!!! SINGLE USE !!!",
        "{{Coin}} Gives Coins equal to its value",
        "Adds 0-4 Coins to value on every room clear"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_READING_GLASSES,
    Name = "Reading Glasses",
    Description = {
        "{{Pill}} Spawns a pill",
        "{{Pill}} Pills are always identified",
        "15% chance to replace cards with pills"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LANGTON_LOOP,
    Name = "Langton Loop",
    Description = {
        "While travelling, tears periodically spawn 2 copies of themselves moving in opposite perpendicular directions",
        "The copies deal 0.75x damage"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ODD_ONION,
    Name = "Odd Onion",
    Description = {
        "\1 +0.7 Damage",
        "Grants the effect of a random \"Tears up\" item every room",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CURIOUS_CARROT,
    Name = "Curious Carrot",
    Description = {
        "\1 +1.5 Range",
        "Every floor, reveals 5 random rooms on the map"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GARLIC,
    Name = "Garlic",
    Description = {
        "\2 -1 Range",
        "\2 x0.9 Range",
        "{{Poison}} Tears gain an aura that poisons enemies",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_WHITE_DAISY,
    Name = "White Daisy",
    Description = {
        "!!! Can only be used 6 times per floor",
        "On use, grants for the room:",
        "{{Blank}} \1 +2 Tears",
        "{{Blank}} \1 +2.5 Damage",
        "{{Blank}} \1 +1.5 Range",
        "{{Blank}} \1 +4 Luck",
        "While held:",
        "{{Blank}} \2 -1 Damage",
        "{{Blank}} \2 -2 Luck",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MELTED_CANDLE,
    Name = "Melted Candle",
    Description = {
        "Start shooting out a stream of flames that block enemy shots and deal contact damage",
        "The stream lasts for 1 second and can be controlled by shooting/movement inputs",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DRILL,
    Name = "Drill",
    Description = {
        "When used near a priced item, makes it free and sends you to an extra Challenge room",
        "The number of waves scales with the price of the item",
        "The extra Challenge room will not charge active items or spawn any clear rewards"
    },
    WispProperties = {
        Layer = 1,
        Amount = 0,
        HP = 2,
        Damage = 3,
        Description = {
            "Grants wisps equal to the amount of waves in the extra Challenge Room",
            "Devil deals/expensive items will grant stronger wisps"
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LOOSE_BOWELS,
    Name = "Loose Bowels",
    Description = {
        "\1 +3 Range",
        "Every 6-8 seconds, Isaac farts",
        --"The farts poison enemies and deflect projectiles"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_TAMMYS_TAIL,
    Name = "Tammy's Tail",
    Description = {
        "All rooms are cleared an additional time, doubling rewards and active charges gained",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MALICE,
    Name = "Malice",
    Description = {
        "All non-boss enemies can be champions",
        "Champion enemies trigger on-kill effects 3 times",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PAPER_PLATE,
    Name = "Paper Plate",
    Description = {
        "Grants up to 3 stationary familiars that spawn in random positions on walls",
        "The familiars change positions every room",
        "They shoot tears every 0.66 seconds that deal 4 damage and copy your tear effects",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_TRENDSETTER,
    Name = "Trendsetter",
    Description = {
        "\1 +3 Luck",
        "The first room clear reward each floor replaces all room clear rewards for the rest of the floor",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_COLORING_BOOK,
    Name = "Coloring Book",
    Description = {
        "Turns all non-champion non-boss enemies in the room into champions",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DISSOCIATION,
    Name = "Dissociation",
    Description = {
        "\1 Grants 7 random stat increases on pick-up",
        "\2 At the start of every floor, decreases a random stat"
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
            end,
            ToModify = {
                "{{Collectible260}} No longer decreases stats",
            }
        }
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ANGEL_DUST,
    Name = "Angel Dust",
    Description = {
        "\1 +2 Damage",
        "{{Fear}} In active rooms, every 10 seconds, Isaac will be Feared for 2 seconds"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_EMBER,
    Name = "Ember",
    Description = {
        "\1 +0.2 Speed",
        "{{Burning}} Touching enemies burns them for 4 seconds",
        "{{Burning}} When an enemy takes burning damage, it spreads the burning debuff to other nearby enemies"
    },
})
--[[
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ENEMA,
    Name = "Enema",
    Description = {
        "Removes all status effects from enemies",
        "{{Timer}} Temporarily grants a random stat up for every status effect instance removed"
    },
})
--]]
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PUGGYS_CLAW,
    Name = "Puggy's Claw",
    Description = {
        "\1 +0.3 flat Damage for the room",
        "{{DamageSmall}} Damage granted by this is permanently increased by +0.02 for every enemy killed while the effect is active",
        "Damage resets at the start of every run",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CONGLOMERATE,
    Name = "Conglomerate",
    Description = {
        enums.CONSTANTS.Icon_CardMantleRock.." 5% chance for mantles to replace random card spawns",
        enums.CONSTANTS.Icon_CardMantleRock.." Mantle effects are enhanced",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BLOCKCHAIN,
    Name = "Blockchain",
    Description = {
        "{{Coin}} Pay 1 coin to spawn a random pickup",
        "Price goes up by 1 coin every 10 uses",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BODYBAG,
    Name = "Bodybag",
    Description = {
        "{{EmptyHeart}} +1 Empty Heart container",
        "{{Heart}} Spawns 6 random hearts",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_AIDS,
    Name = "AIDS",
    Description = {
        "\1 +1 Luck",
        "10% chance to shoot a rainbow tear with 3x damage that poisons, fears, slows, charms, petrifies, burns, baits, homes, freezes on kill, and shrinks as it travels",
        "{{Luck}} 20% chance at 20 luck",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_HIDDEN_BLADE,
    Name = "Hidden Blade",
    Description = {
        "When entering an uncleared room, 66% chance to grant a single-use combat active in your extra pocket slot",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SNAKE_RING,
    Name = "Snake Ring",
    Description = {
        "\1 +0.1 Fire rate for the room",
        "{{TearsSmall}} Fire rate granted by this is permanently increased by +0.1 every time the item is used",
        "Fire rate resets at the start of every run",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CRICKETS_TAIL,
    Name = "Cricket's Tail",
    Description = {
        "{{Battery}} Using an active item grants a fading flat damage up",
        "{{DamageSmall}} The damage up is equal to the number of charges x 0.5 + 0.5",
        "The damage up wears off faster the larger it is",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MP3_PLAYER,
    Name = "MP3 Player",
    Description = {
        enums.CONSTANTS.Icon_StatusEarworm.." ".."Inflicts all enemies with Earworm for 12 seconds",
        enums.CONSTANTS.Icon_StatusEarworm.." ".."Enemies with Earworm are 50% faster and take 50% more damage",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_RELIQUARY,
    Name = "Reliquary",
    Description = {
        "Spawns an orbital wisp that grants a random trinket's effect",
        "The wisp can take damage and is destroyed after taking damage 6 times",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MOUTHPIECE,
    Name = "Mouthpiece",
    Description = {
        "\1 +2 Range",
        "\1 +0.2 Shotspeed",
        enums.CONSTANTS.Icon_StatusEarworm.." ".."5% chance to shoot out a tear that inflicts Earworm for 7 seconds (30% at 10 Luck)",
        enums.CONSTANTS.Icon_StatusEarworm.." ".."Enemies with Earworm are 50% faster and take 50% more damage",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_DADS_PIPE,
    Name = "Dad's Pipe",
    Description = {
        "Throw a smoke cloud",
        "The cloud deals contact damage, slows enemies and grows in size over the course of 4 seconds",
        "The damage dealt decreases as the cloud grows in size"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_NOT_A_PIPE,
    Name = "Not a Pipe",
    Description = {
        "Throw out the pipe as a boomerang",
        "The pipe deals low contact damage, and spawns damaging smoke clouds each time it hits an enemy",
        "The smoke clouds slow enemies and grow in size"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH,
    Name = "Vampire Teeth",
    Description = {
        "{{BleedingOut}} 10% chance to shoot a tear that inflicts bleeding on enemies",
        "{{Luck}} 50% chance at 20 luck",
        "{{BleedingOut}} Bleeding enemies heal you for {{HalfHeart}} half a heart when they die",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PROSPECTORS_PICK,
    Name = "Prospector Pick",
    Description = {
        "{{Rune}} Spawns a random rune",
        enums.CONSTANTS.Icon_CardMantleRock.." ".."Spawns a random mantle instead if used on a decorative floor tile (grass, small rocks, papers, gems etc.)",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_Y2K,
    Name = "Y2K",
    Description = {
        "{{Timer}} When the timer exceeds 10 minutes:",
        "{{SoulHeart}} +1 Soul Heart",
        "\1 +1 Damage",
        "Timer resets back to 0",
        "The requirement for this effect to trigger increases by 5 minutes"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MINDS_EYE,
    Name = "Mind's Eye",
    Description = {
        "Grants an eye familiar that constantly chases you",
        "!!! It has an aura that hurts you for a full heart of damage if you stand inside",
        "{{BleedingOut}} The aura also damages enemies and makes them bleed for 4 seconds",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MINDFLAYER_BABY,
    Name = "Flayer Baby",
    Description = {
        "Bounces around the room",
        "{{Weakness}} Has an aura that weakens enemies",
        "!!! While standing in the aura:",
        "\2 -0.3 Speed",
        "\2 x0.6 Damage multiplier",
        "The aura shrinks in inactive rooms"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_YES_BABY,
    Name = "Yes Baby",
    Description = {
        "Shoots a burst of 3 tears",
        "Each tear deals 4.5 damage",
    },
    BFFSModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 tears", "4 tears"},
                {"4.5", "9"},
            },
        },
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GIMP_BABY,
    Name = "Gimp Baby",
    Description = {
        "Shoots 2.5 damage tears with high fire rate",
        "Blocks enemy projectiles",
    },
    BFFSModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2.5 damage", "5 damage"},
            },
        },
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PSYCHO_BABY,
    Name = "Psycho Baby",
    Description = {
        "Shoots 6 damage tears with very low fire rate",
        "Upon killing an enemy for the first time each room, will gain increased damage and fire rate for the room",
    },
    BFFSModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"6 damage", "12 damage"},
            },
        },
    },
})

enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CHICCHAN_SERPENT,
    Name = "Chicchan",
    Description = {
        "{{BossRoom}} Entering a boss room or taking damage in a boss room grants for the room:",
        "\1 +0.7 Tears",
        "\1 +1 Damage",
        "\1 +1.5 Range",
        "\1 +2 Luck",
        "This effect also works in miniboss rooms or Boss Rush"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ETZNAB_KNIFE,
    Name = "Etznab",
    Description = {
        enums.CONSTANTS.Icon_BloodCoin.." ".."15% chance to gain a \"blood coin\" when you kill an enemy, up to 20",
        enums.CONSTANTS.Icon_BloodCoin.." ".."Blood coins are spent before regular coins when buying items, and grant \1 +0.08 Damage each",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_OC_DOG,
    Name = "Oc",
    Description = {
        "Familiars copy your firerate, damage, and tear effects",
        "{{Trinket183}} Grants the effects of The Twins",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_IMIX_CROCODILE,
    Name = "Imix",
    Description = {
        "At the start of every floor:",
        "\1 +0.2 Speed",
        "\1 +1 Tears",
        "\1 +1 Range",
        "\1 +0.16 Shotspeed",
        "These stats wear off over 1m 30s, and extend when an enemy dies",
        "Defeating the floor's boss makes the remaining stats permanent"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CIB_VULTURE,
    Name = "Cib",
    Description = {
        "\1 +8 Luck",
        "\1 +2 Luck at the start of every floor",
        "\2 -1 Luck when you take damage"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MEN_EAGLE,
    Name = "Men",
    Description = {
        "\1 +0.2 Speed",
        "Flight",
        "When presented with a choice between pickups, you can take all of them",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CABAN_EARTH,
    Name = "Caban",
    Description = {
        "Every floor, an additional item will spawn in the following rooms:",
        "{{TreasureRoom}} Treasure Room",
        "{{Shop}} Shop",
        --"{{SecretRoom}} Secret Room", -- nah thats wack
        "{{AngelDevilChanceSmall}} Angel/Devil Room",
        "When you take one of these extra items, the other ones will become uncollectable",
    },
    StackModifiers = {
        {
            ToModify = {
                "Can pick up an additional extra item",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LAMAT_RABBIT,
    Name = "Lamat",
    Description = {
        "Your chance-based tear effects are rolled with advantage",
        "{{Luck}} 15% x Luck chance for an additional roll",
        "Every 100% chance guarantees an additional roll",
    },
    StackModifiers = {
        {
            ToModify = {
                "Rolls an additional time",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MULAC_WATER,
    Name = "Mulac",
    Description = {
        "\1 +0.3 Speed",
        "Fully clearing the floor (except the Secret and Boss rooms) grants the following:",
        "{{Collectible185}} Dead Dove for the rest of the floor",
        "{{AngelDevilChance}} +100% deal chance",
        "{{Card81}} Triggers Soul of Isaac in the Devil/Angel Room",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_IK_WIND,
    Name = "Ik",
    Description = {
        "\1 +2 Luck",
        "{{Luck}} Using a slot machine or beggar has a luck-based chance to use it again for free",
        "Guarantees 1 free use for every 4 Luck, the remaining Luck grants a chance for an additional use"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_EB_GRASS,
    Name = "Eb",
    Description = {
        "{{DonationMachine}} Every 3 Donation Machine uses will {{Collectible644}} increase your lowest stat and {{HealingRed}} heal half a heart",
        "{{DonationMachine}} Donation Machines can't jam or break",
        "{{SecretRoom}} A Donation Machine will spawn in the Secret Room if there is no Shop on the level"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_KAN_LIZARD,
    Name = "Kan",
    Description = {
        "Familiars grant \1 +0.4 Fire Rate and \1 +0.4 Damage",
        "{{Trinket54}} Grants the effects of Isaac's Head",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MANIK_DEER,
    Name = "Manik",
    Description = {
        "On room clear:",
        "\1 Increases a random stat",
        "{{Collectible418}} Grants a 10% chance to fire tears with a tear effect chosen at random",
        "These bonuses reset at the start of the next floor"
    },
    StackModifiers = {
        {
            ToModify = {
                "Increases random tear effect chance by +10%",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_IX_JAGUAR,
    Name = "Ix",
    Description = {
        "{{UltraSecretRoom}} At the start of each level, reveals the Ultra Secret Room and an adjacent red room",
        "Taking damage once will permanently lock the revealed red room",
    },
    StackModifiers = {
        {
            ToModify = {
                "Each stack allows for an additional hit before locking the red room",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_AHAU_FLOWER,
    Name = "Ahau",
    Description = {
        "The first special room you enter each floor is upgraded, if possible",
        "Whether or not a room can be upgraded is indicated by a flower patch next to the room's entrance",
    },
    StackModifiers = {
        {
            ToModify = {
                "Each stack allows for an additional upgraded room",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CHUEN_MONKEY,
    Name = "Chuen",
    Description = {
        "Item pedestals cycle between 4 random items",
        "Each time you collect an item, all other item pedestals on the floor have their highest quality item removed",
        "This effect doesn't work if a pedestal has only 1 item"
    },
    StackModifiers = {
        {
            ToModify = {
                "Adds an additional item to each cycle",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CIMI_DEATH,
    Name = "Cimi",
    Description = {
        "{{SacrificeRoom}} Guarantees a Sacrifice Room generates each floor",
        "Improves Sacrifice Room layouts and modifies their rewards",
        "{{Heart}} Sacrifice Room spikes prioritize removing Red Hearts"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CAUAC_STORM,
    Name = "Cauac",
    Description = {
        "On hit, consume 2 bars of active charge, block the damage, and gain \1 +0.8 Tears for the room",
        "Only works if you have at least 2 bars of active charge",
        "{{Collectible63}} At the start of every floor, your active items are fully overcharged",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BEN_REED,
    Name = "Ben",
    Description = {
        "Coins, bombs, and keys each grant a random stat boost that scales with their amount",
        "Whenever you use a coin, bomb, or key, changes its respective boost to a different stat",
        "Each pickup can boost either {{ColorYellow}}speed{{CR}}, {{ColorBlue}}tears{{CR}}, {{ColorRed}}damage{{CR}}, or {{ColorOrange}}range{{CR}}"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_AKBAL_HOUSE,
    Name = "Akbal",
    Description = {
        "{{IsaacsRoom}} The starting room of each floor is replaced with a Bedroom",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_TAMMYS_BODY,
    Name = "Tammy's Body",
    Description = {
        "{{Collectible198}} Converts 1 heart container into a random coin, heart, bomb, key, card, pill, and trinket",
        "Also triggers on-hit effects 3 times",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_KROKODIL,
    Name = "Krokodil",
    Description = {
        "\1 +0.7 Tears",
        "\1 +0.15 Shotspeed",
        "{{RottenHeart}} Turns all of your Red Hearts into Rotten Hearts",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_WOODEN_ARM,
    Name = "Wooden Arm",
    Description = {
        "Swings arm in the chosen direction, the arm deals damage and consumes projectiles",
        "Consuming projectiles adds a charge to the item, at full charge can be used to shoot out a volley of tears",
        "The fired tears destroy projectiles they pass through",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_RHUBARB,
    Name = "Rhubarb",
    Description = {
        "\2 x0.75 Damage",
        "On hit, enemies take an additional 15% of their maximum HP as damage",
        "Bosses take 1.5% instead of 15%"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_UNSTABLE_DNA,
    Name = "Unstable DNA",
    Description = {
        "50% chance to upgrade blue flies and blue spiders into stronger variants:",
        "Fly -> Moter, Lvl.2 Fly, Sucker, or Pooter",
        "Spider -> Big Spider, Lvl.2 Spider, 1-4 Swarm Spiders, Small Crazy Long Legs"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LAB_MEAT,
    Name = "Lab Meat",
    Description = {
        "Spawns 4-7 blue flies/spiders",
        "{{Collectible"..ToyboxMod.COLLECTIBLE_UNSTABLE_DNA.."}} Blue flies/spiders are upgraded into stronger variants (e.g blue fly -> moter)",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ANAPHYLAXIS,
    Name = "Anaphylaxis",
    Description = {
        "If a projectile or enemy gets close, blows it away, and grants \1 +1 Tears and \2 -0.2 Shotspeed for the next 7 seconds",
        "This effect has a 12 second cooldown"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CLONE,
    Name = "Clone",
    Description = {
        "+1 Life",
        "On death, revive with an extra clone player that copies half of your passive items",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_HAND_PUMP,
    Name = "Hand Pump",
    Description = {
        "\1 Grants 3 stacks of +0.5 Damage and +1 Luck, up to 9 stacks total",
        "Removes 1 stack of the stat increases each time you fire",
        "All stacks of the stat increases are removed on room clear",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SILVER_PIECES,
    Name = "Silver Pieces",
    Description = {
        "{{DevilChance}} +15% Devil deal chance",
        "{{AngelChance}} Angel Rooms can no longer spawn",
        "Taking a devil deal grants \1 +0.3 Damage and 1 nickel per heart container paid",
    },
    StackModifiers = {
        {
            ToModify = {
                "Taking a devil deal grants an additional \1 +0.3 Damage and 1 nickel",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_TWISTED_HEART,
    Name = "Twisted Heart",
    Description = {
        "{{Heart}} Drains all but 1 heart container, then spawns a random heart pickup for every heart drained, along with 1 additional heart pickup",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CARRION,
    Name = "Carrion",
    Description = {
        "\2 -0.1 Speed",
        "\2 -0.2 Shotspeed",
        "{{RottenHeart}} +1 Rotten Heart",
        "Enemies take x0.45 damage from all sources, but they take 2 additional delayed hits that deal the same amount of damage",
    },
    StackModifiers = {
        {
            ToModify = {
                "Enemies take +1 additional delayed hit",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FERTILIZER,
    Name = "Fertilizer",
    Description = {
        "Every 2 seconds, spawns 1 blue fly, up to 3",
        "Standing still spawns flies 0.6 seconds faster",
        "Not shooting spawns flies 0.6 seconds faster",
    },
    StackModifiers = {
        {
            ToModify = {
                "Can spawn up to 2 additional flies",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_GUNPOWDER,
    Name = "Gunpowder",
    Description = {
        "\1 +1 Damage",
        "\1 +0.3 Shotspeed",
        "Shooting recoils you backwards a short distance",
    },
    StackModifiers = {
        {
            ToModify = {
                "Recoil is more intense",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_INSTANT_GRATIFICATION,
    Name = "Instant Gratification",
    Description = {
        "Spawns a reward plate",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_MUTAGEN,
    Name = "Mutagen",
    Description = {
        "{{Collectible418}} Grants a 20% chance for fired tears to have a tear effect chosen at random (100% at 20 Luck)",
        "The chosen tear effect is different every room",
        "Tear velocity is slightly randomized"
    },
    StackModifiers = {
        {
            ToModify = {
                "Chooses an additional random tear effect, may also fire tears with this effect independently of the first effect",
            }
        }
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FRANKENCAT,
    Name = "Frankencat",
    Description = {
        "+1 Life",
        "Isaac can no longer revive, extra lives instead grant 3 free hits (up to 9 hits max) that replenish at the start of every floor",
        "The free hits count as fake damage and block any form of damage"
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_COLLAR)
            end,
            ToModify = {
                "{{Collectible212}} Chance revives grant 0-3 free hits at random",
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_LEATHERFACE,
    Name = "Leatherface",
    Description = {
        "{{Collectible313}} Every 20 enemies killed grants a shield that prevents one hit",
        "Enemies leave behind creep on death that deals 3 damage per tick (30 per second)",
    },
    StackModifiers = {
        {
            ToModify = {
                "-5 kills required for a shield per stack, to a minimum of 5",
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_NANOMACHINES,
    Name = "Nanomachines",
    Description = {
        "{{HolyMantle}} Grants a one-use Holy Mantle shield",
        "{{Timer}} Every 60 seconds, grants a one-use Holy Mantle shield",
    },
    StackModifiers = {
        {
            ToModify = {
                "-10 seconds required for a shield per stack, to a minimum of 15s",
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_FRANKINCENSE,
    Name = "Frankincense",
    Description = {
        "\1 +0.33 Damage for every enemy in the room, up to +2 Damage",
    },
    StackModifiers = {
        {
            ToModify = {
                "+50% Damage granted per stack",
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_BREAKTHROUGH,
    Name = "Breakthrough",
    Description = {
        "Can be used at any active charge above 0",
        "For every charge pip consumed, grants the effects of a random passive item from the current room's item pool",
        "The item effects granted last for 45 seconds"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ELEPHANTS_FOOT,
    Name = "Elephant's Foot",
    Description = {
        "In uncleared new rooms spawns a nuclear poop",
        "The poop poisons and damages nearby enemies, deals more damage to closer enemies",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_XENOTRANSFUSION,
    Name = "Xenotransfusion",
    Description = {
        "{{Battery}} Charges with damage dealt",
        "When used:",
        "{{HealingRed}} Heals 1 heart",
        "\1 Grants 2 random stat ups",
        "\2 Grants 1 random stat down",
        "Charging becomes less effective if too much damage is dealt in one room"
    },
})

--- OTHER ITEM MODIFIERS ---

enums.FUNCTIONS.AddItem({
    ID = CollectibleType.COLLECTIBLE_URANUS,
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneIsPlayerType(ToyboxMod.PLAYER_JONAS_A)
            end,
            ToModify = {
                enums.CONSTANTS.Icon_PlayerJonas .. enums.CONSTANTS.Color_Jonas .. "Frozen enemies can only drop pills when shattered{{CR}}",
            }
        },
    }
})
enums.FUNCTIONS.AddItem({
    ID = CollectibleType.COLLECTIBLE_CHARM_VAMPIRE,
    Modifiers = {
        {
            Condition = function(descObj)
                return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_GARLIC)
            end,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_GARLIC.."}} Can't heal you!",
            }
        },
    }
})


--- TRINKETS ---

enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_WONDER_DRUG,
    Name = "Wonder Drug",
    Description = {
        enums.CONSTANTS.Icon_GoldenPill .. " Doubles the chance for gold pills to spawn",
        enums.CONSTANTS.Icon_HorsePill .. " Doubles the chance for horse pills to spawn",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"Doubles", "Triples"}
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"Doubles", "Quadruples"}
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_ANTIBIOTICS,
    Name = "Antibiotics",
    Description = {
        "{{Pill}} Using a pill has a 20% chance to use it 2 times",
        "100% chance for unidentified pills",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2 times", "3 times"}
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2 times", "4 times"}
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_AMBER_FOSSIL,
    Name = "Amber Fossil",
    Description = {
        "Blue flies have a 33% chance to be converted into a random locust",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"33%%", "67%%"}
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"33%%", "100%%"}
            }
        },
    },
})
--[[
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_SINE_WORM,
    Name = "Sine Worm",
    Description = {
        "\1 +0.4 Tears",
        "\1 +1.5 Range",
        "Your tears gradually slow down and speed back up to normal velocity",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.4", "+0.8"},
                {"+1.5", "+3"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.4", "+1.2"},
                {"+1.5", "+4.5"},
            }
        },
    },
})
--]]
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_BIG_BLIND,
    Name = "Big Blind",
    Description = {
        "{{Coin}} Every 10 damage dealt to enemies, spawn a coin",
        "The requirement for spawning a coin goes up more and more for every coin spawned",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = function(descObj)
                local mult, color
                if(enums.FUNCTIONS.IsTrinketTripled(descObj)) then
                    color="{{ColorRainbow}}"
                    mult = 3
                elseif(enums.FUNCTIONS.IsTrinketDoubled(descObj)) then
                    color="{{ColorGold}}"
                    mult = 2
                else
                    mult = 1
                end
                --mult = mult+(descObj.Entity and Isaac.GetPlayer():GetTrinketMultiplier(ToyboxMod.TRINKET_BIG_BLIND) or 0)

                local counter = ToyboxMod:getBigBlindDamageRequirement(Isaac.GetPlayer())/mult
                counter = tostring(math.floor(counter))

                local replaceString = (color or "")..counter..(color and "{{CR}}" or "")
                descObj.Description = string.gsub(descObj.Description, "10", replaceString)
                return descObj.Description
            end,
        }
    }
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_JONAS_LOCK,
    Name = "Jonas' Lock",
    Description = {
        "{{Pill}} Using a pill grants a stat bonus equivalent to 50% of a random \"Stat Up\" pill effect",
        "The stat bonuses are only applied while holding this trinket"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "100%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "150%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_BATH_WATER,
    Name = "Bath Water",
    Description = {
        "Familiar that shatters when you take damage and spawns a pool of creep, once per room",
        "The creep deals 24 damage per second",
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_BLACK_RUNE_SHARD,
    Name = "Black Rune Shard",
    Description = {
        "{{Coin}} Blue flies and spiders have a 33% chance to be replaced by a coin",
    },
    Modifiers = {
        {
            Condition = function(descObj)
                return (FiendFolio~=nil)
            end,
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"and spiders", ", spiders, and skuzzes"},
            }
        }
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"33%%", "67%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"33%%", "100%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_SUPPOSITORY,
    Name = "Suppository",
    Description = {
        "{{Pill}} Poop drops have a 20% chance to be replaced by a pill",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"20%%", "40%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"20%%", "60%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_DIVIDED_JUSTICE,
    Name = "Divided Justice",
    Description = {
        "Common heart, coin, bomb, and key drops have a 10% chance to be replaced by a Smorgasbord",
        "Smorgasbords give 1 coin, 1 bomb, 1 key, and heal 1 red heart"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"10%%", "20%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"10%%", "30%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_KILLSCREEN,
    Name = "Killscreen",
    Description = {
        "Enemies on the right side of the room take 1 damage every 0.5 seconds",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"0.5", "0.33"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"0.5", "0.25"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_MIRROR_SHARD,
    Name = "Mirror Shard",
    Description = {
        "\2 -13 Luck",
        "\1 +1 Luck whenever you take damage"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 ", "1.5 "},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 ", "2 "},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_LUCKY_TOOTH,
    Name = "Lucky Tooth",
    Description = {
        "\1 Beggars have a flat +33% chance to payout",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"33%%", "67%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"33%%", "100%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_HOLY_LENS,
    Name = "Holy Lens",
    Description = {
        "{{Planetarium}} Spawns a Planetarium in Cathedral",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"in Cathedral", "{{ColorWhite}}in Cathedral{{CR}} and Chest"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"in Cathedral", "{{ColorWhite}}in Cathedral{{CR}} and Chest"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_DARK_NEBULA,
    Name = "Dark Nebula",
    Description = {
        "{{Planetarium}} Spawns a Planetarium in Sheol",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"in Sheol", "{{ColorWhite}}in Sheol{{CR}} and Dark Room"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"in Sheol", "{{ColorWhite}}in Sheol{{CR}} and Dark Room"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_MAKEUP_KIT,
    Name = "Make-Up Kit",
    Description = {
        "Donation Machines are replaced with Mom's Dressing Tables",
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_YELLOW_BELT,
    Name = "Yellow Belt",
    Description = {
        "10% chance to negate damage taken",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"10%%", "20%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"10%%", "30%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_ZAP_CAP,
    Name = "Zap Cap",
    Description = {
        "Every 40th time any enemy takes damage, the enemy who got hit explodes for 6x damage taken + 15",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"40th", "30th"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"40th", "20th"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_MISPRINT,
    Name = "Misprint",
    Description = {
        "{{Collectible}} Picking up an item grants 1 copy of that item for 60 seconds",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 copy", "2 copies"},
                {"60 seconds", "90 seconds"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 copy", "3 copies"},
                {"60 seconds", "120 seconds"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_CUTOUT,
    Name = "Cutout",
    Description = {
        "When dropped, becomes a decoy that attracts enemies",
        "The decoy can block shots and take damage, when it takes enough damage it turns back into a trinket"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ToModify = {
                "The decoy deals 7.5 contact damage per second",
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ToModify = {
                "The decoy deals 15 contact damage per second",
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_GASOLINE,
    Name = "Gasoline",
    Description = {
        "{{Burning}} On Fire debuff lasts forever, and deals damage 50% more often",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "100%%"}
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "150%%"}
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_LOOTBOX,
    Name = "Lootbox",
    Description = {
        "Shopkeepers have a 50% chance to be replaced by a random chest",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "100%%"}
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "100%%"}
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_SPITEFUL_PENNY,
    Name = "Spiteful Penny",
    Description = {
        "Picking up a coin deals 5 damage to all enemies in the room, and has a 10% chance to deal fake damage to Isaac",
        "Damage and chance increases with the coin's value"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"5 damage", "10 damage"},
                {"10%% chance", "20%% chance"}
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"5 damage", "15 damage"},
                {"10%% chance", "30%% chance"}
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_NIGHTCAP,
    Name = "Nightcap",
    Description = {
        "Makes all Troll Bombs sleepy",
        "Sleepy Troll Bombs don't wake up when you touch them"
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_LIBRARY_CARD,
    Name = "Library Card",
    Description = {
        enums.CONSTANTS.Icon_RoomLibraryTreasure.." Treasure Room items are replaced with Library items",
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_LIFETIME_SUPPLY,
    Name = "Lifetime Supply",
    Description = {
        "At the start of every floor, gain {{Coin}} Coins, {{Bomb}} Bombs, and {{Key}} Keys until you have at least 3 of each",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 of each", "4 of each"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 of each", "5 of each"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_RUBBING_ALCOHOL,
    Name = "Rubbing Alcohol",
    Description = {
        "{{Poison}} Poison and {{Burning}} Burning deal 2x Damage",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2x Damage", "2.5x Damage"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2x Damage", "3x Damage"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_INSIDE_JOKE,
    Name = "Inside Joke",
    Description = {
        "\1 x1.5 Damage",
        "Taking damage disables this trinket for the next 3 rooms"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"x1.5", "x2"},
                {"3", "5"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"x1.5", "x2.5"},
                {"3", "7"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_CITRUSBERRY,
    Name = "Citrusberry",
    Description = {
        "On hit, if Isaac has less than half of his max health, {{HealingRed}} heal 25% Max Health and {{SoulHeart}} gain 1 Soul Heart",
        "Always heals at least 1 Heart",
        "Can only activate once per floor"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"25%%", "50%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"25%%", "75%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_CITRUSBERRY_CONSUMED,
    Name = "Citrusberry",
    Description = {
        "On hit, if Isaac has less than half of his max health, {{HealingRed}} heal 25% Max Health and {{SoulHeart}} gain 1 Soul Heart",
        "Always heals at least 1 Heart",
        "Can only activate once per floor"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"25%%", "50%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"25%%", "75%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_SLINGSHOT,
    Name = "Slingshot",
    Description = {
        "Enemy HP no longer scales based on the current stage",
        "Enemies no longer have boss armor",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ToModify = {
                "Enemies with scaling HP have less health",
                "Enemies with boss armor take 25% more damage",
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ToModify = {
                "Enemies with scaling HP have even less health",
                "Enemies with boss armor take 50% more damage",
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_CATNIP,
    Name = "Catnip",
    Description = {
        "Enemies hit by familiars are slowed for 2 seconds",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2 seconds", "3 seconds"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2 seconds", "4 seconds"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_TRAIL_MIX,
    Name = "Trail Mix",
    Description = {
        "{{UnknownHeart}} Spawns 1 random heart",
        "{{UnknownHeart}} At the start of every floor, spawns 1 random heart",
        "The hearts have equal chance to be of ANY variant"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"spawns 1 random heart", "{{ColorWhite}}spawns{{CR}} 2 random hearts"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"spawns 1 random heart", "{{ColorWhite}}spawns{{CR}} 3 random hearts"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_EARWORM,
    Name = "Earworm",
    Description = {
        enums.CONSTANTS.Icon_StatusEarworm.." ".."Entering a room has a 15% chance to inflict Earworm on random enemies",
        enums.CONSTANTS.Icon_StatusEarworm.." ".."Enemies with Earworm are 50% faster and take 50% more damage",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"15%%", "25%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"15%%", "35%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_7TH_PAGE,
    Name = "The 7th Page",
    Description = {
        "Pickup spawns have a 1/7 chance to be doubled",
        "Doesn't work on items and trinkets",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"doubled", "tripled"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"doubled", "quadrupled"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_POWER_WORD,
    Name = "Power Word",
    Description = {
        "The first tear fired each room will have homing and will {{Collectible503}} instantly kill non-boss enemies",
        "Boss enemies will instead take 36 damage"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"tear", "2 tears"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"tear", "3 tears"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_TUNGSTEN_KEY,
    Name = "Tungsten Key",
    Description = {
        "{{GoldenKey}} Grants infinite keys while held",
        "On new floor, 50% chance to break"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"50%%", "25%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"On new floor, 50%% chance to break", "Does not break"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_SWALLOWED_D10,
    Name = "Swallowed D10",
    Description = {
        "{{Collectible285}} Upon taking damage, devolve all enemies in the room",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"room", "{{ColorWhite}}room{{CR}} twice"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"room", "{{ColorWhite}}room{{CR}} thrice"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_MONOCLE,
    Name = "Monocle",
    Description = {
        "\2 -1 Luck",
        "If clearing a room would yield no reward, spawns a copy of the last room clear reward",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"a copy", "2 copies"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"a copy", "3 copies"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_PINK_DONUT,
    Name = "Pink Donut",
    Description = {
        "{{EmptyHeart}} Items that grant max health on pickup instead grant +0.5 Damage per heart that would be granted",
        "The damage granted by this trinket is permanent"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.5", "+0.75"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.5", "+1"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_INFESTATION_3,
    Name = "Infestation 3",
    Description = {
        "Enemies spawned by other enemies are turned into spiders",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"spiders", "1 HP {{ColorWhite}}spiders{{CR}}"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"spiders", "1 HP {{ColorWhite}}spiders{{CR}}"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_FAKE_BEARD,
    Name = "Fake Beard",
    Description = {
        "{{Collectible147}} When you kill an enemy, 20% chance to get a one-use axe swing",
        "The axe damages enemies, and breaks rocks and secret room entrances"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"20%%", "40%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"20%%", "60%%"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_SUGAR_CUBE,
    Name = "Sugar Cube",
    Description = {
        "{{HealingRed}} Upon using a consumable, heal 1 Red Heart",
        "{{SoulHeart}} If your HP is full, heal half a Soul Heart instead"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 Red Heart", "1 and a half {{ColorWhite}}Red Hearts{{CR}}"},
                {"half a Soul Heart", "1 {{ColorWhite}}Soul Heart"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 Red Heart", "2 {{ColorWhite}}Red Hearts{{CR}}"},
                {"half a Soul Heart", "1 and a half {{ColorWhite}}Soul Hearts{{CR}}"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_INTEREST,
    Name = "Interest",
    Description = {
        "{{Coin}} At the start of every floor, multiplies Isaac's coins by x1.33",
        "Always grants at least 3 coins"
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"x1.33", "x1.67"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"multiplies Isaac's coins by x1.33", "doubles {{ColorWhite}}Isaac's coins{{CR}}"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_NEMATODE,
    Name = "Nematode",
    Description = {
        "{{Collectible664}} Food items no longer heal red HP, but grant 2 random stat ups when picked up",
        "!!! Once picked up, can only be removed with {{Trinket"..ToyboxMod.TRINKET_ANTIBIOTICS.."}} Antibiotics",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2 random", "4 {{ColorWhite}}random{{CR}}"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2 random", "6 {{ColorWhite}}random{{CR}}"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_LIL_GRUB,
    Name = "Lil Grub",
    Description = {
        "On room clear, spawn 3 blue flies",
        "The blue flies may be of a {{Collectible"..ToyboxMod.COLLECTIBLE_UNSTABLE_DNA.."}} stronger variant and may have a random locust color",
        "!!! Once picked up, can only be removed with {{Trinket}} Dewormer",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 blue", "6 {{ColorWhite}}blue{{CR}}"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"3 blue", "9 {{ColorWhite}}blue{{CR}}"},
            }
        },
    },
})
enums.FUNCTIONS.AddTrinket({
    ID = ToyboxMod.TRINKET_CANDIDA,
    Name = "Candida",
    Description = {
        "{{Poison}} Damage dealt by familiars is increased by 1 and has a 33% chance to inflict poison",
        "!!! Once picked up, can only be removed with {{Trinket"..ToyboxMod.TRINKET_ANTIBIOTICS.."}} Antibiotics",
    },
    DoubleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"by 1", "{{ColorWhite}}by{{CR}} 1.5"},
                {"33%%", "67%%"},
            }
        },
    },
    TripleModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"by 1", "{{ColorWhite}}by{{CR}} 2"},
                {"33%%", "100%%"},
            }
        },
    },
})

enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_PRISMSTONE,
    Name = "Prismstone",
    Description = {
        "{{Rune}} Spawns 3 runes or soul stones",
        "Only 1 can be taken"
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_FOIL_CARD,
    Name = "Foil Card",
    Description = {
        "{{Beggar}} Can be given to a beggar to donate to it 15 times in quick succession",
        "This effect ends prematurely if Isaac exits the room",
        "{{HardModeSmall}} Beggars affected by this do not have any Hard Mode restrictions and pay out more often",
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_POISON_RAIN,
    Name = "Poison Rain",
    Description = {
        "{{Poison}} All enemies, including bosses, are poisoned for 10 seconds",
        "For the rest of the room, rocks will be randomly destroyed"
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_ALIEN_MIND,
    Name = "Alien Mind",
    Description = {
        "{{Friendly}} Picks 3 random enemies to become friendly and mimic your movements and attacks",
        "Enemies with higher health are more likely to be picked"
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_FOUR_STARRED_LADYBUG,
    Name = "4-Starred Ladybug",
    Description = {
        "{{Petrify}} Champion and boss enemies are petrified for 4 seconds",
        "{{Weakness}} Champion and boss enemies are weakened for the rest of the room",
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_GREEN_APPLE,
    Name = "Green Apple",
    Description = {
        "Grants progress towards 3 random transformation",
        "Cannot pick transformations Isaac has already obtained"
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_WISE_MEN,
    Name = "S - The Wise Men",
    Description = {
        "{{Collectible651}} Grants a modified Star of Bethlehem for the room",
        "The star will wander around the room instead of towards the Boss Room",
        "{{SoulHeart}} Upon room clear, the star will turn into a Soul Heart"
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ColorOverride = false,
            ToModify = {
                "The familiar's aura is 50% larger"
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_ANGEL,
    Name = "IS - The Angel",
    Description = {
        "{{Collectible33}} Triggers the effects of The Bible",
        "Grants spectral tears for the room",
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_GATE,
    Name = "IIS - The Gate",
    Description = {
        "{{GoldenKey}} Grants a Golden Key for the room",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ColorOverride = false,
            ToModify = {
                "{{GoldenBomb}} Also grants a Golden Bomb for the room"
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_APOCALYPSE,
    Name = "IIIS - Apocalypse",
    Description = {
        "didy",
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_CRYPT,
    Name = "IVS - The Crypt",
    Description = {
        "{{SuperSecretRoom}} Teleports Isaac to the Super Secret Room",
        enums.CONSTANTS.Icon_RoomGraveyard.." If there is a Graveyard, teleports to it instead"
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ColorOverride = false,
            ToModify = {
                "If the Super Secret Room hasn't been entered yet, spawns an {{OldChest}} Old Chest in the room"
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_REAPER,
    Name = "VS - The Reaper",
    Description = {
        "{{Timer}} For the rest of the room, every 5 seconds a random enemy will take 20 damage and be slowed for 5 seconds",
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_DRAGON,
    Name = "VIS - The Dragon",
    Description = {
        "{{GoldenHeart}} Spawns 2 Golden Hearts",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2", "3"}
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_DUALITY,
    Name = "VIIS - Duality",
    Description = {
        "{{BlendedHeart}} Spawns 2 Blended Hearts",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"2", "3"}
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_APOCALYPSE,
    Name = "IIIS - Apocalypse",
    Description = {
        "For the room, a Horseman will periodically charge through the room, hurting players and enemies",
        "Each Horseman has a different attack as it moves through the room",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"a Horseman", "2 Horsemen"}
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_REAPER,
    Name = "VS - The Reaper",
    Description = {
        "{{Slow}} For the room, every 5 seconds a random enemy will take 20 damage and become Slowed for 5 seconds",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            IgnoreMarkup = true,
            ToModify = {
                {"{{Slow}}", "{{Weakness}}"}
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"Slowed", "Weakened"}
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_BARON,
    Name = "VIIIS - The Baron",
    Description = {
        "Rerolls all pickups in the room into rarer pickups",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ToModify = {
                "Rerolls an additional time, resulting in even rarer pickups"
            }
        }
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_ANGEL,
    Name = "IS - The Angel",
    Description = {
        "{{Collectible33}} Triggers the effects of The Bible",
        "{{Timer}} Grants spectral tears for the room"
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ToModify = {
                "Also grants {{Collectible182}} Sacred Heart for the room"
            }
        }
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_TRICKSTER,
    Name = "IXS - The Trickster",
    Description = {
        "{{Beggar}} Spawns a Shell Game",
        "{{DemonBeggar}} 2% chance for it to be a Hell Game"
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"a Shell Game", "2 {{ColorWhite}}Shell Games{{CR}}"}
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            IgnoreMarkup = true,
            ToModify = {
                {"for it", "{{ColorWhite}}for each{{CR}}"}
            }
        },
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_EXCALIBUR,
    Name = "XIIS - Excalibur",
    Description = {
        "{{Collectible"..ToyboxMod.COLLECTIBLE_ART_OF_WAR.."}} Grants a random tear replacement item for the room",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"a random tear replacement item", "2 {{ColorWhite}}random tear replacement items{{CR}}"}
            }
        },
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_FATE,
    Name = "XIIIS - Fate",
    Description = {
        "{{Collectible"..ToyboxMod.COLLECTIBLE_METEOR_SHOWER.."}} For the rest of the room, meteors will fall from the sky every 0.5 seconds",
        "The meteors explode, dealing 35 damage and burning enemies",
        "!!! Meteors can also hurt you",
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"0.5", "0.25"}
            }
        },
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_THE_IDOL,
    Name = "XVIS - The Idol",
    Description = {
        "{{CurseRoom}} Teleports Isaac to the Curse Room",
        enums.CONSTANTS.Icon_RoomTemple.." If there is a Temple, teleports to it instead"
    },
    TarotClothModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            ColorOverride = false,
            ToModify = {
                "If the Curse Room hasn't been entered yet, spawns a coin and 4 random pickups in the room"
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_GREYHOUND,
    Name = "Greyhound",
    Description = {
        "{{Collectible419}} Teleports Isaac to a room that hasn't been visited yet",
        "Has a 66% chance to respawn in the destination room",
        "Hierarchy:",
        "{{Blank}} {{SuperSecretRoom}}>{{Shop}}>{{TreasureRoom}}>{{SacrificeRoom}}>{{DiceRoom}}>{{Library}}>"..enums.CONSTANTS.Icon_RoomGraveyard..">{{CurseRoom}}>"..enums.CONSTANTS.Icon_RoomTemple.."> {{MiniBoss}}>{{ChallengeRoom}}{{BossRushRoom}}>{{IsaacsRoom}}{{BarrenRoom}}>{{ArcadeRoom}}>{{ChestRoom}}>{{Planetarium}}>{{SecretRoom}}>{{ErrorRoom}}"
    },
})

enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_ROCK,
    Name = "Mantle - Rock",
    Description = {
        "{{Timer}} For the room:",
        "Grants {{Collectible592}} Terra",
        "Taking damage fires a shockwave at the enemy who hurt you",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Size up{{CR}}",
                "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Grants {{Collectible302}} Leo{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "2 HP",
                "Does nothing",
                enums.CONSTANTS.Icon_AtlasRock .. " {{ColorGray}}Transformation{{CR}}",
                "No effect",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "Does nothing",
                    "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Still does nothing{{CR}}",
                },
            }
        },
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_POOP,
    Name = "Mantle - Poop",
    Description = {
        "Hold up a throwable poop",
        "When thrown, it leaves liquid poop creep under it as it flies"
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Throw 2 more poops in quick succession{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "2 HP",
                "50% chance to spawn 2 blue flies on room clear",
                "+3.33% chance for rocks to be replaced with poop",
                enums.CONSTANTS.Icon_AtlasPoop .. " {{ColorGray}}Transformation{{CR}}",
                "Destroying poops heals 1 HP to your leftmost damaged mantle",
                "+10% chance to get pickups from poops",
                "Poops can now drop keys, bombs, consumables and batteries",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+3.33%% chance",
                    enums.CONSTANTS.Color_Conglomerate.."+6.67%% chance{{CR}}",
                },
                {
                    "2 blue flies",
                    enums.CONSTANTS.Color_Conglomerate.."2-4 blue flies{{CR}}",
                },
            }
        },
    },
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_BONE,
    Name = "Mantle - Bone",
    Description = {
        "{{Charm}} Spawns a friendly Bony",
        "{{Timer}} For the room, enemies have a 67% chance to spawn an orbital bone shard on death",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"{{Charm}} Spawns a friendly Bony", "{{Collectible"..ToyboxMod.COLLECTIBLE_BONE_BOY.."}} "..enums.CONSTANTS.Color_Conglomerate.."Grants a Bone Boy for the floor{{CR}}"},
                {"67%%", " "..enums.CONSTANTS.Color_Conglomerate.."100%%{{CR}}"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "\1 3 HP",
                "+10% chance to spawn a bone orbital on kill",
                "Losing a Bone Mantle spawns a friendly Bony",
                enums.CONSTANTS.Icon_AtlasBone .. " {{ColorGray}}Transformation{{CR}}",
                "Fire bones in a circle around you when damaged",
                "+0.6 Tears for every missing Mantle",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+10%% chance",
                    enums.CONSTANTS.Color_Conglomerate.."+20%% chance{{CR}}",
                },
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_DARK,
    Name = "Mantle - Dark",
    Description = {
        "Deals 10 damage to all enemies on the floor",
        "{{BlackHeart}} 10% chance for enemies killed by this to drop a Black Heart",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"10%%", " "..enums.CONSTANTS.Color_Conglomerate.."15%%{{CR}}"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Also deals 40 damage to all enemies in the room{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "2 HP",
                "\1 +0.4 Damage",
                "Losing a Dark Mantle deals 60 damage to all enemies",
                enums.CONSTANTS.Icon_AtlasDark .. " {{ColorGray}}Transformation{{CR}}",
                "Gain a dark aura that gives +0.5 Damage for every enemy inside it",
                "Losing any Mantle deals 60 damage to all enemies"
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+0.4 Damage",
                    " "..enums.CONSTANTS.Color_Conglomerate.."+0.8 Damage{{CR}}",
                },
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_HOLY,
    Name = "Mantle - Holy",
    Description = {
        "{{EternalHeart}} +1 Eternal Heart",
        "{{Timer}} Your tears gain a damaging aura for the room"
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"for the room", enums.CONSTANTS.Color_Conglomerate.."and homing as long as you have an Eternal Heart"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "2 HP",
                "\1 +0.5 Range",
                "+3.33% chance to fire a {{Collectible182}} Sacred Heart tear",
                enums.CONSTANTS.Icon_AtlasHoly .. " {{ColorGray}}Transformation{{CR}}",
                "Flight",
                "Gain an aura that deals 10 damage per second",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+0.5 Range",
                    " "..enums.CONSTANTS.Color_Conglomerate.."+1 Range{{CR}}",
                },
                {
                    "+3.33%% chance",
                    enums.CONSTANTS.Color_Conglomerate.."+6.67%% chance{{CR}}",
                },
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_SALT,
    Name = "Mantle - Salt",
    Description = {
        "{{Timer}} Gives the effect of a random \"Tears Up\" item for the room",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"a random \"Tears Up\" item", enums.CONSTANTS.Color_Conglomerate.."2 random \"Tears Up\" items{{CR}}"},
                {"the room", enums.CONSTANTS.Color_Conglomerate.."the floor{{CR}}"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "2 HP",
                "\1 +0.33 Tears",
                enums.CONSTANTS.Icon_AtlasSalt .. " {{ColorGray}}Transformation{{CR}}",
                "Press the DROP key to enter or leave \"salt statue\" form",
                "While in this form, you have x2.5 Tears but are immobile",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+0.33 Tears",
                    " "..enums.CONSTANTS.Color_Conglomerate.."+0.67 Tears{{CR}}",
                },
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_GLASS,
    Name = "Mantle - Glass",
    Description = {
        "{{Timer}} For the room:",
        "\1 x1.5 Damage",
        "\2 Damage taken is doubled and increased by 1 extra heart"
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"x1.5 Damage", " "..enums.CONSTANTS.Color_Conglomerate.."x3 Damage{{CR}}"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Taking damage kills you{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "\2 1 HP",
                "\1 +0.5 Damage",
                "\1 +0.1 Shotspeed",
                "!!! Losing a Glass Mantle destroys all other Glass Mantles",
                enums.CONSTANTS.Icon_AtlasGlass .. " {{ColorGray}}Transformation{{CR}}",
                "\1 x1.5 Damage",
                "!!! Taking damage has a 90% chance to destroy all Mantles",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+0.5 Damage",
                    " "..enums.CONSTANTS.Color_Conglomerate.."+1 Damage{{CR}}",
                },
                {
                    "+0.1 Shotspeed",
                    " "..enums.CONSTANTS.Color_Conglomerate.."+0.2 Shotspeed{{CR}}",
                },
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_METAL,
    Name = "Mantle - Metal",
    Description = {
        "{{SoulHeart}} +1 Soul Heart",
        "All of your full Soul/Black Hearts gain a metal shield that blocks 1 damage",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"+1 Soul Heart", " "..enums.CONSTANTS.Color_Conglomerate.."+2 Soul Hearts{{CR}}"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}} "..enums.CONSTANTS.Color_Conglomerate.."Grants a one-use Holy Mantle shield{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "\1 3 HP",
                "\2 -0.1 Speed",
                "+5% chance to block damage",
                enums.CONSTANTS.Icon_AtlasMetal .. " {{ColorGray}}Transformation{{CR}}",
                "+10% chance to block damage",
                "Spike damage is always blocked",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "-0.1 Speed",
                    " "..enums.CONSTANTS.Color_Conglomerate.."-0.2 Speed{{CR}}",
                },
                {
                    "+5%% chance",
                    enums.CONSTANTS.Color_Conglomerate.."+10%% chance{{CR}}",
                },
            }
        },
    }
})
enums.FUNCTIONS.AddCard({
    ID = ToyboxMod.CARD_MANTLE_GOLD,
    Name = "Mantle - Gold",
    Description = {
        "{{Coin}} Removes 1 coin, spawns a random pickup",
        "Only has a 10% chance to be consumed on use",
    },
    Modifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateNoAtlas,
            ToModify = {
                {"10%%", enums.CONSTANTS.Color_Conglomerate.."5%%{{CR}}"},
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                enums.CONSTANTS.Icon_AtlasEmpty .. " {{ColorGray}}As other players{{CR}}",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = ToyboxMod.areAllPlayersAtlasA,
            ToModify = function()
                return ""
            end
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.APPEND_TOP,
            Condition = ToyboxMod.isAnyPlayerAtlasA,
            ToModify = {
                "2 HP",
                "\1 +1 Luck",
                "Losing a Gold Mantle turns nearby enemies to gold",
                enums.CONSTANTS.Icon_AtlasGold .. " {{ColorGray}}Transformation{{CR}}",
                "Tears have a 5% chance to spawn a penny upon hitting an enemy",
                "Losing any Mantle turns nearby enemies to gold",
            },
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            Condition = enums.CONSTANTS.ModifierCondition.CardConglomerateYesAtlas,
            ToModify = {
                {
                    "+1 Luck",
                    " "..enums.CONSTANTS.Color_Conglomerate.."+2 Luck{{CR}}",
                },
            }
        },
    }
})

enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_DYSLEXIA,
    Name = "Dyslexia",
    Description = {
        "{{Timer}} You fire backwards for 30 seconds",
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"backwards", "in random directions"},
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_I_BELIEVE,
    Name = "I Believe I Can Fly!",
    Description = {
        "{{Timer}} Flight for the room",
    },
    HorseModifiers = {
        {
            ToModify = {
                "Invincibility for 7 seconds",
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_DEMENTIA,
    Name = "Dementia",
    Description = {
        "Rerolls the current pill pool",
        "Unidentifies all pills",
    },
    HorseModifiers = {
        {
            ToModify = {
                "The resulting pill pool doesn't contain any neutral effects",
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_PARASITE,
    Name = "Parasite!",
    Description = {
        "Spawns 1 blue fly for every enemy in the room, along with 2 additional blue flies",
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"1 blue fly", "2 blue flies"},
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_OSSIFICATION,
    Name = "Ossification",
    Description = {
        "Turns 1 heart container into an {{EmptyBoneHeart}} empty bone heart",
    },
    HorseModifiers = {
        {
            ToModify = {
                "Turns all heart containers into empty bone hearts",
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_YOUR_SOUL_IS_MINE,
    Name = "Your Soul is Mine",
    Description = {
        "Turns all of your Soul Hearts into {{BlackHeart}} Black Hearts",
        "If you have no Soul Hearts, gives 1 {{BlackHeart}} Black Heart"
    },
    HorseModifiers = {
        {
            ToModify = {
                "+1 {{BlackHeart}} Black Heart",
                "For every Soul Heart converted, spawns a {{Collectible576}} friendly black dip"
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_FOOD_POISONING,
    Name = "Food Poisoning",
    Description = {
        "Spawns a poisonous cloud at your position",
        "The cloud hurts you if you stand in it for too long",
    },
    HorseModifiers = {
        {
            ToModify = {
                "The poisonous cloud is larger and lasts for the rest of the room",
                "Spawns a puddle of green creep that hurts enemies"
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_CAPSULE,
    Name = "Capsule",
    Description = {
        "Gives a random smelted trinket",
    },
    HorseModifiers = {
        {
            ToModify = {
                "The trinket is golden",
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_HEARTBURN,
    Name = "Heartburn",
    Description = {
        "{{Timer}} You are on fire for the next 30 seconds",
        "{{Burning}} While on fire, take damage every second while standing still"
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"every second", "every 0.5 seconds"},
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_COAGULANT,
    Name = "Coagulant",
    Description = {
        "Spawns a blood clot",
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"a blood clot", "3 blood clots"},
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_FENT,
    Name = "Fent",
    Description = {
        "{{Collectible582}} Uses Wavy Cap once",
        "{{Timer}} Grants 7 seconds of invincibility frames"
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"once", "twice"},
                {"7", "14"},
            }
        }
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_ARTHRITIS,
    Name = "Arthritis",
    Description = {
        "{{Timer}} For the next 10 seconds:",
        "Aim is locked to a single direction",
        "\1 x3 Fire rate",
    },
    HorseModifiers = {
        {
            ToModify = {
                "\1 +1.5 Damage",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"10 seconds", "20 seconds"},
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_MUSCLE_ATROPHY,
    Name = "Muscle Atrophy",
    Description = {
        "\2 Damage is set to 0.5 for the next 15 seconds",
    },
    HorseModifiers = {
        {
            ToModify = {
                "\2 Permanent -0.1 flat Damage",
            }
        },
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"15 seconds", "30 seconds"},
            },
        }
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_VITAMINS,
    Name = "Vitamins!",
    Description = {
        "{{Timer}} For the next 24 seconds:",
        "\1 +0.3 Speed",
        "\1 +1 Range",
        "\1 +0.3 Shotspeed",
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.3", "+0.6"},
                {"+1", "+2"},
                {"+0.3", "+0.6"},
            },
        },
        {
            ToModify = {
                "\1 +1 Damage"
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_DMG_UP,
    Name = "Damage Up",
    Description = {
        "\1 +0.5 flat Damage",
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"+0.5", "+1"},
            }
        },
    }
})
enums.FUNCTIONS.AddPill({
    ID = ToyboxMod.PILL_DMG_DOWN,
    Name = "Damage Down",
    Description = {
        "\2 -0.4 flat Damage",
    },
    HorseModifiers = {
        {
            Type = enums.CONSTANTS.DescriptionModifier.REPLACE,
            ToModify = {
                {"-0.4", "-0.8"},
            }
        },
    }
})


enums.FUNCTIONS.AddPlayer({
    ID = ToyboxMod.PLAYER_ATLAS_A,
    Name = "Atlas",
    Description = {
        "Your health is made of \"mantles\" with various effects, which may replace hearts",
        "Having 3 of the same mantle grants a unique transformation until you get a different transformation",
        "While you have no mantles: lose your transformation, have slightly better stats, and die when you take damage",
    },
    BirthrightDescription = {
        "You can have 2 mantle transformations at once",
        "When you get a new transformation, your original one moves to a second slot",
        "While at no mantles, lose both transformations",
    }
})
enums.FUNCTIONS.AddPlayer({
    ID = ToyboxMod.PLAYER_ATLAS_A_TAR,
    Name = "Atlas",
    Description = {
        "Your health is made of \"mantles\" with various effects, which may replace hearts",
        "Having 3 of the same mantle grants a unique transformation, until you get a different transformation",
        "While you have no mantles: lose your transformation, have slightly better stats, and die when you take damage",
    },
    BirthrightDescription = {
        "You can have 2 mantle transformations at once",
        "When you get a new transformation, your original one moves to the second slot",
        "While at no mantles, lose both transformations",
    }
})
enums.FUNCTIONS.AddPlayer({
    ID = ToyboxMod.PLAYER_JONAS_A,
    Name = "Jonas",
    Description = {
        "Enemies may drop pills",
        "Pills give a bonus to all stats",
        "Stat bonus is lost if you go too long without using pills",
        "On new floor, pill pool is rerolled and unidentified, and you lose a fraction of the stat bonus",
    },
    BirthrightDescription = {
        "{{Pill}} Higher chance for enemies to drop a pill",
        "{{Card}} When an enemy drops a pill, 20% chance to turn it into a card/rune",
        "Cards and runes give a stat bonus like pills",
    }
})
enums.FUNCTIONS.AddPlayer({
    ID = ToyboxMod.PLAYER_MILCOM_A,
    Name = "Milcom",
    Description = {
        enums.CONSTANTS.Icon_Ink .. " Coins, Bombs and Keys become Ink when gained, and consume Ink when used:",
        "{{Blank}} {{Coin}}=1"..enums.CONSTANTS.Icon_Ink..", {{Bomb}}=4"..enums.CONSTANTS.Icon_Ink..", {{Key}}=7"..enums.CONSTANTS.Icon_Ink,
        "No room clear rewards",
        "Higher champion chance, champions drop 2-6 Ink",
    },
    BirthrightDescription = {
        enums.CONSTANTS.Icon_Ink .. " Bombs cost 3 Ink",
        enums.CONSTANTS.Icon_Ink .. " Keys cost 5 Ink",
    }
})
enums.FUNCTIONS.AddPlayer({
    ID = ToyboxMod.PLAYER_HOMUNCULUS_A,
    Name = "Homunculus",
    Description = {
        "{{Heart}} While at full red HP, gain the effects of a random item from the current room's item pool",
        "The item is lost when your HP is no longer full, and is different each time you reach full HP",
        "Can pick up red hearts at full red HP to reroll the item"
    },
    BirthrightDescription = {
        "{{SoulHeart}} Soul/Black Hearts count towards having full red HP",
        "Taking damage no longer incurs any penalties, such as losing deal chance",
    }
})



--- CATEGORIES ---

enums.FUNCTIONS.AddCategory({
    Priority = 10,
    ID = "Mantle Hearts",
    ShowInOverview = false,
    Condition = function()
        return ToyboxMod:isAnyPlayerAtlasA()
    end,
    Description = function(player)
        local toreturn = {}

        local data = ToyboxMod:getAtlasATable(player)
        local mantles = data.MANTLES
        local rIdx = ToyboxMod:getRightmostMantleIdx(player)
        for i=1,rIdx do
            if(mantles[i].TYPE~=ToyboxMod.MANTLE_DATA.NONE.ID) then
                local cardSub = -1
                for _, dt in pairs(ToyboxMod.MANTLE_DATA) do
                    if(dt.ID==mantles[i].TYPE) then
                        cardSub = dt.CONSUMABLE_SUBTYPE
                        break
                    end
                end

                if(cardSub~=-1) then
                    local descObj = EID:getDescriptionObj(5,300,cardSub)

                    local desc = descObj.Description
                    local descPreTransf = ""
                    while((string.find(desc, "Transformation") or -1)>(string.find(desc, "#") or -1)) do
                        local hashtagFound = (string.find(desc, "#") or 0)

                        descPreTransf = descPreTransf..string.sub(desc, 1, hashtagFound)
                        desc = string.sub(desc, hashtagFound+1, -1)
                    end
                    descPreTransf = string.sub(descPreTransf, 1, -2)
                    descPreTransf = string.sub(descPreTransf, (string.find(descPreTransf, "#") or 0)+1, -1)

                    table.insert(toreturn, {
                        Icon = "{{Card"..tostring(cardSub).."}}",
                        Title = descObj.Name,
                        Desc = descPreTransf,
                        ObjID = tostring(5)..tostring(300)..tostring(cardSub)
                    })
                end
            end
        end

        return toreturn
    end,
})
enums.FUNCTIONS.AddCategory({
    Priority = 9,
    ID = "Mantle Transformations",
    ShowInOverview = false,
    Condition = function()
        return ToyboxMod:isAnyPlayerAtlasA()
    end,
    Description = function(player)
        local toreturn = {}

        local data = ToyboxMod:getAtlasATable(player)
        local transfToCheck = {"TRANSFORMATION", "BIRTHRIGHT_TRANSFORMATION"}
        for _, tr in ipairs(transfToCheck) do
            if(data[tr]~=ToyboxMod.MANTLE_DATA.NONE.ID) then
                local cardSub = -1
                for _, dt in pairs(ToyboxMod.MANTLE_DATA) do
                    if(dt.ID==data[tr]) then
                        cardSub = dt.CONSUMABLE_SUBTYPE
                        break
                    end
                end

                if(cardSub~=-1) then
                    local descObj = EID:getDescriptionObj(5,300,cardSub)

                    local desc = descObj.Description
                    local descPreTransf = ""
                    while((string.find(desc, "Transformation") or 0)>(string.find(desc, "#") or 0)) do
                        local hashtagFound = (string.find(desc, "#") or 0)
                        desc = string.sub(desc, hashtagFound+1, -1)
                    end

                    local icon = string.sub(desc, 1, (string.find(desc, "}") or 0)+1)
                    desc = string.sub(desc, (string.find(desc, "#") or 0), -1)

                    table.insert(toreturn, {
                        Icon = icon,
                        Title = string.gsub(descObj.Name, "Mantle", "Transformation"),
                        Desc = desc,
                        ObjID = tostring(5)..tostring(300)..tostring(cardSub)
                    })
                end
            end
        end

        return toreturn
    end,
})
enums.FUNCTIONS.AddCategory({
    ID = "Tinted Rooms",
    ShowInOverview = false,
    Condition = function()
        return ToyboxMod:isTintedRoom(ToyboxMod.GAME:GetLevel():GetCurrentRoomIndex())
    end,
    Description = function(player)
        local toreturn = {}

        local tints = ToyboxMod:getTintedRoomTint(ToyboxMod.GAME:GetLevel():GetCurrentRoomIndex())
        local startIdx = (1<<0)

        local presentTints = {}

        while(ToyboxMod.TINTED_ROOM_BITWISE[startIdx]) do
            if(tints & startIdx ~= 0) then
                table.insert(presentTints, ToyboxMod.TINTED_ROOM_BITWISE[startIdx])
            end

            startIdx = (startIdx<<1)
        end

        local finalTintData = {}
        for _, tint in ipairs(presentTints) do
            local descText = enums.MISC.tinted_rooms[tint]


            --local foundPos = string.find(descText, "}") and (string.find(descText, "}")+2) or (string.find(descText, " ")==2 and string.find(descText, " ")) or 0

            local name = string.sub(tint, 1, 1)..string.lower(string.sub(tint, 2, -1))
            local start = ""--string.sub(descText, 1, foundPos)
            local fin = descText--string.sub(descText, foundPos+1, -1)

            local color = "{{ColorObjName}}"
            descText = start..color..name.."{{CR}}".." - "..fin

            table.insert(finalTintData, descText)
        end

        table.insert(toreturn, {
            Icon = "{{Blank}}",
            Title = "",
            Desc = finalTintData,
        })

        return toreturn
    end,
})

--- GLOBALS ---

enums.FUNCTIONS.AddGlobalModifier({
    ID = "AlphabetBox",
    Modifiers = {
        {
            Condition = function(descObj)
                if(not descObj.Entity) then return false end
                if(not (descObj.ObjType==5 and descObj.ObjVariant==100)) then return false end
                if((ToyboxMod.CONFIG.ALPHABETBOX_EID_DISPLAYS or 0)<=0) then return false end

                return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_ALPHABET_BOX)
            end,
            ToModify = function(descObj)
                local boxDesc = "{{Collectible"..ToyboxMod.COLLECTIBLE_ALPHABET_BOX.."}} :"

                local idx = ToyboxMod:getNextAlphabetItem(descObj.ObjSubType, false)
                for i=1, ToyboxMod.CONFIG.ALPHABETBOX_EID_DISPLAYS do
                    if(i~=1) then boxDesc = boxDesc.." -> " end

                    if(idx==-1) then
                        boxDesc = boxDesc.."Item disappears"
                        break
                    else
                        boxDesc = boxDesc.."{{Collectible"..ToyboxMod.ABOX_ITEMS_ALPHABETICAL[idx][2].."}}"
                    end
                    
                    idx = ToyboxMod:getNextAlphabetItem(ToyboxMod.ABOX_ITEMS_ALPHABETICAL[idx][2], false)
                end

                return boxDesc
            end
        }
    }
})
enums.FUNCTIONS.AddGlobalModifier({
    ID = "FoodStamps",
    Modifiers = {
        {
            Condition = function(descObj)
                if(not (descObj.ObjType==5 and descObj.ObjVariant==100)) then return false end
                if(not (ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_BOSS)) then return false end
                if(descObj.Entity and descObj.Entity.ToPickup and descObj.Entity:ToPickup() and descObj.Entity:ToPickup().Touched) then return false end

                return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_FOOD_STAMPS)
            end,
            ToModify = function(descObj)
                local mult = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_FOOD_STAMPS)
                return "#{{Collectible"..ToyboxMod.COLLECTIBLE_FOOD_STAMPS.."}} {{Heart}} +"..tostring(mult).." Health"
            end
        },
        {
            Condition = function(descObj)
                if(not (descObj.ObjType==5 and descObj.ObjVariant==100)) then return false end
                if(descObj.Entity and descObj.Entity.ToPickup and descObj.Entity:ToPickup() and descObj.Entity:ToPickup().Touched) then return false end

                return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_FOOD_STAMPS)
            end,
            ToModify = function(descObj)
                local mult = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_FOOD_STAMPS)
                return "#{{Collectible"..ToyboxMod.COLLECTIBLE_FOOD_STAMPS.."}} {{HealingRed}} Heals "..tostring(mult*3).." hearts"
            end
        },
    }
})
enums.FUNCTIONS.AddGlobalModifier({
    ID = "RETROFALL",
    Modifiers = {
        {
            Condition = function(descObj)
                if(not (descObj.ObjType==5 and descObj.ObjVariant==100)) then return false end
                if(not ToyboxMod:canApplyRetrofall(descObj.ObjSubType)) then return false end

                return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_RETROFALL)
            end,
            ToModify = {
                "{{Collectible"..ToyboxMod.COLLECTIBLE_RETROFALL.."}} Triggers the effect of The D6",
            }
        }
    }
})
--[[]]
enums.FUNCTIONS.AddGlobalModifier({
    ID = "Parasite Modifier",
    Modifiers = {
        {
            Condition = function(descObj)
                if(not (descObj.ObjType==5 and descObj.ObjVariant==100)) then return false end
                
                local ent = descObj.Entity
                if(ent and ent.ToPickup and ToyboxMod:getEntityData(ent, "GRAVEYARD_PARASITE")) then
                    return true
                end
                return false
            end,
            ToModify = function(descObj)
                if(not (descObj.Entity and descObj.Entity.ToPickup)) then return end

                local trinket = ToyboxMod:getEntityData(descObj.Entity, "GRAVEYARD_PARASITE")
                if(trinket) then
                    local desc = EID:getDescriptionObj(5, 350, trinket, nil)

                    --#region VANILLA EID SHIT
                    --Display Itemname
                    local curName = ""
                    if(EID.Config["ShowItemName"] and desc.Name) then
                        curName = desc.Name
                    end
                    -- Display Entity ID
                    if(EID.Config["ShowObjectID"] and desc.ObjType and desc.ObjType > 0) then
                        curName = curName.." {{ColorGray}}"..desc.ObjType.."."..desc.ObjVariant.."."..desc.ObjSubType
                    end
                    -- Display Quality
                    if(EID.Config["ShowQuality"] and desc.Quality) then
                        curName = curName.." - {{Quality"..desc.Quality.."}}"
                    end
                    -- Display Last Pool for Collectible for full reroll effects (icon)
                    if(desc.ItemPoolType and EID.Config["ShowItemPoolIcon"]) then
                        local itemConfig = EID.itemConfig:GetCollectible(desc.ObjSubType)
                        if itemConfig:IsCollectible() and not itemConfig:HasTags(ItemConfig.TAG_QUEST) then
                            if not EID.Config["ShowQuality"] then
                                curName = curName.." - "
                            end
                            curName = curName..""..(EID.ItemPoolTypeToMarkup[desc.ItemPoolType] or "{{ItemPoolUnknown}}")
                        end
                    end
                    -- Display the mod this item is from
                    if(desc.ModName) then
                        curName = curName .. EID:getModNameString(desc)
                    end
                    curName = "{{ColorObjName}}"..curName.."{{CR}}"
                    if(EID.Config["ShowItemIcon"]) then
                        curName = "{{Trinket"..(trinket & ~TrinketType.TRINKET_GOLDEN_FLAG).."}} "..curName
                    end
                    local formatted = curName.."#"

                    if(desc.Transformation and not (desc.Transformation == "0" or desc.Transformation == "")) then
                        for transform in (string.gmatch(desc.Transformation, "([^,]+)")) do
                            formatted = formatted.."{{Blank}} "
                            --have a blank sprite info table if we aren't displaying it
                            local transformIcon = ""
                            if(EID.Config["TransformationIcons"]) then
                                local str = transform
                                if(tonumber(str)~=nil) then
                                    str = EID.descriptions[EID.DefaultLanguageCode].transformations[tonumber(str + 1)]
                                end
                                str = string.gsub(str, " ", "")
                                transformIcon = EID:getIcon(str) and "{{"..str.."}}" or "{{CustomTransformation}}"
                                formatted = formatted..transformIcon
                            end
                            if EID.Config["TransformationText"] or EID.Config["TransformationProgress"] then
                                formatted = formatted.."{{ColorTransform}}"
                                local transformationName = ""
                                if EID.Config["TransformationText"] then
                                    transformationName = EID:getTransformationName(transform)
                                end
                                if EID.Config["TransformationProgress"] then
                                    EID:evaluateTransformationProgress(transform)
                                    transformationName = transformationName .. " "
                                    for _, player in ipairs(EID.coopAllPlayers) do
                                        local playerType = player:GetPlayerType()
                                        if playerType ~= PlayerType.PLAYER_THESOUL_B and player:GetBabySkin() == -1 then
                                            if #EID.coopAllPlayers > 1 then
                                                transformationName = transformationName .. EID:GetPlayerIcon(playerType)
                                            end
                                            local numCollected = EID.TransformationProgress[EID:getPlayerID(player, true)] and EID.TransformationProgress[EID:getPlayerID(player, true)][transform] or 0
                                            local numMax = EID.TransformationData[transform] and EID.TransformationData[transform].NumNeeded or 3
                                            transformationName = transformationName.."("..numCollected.."/"..numMax..") "
                                        end
                                    end
                                end
                                formatted = formatted.."{{ColorTransform}}"..transformationName.."{{CR}}"
                            end
                            formatted = formatted.."#"
                        end
                    end
                    --#endregion
                    
                    local formatDesc = enums.FUNCTIONS.StringTableToDescription(desc.Description)
                    formatted = formatted..formatDesc

                    return "#"..formatted
                end

                return ""
            end
        }
    }
})
--]]

--- JOKES ---

enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_CURSED_D6,
    Name = "Cursed D6",
    Description = {
        "{{Quality4}} Can reroll items into Q4",
        "{{Quality0}} but can also reroll into Q0",
        "{{BrokenHeart}} or give a broken heart",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SUPER_HAMBURGER,
    Name = "Super Hamburger",
    Description = {
        "{{Heart}} +50 Health",
        "\2 -2 Speed",
        "Makes you big and fat",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_URANIUM,
    Name = "Uranium",
    Description = {
        "Nearby rocks are irradiated and will destroy after a short duration",
        "Nearby enemies are poisoned",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_ZERO_GRAVITY,
    Name = "Zero-Gravity",
    Description = {
        "\1 +1.5 Damage",
        "You move on a 2 second delay",
        "Releasing movement buttons makes you instantly teleport to the desired position"
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_PORTABLE_TELLER,
    Name = "Portable Teller",
    Description = {
        "{{Coin}} Spend 1 coin to display a fortune or a chance to spawn a trinket, card or soul heart",
    },
})
enums.FUNCTIONS.AddItem({
    ID = ToyboxMod.COLLECTIBLE_SO_MANY_OPTIONS,
    Name = "So Many Options",
    Description = {
        "All enemies spawn as a choice between the original enemy and a random enemy with a similar amount of HP",
        "Enemies are frozen until Isaac makes the choice by damaging one of the 2 enemies"
    },
})

enums.MISC.death_sacrifice = {
    {
        "{{Coin}} 67% chance for a coin",
        "{{SoulHeart}} 33% chance for a Soul Heart",
    },
    {
        "{{Coin}} 20% chance for 1-3 coins",
        "{{Key}} 40% chance for 1 key",
        "{{Bomb}} 40% chance for 1 bomb",
    },
    {
        "{{GrabBag}} 100% chance for a sack",
    },
    {
        "\1 Permanent increase to a random stat",
    },
    {
        "33% chance for 3 random pickups",
        "{{Chest}} 67% chance for a chest",
    },
    {
        "{{Card}} 50% chance for a random card",
        "{{Rune}} 50% chance for a random rune or soul stone",
    },
    {
        "{{GoldenChest}} 75% chance for a locked chest",
        "{{Chest}} 25% chance for a chest"
    },
    {
        "\1 Permanent increase to a random stat",
    },
}
enums.MISC.death_sacrifice_endless = {
    {
        "{{GoldenChest}} 25% chance for a locked chest",
        "50% chance for 3 random non-heart pickups",
        "{{SoulHeart}} 25% chance for a Soul Heart",
    },
    {
        "\1 Permanent increase to a random stat",
    },
}

enums.MISC.tinted_rooms = {
    RED = "\1 +1.2 Damage",
    BLUE = "\1 +1 Tears",
    GREEN = "\1 +5 Luck",
    YELLOW = "On death, enemies drop coins that disappear",
    PURPLE = "{{Collectible3}} Homing shots",
    CYAN = "Every 2 seconds, spawn 1 blue fly, up to 3",
    WHITE = "{{Collectible108}} Wafer effect",
    BLACK = "Room clear effects are triggered 2 additional times",

    BROWN = "\1 Major size down",
    PINK = "On death, enemies have a 15% chance to respawn as a friendly copy",
}