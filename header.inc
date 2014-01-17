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
enum {
	// dialogid
	DIALOG_BLANK=0,
	DIALOG_LOGIN=1,
	DIALOG_REGISTER,
	DIALOG_INSERT_EMAIL, // TODO: wysylanie wiadomosci powitalnej na adres email
};

enum {
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

enum {
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

enum (<<=1) {
	// Properties player stuff
	PLAYER_NULL=0,
	PLAYER_INLOGINDIALOG=1,
	PLAYER_ISLOGGED,
	
	
};

enum (<<=1) {
	// Vehicle property stuff
	VEHICLE_NONE=0,
	VEHICLE_NOTSPAWNED,
	VEHICLE_SPAWNED, // pojazd jest zespawnowany na mapie
	VEHICLE_ISOWNED, // pojazd ma wlasciciela
	VEHICLE_DOOR_OPEN,
	VEHICLE_DOOR_CLOSED,
	VEHICLE_DESTROYED
};

enum e_VehicleData {
	Float:evd_pos[4], // x,y,z,rot
	evd_carid,
	evd_modelid,
	evd_properties,
	evd_tuning[13],
	evd_ownerID, // odpowiednik playerid
	evd_color[2],
	evd_doorEnterType, // wejscie do pojazdu jako kierowca/pasazer: 0=nikt, 1=znajomi, 2=czlonkowie gangu, 3=wszyscy
	evd_paintjob
};

enum e_ServerData {
	MySQL:esd_MySQLHandler,
	esd_streamerTickRate,
	esd_codeDebugger,
	esd_highestPlayerID
};

enum e_PlayerData {
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
};

new 
	PlayerData[MAX_PLAYERS][e_PlayerData],
	ServerData[e_ServerData],
	VehicleData[MAX_VEHICLES][e_VehicleData],
	ConfigColorData[MAX_COLORS_CHAT][2];
