-- DemonHunterHavoc.lua
-- October 2022

if UnitClassBase( "player" ) ~= "DEMONHUNTER" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local strformat = string.format

local spec = Hekili:NewSpecialization( 577 )

spec:RegisterResource( Enum.PowerType.Fury, {
    -- Immolation Aura now grants 20 up front, 60 over 12 seconds (5 fps).
    immolation_aura = {
        talent  = "burning_hatred",
        aura    = "immolation_aura",

        last = function ()
            local app = state.buff.immolation_aura.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = 1,
        value = 5
    },

    tactical_retreat = {
        talent  = "tactical_retreat",
        aura    = "tactical_retreat",

        last = function ()
            local app = state.buff.tactical_retreat.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = function() return class.auras.tactical_retreat.tick_time end,
        value = 8
    },

    eye_beam = {
        talent = "blind_fury",
        aura   = "eye_beam",

        last = function ()
            local app = state.buff.eye_beam.applied
            local t = state.query_time

            return app + floor( ( t - app ) / state.haste ) * state.haste
        end,

        interval = function () return state.haste end,
        value = 20,
    },
} )

-- Talents
spec:RegisterTalents( {
    -- Demon Hunter
    aldrachi_design          = { 90999, 391409, 1 }, -- Increases your chance to parry by 3%.
    aura_of_pain             = { 90932, 207347, 1 }, -- Increases the critical strike chance of Immolation Aura by 6%.
    blazing_path             = { 91008, 320416, 1 }, -- Fel Rush gains an additional charge.
    bouncing_glaives         = { 90931, 320386, 1 }, -- Throw Glaive ricochets to 1 additional target.
    chaos_fragments          = { 90992, 320412, 1 }, -- Each enemy stunned by Chaos Nova has a 30% chance to generate a Lesser Soul Fragment.
    chaos_nova               = { 90993, 179057, 1 }, -- Unleash an eruption of fel energy, dealing 2,211 Chaos damage and stunning all nearby enemies for 2 sec.
    charred_warblades        = { 90948, 213010, 1 }, -- You heal for 3% of all Fire damage you deal.
    collective_anguish       = { 90995, 390152, 1 }, -- Eye Beam summons an allied Vengeance Demon Hunter who casts Fel Devastation, dealing 11,716 Fire damage over 2 sec. Dealing damage heals you for up to 1,268 health.
    concentrated_sigils      = { 90944, 207666, 1 }, -- All Sigils are now placed at your location, and the duration of their effects is increased by 2 sec.
    consume_magic            = { 91006, 278326, 1 }, -- Consume 1 beneficial Magic effect removing it from the target.
    darkness                 = { 91002, 196718, 1 }, -- Summons darkness around you in an 8 yd radius, granting friendly targets a 20% chance to avoid all damage from an attack. Lasts 8 sec.
    demon_muzzle             = { 90928, 388111, 1 }, -- Enemies deal 8% reduced magic damage to you for 8 sec after being afflicted by one of your Sigils.
    demonic                  = { 91003, 213410, 1 }, -- Eye Beam causes you to enter demon form for 6 sec after it finishes dealing damage.
    disrupting_fury          = { 90937, 183782, 1 }, -- Disrupt generates 30 Fury on a successful interrupt.
    erratic_felheart         = { 90996, 391397, 2 }, -- The cooldown of Fel Rush is reduced by 10%.
    extended_sigils          = { 90998, 389697, 2 }, -- Increases the duration of Sigil effects by 1.0 sec.
    felblade                 = { 90932, 232893, 1 }, -- Charge to your target and deal 6,539 Fire damage. Demon Blades has a chance to reset the cooldown of Felblade. Generates 40 Fury.
    felfire_haste            = { 90939, 389846, 1 }, -- Fel Rush increases your movement speed by 10% for 8 sec.
    first_of_the_illidari    = { 91003, 235893, 1 }, -- Metamorphosis grants 10% versatility and its cooldown is reduced by 60 sec.
    flames_of_fury           = { 90949, 389694, 1 }, -- Sigil of Flame generates 2 additional Fury per target hit.
    illidari_knowledge       = { 90935, 389696, 2 }, -- Reduces magic damage taken by 2%.
    imprison                 = { 91007, 217832, 1 }, -- Imprisons a demon, beast, or humanoid, incapacitating them for 1 min. Damage will cancel the effect. Limit 1.
    improved_disrupt         = { 90938, 320361, 1 }, -- Increases the range of Disrupt to 10 yds.
    improved_sigil_of_misery = { 90945, 320418, 1 }, -- Reduces the cooldown of Sigil of Misery by 30 sec.
    infernal_armor           = { 91004, 320331, 2 }, -- Immolation Aura increases your armor by 10% and causes melee attackers to suffer $320334s1/$s3${$320334s1/$s3} Fire damage.
    internal_struggle        = { 90934, 393822, 1 }, -- Increases your mastery by 3.6%.
    long_night               = { 91001, 389781, 1 }, -- Increases the duration of Darkness by 3 sec.
    lost_in_darkness         = { 90947, 389849, 1 }, -- Spectral Sight lasts an additional 6 sec if disrupted by attacking or taking damage.
    master_of_the_glaive     = { 90994, 389763, 1 }, -- Throw Glaive has 2 charges, and snares all enemies hit by 50% for 6 sec.
    misery_in_defeat         = { 90945, 388110, 1 }, -- You deal 20% increased damage to enemies for 5 sec after Sigil of Misery's effect on them ends.
    pitch_black              = { 91001, 389783, 1 }, -- Reduces the cooldown of Darkness by 120 sec.
    precise_sigils           = { 90944, 389799, 1 }, -- All Sigils are now placed at your target's location, and the duration of their effects is increased by 2 sec.
    pursuit                  = { 90940, 320654, 1 }, -- Mastery increases your movement speed.
    quickened_sigils         = { 90997, 209281, 1 }, -- All Sigils activate 1 second faster, and their cooldowns are reduced by 20%.
    relentless_pursuit       = { 90926, 389819, 1 }, -- The cooldown of The Hunt is reduced by 12 sec whenever an enemy is killed while afflicted by its damage over time effect.
    rush_of_chaos            = { 90933, 320421, 1 }, -- Reduces the cooldown of Metamorphosis by 60 sec.
    shattered_restoration    = { 90950, 389824, 2 }, -- The healing of Shattered Souls is increased by 5%.
    sigil_of_misery          = { 90946, 207684, 1 }, -- Place a Sigil of Misery at the target location that activates after 2 sec. Causes all enemies affected by the sigil to cower in fear, disorienting them for 22 sec.
    soul_rending             = { 90936, 204909, 2 }, -- Leech increased by 5%. Gain an additional 5% leech while Metamorphosis is active.
    soul_sigils              = { 90929, 395446, 1 }, -- Afflicting an enemy with a Sigil generates 1 Lesser Soul Fragment.
    swallowed_anger          = { 91005, 320313, 1 }, -- Consume Magic generates 20 Fury when a beneficial Magic effect is successfully removed from the target.
    the_hunt                 = { 90927, 370965, 1 }, -- Charge to your target, striking them for 24,488 Nature damage, rooting them in place for 1.5 sec and inflicting 26,387 Nature damage over 6 sec to up to 5 enemies in your path. The pursuit invigorates your soul, healing you for 10% of the damage you deal to your Hunt target for 20 sec.
    unleashed_power          = { 90992, 206477, 1 }, -- Reduces the Fury cost of Chaos Nova by 50% and its cooldown by 20%.
    unnatural_malice         = { 90926, 389811, 1 }, -- Increase the damage over time effect of The Hunt by 30%.
    unrestrained_fury        = { 90941, 320770, 2 }, -- Increases maximum Fury by 10.
    vengeful_bonds           = { 90930, 320635, 1 }, -- Vengeful Retreat reduces the movement speed of all nearby enemies by 70% for 3 sec.
    will_of_the_illidari     = { 91000, 389695, 2 }, -- Increases maximum health by 2%.

    -- Havoc
    accelerated_blade        = { 91011, 391275, 1 }, -- Throw Glaive deals 60% increased damage, reduced by 30% for each previous enemy hit.
    any_means_necessary      = { 90919, 388114, 1 }, -- Mastery: Demonic Presence now also causes your Arcane, Fire, Frost, Nature, and Shadow damage to be dealt as Chaos instead, and increases that damage by 29.5%.
    blind_fury               = { 91026, 203550, 2 }, -- Eye Beam generates 20 Fury every second, and its damage and duration are increased by 10%.
    burning_hatred           = { 90923, 320374, 1 }, -- Immolation Aura generates an additional 60 Fury over 12 sec.
    burning_wound            = { 90917, 391189, 1 }, -- Demon Blades and Throw Glaive leave open wounds on your enemies, dealing 5,909 Chaos damage over 15 sec and increasing damage taken from your Immolation Aura by 40%. May be applied to up to 3 targets.
    chaos_theory             = { 91035, 389687, 1 }, -- Blade Dance causes your next Chaos Strike within 8 sec to have a 14-30% increased critical strike chance and will always refund Fury.
    chaotic_transformation   = { 90922, 388112, 1 }, -- When you activate Metamorphosis, the cooldowns of Blade Dance and Eye Beam are immediately reset.
    critical_chaos           = { 91028, 320413, 2 }, -- The chance that Chaos Strike will refund 20 Fury is increased by 25% of your critical strike chance.
    cycle_of_hatred          = { 91032, 258887, 2 }, -- Blade Dance, Chaos Strike, and Glaive Tempest reduce the cooldown of Eye Beam by 0.5 sec.
    dancing_with_fate        = { 91015, 389978, 2 }, -- The final slash of Blade Dance deals an additional 20% damage.
    demon_blades             = { 91019, 203555, 1 }, -- Your auto attacks deal an additional 992 Shadow damage and generate 7-12 Fury.
    demonic_appetite         = { 90914, 206478, 1 }, -- Chaos Strike has a chance to spawn a Lesser Soul Fragment. Consuming any Soul Fragment grants 30 Fury.
    desperate_instincts      = { 93016, 205411, 1 }, -- Blur now reduces damage taken by an additional 10%. Additionally, you automatically trigger Blur with 50% reduced cooldown and duration when you fall below 35% health. This effect can only occur when Blur is not on cooldown.
    elysian_decree           = { 91010, 390163, 1 }, -- Place a Kyrian Sigil at the target location that activates after 2 sec. Detonates to deal 22,591 Arcane damage and shatter up to 3 Lesser Soul Fragments from enemies affected by the sigil. Deals reduced damage beyond 5 targets.
    essence_break            = { 91033, 258860, 1 }, -- Slash all enemies in front of you for 22,729 Chaos damage, and increase the damage your Chaos Strike and Blade Dance deal to them by 80% for 4 sec. Deals reduced damage beyond 8 targets.
    eye_beam                 = { 91018, 198013, 1 }, -- Blasts all enemies in front of you, dealing guaranteed critical strikes for up to 46,070 Chaos damage over 1.9 sec. Deals reduced damage beyond 5 targets. When Eye Beam finishes fully channeling, your Haste is increased by an additional 10% for 10 sec.
    fel_barrage              = { 91023, 258925, 1 }, -- Unleash a torrent of Fel energy over 3 sec, inflicting 37,847 Chaos damage to all enemies within 8 yds. Deals reduced damage beyond 8 targets.
    fel_eruption             = { 93015, 211881, 1 }, -- Impales the target for 2,978 Chaos damage and stuns them for 4 sec.
    felfire_heart            = { 91017, 388109, 1 }, -- Increases duration of Immolation Aura and Sigil of Flame by 2 sec.
    first_blood              = { 90925, 206416, 1 }, -- Blade Dance deals 17,893 Chaos damage to the first target struck.
    fodder_to_the_flame      = { 91010, 391429, 1 }, -- Your damaging abilities have a chance to call forth a condemned demon for 25 sec. Throw Glaive deals lethal damage to the demon, which explodes on death, dealing 12,790 Shadow damage to nearby enemies and healing you for 20% of your maximum health. The explosion deals reduced damage beyond 5 targets.
    furious_gaze             = { 91025, 343311, 1 }, -- When Eye Beam finishes fully channeling, your Haste is increased by an additional 10% for 10 sec.
    furious_throws           = { 93013, 393029, 1 }, -- Throw Glaive now costs 25 Fury and throws a second glaive at the target.
    glaive_tempest           = { 91023, 342817, 1 }, -- Launch two demonic glaives in a whirlwind of energy, causing 21,027 Chaos damage over 3 sec to all nearby enemies. Deals reduced damage beyond 5 targets.
    growing_inferno          = { 90916, 390158, 2 }, -- Immolation Aura's damage increases by 5% each time it deals damage.
    improved_chaos_strike    = { 91030, 343206, 1 }, -- Chaos Strike damage increased by 10%.
    improved_fel_rush        = { 93014, 343017, 1 }, -- Fel Rush damage increased by 20%.
    initiative               = { 91027, 388108, 1 }, -- Damaging an enemy before they damage you increases your critical strike chance by 12% for 5 sec. Using Vengeful Retreat refreshes your potential to activate this effect on any enemies you are in combat with.
    inner_demon              = { 91009, 389693, 1 }, -- Entering demon form causes your next Chaos Strike to unleash your inner demon, causing it to crash into your target and deal 17,137 Chaos damage to all nearby enemies.
    insatiable_hunger        = { 91019, 258876, 1 }, -- Demon's Bite deals 50% more damage and generates 5 to 10 additional Fury.
    isolated_prey            = { 91036, 388113, 1 }, -- Chaos Nova, Eye Beam, and Fel Rush gain bonuses when striking 1 target.  Chaos Nova: Stun duration increased by 2 sec.  Eye Beam: Deals 30% increased damage.  Fel Rush: Generates 25-35 Fury.
    know_your_enemy          = { 91034, 388118, 2 }, -- Gain critical strike damage equal to 40% of your critical strike chance.
    looks_can_kill           = { 90921, 320415, 1 }, -- Eye Beam deals guaranteed critical strikes.
    momentum                 = { 91021, 206476, 1 }, -- Fel Rush, The Hunt, and Vengeful Retreat increase your damage done by 8% for 5 sec.
    mortal_dance             = { 90924, 328725, 1 }, -- Blade Dance now reduces targets' healing received by 50% for 6 sec.
    netherwalk               = { 93016, 196555, 1 }, -- Slip into the nether, increasing movement speed by 100% and becoming immune to damage, but unable to attack. Lasts 6 sec.
    ragefire                 = { 90918, 388107, 1 }, -- Each time Immolation Aura deals damage, 35% of the damage dealt by up to 3 critical strikes is gathered as Ragefire. When Immolation Aura expires you explode, dealing all stored Ragefire damage to nearby enemies.
    relentless_onslaught     = { 91012, 389977, 1 }, -- Chaos Strike has a 10% chance to trigger a second Chaos Strike.
    restless_hunter          = { 91024, 390142, 1 }, -- Leaving demon form grants a charge of Fel Rush and increases the damage of your next Blade Dance by 50%.
    serrated_glaive          = { 91013, 390154, 2 }, -- Enemies hit by Throw Glaive take 10% increased damage from Chaos Strike and Eye Beam.
    shattered_destiny        = { 91031, 388116, 1 }, -- The duration of your active demon form is extended by 0.1 sec per 8 Fury spent.
    sigil_of_flame           = { 90943, 204596, 1 }, -- Place a Sigil of Flame at the target location that activates after 2 sec. Deals 1,074 Fire damage, and an additional 5,043 Fire damage over 10 sec, to all enemies affected by the sigil. Generates 30 Fury.
    soulrend                 = { 90920, 388106, 2 }, -- Throw Glaive causes targets to take an additional 60% of damage dealt as Chaos over 6 sec.
    tactical_retreat         = { 91022, 389688, 1 }, -- Vengeful Retreat has a 5 sec reduced cooldown and generates 80 Fury over 10 sec.
    trail_of_ruin            = { 90915, 258881, 1 }, -- The final slash of Blade Dance inflicts an additional 5,789 Chaos damage over 4 sec.
    unbound_chaos            = { 91020, 347461, 2 }, -- Activating Immolation Aura increases the damage of your next Fel Rush by 250%. Lasts 12 sec.
    vengeful_retreat         = { 90942, 198793, 1 }, -- Remove all snares and vault away. Nearby enemies take 942 Physical damage.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    blood_moon        = 5433, -- (355995) Consume Magic now affects all enemies within 8 yards of the target and generates a Lesser Soul Fragment. Each effect consumed has a 5% chance to upgrade to a Greater Soul.
    chaotic_imprint   = 809 , -- (356510) Throw Glaive now deals damage from a random school of magic, and increases the target's damage taken from the school by 10% for 20 sec.
    cleansed_by_flame = 805 , -- (205625) Immolation Aura dispels all magical effects on you when cast.
    cover_of_darkness = 1206, -- (357419) The radius of Darkness is increased by 4 yds, and its duration by 2 sec.
    detainment        = 812 , -- (205596) Imprison's PvP duration is increased by 1 sec, and targets become immune to damage and healing while imprisoned.
    glimpse           = 813 , -- (354489) Vengeful Retreat provides immunity to loss of control effects, and reduces damage taken by 35% until you land.
    rain_from_above   = 811 , -- (206803) You fly into the air out of harm's way. While floating, you gain access to Fel Lance allowing you to deal damage to enemies below.
    reverse_magic     = 806 , -- (205604) Removes all harmful magical effects from yourself and all nearby allies within 10 yards, and sends them back to their original caster if possible.
    sigil_mastery     = 5523, -- (211489) Reduces the cooldown of your Sigils by an additional 25%.
    unending_hatred   = 1218, -- (213480) Taking damage causes you to gain Fury based on the damage dealt.
} )


-- Auras
spec:RegisterAuras( {
    -- Dodge chance increased by $s2%.
    -- https://wowhead.com/beta/spell=188499
    blade_dance = {
        id = 188499,
        duration = 1,
        max_stack = 1
    },
    blazing_slaughter = {
        id = 355892,
        duration = 12,
        max_stack = 20,
    },
    -- Versatility increased by $w1%.
    -- https://wowhead.com/beta/spell=355894
    blind_faith = {
        id = 355894,
        duration = 20,
        max_stack = 1
    },
    -- Dodge increased by $s2%. Damage taken reduced by $s3%.
    -- https://wowhead.com/beta/spell=212800
    blur = {
        id = 212800,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Taking $w1 Chaos damage every $t1 seconds.  Damage taken from $@auracaster's Immolation Aura increased by $s2%.
    -- https://wowhead.com/beta/spell=391191
    burning_wound_391191 = {
        id = 391191,
        duration = 15,
        tick_time = 3,
        max_stack = 1,
    },
    burning_wound_346278 = {
        id = 346278,
        duration = 15,
        tick_time = 3,
        max_stack = 1,
    },
    burning_wound = {
        alias = { "burning_wound_391191", "burning_wound_346278" },
        aliasMode = "first",
        aliasType = "buff",
    },
    -- Talent: Stunned.
    -- https://wowhead.com/beta/spell=179057
    chaos_nova = {
        id = 179057,
        duration = function () return talent.isolated_prey.enabled and active_enemies == 1 and 4 or 2 end,
        type = "Magic",
        max_stack = 1
    },
    chaos_theory = {
        id = 390195,
        duration = 8,
        max_stack = 1,
    },
    chaotic_blades = {
        id = 337567,
        duration = 8,
        max_stack = 1
    },
    darkness = {
        id = 196718,
        duration = function () return pvptalent.cover_of_darkness.enabled and 10 or 8 end,
        max_stack = 1,
    },
    death_sweep = {
        id = 210152,
        duration = 1,
        max_stack = 1,
    },
    demon_soul = {
        id = 347765,
        duration = 15,
        max_stack = 1,
    },
    elysian_decree = { -- TODO: This aura determines sigil pop time.
        id = 390163,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1
    },
    essence_break = {
        id = 320338,
        duration = 4,
        max_stack = 1,
        copy = "dark_slash" -- Just in case.
    },
    -- https://wowhead.com/beta/spell=198013
    eye_beam = {
        id = 198013,
        duration = function () return 2 * ( 1 + 0.1 * talent.blind_fury.rank ) * haste end,
        generate = function( t )
            if buff.casting.up and buff.casting.v1 == 198013 then
                t.applied  = buff.casting.applied
                t.duration = buff.casting.duration
                t.expires  = buff.casting.expires
                t.stack    = 1
                t.caster   = "player"
                forecastResources( "fury" )
                return
            end

            t.applied  = 0
            t.duration = class.auras.eye_beam.duration
            t.expires  = 0
            t.stack    = 0
            t.caster   = "nobody"
        end,
        tick_time = 0.2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Unleashing Fel.
    -- https://wowhead.com/beta/spell=258925
    fel_barrage = {
        id = 258925,
        duration = 3,
        tick_time = 0.25,
        max_stack = 1
    },
    -- Legendary.
    fel_bombardment = {
        id = 337849,
        duration = 40,
        max_stack = 5,
    },
    -- Legendary
    fel_devastation = {
        id = 333105,
        duration = 2,
        max_stack = 1,
    },
    furious_gaze = {
        id = 343312,
        duration = 12,
        max_stack = 1,
    },
    -- Talent: Stunned.
    -- https://wowhead.com/beta/spell=211881
    fel_eruption = {
        id = 211881,
        duration = 4,
        max_stack = 1
    },
    -- Talent: Movement speed increased by $w1%.
    -- https://wowhead.com/beta/spell=389847
    felfire_haste = {
        id = 389847,
        duration = 8,
        max_stack = 1,
        copy = 338804
    },
    -- Branded, dealing $204021s1% less damage to $@auracaster$?s389220[ and taking $w2% more Fire damage from them][].
    -- https://wowhead.com/beta/spell=207744
    fiery_brand = {
        id = 207744,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Battling a demon from the Theater of Pain...
    -- https://wowhead.com/beta/spell=391430
    fodder_to_the_flame = {
        id = 391430,
        duration = function () return 30 + ( conduit.brooding_pool.mod * 0.001 ) end,
        max_stack = 1,
        copy = 330910
    },
    -- The demon is linked to you.
    fodder_to_the_flame_chase = {
        id = 328605,
        duration = 3600,
        max_stack = 1,
    },
    -- This is essentially the countdown before the demon despawns (you can Imprison it for a long time).
    fodder_to_the_flame_cooldown = {
        id = 342357,
        duration = 120,
        max_stack = 1,
    },
    -- Falling speed reduced.
    -- https://wowhead.com/beta/spell=131347
    glide = {
        id = 131347,
        duration = 3600,
        max_stack = 1
    },
    -- Burning nearby enemies for $258922s1 $@spelldesc395020 damage every $t1 sec.$?a207548[    Movement speed increased by $w4%.][]$?a320331[    Armor increased by $w5%. Attackers suffer $@spelldesc395020 damage.][]
    -- https://wowhead.com/beta/spell=258920
    immolation_aura = {
        id = 258920,
        duration = function() return talent.felfire_heart.enabled and 8 or 6 end,
        tick_time = 1,
        max_stack = 1
    },
    -- Talent: Incapacitated.
    -- https://wowhead.com/beta/spell=217832
    imprison = {
        id = 217832,
        duration = 60,
        mechanic = "sap",
        type = "Magic",
        max_stack = 1
    },
    initiative = {
        id = 391215,
        duration = 5,
        max_stack = 1,
    },
    inner_demon = {
        id = 337313,
        duration = 10,
        max_stack = 1,
        copy = 390145
    },
    -- Talent: Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=213405
    master_of_the_glaive = {
        id = 213405,
        duration = 6,
        mechanic = "snare",
        max_stack = 1
    },
    -- Chaos Strike and Blade Dance upgraded to $@spellname201427 and $@spellname210152.  Haste increased by $w4%.$?s235893[  Versatility increased by $w5%.][]$?s204909[  Leech increased by $w3%.][]
    -- https://wowhead.com/beta/spell=162264
    metamorphosis = {
        id = 162264,
        duration = function () return 24 + ( pvptalent.demonic_origins.enabled and -15 or 0 ) end,
        max_stack = 1,
        meta = {
            extended_by_demonic = function ()
                return false -- disabled in 8.0:  talent.demonic.enabled and ( buff.metamorphosis.up and buff.metamorphosis.duration % 15 > 0 and buff.metamorphosis.duration > ( action.eye_beam.cast + 8 ) )
            end,
        },
    },
    momentum = {
        id = 208628,
        duration = 5,
        max_stack = 1,
    },
    -- Stunned.
    -- https://wowhead.com/beta/spell=200166
    metamorphosis_stun = {
        id = 200166,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    -- Dazed.
    -- https://wowhead.com/beta/spell=247121
    metamorphosis_daze = {
        id = 247121,
        duration = 3,
        type = "Magic",
        max_stack = 1
    },
    misery_in_defeat = {
        id = 391369,
        duration = 5,
        max_stack = 1,
    },
    -- Talent: Healing effects received reduced by $w1%.
    -- https://wowhead.com/beta/spell=356608
    mortal_dance = {
        id = 356608,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Immune to damage and unable to attack.  Movement speed increased by $s3%.
    -- https://wowhead.com/beta/spell=196555
    netherwalk = {
        id = 196555,
        duration = 6,
        max_stack = 1
    },
    ragefire = {
        id = 390192,
        duration = 30,
        max_stack = 1,
    },
    rain_from_above_immune = {
        id = 206803,
        duration = 1,
        tick_time = 1,
        max_stack = 1,
        copy = "rain_from_above_launch"
    },
    rain_from_above = { -- Gliding/floating.
        id = 206804,
        duration = 10,
        max_stack = 1
    },
    restless_hunter = {
        id = 390212,
        duration = 12,
        max_stack = 1
    },
    serrated_glaive = {
        id = 390155,
        duration = 15,
        max_stack = 1
    },
    -- Movement slowed by $s1%.
    -- https://wowhead.com/beta/spell=204843
    sigil_of_chains = {
        id = 204843,
        duration = function() return 6 + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Suffering $w2 $@spelldesc395020 damage every $t2 sec.
    -- https://wowhead.com/beta/spell=204598
    sigil_of_flame_dot = {
        id = 204598,
        duration = function() return ( talent.felfire_heart.enabled and 8 or 6 ) + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Sigil of Flame is active.
    -- https://wowhead.com/beta/spell=389810
    sigil_of_flame = {
        id = 389810,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1,
        copy = 204596
    },
    -- Talent: Disoriented.
    -- https://wowhead.com/beta/spell=207685
    sigil_of_misery_debuff = {
        id = 207685,
        duration = function() return 20 + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        mechanic = "flee",
        type = "Magic",
        max_stack = 1
    },
    sigil_of_misery = { -- TODO: Model placement pop.
        id = 207684,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1
    },
    -- Silenced.
    -- https://wowhead.com/beta/spell=204490
    sigil_of_silence_debuff = {
        id = 204490,
        duration = function() return 6 + talent.extended_sigils.rank + ( talent.precise_sigils.enabled and 2 or 0 ) end,
        type = "Magic",
        max_stack = 1
    },
    sigil_of_silence = { -- TODO: Model placement pop.
        id = 202137,
        duration = function () return talent.quickened_sigils.enabled and 1 or 2 end,
        max_stack = 1
    },
    -- Consume to heal for $210042s1% of your maximum health.
    -- https://wowhead.com/beta/spell=203795
    soul_fragment = {
        id = 203795,
        duration = 20,
        max_stack = 1
    },
    -- Talent: Suffering $w1 Chaos damage every $t1 sec.
    -- https://wowhead.com/beta/spell=390181
    soulrend = {
        id = 390181,
        duration = 6,
        tick_time = 2,
        max_stack = 1
    },
    -- Can see invisible and stealthed enemies.  Can see enemies and treasures through physical barriers.
    -- https://wowhead.com/beta/spell=188501
    spectral_sight = {
        id = 188501,
        duration = 10,
        max_stack = 1
    },
    tactical_retreat = {
        id = 389890,
        duration = 8,
        tick_time = 1,
        max_stack = 1
    },
    -- Talent: Suffering $w1 $@spelldesc395042 damage every $t1 sec.
    -- https://wowhead.com/beta/spell=345335
    the_hunt_dot = {
        id = 370969,
        duration = 6,
        tick_time = 2,
        type = "Magic",
        max_stack = 1,
        copy = 345335
    },
    -- Talent: Marked by the Demon Hunter, converting $?c1[$345422s1%][$345422s2%] of the damage done to healing.
    -- https://wowhead.com/beta/spell=370966
    the_hunt = {
        id = 370966,
        duration = 30,
        max_stack = 1,
        copy = 323802
    },
    the_hunt_root = {
        id = 370970,
        duration = 1.5,
        max_stack = 1,
        copy = 323996
    },
    -- Taunted.
    -- https://wowhead.com/beta/spell=185245
    torment = {
        id = 185245,
        duration = 3,
        max_stack = 1
    },
    -- Talent: Suffering $w1 Chaos damage every $t1 sec.
    -- https://wowhead.com/beta/spell=258883
    trail_of_ruin = {
        id = 258883,
        duration = 4,
        tick_time = 1,
        type = "Magic",
        max_stack = 1
    },
    unbound_chaos = {
        id = 347462,
        duration = 20,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=198813
    vengeful_retreat = {
        id = 198813,
        duration = 3,
        max_stack = 1,
        copy = "vengeful_retreat_snare"
    },

    -- Conduit
    exposed_wound = {
        id = 339229,
        duration = 10,
        max_stack = 1,
    },

    -- PvP Talents
    chaotic_imprint_shadow = {
        id = 356656,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_nature = {
        id = 356660,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_arcane = {
        id = 356658,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_fire = {
        id = 356661,
        duration = 20,
        max_stack = 1,
    },
    chaotic_imprint_frost = {
        id = 356659,
        duration = 20,
        max_stack = 1,
    },
    -- Conduit
    demonic_parole = {
        id = 339051,
        duration = 12,
        max_stack = 1
    },
    glimpse = {
        id = 354610,
        duration = 8,
        max_stack = 1,
    },
} )


local sigils = setmetatable( {}, {
    __index = function( t, k )
        t[ k ] = 0
        return t[ k ]
    end
} )

spec:RegisterStateFunction( "create_sigil", function( sigil )
    sigils[ sigil ] = query_time + ( talent.quickened_sigils.enabled and 1 or 2 )
end )

spec:RegisterStateExpr( "soul_fragments", function ()
    return buff.soul_fragments.stack
end )

spec:RegisterStateTable( "fragments", {
    real = 0,
    realTime = 0,
} )

spec:RegisterStateFunction( "queue_fragments", function( num, extraTime )
    fragments.real = fragments.real + num
    fragments.realTime = GetTime() + 1.25 + ( extraTime or 0 )
end )

spec:RegisterStateFunction( "purge_fragments", function()
    fragments.real = 0
    fragments.realTime = 0
end )

local last_darkness = 0
local last_metamorphosis = 0
local last_eye_beam = 0

spec:RegisterStateExpr( "darkness_applied", function ()
    return max( class.abilities.darkness.lastCast, last_darkness )
end )

spec:RegisterStateExpr( "metamorphosis_applied", function ()
    return max( class.abilities.darkness.lastCast, last_metamorphosis )
end )

spec:RegisterStateExpr( "eye_beam_applied", function ()
    return max( class.abilities.eye_beam.lastCast, last_eye_beam )
end )

spec:RegisterStateExpr( "extended_by_demonic", function ()
    return buff.metamorphosis.up and buff.metamorphosis.extended_by_demonic
end )

local activation_time = function ()
    return talent.quickened_sigils.enabled and 1 or 2
end

spec:RegisterStateExpr( "activation_time", activation_time )

local sigil_placed = function ()
    return sigils.flame > query_time
end

spec:RegisterStateExpr( "sigil_placed", sigil_placed )

spec:RegisterStateExpr( "meta_cd_multiplier", function ()
    return 1
end )


local furySpent = 0

local FURY = Enum.PowerType.Fury
local lastFury = -1

spec:RegisterUnitEvent( "UNIT_POWER_FREQUENT", "player", nil, function( event, unit, powerType )
    if powerType == "FURY" and state.set_bonus.tier30_2pc > 0 then
        local current = UnitPower( "player", FURY )

        if current < lastFury - 3 then
            furySpent = ( furySpent + lastFury - current )
        end

        lastFury = current
    end
end )

spec:RegisterStateExpr( "fury_spent", function ()
    if set_bonus.tier30_2pc == 0 then return 0 end
    return furySpent
end )

local queued_frag_modifier = 0

spec:RegisterHook( "COMBAT_LOG_EVENT_UNFILTERED", function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID == GUID then
        if subtype == "SPELL_CAST_SUCCESS" then
            -- Fracture:  Generate 2 frags.
            if spellID == 263642 then
                queue_fragments( 2 ) end

            -- Shear:  Generate 1 frag.
            if spellID == 203782 then
                queue_fragments( 1 ) end

            --[[ Spirit Bomb:  Up to 5 frags.
            if spellID == 247454 then
                local name, _, count = FindUnitBuffByID( "player", 203981 )
                if name then queue_fragments( -1 * count ) end
            end

            -- Soul Cleave:  Up to 2 frags.
            if spellID == 228477 then
                local name, _, count = FindUnitBuffByID( "player", 203981 )
                if name then queue_fragments( -1 * min( 2, count ) ) end
            end ]]

        -- We consumed or generated a fragment for real, so let's purge the real queue.
        elseif spellID == 203981 and fragments.real > 0 and ( subtype == "SPELL_AURA_APPLIED" or subtype == "SPELL_AURA_APPLIED_DOSE" ) then
            fragments.real = fragments.real - 1

        elseif state.set_bonus.tier30_2pc > 0 and subtype == "SPELL_AURA_APPLIED" and spellID == 408737 then
            furySpent = max( 0, furySpent - 175 )

        end
    end
end, false )


-- Gear Sets
spec:RegisterGear( "tier29", 200345, 200347, 200342, 200344, 200346 )
spec:RegisterAura( "seething_chaos", {
    id = 394934,
    duration = 6,
    max_stack = 1
} )

-- Tier 30
spec:RegisterGear( "tier30", 202527, 202525, 202524, 202523, 202522 )
-- 2 pieces (Havoc) : Every 175 Fury you spend, gain Seething Fury, increasing your Agility by 8% for 6 sec.
-- TODO: Track Fury spent toward Seething Fury.  New expressions: seething_fury_threshold, seething_fury_spent, seething_fury_deficit.
spec:RegisterAura( "seething_fury", {
    id = 408737,
    duration = 6,
    max_stack = 1
} )
-- 4 pieces (Havoc) : Each time you gain Seething Fury, gain 15 Fury and the damage of your next Eye Beam is increased by 15%, stacking 5 times.
spec:RegisterAura( "seething_potential", {
    id = 408754,
    duration = 60,
    max_stack = 5
} )


local sigil_types = { "chains", "flame", "misery", "silence" }

spec:RegisterHook( "reset_precast", function ()
    last_metamorphosis = nil
    last_infernal_strike = nil

    for i, sigil in ipairs( sigil_types ) do
        local activation = ( action[ "sigil_of_" .. sigil ].lastCast or 0 ) + ( talent.quickened_sigils.enabled and 2 or 1 )
        if activation > now then sigils[ sigil ] = activation
        else sigils[ sigil ] = 0 end
    end

    last_darkness = 0
    last_metamorphosis = 0
    last_eye_beam = 0

    local rps = 0

    if equipped.convergence_of_fates then
        rps = rps + ( 3 / ( 60 / 4.35 ) )
    end

    if equipped.delusions_of_grandeur then
        -- From SimC model, 1/13/2018.
        local fps = 10.2 + ( talent.demonic.enabled and 1.2 or 0 )

        -- SimC uses base haste, we'll use current since we recalc each time.
        fps = fps / haste

        -- Chaos Strike accounts for most Fury expenditure.
        fps = fps + ( ( fps * 0.9 ) * 0.5 * ( 40 / 100 ) )

        rps = rps + ( fps / 30 ) * ( 1 )
    end

    meta_cd_multiplier = 1 / ( 1 + rps )

    fury_spent = nil
end )


spec:RegisterHook( "advance_end", function( time )
    if query_time - time < sigils.flame and query_time >= sigils.flame then
        -- SoF should've applied.
        applyDebuff( "target", "sigil_of_flame", debuff.sigil_of_flame.duration - ( query_time - sigils.flame ) )
        active_dot.sigil_of_flame = active_enemies
        sigils.flame = 0
    end
end )


spec:RegisterHook( "spend", function( amt, resource )
    if set_bonus.tier30_2pc == 0 or amt < 0 or resource ~= "fury" then return end

    fury_spent = fury_spent + amt
    if fury_spent > 175 then
        fury_spent = fury_spent - 175
        applyBuff( "seething_fury" )
        if set_bonus.tier30_4pc > 0 then
            gain( 15, "fury" )
            applyBuff( "seething_potential" )
        end
    end
end )




spec:RegisterGear( "tier19", 138375, 138376, 138377, 138378, 138379, 138380 )
spec:RegisterGear( "tier20", 147130, 147132, 147128, 147127, 147129, 147131 )
spec:RegisterGear( "tier21", 152121, 152123, 152119, 152118, 152120, 152122 )
    spec:RegisterAura( "havoc_t21_4pc", {
        id = 252165,
        duration = 8
    } )

spec:RegisterGear( "class", 139715, 139716, 139717, 139718, 139719, 139720, 139721, 139722 )

spec:RegisterGear( "convergence_of_fates", 140806 )

spec:RegisterGear( "achor_the_eternal_hunger", 137014 )
spec:RegisterGear( "anger_of_the_halfgiants", 137038 )
spec:RegisterGear( "cinidaria_the_symbiote", 133976 )
spec:RegisterGear( "delusions_of_grandeur", 144279 )
spec:RegisterGear( "kiljaedens_burning_wish", 144259 )
spec:RegisterGear( "loramus_thalipedes_sacrifice", 137022 )
spec:RegisterGear( "moarg_bionic_stabilizers", 137090 )
spec:RegisterGear( "prydaz_xavarics_magnum_opus", 132444 )
spec:RegisterGear( "raddons_cascading_eyes", 137061 )
spec:RegisterGear( "sephuzs_secret", 132452 )
spec:RegisterGear( "the_sentinels_eternal_refuge", 146669 )

spec:RegisterGear( "soul_of_the_slayer", 151639 )
spec:RegisterGear( "chaos_theory", 151798 )
spec:RegisterGear( "oblivions_embrace", 151799 )


do
    local wasWarned = false

    spec:RegisterEvent( "PLAYER_REGEN_DISABLED", function ()
        if state.talent.demon_blades.enabled and not state.settings.demon_blades_acknowledged and not wasWarned then
            Hekili:Notify( "|cFFFF0000WARNING!|r  Demon Blades cannot be forecasted.\nSee /hekili > Havoc for more information." )
            wasWarned = true
        end
    end )
end

-- SimC documentation reflects that there are still the following expressions, which appear unused:
-- greater_soul_fragments, lesser_soul_fragments, blade_dance_worth_using, death_sweep_worth_using
-- They are not implemented becuase that documentation is from mid-2016.


-- Abilities
spec:RegisterAbilities( {
    annihilation = {
        id = 201427,
        known = 162794,
        flash = { 201427, 162794 },
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function () return 40 - buff.thirsting_blades.stack end,
        spendType = "fury",

        startsCombat = true,
        texture = 1303275,

        bind = "chaos_strike",
        buff = "metamorphosis",

        handler = function ()
            removeBuff( "thirsting_blades" )
            removeBuff( "inner_demon" )
            if azerite.thirsting_blades.enabled then applyBuff( "thirsting_blades", nil, 0 ) end

            if buff.chaotic_blades.up then gain( 20, "fury" ) end -- legendary
        end,
    },

    -- Strike $?a206416[your primary target for $<firstbloodDmg> Chaos damage and ][]all nearby enemies for $<baseDmg> Physical damage$?s320398[, and increase your chance to dodge by $193311s1% for $193311d.][. Deals reduced damage beyond $199552s1 targets.]
    blade_dance = {
        id = 188499,
        flash = { 188499, 210152 },
        cast = 0,
        cooldown = function() return ( level > 21 and 10 or 15 ) * haste end,
        gcd = "spell",
        school = "physical",

        spend = 35,
        spendType = "fury",

        startsCombat = true,

        bind = "death_sweep",
        nobuff = "metamorphosis",

        handler = function ()
            removeBuff( "restless_hunter" )
            applyBuff( "blade_dance" )
            setCooldown( "death_sweep", action.blade_dance.cooldown )
            if talent.chaos_theory.enabled then applyBuff( "chaos_theory" ) end
            if pvptalent.mortal_dance.enabled or talent.mortal_dance.enabled then applyDebuff( "target", "mortal_dance" ) end
            if talent.cycle_of_hatred.enabled and cooldown.eye_beam.remains > 0 then reduceCooldown( "eye_beam", 0.5 * talent.cycle_of_hatred.rank ) end
        end,

        copy = "blade_dance1"
    },

    -- Increases your chance to dodge by $212800s2% and reduces all damage taken by $212800s3% for $212800d.
    blur = {
        id = 198589,
        cast = 0,
        cooldown = function () return 60 + ( conduit.fel_defender.mod * 0.001 ) end,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "blur" )
        end,
    },

    -- Talent: Unleash an eruption of fel energy, dealing $s2 Chaos damage and stunning all nearby enemies for $d.$?s320412[    Each enemy stunned by Chaos Nova has a $s3% chance to generate a Lesser Soul Fragment.][]
    chaos_nova = {
        id = 179057,
        cast = 0,
        cooldown = function () return talent.unleashed_power.enabled and 48 or 60 end,
        gcd = "spell",
        school = "chromatic",

        spend = function () return talent.unleashed_power.enabled and 15 or 30 end,
        spendType = "fury",

        talent = "chaos_nova",
        startsCombat = true,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "chaos_nova" )
        end,
    },

    -- Slice your target for ${$222031s1+$199547s1} Chaos damage. Chaos Strike has a ${$min($197125h,100)}% chance to refund $193840s1 Fury.
    chaos_strike = {
        id = 162794,
        flash = { 162794, 201427 },
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "chaos",

        spend = function () return 40 - buff.thirsting_blades.stack end,
        spendType = "fury",

        startsCombat = true,

        bind = "annihilation",
        nobuff = "metamorphosis",

        cycle = function () return ( talent.burning_wound.enabled or legendary.burning_wound.enabled ) and "burning_wound" or nil end,

        handler = function ()
            removeBuff( "thirsting_blades" )
            removeBuff( "inner_demon" )
            if azerite.thirsting_blades.enabled then applyBuff( "thirsting_blades", nil, 0 ) end
            if talent.burning_wound.enabled then applyDebuff( "target", "burning_wound" ) end
            if buff.chaos_theory.up then
                gain( 20, "fury" )
                removeBuff( "chaos_theory" )
            end
            removeBuff( "chaotic_blades" )
            if talent.cycle_of_hatred.enabled and cooldown.eye_beam.remains > 0 then reduceCooldown( "eye_beam", 0.5 * talent.cycle_of_hatred.rank ) end
        end,
    },

    -- Talent: Consume $m1 beneficial Magic effect removing it from the target$?s320313[ and granting you $s2 Fury][].
    consume_magic = {
        id = 278326,
        cast = 0,
        cooldown = 10,
        gcd = "spell",
        school = "chromatic",

        talent = "consume_magic",
        startsCombat = false,

        toggle = "interrupts",

        usable = function () return buff.dispellable_magic.up end,
        handler = function ()
            removeBuff( "dispellable_magic" )
            if talent.swallowed_anger.enabled then gain( 20, "fury" ) end
        end,
    },

    -- Talent: Summons darkness around you in a$?a357419[ 12 yd][n 8 yd] radius, granting friendly targets a $209426s2% chance to avoid all damage from an attack. Lasts $d.
    darkness = {
        id = 196718,
        cast = 0,
        cooldown = 300,
        gcd = "spell",
        school = "physical",

        talent = "darkness",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            last_darkness = query_time
            applyBuff( "darkness" )
        end,
    },


    death_sweep = {
        id = 210152,
        known = 188499,
        flash = { 210152, 188499 },
        cast = 0,
        cooldown = function() return 9 * haste end,
        gcd = "spell",

        spend = 35,
        spendType = "fury",

        startsCombat = true,
        texture = 1309099,

        bind = "blade_dance",
        buff = "metamorphosis",

        handler = function ()
            removeBuff( "restless_hunter" )
            applyBuff( "death_sweep" )
            setCooldown( "blade_dance", action.death_sweep.cooldown )

            if pvptalent.mortal_dance.enabled or talent.mortal_dance.enabled then
                applyDebuff( "target", "mortal_dance" )
            end
            if talent.cycle_of_hatred.enabled and cooldown.eye_beam.remains > 0 then reduceCooldown( "eye_beam", 0.5 * talent.cycle_of_hatred.rank ) end
        end,
    },

    -- Quickly attack for $s2 Physical damage.    |cFFFFFFFFGenerates $?a258876[${$m3+$258876s3} to ${$M3+$258876s4}][$m3 to $M3] Fury.|r
    demons_bite = {
        id = 162243,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "physical",

        spend = function () return talent.insatiable_hunger.enabled and -25 or -20 end,
        spendType = "fury",

        startsCombat = true,

        notalent = "demon_blades",
        cycle = function () return ( talent.burning_wound.enabled or legendary.burning_wound.enabled ) and "burning_wound" or nil end,

        handler = function ()
            if talent.burning_wound.enabled then applyDebuff( "target", "burning_wound" ) end
        end,
    },

    -- Interrupts the enemy's spellcasting and locks them from that school of magic for $d.|cFFFFFFFF$?s183782[    Generates $218903s1 Fury on a successful interrupt.][]|r
    disrupt = {
        id = 183752,
        cast = 0,
        cooldown = 15,
        gcd = "off",
        school = "chromatic",

        startsCombat = true,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            if talent.disrupting_fury.enabled then gain( 30, "fury" ) end
        end,
    },

    -- Covenant (Kyrian): Place a Kyrian Sigil at the target location that activates after $d.    Detonates to deal $307046s1 $@spelldesc395039 damage and shatter up to $s3 Lesser Soul Fragments from enemies affected by the sigil. Deals reduced damage beyond $s1 targets.
    elysian_decree = {
        id = function() return talent.elysian_decree.enabled and 390163 or 306830 end,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "arcane",

        startsCombat = false,

        handler = function ()
            create_sigil( "elysian_decree" )
            if legendary.blind_faith.enabled then applyBuff( "blind_faith" ) end
        end,

        copy = { 390163, 306830 }
    },

    -- Talent: Slash all enemies in front of you for $s1 Chaos damage, and increase the damage your Chaos Strike and Blade Dance deal to them by $320338s1% for $320338d. Deals reduced damage beyond $s2 targets.
    essence_break = {
        id = 258860,
        cast = 0,
        cooldown = 40,
        gcd = "spell",
        school = "chromatic",

        talent = "essence_break",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "essence_break" )
            active_dot.essence_break = max( 1, active_enemies )
        end,

        copy = "dark_slash"
    },

    -- Talent: Blasts all enemies in front of you, $?s320415[dealing guaranteed critical strikes][] for up to $<dmg> Chaos damage over $d. Deals reduced damage beyond $s5 targets.$?s343311[    When Eye Beam finishes fully channeling, your Haste is increased by an additional $343312s1% for $343312d.][]
    eye_beam = {
        id = 198013,
        cast = function () return ( talent.blind_fury.enabled and 3 or 2 ) * haste end,
        channeled = true,
        cooldown = 40,
        gcd = "spell",
        school = "chromatic",

        spend = 30,
        spendType = "fury",

        talent = "eye_beam",
        startsCombat = true,

        start = function ()
            last_eye_beam = query_time

            applyBuff( "eye_beam" )
            removeBuff( "seething_potential" )

            if talent.demonic.enabled then
                if buff.metamorphosis.up then
                    buff.metamorphosis.duration = buff.metamorphosis.remains + 8
                    buff.metamorphosis.expires = buff.metamorphosis.expires + 8
                else
                    applyBuff( "metamorphosis", action.eye_beam.cast + 8 )
                    buff.metamorphosis.duration = action.eye_beam.cast + 8
                    stat.haste = stat.haste + 25

                    if talent.inner_demon.enabled then
                        applyBuff( "inner_demon" )
                    end
                end
            end

            if pvptalent.isolated_prey.enabled and active_enemies == 1 then
                applyDebuff( "target", "isolated_prey" )
            end

            -- This is likely repeated per tick but it's not worth the CPU overhead to model each tick.
            if legendary.agony_gaze.enabled and debuff.sinful_brand.up then
                debuff.sinful_brand.expires = debuff.sinful_brand.expires + 0.75
            end
        end,

        finish = function ()
            if talent.furious_gaze.enabled then applyBuff( "furious_gaze" ) end
        end,
    },

    -- Talent: Unleash a torrent of Fel energy over $d, inflicting ${(($d/$t1)+1)*$258926s1} Chaos damage to all enemies within $258926A1 yds. Deals reduced damage beyond $258926s2 targets.
    fel_barrage = {
        id = 258925,
        cast = 3,
        channeled = true,
        cooldown = 60,
        gcd = "spell",
        school = "chromatic",

        talent = "fel_barrage",
        startsCombat = false,

        toggle = "cooldowns",

        start = function ()
            applyBuff( "fel_barrage", 2 )
        end,
    },

    -- Talent: Impales the target for $s1 Chaos damage and stuns them for $d.
    fel_eruption = {
        id = 211881,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "chromatic",

        spend = 10,
        spendType = "fury",

        talent = "fel_eruption",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "fel_eruption" )
        end,
    },

    -- Rush forward, incinerating anything in your path for $192611s1 Chaos damage.
    fel_rush = {
        id = 195072,
        cast = 0,
        charges = function() return talent.blazing_path.enabled and 2 or nil end,
        cooldown = function () return ( legendary.erratic_fel_core.enabled and 7 or 10 ) * ( 1 - 0.1 * talent.erratic_felheart.rank ) end,
        recharge = function () return talent.blazing_path.enabled and ( ( legendary.erratic_fel_core.enabled and 7 or 10 ) * ( 1 - 0.1 * talent.erratic_felheart.rank ) ) or nil end,
        gcd = "off",
        icd = 1,
        school = "physical",

        startsCombat = true,
        nodebuff = "rooted",

        readyTime = function ()
            if prev[1].fel_rush then return 3600 end
            if ( settings.fel_rush_charges or 1 ) == 0 then return end
            return ( ( 1 + ( settings.fel_rush_charges or 1 ) ) - cooldown.fel_rush.charges_fractional ) * cooldown.fel_rush.recharge
        end,

        handler = function ()
            removeBuff( "unbound_chaos" )
            setDistance( 5 )
            setCooldown( "global_cooldown", 0.25 )
            if cooldown.vengeful_retreat.remains < 1 then setCooldown( "vengeful_retreat", 1 ) end
            if talent.momentum.enabled then applyBuff( "momentum" ) end
            if active_enemies == 1 and talent.isolated_prey.enabled then gain( 25, "fury" ) end
            if conduit.felfire_haste.enabled then applyBuff( "felfire_haste" ) end
        end,
    },


    fel_lance = {
        id = 206966,
        cast = 1,
        cooldown = 0,
        gcd = "spell",

        pvptalent = "rain_from_above",
        buff = "rain_from_above",

        startsCombat = true,
    },

    -- Talent: Charge to your target and deal $213243sw2 $@spelldesc395020 damage.    $?s203513[Shear has a chance to reset the cooldown of Felblade.    |cFFFFFFFFGenerates $213243s3 Fury.|r]?a203555[Demon Blades has a chance to reset the cooldown of Felblade.    |cFFFFFFFFGenerates $213243s3 Fury.|r][Demon's Bite has a chance to reset the cooldown of Felblade.    |cFFFFFFFFGenerates $213243s3 Fury.|r]
    felblade = {
        id = 232893,
        cast = 0,
        cooldown = 15,
        hasteCD = true,
        gcd = "spell",
        school = "physical",

        spend = -40,
        spendType = "fury",

        talent = "felblade",
        startsCombat = true,
        nodebuff = "rooted",

        -- usable = function () return target.within15 end,
        handler = function ()
            setDistance( 5 )
        end,
    },

    -- Talent: Launch two demonic glaives in a whirlwind of energy, causing ${14*$342857s1} Chaos damage over $d to all nearby enemies. Deals reduced damage beyond $s2 targets.
    glaive_tempest = {
        id = 342817,
        cast = 0,
        cooldown = 20,
        gcd = "spell",
        school = "magic",

        spend = 30,
        spendType = "fury",

        talent = "glaive_tempest",
        startsCombat = true,

        handler = function ()
            if talent.cycle_of_hatred.enabled and cooldown.eye_beam.remains > 0 then reduceCooldown( "eye_beam", 0.5 * talent.cycle_of_hatred.rank ) end
        end,
    },

    -- Engulf yourself in flames, $?a320364 [instantly causing $258921s1 $@spelldesc395020 damage to enemies within $258921A1 yards and ][]radiating ${$258922s1*$d} $@spelldesc395020 damage over $d.$?s320374[    |cFFFFFFFFGenerates $<havocTalentFury> Fury over $d.|r][]$?(s212612 & !s320374)[    |cFFFFFFFFGenerates $<havocFury> Fury.|r][]$?s212613[    |cFFFFFFFFGenerates $<vengeFury> Fury over $d.|r][]
    immolation_aura = {
        id = 258920,
        cast = 0,
        cooldown = 30,
        gcd = "spell",
        school = "fire",

        spend = -20,
        spendType = "fury",

        startsCombat = true,

        handler = function ()
            applyBuff( "immolation_aura" )
            if talent.unbound_chaos.enabled then applyBuff( "unbound_chaos" ) end
            if talent.ragefire.enabled then applyBuff( "ragefire" ) end
        end,
    },

    -- Talent: Imprisons a demon, beast, or humanoid, incapacitating them for $d. Damage will cancel the effect. Limit 1.
    imprison = {
        id = 217832,
        cast = 0,
        gcd = "spell",
        school = "shadow",

        talent = "imprison",
        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "imprison" )
        end,
    },

    -- Leap into the air and land with explosive force, dealing $200166s2 Chaos damage to enemies within 8 yds, and stunning them for $200166d. Players are Dazed for $247121d instead.    Upon landing, you are transformed into a hellish demon for $162264d, $?s320645[immediately resetting the cooldown of your Eye Beam and Blade Dance abilities, ][]greatly empowering your Chaos Strike and Blade Dance abilities and gaining $162264s4% Haste$?(s235893&s204909)[, $162264s5% Versatility, and $162264s3% Leech]?(s235893&!s204909[ and $162264s5% Versatility]?(s204909&!s235893)[ and $162264s3% Leech][].
    metamorphosis = {
        id = 191427,
        cast = 0,
        cooldown = function () return ( 240 - ( talent.rush_of_chaos.enabled and 60 or 0 ) ) * ( essence.vision_of_perfection.enabled and 0.87 or 1 ) - ( pvptalent.demonic_origins.up and 120 or 0 ) end,
        gcd = "spell",
        school = "physical",

        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "metamorphosis" )
            last_metamorphosis = query_time

            setDistance( 5 )

            if IsSpellKnownOrOverridesKnown( 317009 ) then
                applyDebuff( "target", "sinful_brand" )
                active_dot.sinful_brand = active_enemies
            end

            if level > 19 then stat.haste = stat.haste + 25 end

            if azerite.chaotic_transformation.enabled or talent.chaotic_transformation.enabled then
                setCooldown( "eye_beam", 0 )
                setCooldown( "blade_dance", 0 )
                setCooldown( "death_sweep", 0 )
            end
        end,

        meta = {
            adjusted_remains = function ()
                --[[ if level < 116 and ( equipped.delusions_of_grandeur or equipped.convergeance_of_fates ) then
                    return cooldown.metamorphosis.remains * meta_cd_multiplier
                end ]]

                return cooldown.metamorphosis.remains
            end
        }
    },

    -- Talent: Slip into the nether, increasing movement speed by $s3% and becoming immune to damage, but unable to attack. Lasts $d.
    netherwalk = {
        id = 196555,
        cast = 0,
        cooldown = 180,
        gcd = "spell",
        school = "physical",

        talent = "netherwalk",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "netherwalk" )
            setCooldown( "global_cooldown", buff.netherwalk.remains )
        end,
    },


    rain_from_above = {
        id = 206803,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        pvptalent = "rain_from_above",

        startsCombat = false,
        texture = 1380371,

        handler = function ()
            applyBuff( "rain_from_above" )
        end,
    },


    reverse_magic = {
        id = 205604,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        -- toggle = "cooldowns",
        pvptalent = "reverse_magic",

        startsCombat = false,
        texture = 1380372,

        debuff = "reversible_magic",

        handler = function ()
            if debuff.reversible_magic.up then removeDebuff( "player", "reversible_magic" ) end
        end,
    },


    -- Talent: Place a Sigil of Flame at your location that activates after $d.    Deals $204598s1 Fire damage, and an additional $204598o3 Fire damage over $204598d, to all enemies affected by the sigil.    |CFFffffffGenerates $389787s1 Fury.|R
    sigil_of_flame = {
        id = function ()
            if talent.precise_sigils.enabled then return 389810 end
            if talent.concentrated_sigils.enabled then return 204513 end
            return 204596
        end,
        known = 204596,
        cast = 0,
        cooldown = function() return 30 * ( talent.quickened_sigils.enabled and 0.8 or 1 ) end,
        gcd = "spell",
        school = "physical",

        spend = -30,
        spendType = "fury",

        talent = "sigil_of_flame",
        startsCombat = false,

        sigil_placed = function() return sigil_placed end,

        handler = function ()
            create_sigil( "flame" )
        end,

        copy = { 204596, 204513 }
    },

    -- Talent: Place a Sigil of Misery at your location that activates after $d.    Causes all enemies affected by the sigil to cower in fear. Targets are disoriented for $207685d.
    sigil_of_misery = {
        id = function ()
            if talent.precise_sigils.enabled then return 389813 end
            if talent.concentrated_sigils.enabled then return 202140 end
            return 207684
        end,
        known = 207684,
        cast = 0,
        cooldown = function () return ( pvptalent.sigil_mastery.enabled and 0.75 or 1 ) * ( talent.improved_sigil_of_misery.enabled and 90 or 120 ) * ( talent.quickened_sigils.enabled and 0.8 or 1 ) end,
        gcd = "spell",
        school = "physical",

        talent = "sigil_of_misery",
        startsCombat = false,

        toggle = function()
            if talent.misery_in_defeat.enabled then return "cooldowns" end
            return "interrupts"
        end,

        handler = function ()
            create_sigil( "misery" )
        end,

        copy = { 389813, 207684, 202140 }
    },

    -- Allows you to see enemies and treasures through physical barriers, as well as enemies that are stealthed and invisible. Lasts $d.    Attacking or taking damage disrupts the sight.
    spectral_sight = {
        id = 188501,
        cast = 0,
        cooldown = 60,
        gcd = "spell",
        school = "physical",

        startsCombat = false,

        handler = function ()
            applyBuff( "spectral_sight" )
        end,
    },

    -- Talent / Covenant (Night Fae): Charge to your target, striking them for $370966s1 $@spelldesc395042 damage, rooting them in place for $370970d and inflicting $370969o1 $@spelldesc395042 damage over $370969d to up to $370967s2 enemies in your path.     The pursuit invigorates your soul, healing you for $?c1[$370968s1%][$370968s2%] of the damage you deal to your Hunt target for $370966d.
    the_hunt = {
        id = function() return talent.the_hunt.enabled and 370965 or 323639 end,
        cast = 1,
        cooldown = function() return talent.the_hunt.enabled and 90 or 180 end,
        gcd = "spell",
        school = "nature",

        startsCombat = true,
        toggle = "cooldowns",
        nodebuff = "rooted",

        handler = function ()
            applyDebuff( "target", "the_hunt" )
            applyDebuff( "target", "the_hunt_dot" )
            setDistance( 5 )

            if talent.momentum.enabled then applyBuff( "momentum" ) end

            if legendary.blazing_slaughter.enabled then
                applyBuff( "immolation_aura" )
                applyBuff( "blazing_slaughter" )
            end
        end,

        copy = { 370965, 323639 }
    },

    -- Throw a demonic glaive at the target, dealing $337819s1 Physical damage. The glaive can ricochet to $?$s320386[${$337819x1-1} additional enemies][an additional enemy] within 10 yards.
    throw_glaive = {
        id = 185123,
        cast = 0,
        charges = function () return talent.master_of_the_glaive.enabled and 2 or nil end,
        cooldown = 9,
        recharge = function () return talent.master_of_the_glaive.enabled and 9 or nil end,
        gcd = "spell",
        school = "physical",

        spend = function() return talent.furious_throws.enabled and 25 or 0 end,
        spendType = "fury",

        startsCombat = true,

        readyTime = function ()
            if ( settings.throw_glaive_charges or 1 ) == 0 then return end
            return ( ( 1 + ( settings.throw_glaive_charges or 1 ) ) - cooldown.throw_glaive.charges_fractional ) * cooldown.throw_glaive.recharge
        end,

        handler = function ()
            if talent.burning_wound.enabled then applyDebuff( "target", "burning_wound" ) end
            if talent.mastery_of_the_glaive.enabled then applyDebuff( "target", "master_of_the_glaive" ) end
            if talent.serrated_glaive.enabled then applyDebuff( "target", "serrated_glaive" ) end
            if talent.soulrend.enabled then applyDebuff( "target", "soulrend" ) end
        end,
    },

    -- Taunts the target to attack you.
    torment = {
        id = 185245,
        cast = 0,
        cooldown = 8,
        gcd = "off",
        school = "shadow",

        startsCombat = false,

        handler = function ()
            applyBuff( "torment" )
        end,
    },

    -- Talent: Remove all snares and vault away. Nearby enemies take $198813s2 Physical damage$?s320635[ and have their movement speed reduced by $198813s1% for $198813d][].$?a203551[    |cFFFFFFFFGenerates ${($203650s1/5)*$203650d} Fury over $203650d if you damage an enemy.|r][]
    vengeful_retreat = {
        id = 198793,
        cast = 0,
        cooldown = function () return talent.tactical_retreat.enabled and 20 or 25 end,
        gcd = "spell",

        startsCombat = true,
        nodebuff = "rooted",

        readyTime = function ()
            if settings.retreat_and_return == "fel_rush" or settings.retreat_and_return == "either" and not talent.felblade.enabled then
                return max( 0, cooldown.fel_rush.remains - 1 )
            end
            if settings.retreat_and_return == "felblade" and talent.felblade.enabled then
                return max( 0, cooldown.felblade.remains - 1 )
            end
            if settings.retreat_and_return == "either" then
                return max( 0, min( cooldown.felblade.remains, cooldown.fel_rush.remains ) - 1 )
            end
        end,

        handler = function ()
            if target.within8 then
                applyDebuff( "target", "vengeful_retreat" )
                applyDebuff( "target", "vengeful_retreat_snare" )
                -- Assume that we retreated away.
                setDistance( 15 )
            else
                -- Assume that we retreated back.
                setDistance( 5 )
            end
            if talent.tactical_retreat.enabled then applyBuff( "tactical_retreat" ) end
            if talent.momentum.enabled then applyBuff( "momentum" ) end
            if pvptalent.glimpse.enabled then applyBuff( "glimpse" ) end
        end,
    }
} )


spec:RegisterOptions( {
    enabled = true,

    aoe = 2,

    nameplates = true,
    nameplateRange = 7,

    damage = true,
    damageExpiration = 8,

    potion = "phantom_fire",

    package = "Havoc",
} )


spec:RegisterSetting( "demon_blades_text", nil, {
    name = function()
        return strformat( "|cFFFF0000WARNING!|r  If using the %s talent, Fury gains from your auto-attacks will be forecast conservatively and updated when you "
            .. "actually gain resources.  This prediction can result in Fury spenders appearing abruptly since it was not guaranteed that you'd have enough Fury on "
            .. "your next melee swing.", Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    type = "description",
    width = "full"
} )

spec:RegisterSetting( "demon_blades_acknowledged", false, {
    name = function()
        return strformat( "I understand that Fury generation from %s is unpredictable.", Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    desc = function()
        return strformat( "If checked, %s will not trigger a warning when entering combat.", Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    type = "toggle",
    width = "full",
    arg = function() return false end,
} )


-- Fel Rush
spec:RegisterSetting( "fel_rush_head", nil, {
    name = Hekili:GetSpellLinkWithTexture( 195072, 20 ),
    type = "header"
} )

spec:RegisterSetting( "fel_rush_warning", nil, {
    name = strformat( "The %s, %s, and/or %s talents require the use of %s.  If you do not want |W%s|w to be recommended to trigger these talents, you may want to "
        .. "consider a different talent build.\n\n"
        .. "You can reserve |W%s|w charges to ensure recommendations will always leave you with charge(s) available to use, but failing to use |W%s|w may ultimately "
        .. "cost you DPS.", Hekili:GetSpellLinkWithTexture( 388113 ), Hekili:GetSpellLinkWithTexture( 206476 ), Hekili:GetSpellLinkWithTexture( 347461 ),
        Hekili:GetSpellLinkWithTexture( 195072 ), spec.abilities.fel_rush.name, spec.abilities.fel_rush.name, spec.abilities.fel_rush.name ),
    type = "description",
    width = "full",
} )

spec:RegisterSetting( "fel_rush_charges", 0, {
    name = strformat( "Reserve %s Charges", Hekili:GetSpellLinkWithTexture( 195072 ) ),
    desc = strformat( "If set above zero, %s will not be recommended if it would leave you with fewer (fractional) charges.", Hekili:GetSpellLinkWithTexture( 195072 ) ),
    type = "range",
    min = 0,
    max = 2,
    step = 0.1,
    width = "full"
} )

spec:RegisterSetting( "fel_rush_filler", true, {
    name = strformat( "%s: Filler and Movement", Hekili:GetSpellLinkWithTexture( 195072 ) ),
    desc = strformat( "When enabled, %s may be recommended as a filler ability or for movement.\n\n"
        .. "These recommendations may occur with %s talented, when your other abilities are on cooldown, and/or because you are out of range of your target.",
        Hekili:GetSpellLinkWithTexture( 195072 ), Hekili:GetSpellLinkWithTexture( 203555 ) ),
    type = "toggle",
    width = "full"
} )

-- Throw Glaive
spec:RegisterSetting( "throw_glaive_head", nil, {
    name = Hekili:GetSpellLinkWithTexture( 185123, 20 ),
    type = "header"
} )

spec:RegisterSetting( "throw_glaive_charges_text", nil, {
    name = strformat( "You can reserve charges of %s to ensure that it is always available for %s or |W|T1385910:0::::64:64:4:60:4:60|t |cff71d5ff%s (affix)|r|w procs. "
        .. "If set to your maximum charges (2 with %s, 1 otherwise), |W%s|w will never be recommended.  Failing to use |W%s|w when appropriate may impact your DPS.",
        Hekili:GetSpellLinkWithTexture( 185123 ), Hekili:GetSpellLinkWithTexture( 391429 ), GetSpellInfo( 396363 ), Hekili:GetSpellLinkWithTexture( 389763 ),
        spec.abilities.throw_glaive.name, spec.abilities.throw_glaive.name ),
    type = "description",
    width = "full",
} )

spec:RegisterSetting( "throw_glaive_charges", 0, {
    name = strformat( "Reserve %s Charges", Hekili:GetSpellLinkWithTexture( 185123 ) ),
    desc = strformat( "If set above zero, %s will not be recommended if it would leave you with fewer (fractional) charges.", Hekili:GetSpellLinkWithTexture( 185123 ) ),
    type = "range",
    min = 0,
    max = 2,
    step = 0.1,
    width = "full"
} )

--[[ Retired 20240712:
spec:RegisterSetting( "footloose", true, {
    name = strformat( "%s before %s", Hekili:GetSpellLinkWithTexture( 185123 ) , Hekili:GetSpellLinkWithTexture( 188499 ) ),
    desc = strformat( "When enabled, %s may be recommended without having %s on cooldown.\n\n"
        .. "This setting deviates from the default SimulationCraft profile, but performs equally on average with higher top-end damage.",
        Hekili:GetSpellLinkWithTexture( 185123 ) , Hekili:GetSpellLinkWithTexture( 188499 ) ),
    type = "toggle",
    width = "full"
} ) ]]

-- Vengeful Retreat
spec:RegisterSetting( "retreat_head", nil, {
    name = Hekili:GetSpellLinkWithTexture( 198793, 20 ),
    type = "header"
} )

spec:RegisterSetting( "retreat_warning", nil, {
    name = strformat( "The %s, %s, and/or %s talents require the use of %s.  If you do not want |W%s|w to be recommended to trigger the benefit of these talents, you "
        .. "may want to consider a different talent build.", Hekili:GetSpellLinkWithTexture( 388108 ),Hekili:GetSpellLinkWithTexture( 206476 ),
        Hekili:GetSpellLinkWithTexture( 389688 ), Hekili:GetSpellLinkWithTexture( 198793 ), spec.abilities.vengeful_retreat.name ),
    type = "description",
    width = "full",
} )

spec:RegisterSetting( "retreat_and_return", "off", {
    name = strformat( "%s: %s and %s", Hekili:GetSpellLinkWithTexture( 198793 ), Hekili:GetSpellLinkWithTexture( 195072 ), Hekili:GetSpellLinkWithTexture( 232893 ) ),
    desc = function()
        return strformat( "When enabled, %s will |cFFFF0000NOT|r be recommended unless either %s or %s are available to quickly return to your current target.  This "
            .. "requirement applies to all |W%s|w and |W%s|w recommendations, regardless of talents.\n\n"
            .. "If |W%s|w is not talented, its cooldown will be ignored.\n\n"
            .. "This option does not guarantee that |W%s|w or |W%s|w will be the first recommendation after |W%s|w but will ensure that either/both are available immediately.",
            Hekili:GetSpellLinkWithTexture( 198793 ), Hekili:GetSpellLinkWithTexture( 195072 ), Hekili:GetSpellLinkWithTexture( 232893 ),
            spec.abilities.fel_rush.name, spec.abilities.vengeful_retreat.name, spec.abilities.felblade.name,
            spec.abilities.fel_rush.name, spec.abilities.felblade.name, spec.abilities.vengeful_retreat.name )
    end,
    type = "select",
    values = {
        off = "Disabled (default)",
        fel_rush = "Require " .. Hekili:GetSpellLinkWithTexture( 195072 ),
        felblade = "Require " .. Hekili:GetSpellLinkWithTexture( 232893 ),
        either = "Either " .. Hekili:GetSpellLinkWithTexture( 195072 ) .. " or " .. Hekili:GetSpellLinkWithTexture( 232893 )
    },
    width = "full"
} )

spec:RegisterSetting( "retreat_filler", false, {
    name = strformat( "%s: Filler and Movement", Hekili:GetSpellLinkWithTexture( 198793 ) ),
    desc = function()
        return strformat( "When enabled, %s may be recommended as a filler ability or for movement.\n\n"
            .. "These recommendations may occur with %s talented, when your other abilities being on cooldown, and/or because you are out of range of your target.",
            Hekili:GetSpellLinkWithTexture( 198793 ), Hekili:GetSpellLinkWithTexture( 203555 ) )
    end,
    type = "toggle",
    width = "full"
} )

spec:RegisterPack( "Havoc", 20230711, [[Hekili:T3ZAZTTrs(Br1wHM02IbaKus(krM6I3hxCDB2ToL7(OaHibLqzscEaG2rPuXF7x3ZGbyE1daHOLD2lFjrgyqp97xZWzU1)2F52BwgveF7ph4fmY7sF)HbJcUYl42BkECx8T3SlAXhJUh(JTrBG)7)r0NsxGp9X1PrlXVopDF2c4n3KSz)6OIK0TVplAvXT3C3(K1f)02BVZ6maF4U4f3(ZtU8YBV5HKLlJ5JmohapoYZ9U8CF))TdZpm)FgvS4HdZ99g6pCYH573HWB4HpC4dIb6nMnW)9LlpmpDhIehMxKEy(V8qw6Npm)VTok5tXhM)5KIhs3xCy(pUoAj8V)ZrBxa)pC0V)plbWlopychGRxJF)9XBJZswaWmlz7hJlY5q)(yauzXls3SjE7YyCUxT68)MgO8gXa1FpfXGAaKat6Y4vr7xdazxwsAwsXJsF4KZ9dyF4VW)ebDdF6QS0nhMdm83ln(XNpYJn()B2Wwkpm4VtZkzG1FrW5bxY(IFA1H5)141hM)FTph4ZrBHp()jE79XR2JpmUilocM)OmGawMKhD3Ae89bz1UKIyK0a6Vy)MYp9xIwuKSis(tVloz79a1hTggy8YbVf(7hIRPBu0Sg(Gio)(VKNhZKm)i85FKZSVlwHxRqh(xXOJ)btYNJJ7(OSLSPSf01NJZyW(tj5iCN)p2U(Xs8BfGvXzF)gq2HKOegevovlI2YXTI9zBlvbarvoBYzwlVcgfQRNeTo53I46M5XffWiYhYeW4mbqplbfUr55PWyzsquFfep5PR5)7)zw8JVTMFd)5)927s3J017FiknhEWpTnPa(AqD)T0u8MOhrE9NJEm3GXcAMRqQpnpwiWYlL95XRJxaiYqWbqwkWBaZEuwdmIH7yG4UOI3m97)uuwcQK8w0NX0IhYIJd3KSnSu5)TFkA9E458)fOsUinD9Y0pVD4Y9zmg0u)R8E6jXacSpGdFW2ChLbsK4WI0SmaZFBYQPR2N94qWslzrsXm)j2)S95XHGU8gokhTgmTFiklC3(F73whhEx6VIqQcn2exeTjnBhWKsYhMfVjkzB(1eGop5(K1HPRcxTgGncNZI)F3NSBhWiTmr2bsYMnPCVRHrapav(lh2uWImB)UIQhaJEb8)2Vby6r3dET(WFs3HhxV6VMKLZ8fMMU8TOFMOK1O(lAVKSfEc6ZavxcEdQjKDp63sAwufZ3HZq4sCcecyMYZWv40eEholGmL)ScCUqEsgmtvpDbQdhcgEPzp27U9RwP8KHiR)PNatP1RdlrNHsZQ)mFASBhi6adUqWpyOjMkgRm46H6nx3)YjNxIDlJ3aCF2iYFDG3GEvQdsFvLYW9lwoCt0V2omk(rq0hhTrLXXMWKf9oR8FFhm(LHiAvp1IVSAE7xoXVoyaNcUWJgh(CusHah2iCQOGdIN27mM8q8phUFxVZ6Zb7WvXRb5y(ddfXg6v(Ipv65jmJ74PAadOrPhacdrj0eRev6RXpk)NX8GeH3HXig0RsgA4VP3QK7FOiSKdnZTv8Bg59MYji)HOIci2WYqqId8PhF9fE9AWhqqtJywjVPsWf)RXl2xaESs2e)gHWtqYjBHepcze(BcaU2FcmLR5CjB)u6hJdJ)val3gToefrcLliOwyY2vqGiiEJe3wZrc6oQCUYG08aB1yM07tay3gVbIinB6OE9DPQ)0tlJzkhkceM1QICUaZfl8EwQystBECwggDR8n96Zv0SY7eSNl61VCo1(6sFeeVuiKQTEuWyHgWKEUhW1sMynWzAnGaFGG8)AVHtg0JKD2J71Biouicx4YK4kwYvDGvt7fPcX61aRSFWBSiVqG(6lAK7q8LNcoGWNes9myTNNOuilIc6(QVLhBq(yOj9jusQPeZfYDnK)pdxNKxWnefmGMhjYhaBULvySkJbWyAddbkPz6E9iDpg7sw8XW97cxbg7ON83If5nL5FbNxEioOIU1vJiFMNKy0qr5cRsrH9kOmZfKByoKyEsfZqfig90tkoOV2)Ygr7nPlJNUngYknVKgwJklzsk7LrlcJGeTkGu76PKh40Xt61)mB0v0YhbecJCoYtrahTDBYdjCFNvcjjh0OiQHOdtb50RhPe8tle5BXerHsicHro1xICsQYR3A8VEOc6mFzrLnpoq(VT1PeWEu5KwL073jdpnTdy2EtFFVxlsV7XfRrIleIRc6cdgaoiyE9gbj7JZALcWGQCEI2(iKkq028WTXla8ncs(PcXQ5jL4w9d0PgU)1zJh87dMp44TFduuVZQY4roNjho1NkXJ71hYaFzy8Nym5LlZHzAw)XENBxw9A)jd45todfwVaAg0Y)NRe8mxIqJ0CPcQOLF8W4T8uFv)ElIvisderjh9LXaC06z(dVYbV66rUci6kcRmUR8Pib0xlnpih3e0dDzLvp9KffKXqvp1QD2QEOvPVnYPMbmhvw4fiscXlfY3snn9hZu2yUs8BQUSPJg6)6kNcQbEUqMHTeG7dH5FooEhYUSwIyFR6snzKpZEceO21DrzyA44e2bXZiLs94zQfwabFXOKDdK(EvPABQ890tAq0V7bmT6T6yn(AoH2regOtSLDLEIBfpeh(WEExLOTi7xQikPgy3CahIZwbnWQx635zW3hX1(fjOYmHyo0UWHNJkLxWTEs6(8W7J(nrGu5hbIjO8KZYJlaCA7(Cix44SrEHb7wOiURAIr300Ch8P3zwjemp(g4YUalqwwdIoWQBmUkFZ(3QJpIPNIjMY0AIZgyKP7ezgOCFPi94q74eOgxktn1xc71QjA46alb9TPCkaspZ3DDaKdHm9A2yuhj9rRhRPRnDCBQegkajdk2QxxIcc5BGrE4bY59T5Dd6P0xYzt7hCUM5fdvYDPjBc4RLcz60x7PHx2qJI050b8omEPx7GOE8GABpIUZ(0t2C687uXBd8wEINAVGPvu5mPS)CgAcTHOaxOnemnPCvMc3Lf)OMr1uFTQNhP44I3L(8ISKpg3kbBp7Jq4sZTITvQth)80Ow2KJFTwxa0hxfxPAf6epmKVwGvLpuLXRSBXYLhOhvNfQs)FAGQ)tXkmwMZL1mXu9EYMV8W7skIFlpYwP8xPUN72NTfzVFg7YLWmv5HvPanwi0xMQ9Dx3xv7)hgrQm1E22z24BQZJ)jKDDk0JKy5hn93VcLxMKxGgbS2bWZZiDFbBXWIGQzzlTIgZAG72wipVLptNTlv)RneXLp1(weuLPbPH3TZ5N6sTUeCRLUf9Rbo63ChK)kOdSfBLNrP8Q5ofGjyxQDixqPXIovLIpnseVMXrs2VjCx6IpcbDI2(PK1QOG0AUou0Sw16eT(E5OEYGqGWY6MBsac)r5kCypimzluX0kyIq5jRF0jGAyAEUT(H771uoXyxBvtMZrLtU7WRp2J0)0H5Vpcxk5)U8y4BKGphl2BhSDlt0H5y81dZ)lpIBVd0z)8S4vqIYpWxVz(MpGTHiwKYYAgEgUbewVjfNcq5nZktub)yrH0iX(vrsX4vfjlclaf3CiWZgMWXvtjWL7TdrDVa0rzIjnvxPGXojbDk45qaWxBRIcPpYs7seL0mGGoOxQ0l9O1PC2Hg7SMDPISgDOmgmHOtK01(W62VfsdLCSkO9g63RSGERiw86hZtIq7ZfzXXDTXAYl1Gm0vDtTjcxqJ7ZsIxvKMT4btxK9P6A8SG20drNTRQSfPJ171GOZB9C2lJsUCFf2839D(bExJTw(miRZpH0XqFTf2Vf8fBBxhdwtdUeNkQ0AIatnq1R84nN085xheyuBpLrUkQNKLSmEFE9kB1v8MlDc0Wcbw3ZkoBGYbmF5)zXUsCpUfWqC9W81PSDsKd6j)T5RtHSpl30fC1X6nLb)PH5pUDrioqOKcB9ybBKR(cpz2EpIoyOUpp(bhBWSVlyGHaBk4KhMChOCae(1CpPXCImqUvsgF5G2TMvqguhdloOjwCWlgl2Yw0RBSy)AwS)xdwm3QmhCVUbs3kodtZcI7CKwL14IidErGjT(oJRqUE8cF7fWpUvHiGWSlGS0bNZyZQVl(X0TlnXE6qbK(HbsQY9UUtR6TQPImtK5H1DYPuMvTGSoIQe6lhDAKxRQmqQZP2yGsVwN0XgTtt7(UPD5xBBxW2WEG1tcViQGrAe5q(jrBWA6HKUw8XqolnFbONknQnrzFeRezjKSs2(1O1QdmCMBmCMNt2JlEZaPSjiOnEAzbtAH6tRQVJvZGK6VOc(EslB(X4E(pIaE6Dp)hra)IZI)Moc4T3aL)JBP16Fnr3EZNJy9Qm)2By)sks2SlnRO8N8YReO5RW(maEuYWFHd5asCyE0(I0n8Fyfqb1qSH8Hh(W)zYw4v4V7O3NUfMm2RFfr7yEf)NMc1Rf6uWW67)RdAc6LAIAavt)uhwbF5HL9UnObA7dIAMgDcXAcy9YH1gn)qBsmEpf8Vqf(P7I5osk)1I9Q)fS6EbR63BKwlOSkX6LniwD7j9lsNjeS9N7utmZoM4kUYvNgUYPPVhhj)GysToNKtzfN4D6UvOZARYZs5qkSpgfVkNAW3iG1Zm0aQwgqRW4JhW0GuprjnF2soIiCw)UMCw)nrM)2KGDlVuPu)n4ZDiXubHznb1QOcFZYd)(V95H1PB61S9ePha7JrnD2tn8BgY6vg5YXLvxmNqi7aMpBNm6G8O8Y8Yv8RnPy38Yiv9RbN(KBH0cVmFD5HDZlZlkpSwvLQM5Yc(1091372gA(gfJAZaLXsCBIkgYxsO3mCn7WP7KxooSUBqVgUgf2(S4g6y9Pf6nd3UXnAlw3nO3mC7A64TfV7k8BgYDnmFBX8Uc)MHCx5jTfZ7k8BgYDLN0wmVRWVzi3nR(2I3Dd6nd3Uz13wSUBqVgUtAMBCu6F649Pg(nd5JVu)2IZhpKDaZNFc(tEgj4)1Te4ULG)lAjWTib)VU8WULG)lkpSwv9IMTOoQyf6McNA43mKp(I9BloF8q2bmF(EzACLL(MTe4U5L5fTe4w4L5RlpSBEzEr5H1QQxAx7)OBJWHpyz3auEGB(QJAZaqSSVsNRDAiL0BoYLsw5CXtdQkV7iHR85ONgyvoI9iG6y7qv(xeKguLFffujYMQtBcacyvFK5PbU6x0YfJVZ6HCOrOv3jALawkl)SgevxF8JdUNST3ab8LorimcSvFwrqaZRSdtXVvwnakEmf0iwLqTd)mD6x7OrRLTY)0c8V8vMCYuZOaCNSfOaM2z9GUpp13ESa3YVPETjWYio2j55i6(YNb5PtBGaWNgbibW7MQ2xdm90QQr6bU76fFPcg5t4lw)OFsd2gNmueGpGWB8ZgVdimNLprD0GRYHTdfy)sQ89vb4ANnoAax7TKa)uMxvarYeNuBWaQCmkpYs0GS4Xhl4upvsiu44VKc0JimroPSJru7P2UXoOa3PGDqueuht1CevyF5JHfD3XYVJeWeAeDSWfkW9mR9BmHYLY5oIgCvp2sOa8PDBiqbUNl5tOm1vS80Nd5yxPo1fc3A)yQUIdE1r1rgdHIzxxpQ1Jsp3Jtm4BeWDTd3TeV7k4zsTFIjWq4nwCKmFyoESvJIJBVH9x49ae2Ms8ipb(7FMDTcXhlEL(uDaPC7nLQf3(J3wC7phipm5Zjf1XvGWG13otyZV7lCbxL7cdTbochy9tUjfWW84I6pw0Jt8VwVh(FIqgMD47W8NE6q5fMI9E1PmcBTD7W8EhMZ6oQX9Eb)BPV7lomFgi)53Fszj74y)P6s)GXhc5xaustkYbhF0CWQ2glbjgHJnJ7W8RbD6dZVCYH5NxXRS5y5W8xJzXFy(a2hxP8A7yWfbA5o3xMuioCYqYAYrtwYOADkMmC7SkcXSRJQiV(bLIGDuI8CAwqYv8Rl8OOkb8qs6IUss6bFe0K6pNV97epVVWnH5fdcBiLVK8YbbOpz6X2PmmspxE00tFvfknPu5RSwKNGLxVKh63XiCjI8kSWSiDViohM)gmnB2)tKGlvZuzY(l8u1xiG61ClJwmYzvIdR3hjmmtw5RMfAP3SSrhOj(KpwvrX2vAInWBfqVjrvQB6joxPZu)defW7PaJJ9M(nz7J(nPpEkrKvOWOD4lIy77AcBj6pRa1SSOFY8Ezw7fIVXXnBIc1qCLCWe)1EuS9dJJjOMO56X(aVMW5tRy7Dc4SyKmDp41E499hFgDid7jIujFoOzWGVQwslFe3HIzFVNJC2T7BnkSxRKF9zJ9nwvG40mxJ5iegKq6fG96tYEztQ(DZII1J1BOfBCwEYvM4PfTSAuveIIHMbAOzvkKAxyl8SElDWj48miONqPgHQV8)1j8r7jVc3T4geE9OwIMvPNJOPEwBAOP6z0ERcKC9uvU8iIe7Xzxp5kdJnZQtBre6Ec3gyIWgMfeEGWXo54DwXb(z05tqyWHmt15YWJrjg9g2m47XyMIsgS3WvMf8ajFbvEpXulWPt(ambFUVyW1uGJw2zsU2KpvuS0lTY7Q9VpJvsPKXOEkH3EJ0Pobw5hQ9ONh7V)0EQce0VLSmUKQk5t5uQAma0unXpFAnpEnyutFSXCYvErQY9AoPpqTyKz16CFtAC0SY(rQmQxesBvgp741hTuX1rISnM6T1k9uN0gvOnVEB40WWRAu6EnlN(2KoIRSDiITtNjFFlLxGiGYP2jh5jmBg7j5qTYm1wHRkM9TRUGrnY3MXTfgy6OMA1qLSbTCv6OLdUFBBYcwt2qFgsR4TxRSySJf1cjfjmR5D05It26O(TWIQnEPN5kvr5(yI4jDsTpt1PrEQ6WLxkqSjvpf1t2K67j4Kom9WV3Y84RWNuV3HyyDdPf7kFt6qASU5rLKzaDkUUC21(s5g1GZXjsV3OOl7(OcOtm2T7W(AwRkQ60Ez8Rdv78cPU2ZcHUZ78ivngv7mrUGmf)vvb6UOfU(vm1TTZjK8TPDlgv1EHZyxa7MxSiYAXI76jMGHoNZNPvxxs4IhMH6G2xp1vAX)XnXL8nIKqh4iWwTRJ2g1tn)rITcsL00m8cuHzD8fPwGhqNUMRqlUd9wYBCBb1RvseQ(4iwqozfyxjxtBPw2DaXSWqmBdf7GCz691SsT1ijOX8jBQOs3w6gMwGF)X1yJ6f6bdHAUBTABFeHe(zAfBEJbXQr5Dc7cLLTJti8g8DUHNm19Gs7T3THcMrSAv8B9U3nQXMJ2z5SlP5OJi)QPIcqQwtSl9A7mBPR)JOZYs2fiX6hYzZ2cWqNUYi6mK(xwvxhAC0jVjQc28IYYm7aZvsIq))yyySGWU1EAU)M22hxw95nvu9V81sexmmAI9SihrNSsRuE7PgN36Yjx3YzPB(l2KthH1b)0o95507aDWhtqnwTGkg5YacDadQ7Xjb)XvreYHMn21c8p3wkfrlFSkJdEtuyY)aBX0LU)RKREZrTDQHYLvygR7FxmigbWVURSOeBD34j7016TmgZ58yzDDJBBmXcGP765h4Thcqf5B7SYMBnMoAXZruEwZstD0uU)XVOIr6GwNwtVXSyvwvsQNDCC0EXDksawKXvuwf(wYdzkyA3(ynkpDW7ODztCXQPnzeT5LIoULUXTi2q7bVFd6JvvzzWB6E04X6(0Re9uxkdgDF(g(Aq64dKCFBuoxGOLgsMt6DfL6UDG3lggzOhXOQcr7xoacKM81gDyV426fdwSrfDLga1XfETUL8v9wzOfRRdFDZ7AQkZRzDzH1sgIci71uxWUOvfZZCwzXncNOzLRripuGP2oA8f9AMtl1jhmS(AzE6(yfxVx026Qq9oB8zMV6fLgpvQqwSVyP0wyUDyn0yjO9tnHxbv7DLrbiwxkc5MjnOv0FB3bEx61KfsVMqUbuQ6fMBNwTgLtBUfmH0QSPDWblVZgyrcTOQw16nKNLJuFNRjl(L1hsp0XvF(LUos1dJ6fXho56HrR46AxJEuHRmhNc633XQ3ptBVE106y2I1JQN8kcpUwCO3w9AX01slDS72tQi97BOa8DaGq7s(YAmqkzcQt)(shkuzoybjOecwhATCOX4DA7lPjMeRD69kp5CUjzlxXzlbboAhDL)vQmq0VuPO4fMJRJmczDPaROTglW0PGgXtq5bizRxLTseDYlBqnRn6tBgPUKyFbieRODFNno3LlsLw0RVlVH6sD9R)5W8VxS1wj0qMwfUVelBGwdQsqK6qatEHcCbmlBzG2U3Uy1ua51Hxhtq(bCy7lvfH4jfw2ETAdk44K1bFBiRT8lM60lR9nK16hftFTK1mtBJD2Bv((A3FuuU0mhx7DPPtoMv8xNrKXs0ptelRhvB09DM9HpBt)W4bufYy7QeKIpyFS18c35r4msCfBI8smSmPbRAyQzMRmoZJK06sxymg96j(Y24G(M5dj2mITSnb8b78QGuBiMCY6D1qdSt)wYongN1ymGRchWZ24A66vuBuoU(i1gP2viPSZo30WSwsd8X1ogDJC4bgzitYpKl3jG1tjJnsFJ9uYU(n5WvAaHL7MsgsjT)EziLErxgHKpQOT)rMvFleT1(EF)pYJQTs2V1ZJIQs5))tEuq1SvNge2AFEZ)(EBmcjRG1MJVWhP8pIvJFUV26Fn5kqRUIprzlI2IzPKLfZ3EHuPj9CB9bUWho6IIZ2n2qlJCT(GtKxEq99hHYseYe6r7lEifsKdg67zp52)Vp]] )