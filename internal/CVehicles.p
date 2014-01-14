/*
	@file: /internal/CVehicles.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define thevehicle:: thevehicle_

#define VEHICLE_ENTER_NOBODY (0)
#define VEHICLE_ENTER_FRIENDS (1)
#define VEHICLE_ENTER_GANGMEMBERS (2)
#define VEHICLE_ENTER_ALL (3)

#define thevehicle_getDoorEnterType(%0) VehicleData[(%0)-1][evd_doorEnterType]
#define thevehicle_getOwner(%0) VehicleData[(%0)-1][evd_ownerID]
#define thevehicle_getProperties(%0) VehicleData[(%0)-1][evd_properties]

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
	evd_tuning[12],
	evd_ownerID, // odpowiednik playerid
	evd_color[2],
	evd_doorEnterType, // wejscie do pojazdu jako kierowca/pasazer: 0=nikt, 1=znajomi, 2=czlonkowie gangu, 3=wszyscy
	evd_paintjob
};

new VehicleData[MAX_VEHICLES][e_VehicleData];

stock CVehicles_Init() {

}

stock CVehicles_Exit() {

}

stock thevehicle::create(modelid, owner=INVALID_PLAYER_ID, Float:x, Float:y Float:z, Float:rot, color[2]) {
	if(modelid<=400) return false;
	
	new carid=CreateVehicle(modelid, x, y, z, rot, color[0], color[1], DURATION(3 hours));
	VehicleData[carid-1][evd_carid]=carid;
	VehicleData[carid-1][evd_modelid]=modelid;
	VehicleData[carid-1][evd_pos][0]=x;
	VehicleData[carid-1][evd_pos][1]=y;
	VehicleData[carid-1][evd_pos][2]=z;
	VehicleData[carid-1][evd_pos][3]=rot;
	
	VehicleData[carid-1][evd_color]=color[0];
	VehicleData[carid-1][evd_color]=color[1];
	
	bit_set(VehicleData[carid-1][evd_properties], VEHICLE_DOOR_OPEN);
	
	if(owner==INVALID_PLAYER_ID) {
		bit_set(VehicleData[carid-1][evd_properties], VEHICLE_ISOWNED);
		VehicleData[carid-1][evd_ownerID]=INVALID_PLAYER_ID;
	} else {
		bit_set(VehicleData[carid-1][evd_properties], VEHICLE_ISOWNED);
		bit_set(VehicleData[carid-1][evd_properties], VEHICLE_DOOR_CLOSED); // zamykamy pojazd przed innymi osobnikami
		VehicleData[carid-1][evd_doorEnterType]=VEHICLE_ENTER_NOBODY;
		VehicleData[carid-1][evd_ownerID]=owner;
	}
	return true;
}

