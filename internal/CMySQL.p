/*
	@file: /internal/CMySQL.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013, l0nger.programmer@gmail.com
*/

// CMySQL_Init: Nawiazuje polaczenie z MySQL - handler zapisujemy do zmiennej globalnej
stock CMySQL_Init(const hostname[], const username[], const password[], const dbname[], auto_reconnect=1) {
#if _DEBUG > 2
	ServerData[esd_MySQLHandler]=mysql_init(LOG_ALL);
#else 
	ServerData[esd_MySQLHandler]=mysql_init(LOG_ONLY_ERRORS);
#endif
	new handler=mysql_connect(hostname, username, password, dbname, ServerData[esd_MySQLHandler], auto_reconnect);
	if(handler) {
		return 1;
	} else {
		return 0;
	}
}

// CMySQL_Exit: Zamyka istniejace polaczenie z MySQL
stock CMySQL_Exit() {
	print(" [CMySQL]: Zamknieto polaczenie z MySQL");
	mysql_close(ServerData[esd_MySQLHandler]);
}