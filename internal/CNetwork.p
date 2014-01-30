/*
	@file: /internal/CNetwork.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

#define network:: network_

stock network::setServerSyncRate(playersCount)
{
	/*
		Funkcja ma za zadanie zmniejszyc obciazenie sieci przy wiekszej ilosci graczy
	*/
	#define PATH_minimal "scriptfiles/EggplantDM/config/samp-network/serverMinimal"
	#define PATH_normal "scriptfiles/EggplantDM/config/samp-network/serverNormal"
	#define PATH_high "scriptfiles/EggplantDM/config/samp-network/serverHigh"
	#define PATH_vhigh "scriptfiles/EggplantDM/config/samp-network/serverVeryHigh"
	
	new bufPath[128];
	switch(playersCount)
	{
		case 1, 49:
		{
			format(bufPath, sizeof(bufPath), "exec %s", PATH_vhigh);
			SendRconCommand(bufPath);
		}
		case 50, 99:
		{
			format(bufPath, sizeof(bufPath), "exec %s", PATH_high);
			SendRconCommand(bufPath);
		}
		case 100, 199:
		{
			format(bufPath, sizeof(bufPath), "exec %s", PATH_normal);
			SendRconCommand(bufPath);
		}
		case 200:
		{
			format(bufPath, sizeof(bufPath), "exec %s", PATH_minimal);
			SendRconCommand(bufPath);
		}
	}
	#undef PATH_minimal
	#undef PATH_normal
	#undef PATH_high
	#undef PATH_vhigh
}