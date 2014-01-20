/*
	@file: /internal/CAnticheat.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

stock CAnticheat_Init() {

}

stock CAnticheat_Exit() {

}

stock CAnticheat_CheckPlayer(playerid) {
	new tmpAC[16];
	GetPlayerVersion(playerid, tmpAC, sizeof(tmpAC));
	if(!strcmp(tmpAC, CAC_SOBEIT_VERSION)) {
		return true;
	}
	return false;
}
