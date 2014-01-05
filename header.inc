/*
	@file: /header.inc
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013, l0nger.programmer@gmail.com
*/

#define CExecTick_begin(%0) new %0=GetTickCount()
#define CExecTick_end(%0) (GetTickCount()-%0)

#define bit_set(%0,%1) %0|=%1
#define bit_unset(%0,%1) %0&=~%1
#define bit_if(%0,%1) ((%0) & (%1))

// Variables
enum {
	// dialogid
	DIALOG_BLANK=0,
	DIALOG_LOGIN=1,
	DIALOG_REGISTER,
	DIALOG_INSERT_EMAIL, // TODO: wysylanie wiadomosci powitalnej na adres email
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
	// Admin stuff
	
};

enum e_ServerData {
	MySQL:esd_MySQLHandler,
	esd_streamerTickRate,
	
};

new ServerData[e_ServerData];
