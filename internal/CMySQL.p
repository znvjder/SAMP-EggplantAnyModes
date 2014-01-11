/*
	@file: /internal/CMySQL.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

static stock
	string_MySQLBuffer[384];
	
// CMySQL_Init: Nawiazuje polaczenie z MySQL - handler zapisujemy do zmiennej globalnej
stock CMySQL_Init(const hostname[], const username[], const password[], const dbname[], auto_reconnect=1) {
	if(ServerData[esd_codeDebugger]<=_DEBUG_NORMAL)
		ServerData[esd_MySQLHandler]=mysql_init(LOG_ALL);
	else
		ServerData[esd_MySQLHandler]=mysql_init(LOG_ONLY_ERRORS);
		
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

/*
		CMySQL_Query:
	@desc: 
		Wysylanie zapytania do serwera MySQL
	@params:
		string query[] - zapytanie wysylane do serwera mysql
		int resultid - zapytanie wykonywane w danych resulcie
		va_args<> - argumenty wlasne
	@returns:
		0 - jezeli zapytanie wysle sie prawidlowo
		1 - jezeli nastapi blad
		(standardowe wartosci z mysql_query)
*/
stock CMySQL_Query(query[], resultid=(-1), va_args<>) {
	string_MySQLBuffer[0]=EOS;
	if(numargs()>2) {
		va_format(string_MySQLBuffer, sizeof(string_MySQLBuffer), query, va_start<2>);
		return mysql_query(string_MySQLBuffer, resultid);
	} else {
		return mysql_query(query, resultid);
	}
}

public OnMysqlQuery(resultid, spareid, MySQL:handle) {
	switch(resultid) {
		case -1: {
			if(mysql_result_stored()) mysql_free_result();
			return 1;
		}
	}
	return 1;
}

public OnMysqlError(error[], errorid, MySQL:handle) {
	if(errorid == 8) return;
	if(ServerData[esd_codeDebugger]>=_DEBUG_NORMAL) {
		CLogging_Insert(CLOG_DEBUG, "Error MySQL: %s (%d)", error, errorid);
	}
}