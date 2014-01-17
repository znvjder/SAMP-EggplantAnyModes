/*
	@file: /internal/CUtility.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>,
		Andrew <andx98@wp.pl>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define RAND() random(cellmax-1)

#undef string
#define string:: string_

stock string::copy(dest[], const source[], length = sizeof(source)) // by promsters
{
	strins((dest[0] = EOS, dest), source, 0, length);
}

stock string::replace(subject[], const search[], const replace[]) { // w przyszlosci zostanie ta funkcja napisana w pluginie
	new start_pos,
		searchLen=strlen(search),
		replaceLen=strlen(replace),
		subjectLen=strlen(subject);
	while((start_pos=strfind(subject, search)) != -1) {
		strdel(subject, start_pos, start_pos+searchLen);
		strins(subject, replace, start_pos, subjectLen+replaceLen);
		start_pos+=replaceLen;
	}
}

#define math:: math_ // taki tam stuff
#define math_pi() (3.14159)

stock Float:math::length2D(Float:x, Float:y) {
	return floatsqroot((x*x)+(y*y));
}

stock Float:math::length3D(Float:x, Float:y, Float:z) {
	return floatsqroot((x*x)+(y*y)+(z*z));
}

stock Float:math::betweenDist2D(Float:x1, Float:y1, Float:x2, Float:y2) {
	return floatsqroot((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
}

stock Float:math::betweenDist3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
	return floatsqroot((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
}

stock Float:math::calculateVelocity3D(Float:x, Float:y, Float:z, Float:mod) {
	return floatsqroot((x*x)+(y*y)+(z*z))*mod;
}

stock math::abs(val) return (val<0)? -val: val;

stock Float:math::floatrandom(Float:max, Float:min = 0.0, dp = 4)
{
    new
        Float:mul = floatpower(10.0, dp),
        imin = floatround(min*mul),
        imax = floatround(max*mul);
		
    return float(random(imax-imin)+imin)/mul;
}

#define theplayer:: theplayer_ // taki tam stuff, cos z player:: bylo zjebane
#define theplayer_kick(%0) SetTimerEx("KickCalled", 150, false, "d", %0)
#define theplayer_foreach(%0) for(new %0; %0<=ServerData[esd_highestPlayerID] && IsPlayerConnected(%0); %0++) 

stock theplayer::isGamemaster(playerid) {
	if(!IsPlayerConnected(playerid)) return false;
	return (PlayerData[playerid][epd_admin]>=RANK_GAMEMASTER);
}

stock theplayer::isAdmin(playerid, level=RANK_ADMIN) {
	if(!IsPlayerConnected(playerid)) return false;
	return (PlayerData[playerid][epd_admin]>=level);
}

stock theplayer::removeWeapon(playerid, weaponid) {
	new slot = utility::getWeaponSlot(weaponid), weapon, ammo;
	if(!slot) return;
	ResetPlayerWeapons(playerid);
	for (new i=1; i<=12; i++) {
		if (slot != i) {
			GetPlayerWeaponData(playerid, i, weapon, ammo);
			GivePlayerWeapon(playerid, weapon, ammo);
		}
	}
}

#define utility:: utility_
#define utility_resetVariablesInEnum(%0,%1) for(new __rvine; %1:__rvine != %1; __rvine++) %0[%1:__rvine]=0

stock utility::setColorAlpha(color, alpha) {
	return (((color >> 24) & 0xFF) << 24 | ((color >> 16) & 0xFF) << 16 | ((color >> 8) & 0xFF) << 8 | floatround((float(color & 0xFF) / 255) * alpha));
}

stock utility::getWeaponSlot(weaponid)
{
	static const
		s_weaponSlots[] =
		{
			0x00000101, 0x01010101, 0x01010A0A, 0x0A0A0A0A,
			0x080808FF, 0xFFFF0202, 0x02030303, 0x04040505,
			0x04060607, 0x07070708, 0x0C090909, 0x0B0B0B00
		};
	
	if(0 <= weaponid <= 46) return (s_weaponSlots{weaponid}==0xFF)? WEAPONSLOT_NONE: s_weaponSlots{weaponid};
	return WEAPONSLOT_NONE;

}

stock utility::addAllSkins() {
	for(new i=0; i<=298; i++) {
		AddPlayerClass(i, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	}
}

stock utility::isValidSkin(skinid) {
	return (0 <= skinid <= 299);
}

// Kick fix
forward KickCalled(pid);
public KickCalled(pid) {
	if(!IsPlayerConnected(pid)) return; // sprawdzamy, czy gracz do tego momentu nie wyszedl xD
	Kick(pid);
}
