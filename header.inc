/*
	@file: /header.inc
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

// Poziom debugowania 
/*
	1) Debugowanie podstawowych rzeczy 
	(tu moga wystepowac lagi) 2) Debugowanie mniej waznych elementow 
	(i tu tez moga byc lagi) 3) Debugowanie wszystkiego
*/
#define _DEBUG_EASY (1)
#define _DEBUG_NORMAL (2)
#define _DEBUG_HARD (3)

// natives SA-MP
native GetPlayerClientId(playerid, const serial[], maxsize) = gpci;

#define CheckVehicleBounds(%0) if((%0)>(MAX_VEHICLES-1)) return false
#define CheckPlayerBounds(%0) if((%0)>(MAX_PLAYERS-1)) return false

#define CExecTick_begin(%0) new %0=GetTickCount()
#define CExecTick_end(%0) (GetTickCount()-%0)

#define bit_set(%0,%1) (%0)|=(%1)
#define bit_unset(%0,%1) (%0)&=~(%1)
#define bit_if(%0,%1) ((%0) & (%1))

// Color chat
#define COLOR_INFO1 (0)
#define COLOR_INFO2 (1)
#define COLOR_INFO3 (2)
#define COLOR_ERROR (3)
#define COLOR_PM (4)
#define COLOR_LOCAL (5)

#define MAX_COLORS_CHAT (6)

// Admins ranks
#define RANK_GAMEMASTER (1)
#define RANK_ADMIN (2)
#define RANK_MASTERADMIN (3)
#define RANK_DEV (4)

// Durations macros
/*
	Compile-time duration
	Example:
		DURATION(5 minutes, 20 seconds) == 320
*/
#define DURATION_MS(%1) (DURATION(%1) * 1000)
#define DURATION(%1) (DURATION_PT:%1,0)
#define DURATION_PT:%1, (%1:DURATION)+_:DURATION_PT:

#define second%1:DURATION
#define seconds%1:DURATION
#define minute%1:DURATION   * DURATION_MINUTE
#define minutes%1:DURATION  * DURATION_MINUTE
#define hour%1:DURATION     * DURATION_HOUR
#define hours%1:DURATION    * DURATION_HOUR
#define day%1:DURATION      * DURATION_DAY
#define days%1:DURATION     * DURATION_DAY
#define week%1:DURATION     * DURATION_WEEK
#define weeks%1:DURATION    * DURATION_WEEK
#define month%1:DURATION    * DURATION_MONTH
#define months%1:DURATION   * DURATION_MONTH
#define year%1:DURATION     * DURATION_YEAR
#define years%1:DURATION    * DURATION_YEAR

// Variables
enum 
{
	// dialogid
	DIALOG_BLANK=0,
	DIALOG_LOGIN=1,
	DIALOG_REGISTER,
	DIALOG_INSERT_EMAIL, // TODO: wysylanie wiadomosci powitalnej na adres email
	
	DIALOG_FRIENDS_INDEX,
	DIALOG_FRIENDS_LIST,
	DIALOG_FRIENDS_ACCEPTING,
	DIALOG_FRIENDS_INVITE,
	DIALOG_FRIENDS_PROPERTIES,
	DIALOG_FRIENDS_MESSAGE,
	DIALOG_FRIENDS_FDELETE,
	DIALOG_FRIENDS_FSHOWSTAT,
	
	DIALOG_ATM_HOME
};

enum 
{
	// Durations
	DURATION_SECOND=1,
	DURATION_MINUTE=60*DURATION_SECOND,
	DURATION_HOUR=60*DURATION_MINUTE,
	DURATION_DAY=24*DURATION_HOUR,
	DURATION_WEEK=7*DURATION_DAY,
	DURATION_MONTH=30*DURATION_DAY,
	DURATION_YEAR=365*DURATION_DAY,
	
	DURATION_PERMANENT=0,
	DURATION_EXPIRED = -1
};

enum 
{
	// Weaponslots
	WEAPONSLOT_NONE = 0xffffffff,
	WEAPONSLOT_FIST,
	WEAPONSLOT_MELEE,
	WEAPONSLOT_PISTOL,
	WEAPONSLOT_SHOTGUN,
	WEAPONSLOT_SMG,
	WEAPONSLOT_MACHINEGUN,
	WEAPONSLOT_RIFLE,
	WEAPONSLOT_HEAVY,
	WEAPONSLOT_PROJECTILE,
	WEAPONSLOT_SPECIAL_1,
	WEAPONSLOT_GIFTS,
	WEAPONSLOT_SPECIAL_2,
	WEAPONSLOT_DETONATORS,
        
	MAX_WEAPON_SLOT	
};

enum (<<=1) 
{
	// Properties player stuff
	PLAYER_NULL=0,
	PLAYER_INLOGINDIALOG=1,
	PLAYER_ISLOGGED,
	PLAYER_FIRSTSPAWN,
	PLAYER_HASCAP, // ma client audioplugin
	PLAYER_SYNCACP, // synchronizacja plikow audio - w tym czasie nie uwzgledniamy tego gracza przy "sprawdzaniu" pingu
};

enum (<<=1) 
{
	// Vehicle property stuff
	VEHICLE_NONE=0,
	VEHICLE_NOTSPAWNED,
	VEHICLE_SPAWNED, // pojazd jest zespawnowany na mapie
	VEHICLE_ISOWNED, // pojazd ma wlasciciela
	VEHICLE_DOOR_OPEN,
	VEHICLE_DOOR_CLOSED,
	VEHICLE_DESTROYED
};

enum e_VehicleData 
{
	Float:evd_pos[4], // x,y,z,rot
	evd_uid, // unique id
	evd_carid,
	evd_modelid,
	evd_properties,
	evd_tuning[13],
	evd_ownerID, // odpowiednik playerid
	evd_color[2],
	evd_doorEnterType, // wejscie do pojazdu jako kierowca/pasazer: 0=nikt, 1=znajomi, 2=czlonkowie gangu, 3=wszyscy
	evd_paintjob
};

enum e_ServerData 
{
	MySQL:esd_MySQLHandler,
	esd_streamerTickRate,
	esd_codeDebugger,
	esd_highestPlayerID,
	esd_countPlayersOnline,
};

enum e_PlayerData 
{
	epd_nickname[MAX_PLAYER_NAME],
	epd_addressIP[16],
	epd_serialID[32],
	epd_accountID,
	epd_loginAttempts,
	epd_lastSkin,
	epd_respect,
	epd_levelRP,
	epd_walletMoney,
	epd_bankMoney,
	epd_spawnType, // 0=ostatnie miejsce, 1=dom jezeli go ma ;-)
	epd_properties, // stuff do przechowywania wartosci 'specjalnych'
	epd_admin, // 0=nic, 1=mod, 2=admin, 3=master admin, 4=owner/developer
	bool:epd_haveVip,
	Float:epd_lastArmour,
	Float:epd_lastHealth,
	Float:epd_lastPos[4], // X, Y, Z, ROT
	// CEntries
	epd_entriesPickupDelay,
	Float:epd_entriesVelocity[3],
	// Commands
	epd_cmdSpamCount,
	epd_cmdSpamTime,
	// FPS
	epd_fpsDrunkL,
	epd_fpsLastDrunkL,
	epd_fpsValue,
	// CAudio
	epd_audioBgHandle,
	epd_audioAZHandle,
	// CFriends
	epd_lastMessageIDSender, // ostatnie ID piszacego PM
};

new 
	PlayerData[MAX_PLAYERS][e_PlayerData],
	ServerData[e_ServerData],
	VehicleData[MAX_VEHICLES][e_VehicleData],
	ConfigColorData[MAX_COLORS_CHAT][2];
	
stock const GTAVehicleNames[212][32] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Pereniel",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR 350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Smiglowiec",
	"News Chopper",
	"Terenowka",
	"FBI",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Smiglowiec policyjny",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer A",
	"Hotring Racer B",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Skladak",
	"Rower gorski",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker",
	"RoadTrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster A",
	"Monster B",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight",
	"Trailer",
	"Kart",
	"Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer A",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Trailer B",
	"Trailer C",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Radiowoz LSPD",
	"Radiowoz SFPD",
	"Radiowoz LVPD",
	"Radiowoz terenowy",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer A",
	"Luggage Trailer B",
	"Stair Trailer",
	"Boxville",
	"Farm Plow",
	"Utility Trailer"
};


stock const RealVehicleNames[212][32] =
{
	"Jeep Wagoneer",					// 400
	"Mercury Cougar",					// 401
	"Camaro with Scoop",				// 402
	"Big Rig",							// 403
	"Jeep Grand Wagoneer",				// 404
	"BMW 7-Series",						// 405
	"Dumptruck",						// 406
	"SA Firetruck",						// 407
	"Peterbuilt",						// 408
	"Lincoln Towncar",					// 409
	"Dodge Aries",						// 410
	"Acura NSX '05",					// 411
	"Chevy Biscayne",					// 412
	"Ford Aerostar",					// 413
	"Ford Box Van",						// 414
	"Ferrari Testarosso",				// 415
	"Ford Econoline",					// 416
	"Emergency Helicopter",				// 417
	"Chevrolet Astrovan",				// 418
	"Cadillac Eldorado",				// 419
	"Chevy Caprice",					// 420
	"Lincoln Mark 7",					// 421
	"Chevrolet S10",					// 422
	"Chevy Ice Cream Truck",			// 423
	"Volkswagen Beach Buggy",			// 424
	"AH-64A",							// 425
	"Chevrolet Caprice",				// 426
	"SWAT Van",							// 427
	"Securita Van",						// 428
	"Dodge Viper",						// 429
	"Preditor",							// 430
	"Volvo Bus",						// 431
	"M1A1 Abrams",						// 432
	"Barracks",							// 433
	"Ford Hot Rod",						// 434
	"Trailer",							// 435
	"Nissan Pulsar",					// 436
	"Old Coach",						// 437
	"Caprice Classic Cab",				// 438
	"Ford Mustang Mach 1",				// 439
	"Mercedes Van",						// 440
	"RC Bandit",						// 441
	"Cadillac Hearse",					// 442
	"Packer/Stunt Helper",				// 443
	"Chevy S-10 Monster Truck",			// 444
	"Mercedes-Benz S-Class",			// 445
	"Chris Craft Stinger",				// 446
	"Bell 47G",							// 447
	"Piaggio Vespa PX 200",				// 448
	"Tram",								// 449
	"Trailer",							// 450
	"Ferrari F40",						// 451
	"Go-Fast Boat",						// 452
	"Orca",								// 453
	"Sea Ray 270 Sedan Bridge",			// 454
	"Flatbed",							// 455
	"1992 Ford F800",					// 456
	"Golf Car",							// 457
	"Ford Taurus Wagon",				// 458
	"Honda Life '74",					// 459
	"Cessna 150 With Floats",			// 460
	"Honda CBR 600 '92",				// 461
	"Piaggio Vespa PX 200 '86",			// 462
	"Harley Davidson Soft Tail",		// 463
	"RC Red Baron",						// 464
	"RC Raider",						// 465
	"Dodge Dart",						// 466
	"Plymouth Belverdere",				// 467
	"Yamaha DT 200 Dirt Bike",			// 468
	"Bell 47G",							// 469
	"Hummer H-1",						// 470
	"Honda TRX250x '92",				// 471
	"Coastguard Boat",					// 472
	"Rescue Boat",						// 473
	"Mercury '51",						// 474
	"Chevy Chevelle",					// 475
	"Curtiss P-40D Warhawk",			// 476
	"Mazda RX-7",						// 477
	"Chevy Farm Truck",					// 478
	"Chevy Caprice Estate",				// 479
	"Porsche 911",						// 480
	"Schwinn BMX",						// 481
	"Dodge Ramvan",						// 482
	"Volkswagen Bus",					// 483
	"Endeavour 42",						// 484
	"Equitech M40 '85",					// 485
	"Bulldozer",						// 486
	"Bell 206L-4",						// 487
	"Bell 206B-3",						// 488
	"Ford Bronco",						// 489
	"Chevrolet Suburban '92",			// 490
	"Lincoln Mark 7",					// 491
	"Dodge Diplomat",					// 492
	"CMN Interceptor DV-15",			// 493
	"Ford Mustang LX",					// 494
	"Ford Bronco",						// 495
	"Honda CRX",						// 496
	"Bell 206L-4",						// 497
	"Chevy Cargo Van",					// 498
	"Ford Moving Van",					// 499
	"Jeep Wrangler",					// 500

	"RC Heli",							// 501
	"Ford Mustang LX '86",				// 502
	"Ford Mustang LX '86",				// 503
	"Customised Glendale",				// 504
	"Ford Bronco '80",					// 505
	"Mitsubishi 3000 GT",				// 506
	"Buick Roadmaster",					// 507
	"GMC R.V.",							// 508
	"Old Bike",							// 509
	"Schwinn Mesa Mountain Hardtail",	// 510

	"C-2 Greyhound",					// 511
	"Grumman G-164 AgCat",				// 512
	"Pitt's Special",					// 513
	"Gas Tanker",						// 514
	"International 9370 Truck",			// 515
	"Lincoln Towncar",					// 516
	"Chevy Monte Carlo",				// 517
	"Chevrolet Monte Carlo",			// 518
	"Bombardier Learjet 55",			// 519
	"AV-8 Harrier Jump-Jet",			// 520
	"Honda CBR 900 RR Fireblade",		// 521
	"Honda NSR 500 '01",				// 522
	"Kawasaki KZ1000-P21",				// 523
	"Chevrolet Cement Truck",			// 524
	"Tow Truck '91",					// 525
	"Ford Thunderbird",					// 526
	"Ford Escort",						// 527
	"CSI/FBI Investigation Truck",		// 528
	"Dodge Dynasty",					// 529
	"Forklift '89",						// 530
	"Old Tractor",						// 531
	"Combine Harvester",				// 532
	"Mercedes-Benz SL-Class",			// 533
	"Lincoln Mark 5",					// 534
	"Chevy CST '68",					// 535
	"Chevrolet Caprice Droptop",		// 536
	"1972 EMD SD40",					// 537
	"Amtrak F40PH",						// 538
	"Hovercraft",						// 539
	"Mercedes Benz E120",				// 540
	"Ford GT-40",						// 541
	"Dodge Challenger '70",				// 542
	"Dodge 100 Series",					// 543
	"SA Firetruck",						// 544
	"Ford Hotrod",						// 545
	"Chevrolet Lumina",					// 546
	"Oldsmobile Cutlass Ciera",			// 547
	"Sikorsky CH-53",					// 548
	"Dodge Roadrunner",					// 549
	"Late 80's Honda Sedan",			// 550
	"Mercury Grand Marquis",			// 551
	"Chevy 2500",						// 552
	"Douglas C-47",						// 553
	"GMC Sierra",						// 554
	"Jaguar XKE '66",					// 555
	"Chevy S-10 Monster Truck",			// 556
	"Chevy S-10 Monster Truck",			// 557
	"Eagle Talon",						// 558
	"Toyota Supra",						// 559
	"Impreza 2.5RS '95",				// 560
	"Honda Accord Wagon",				// 561
	"Nissan R34 Skyline",				// 562
	"Sikorsky UH-60 Black Hawk",		// 563
	"RC Tiger",							// 564
	"Honda Civic",						// 565
	"Oldsmobile Cutlass",				// 566
	"Chevy Impala",						// 567
	"Half Life 2 Sand Rail",			// 568
	"EMD SD40",							// 569
	"Trailer",							// 570
	"Go Kart",							// 571
	"Ride-On Lawn Mower",				// 572
	"Mercedes-Benz AK 4x4 '91",			// 573
	"Elgin Pelican",					// 574
	"Caddilac '54",						// 575
	"Chevy Bel Air '57",				// 576
	"Boeing 737",						// 577
	"Flatbed",							// 578
	"Range Rover",						// 579
	"Rolls Royce",						// 580
	"Honda VFR 400",					// 581
	"Dodge Ramvan Newsvan",				// 582
	"Baggage Tow Tractor HTAG-30/40",	// 583
	"Trailer",							// 584
	"Infinity J30 '92",					// 585
	"Honda Goldwing GL1500 '04",		// 586
	"Nissan 350Z/240SX",				// 587
	"Hotdog Van",						// 588
	"Volkswagen Golf",					// 589
	"Trailer",							// 590
	"Trailer",							// 591
	"Lockheed C-5 Galaxy",				// 592
	"Cessna 150",						// 593
	"Unknown",							// 594
	"CMN Interceptor DV-15",			// 595
	"Chevy Caprice LA",					// 596
	"Chevy Caprice SF",					// 597
	"Chevy Caprice LV",					// 598
	"Chevy Blazer Desert",				// 599
	"Chevrolet El Camino '68",			// 600
	"S.W.A.T. Van",						// 601
	"Dodge Stealth '91",				// 602
	"Pontiac Trans AM",					// 603
	"Dodge Dart",						// 604
	"Dodge 100 Series",					// 605
	"Luggage Trailer",					// 606
	"Luggage Trailer",					// 607
	"Stair Trailer",					// 608
	"Chevy Cargo Van",					// 609
	"Farm Plow",						// 610
	"Chevy 2500 Trailer"				// 611
};

