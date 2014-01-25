/*
	@file: /internal/commands/cmds_players.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

CMD:rejestracja(playerid) 
{
	if(bit_if(PlayerData[playerid][epd_properties], PLAYER_ISLOGGED)) return theplayer::sendMessage(playerid, COLOR_ERROR, "Jesteœ ju¿ zarejestrowany.");
	
	theplayer::showRegisterDialog(playerid);
	return 1;
}

CMD:register(playerid) return cmd_rejestracja(playerid);

CMD:znajomi(playerid) 
{
	if(!bit_if(PlayerData[playerid][epd_properties], PLAYER_ISLOGGED)) return theplayer::sendMessage(playerid, COLOR_ERROR, "Aby skorzystaæ z tej komendy musisz zarejestrowaæ konto.");
	CFriends_ShowHomePage(playerid);
	return 1;
}

CMD:friends(playerid) return cmd_znajomi(playerid);