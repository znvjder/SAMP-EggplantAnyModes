/*
	@file: /internal/CPlayer.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define theplayer:: theplayer_ // taki tam stuff, cos z player:: bylo zjebane
#define theplayer_kick(%0) SetTimerEx("KickCalled", 150, false, "d", %0)
#define theplayer_foreach(%0) for(new %0; %0<=ServerData[esd_highestPlayerID] && IsPlayerConnected(%0); %0++) 

stock theplayer::isGamemaster(playerid) 
{
	if(!IsPlayerConnected(playerid)) return false;
	return (PlayerData[playerid][epd_admin]>=RANK_GAMEMASTER);
}

stock theplayer::isAdmin(playerid, level=RANK_ADMIN) 
{
	if(!IsPlayerConnected(playerid)) return false;
	return (PlayerData[playerid][epd_admin]>=level);
}

stock theplayer::removeWeapon(playerid, weaponid) 
{
	new slot = utility::getWeaponSlot(weaponid), weapon, ammo;
	if(!slot) return;
	ResetPlayerWeapons(playerid);
	for (new i=1; i<=12; i++) 
	{
		if (slot != i)
		{
			GetPlayerWeaponData(playerid, i, weapon, ammo);
			GivePlayerWeapon(playerid, weapon, ammo);
		}
	}
}

stock theplayer::teleport(playerid, bool:streamerSync=true, Float:x, Float:y, Float:z, Float:rot, interior=-1, vw=-1) 
{
	new vid=GetPlayerVehicleID(playerid);
	if(vid) 
	{
		SetVehiclePos(vid, x, y, z+0.35);
		SetVehicleZAngle(vid, rot);
		if(vw != -1) SetVehicleVirtualWorld(vid, vw);
		if(interior != -1) LinkVehicleToInterior(vid, interior);
	} else {
		SetPlayerPos(playerid, x, y, z+0.35);
		SetPlayerFacingAngle(playerid, rot);
		if(vw != -1) SetPlayerVirtualWorld(vid, vw);
		if(interior != -1) SetPlayerInterior(vid, interior);
	}
	if(streamerSync) Streamer_Update(playerid);
	SetCameraBehindPlayer(playerid);
}


stock theplayer::isSpawned(playerid) 
{

}

stock theplayer::showATMDialog(playerid) 
{
	ShowPlayerDialog(playerid, DIALOG_ATM_HOME, DIALOG_STYLE_LIST, "Bankomat", "DO_UZUPELNIENIA", "Wybierz", "Anuluj");
}