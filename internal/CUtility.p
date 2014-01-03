/*
	@file: /internal/CUtility.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013, l0nger.programmer@gmail.com
*/

#define RAND() random(cellmax-1)

stock strcpy(dest[], const source[], length = sizeof(source)) // by promsters
{
	strins((dest[0] = EOS, dest), source, 0, length);
}

#define math:: math_ // taki tam stuff
#define math::pi() (3.14159)

stock math::length2D(Float:x, Float:y) {
	return floatsqroot((x*x)+(y*y));
}

stock math::length3D(Float:x, Float:y, Float:z) {
	return floatsqroot((x*x)+(y*y)+(z*z));
}

stock math::betweenDist2D(Float:x1, Float:y1, Float:x2, Float:y2) {
	return floatsqroot((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
}

stock math::betweenDist3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
	return floatsqroot((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
}

stock math::calculateVelocity3D(Float:x, Float:y, Float:z, Float:mod) {
	return floatsqroot((x*x)+(y*y)+(z*z))*mod;
}

stock math::abs(val) return (v<0)? -v: v;

stock Float:math::floatrandom(Float:max, Float:min = 0.0, dp = 4)
{
    new
        Float:mul = floatpower(10.0, dp),
        imin = floatround(min*mul),
        imax = floatround(max*mul);
		
    return float(random(imax-imin)+imin)/mul;
}

#define theplayer:: theplayer_ // taki tam stuff, cos z player:: bylo zjebane

stock theplayer::removeWeapon(playerid, weaponid) {
	static weaponData[2][12];
	weaponData[0]=EOS;
	weaponData[1]=EOS;
	
	for(new i; i<sizeof(weaponData[]); i++) {
		GetPlayerWeaponData(playerid, i, weapondData[0][i], weaponData[1][i]);
		if(weaponData[0][i]==weaponid) {
			weaponData[0][i]=0;
			weaponData[0][i]=0;
		}
	}
	ResetPlayerWeapons(playerid);
	for(new i; i!=12; i++) {
		GivePlayerWeapon(playerid, weaponData[0][i], weaponData[1][i]);
	}
	// nie mam pomyslu na optymalniejsza metode... 
}

// Kick fix
forward KickCalled(pid);
public KickCalled(pid) {
	if(!IsPlayerConnected(pid)) return; // sprawdzamy, czy gracz do tego momentu nie wyszedl xD
	Kick(pid);
}
