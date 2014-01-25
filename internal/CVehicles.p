/*
	@file: /internal/CVehicles.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		Zielony745 <SzymonGeek@gmail.com>
		
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

stock CVehicles_Init() {
	CVehicles_loadAll();
}

stock CVehicles_Exit() {
	for (new vehh; vehh < /*max_veh*/; vehh++)
	{
		CVehicles_Save( vehh );
	}
}

stock CVehicles_loadAll() {
	new buf[128], tmpTuning[128], addData[11], tmpColor[2];
	CMySQL_Query("SELECT modelid, fX, fY, fZ, fAng, doors, dmgPanels, dmgDoors, dmgLights, dmgTires, color1, color2, tuning, hp FROM vehicles WHERE owner=0;", -1);
	mysql_store_result();
	new i, vid;
	while(mysql_fetch_row(buf, "|")) {
		sscanf(buf, "p<|>dffffddddddds[128]f", 
			addData[0], Float:addData[1],
			Float:addData[2], Float:addData[3],
			Float:addData[4], addData[5],
			addData[6], addData[7], 
			addData[8], addData[9],
			tmpColor[0], tmpColor[1],
			tmpTuning, addData[10]
		);	
		
		vid=thevehicle::create(addData[0], _, Float:addData[1], Float:addData[2], Float:addData[3], Float:addData[4], tmpColor);
		sscanf(tmpTuning, "p<;>a<d>[12]", VehicleData[vid-1][evd_tuning]);
		for(new j; j<12; j++) {
			AddVehicleComponent(vid, VehicleData[vid-1][evd_tuning][j]);
		}
		
		i++;
	}
	mysql_free_result();
	printf("[CVehicles]: Wczytano %d pojazdow.", i);
}

//Kod zostanie dokończony w najbliższym czasie!
stock CVehicles_Save( vehid )
{
	new tmp_format[100];
	format(tmp_format, 100, "UPDATE vehicles SET fX=%f, fY=%f, fZ=%f, fANG=%f, doors=%i, dmgPanels=%i, dmgDoors=%i, dmgLights=%i, dmgTires=%i, color1=%i, color2=%i, tuning=%s, hp=%f, owner=%i WHERE id = %d", 
	VehicleData[vehid][evd_pos][0], VehicleData[vehid][evd_pos][1], VehicleData[vehid][evd_pos][2], VehicleData[vehid][evd_pos][3], VehicleData[vehid][], vehid)
}
//

stock thevehicle::create(modelid, owner=INVALID_PLAYER_ID, Float:x=0.0, Float:y=0.0, Float:z=1.0, Float:rot=90.0, color[2]) {
	if(modelid<400) return false;
	
	new carid=CreateVehicle(modelid, x, y, z, rot, color[0], color[1], DURATION(3 hours));
	VehicleData[carid-1][evd_carid]=carid;
	VehicleData[carid-1][evd_modelid]=modelid;
	VehicleData[carid-1][evd_pos][0]=x;
	VehicleData[carid-1][evd_pos][1]=y;
	VehicleData[carid-1][evd_pos][2]=z;
	VehicleData[carid-1][evd_pos][3]=rot;
	
	VehicleData[carid-1][evd_color]=color[0];
	VehicleData[carid-1][evd_color]=color[1];
	
	if(owner==INVALID_PLAYER_ID) {
		bit_set(VehicleData[carid-1][evd_properties], VEHICLE_DOOR_OPEN);
		VehicleData[carid-1][evd_ownerID]=INVALID_PLAYER_ID;
	} else {
		bit_set(VehicleData[carid-1][evd_properties], VEHICLE_ISOWNED);
		bit_set(VehicleData[carid-1][evd_properties], VEHICLE_DOOR_CLOSED); // zamykamy pojazd przed innymi osobnikami
		VehicleData[carid-1][evd_doorEnterType]=VEHICLE_ENTER_NOBODY;
		VehicleData[carid-1][evd_ownerID]=owner;
	}
	return carid;
}

CMD:addpojazd(playerid, params[]) {
	if(!theplayer::isAdmin(playerid, RANK_DEV)) return theplayer::sendMessage(playerid, COLOR_ERROR, "[E] Brak uprawnien do uzywania tej komendy!");
	
	new Float:PP[4], tmpColor[2];
	GetPlayerPos(playerid, PP[0], PP[1], PP[2]);
	GetPlayerFacingAngle(playerid, PP[3]);
	tmpColor[0]=random(250);
	tmpColor[1]=random(250)+1;
	thevehicle::create(strval(params), _, PP[0], PP[1], PP[2], PP[3], tmpColor);
	CMySQL_Query("INSERT INTO vehicles (modelid, fX, fY, fZ, fAng, color1, color2) VALUES (%d, '%f', '%f', '%f', '%f', %d, %d);", -1, strval(params), PP[0], PP[1], PP[2], PP[3], tmpColor[0], tmpColor[1]);
	return 1;
}