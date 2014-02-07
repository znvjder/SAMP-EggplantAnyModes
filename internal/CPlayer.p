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

stock theplayer::getFPS(playerid) 
{
	PlayerData[playerid][epd_fpsDrunkL]=GetPlayerDrunkLevel(playerid);
	if(PlayerData[playerid][epd_fpsDrunkL]<100) 
	{
		SetPlayerDrunkLevel(playerid, 2000);
	} else {
		if(PlayerData[playerid][epd_fpsLastDrunkL] != PlayerData[playerid][epd_fpsDrunkL])
		{
			PlayerData[playerid][epd_fpsValue]=(PlayerData[playerid][epd_fpsLastDrunkL]-PlayerData[playerid][epd_fpsDrunkL]);
			PlayerData[playerid][epd_fpsLastDrunkL]=PlayerData[playerid][epd_fpsDrunkL];
			return (0<PlayerData[playerid][epd_fpsValue]<200)? PlayerData[playerid][epd_fpsValue]-1: 0;
		}
	}
	return false;
}

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

stock theplayer::isAFK(playerid)
{
	if(IsPlayerConnected(playerid)) return (GetTickCount()-PlayerData[playerid][epd_ticklastUpdate])>AFK_TIME;
	return false;
}

stock theplayer::isSpawned(playerid) 
{
	new pState=GetPlayerState(playerid);
	return (pState != PLAYER_STATE_NONE && pState != PLAYER_STATE_WASTED && pState != PLAYER_STATE_SPECTATING);
}

stock theplayer::showATMDialog(playerid) 
{
	ShowPlayerDialog(playerid, DIALOG_ATM_HOME, DIALOG_STYLE_LIST, "Bankomat", "DO_UZUPELNIENIA", "Wybierz", "Anuluj");
}

// Attached object per player

#define CPLAYER_ATTACH_OBJECT_HAT (0)
#define CPLAYER_ATTACH_OBJECT_GLASS (1)

stock theplayer::loadAttachedObjects(playerid)
{
	if(PlayerData[playerid][epd_accountID]<=0) return;
	new tmpBuf[100], idx, modelid, bone, fPos[9], mcolor[2];
	CMySQL_Query("SELECT idx, modelid, bone, fX, fY, fZ, fRX, fRY, fRZ, fSX, fSY, fSZ, mcolor1, mcolor2 FROM playerClothes WHERE userID='%d'", -1, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	if(!mysql_num_rows()) return;
	while(mysql_fetch_row(tmpBuf, "|"))
	{
		if(sscanf(tmpBuf, "p<|>dddfffffffffxx", idx, modelid, bone, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], fPos[6], fPos[7], fPos[8], mcolor[0], mcolor[1])) continue;
		if(IsPlayerAttachedObjectSlotUsed(playerid, idx)) RemovePlayerAttachedObject(playerid, idx);
		SetPlayerAttachedObject(playerid, idx, modelid, bone, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], fPos[6], fPos[7], fPos[8], mcolor[0], mcolor[1]);
	}
	mysql_free_result();
}
