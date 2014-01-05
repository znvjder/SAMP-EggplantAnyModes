/*
	@file: /internal/CUtility.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>,
		Andrew <andx@wp.pl>
		
	@licence: GPLv2
	
	(c) 2013, l0nger.programmer@gmail.com
*/

#define RAND() random(cellmax-1)

#undef strcpy
stock strcpy(dest[], const source[], length = sizeof(source)) // by promsters
{
	strins((dest[0] = EOS, dest), source, 0, length);
}

#define math:: math_ // taki tam stuff
#define math_pi() (3.14159)

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

stock theplayer::removeWeapon(playerid, weaponid) {
	new slot = GetWeaponSlot(weaponid), weapon, ammo;
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

// Kick fix
forward KickCalled(pid);
public KickCalled(pid) {
	if(!IsPlayerConnected(pid)) return; // sprawdzamy, czy gracz do tego momentu nie wyszedl xD
	Kick(pid);
}
