/*
	@file: /internal/CUtility.p
	@author: l0nger <l0nger.programmer@gmail.com>
	@licence: GPLv2
	
	(c) 2013, l0nger.programmer@gmail.com
*/

#define PATH_logs "/EggplantDM/logs/"
#define CLOG_SERVER (0)
#define CLOG_SQL (1)
#define CLOG_CMDS (2)
#define CLOG_DEBUG (3)

#define CLOG_SERVER_NAME "server"
#define CLOG_SQL_NAME "sql"
#define CLOG_CMDS_NAME "commands"
#define CLOG_DEBUG_NAME "debug"

#define flushFile(%0) fclose(fopen(%0))

static stock 
	string_LoggingBuffer[160],
	File:logFile,
	logTime[3],
	logDate[3];

// 	CLogging_Init: inicjajcja klasy
stock CLogging_Init() {
	printf("[CLogging]: Loaded and recreated all logging files...");
}

stock CLogging_Exit() {
	printf("[CLogging]: Deactived logging");
}

stock CLogging_Insert(logtype, txt[], va_args<>) {
	if(isnull(txt))
    {
        print("[CLogging]: Input text is null");
		return 0;
    }

    new fName[48];
		
    switch(logtype)
    {
        case CLOG_SERVER: strcat(fName, CLOG_SERVER_NAME);
        case CLOG_SQL: strcat(fName, CLOG_SQL_NAME);
        case CLOG_CMDS: strcat(fName, CLOG_CMDS_NAME);
		case CLOG_DEBUG: strcat(fName, CLOG_DEBUG_NAME);
        default: strcat(fName, "unkown");
    }
    
	gettime(logTime[0], logTime[1], logTime[2]);
	getdate(logDate[0], logDate[1], logDate[2]);
	
	format(fName, sizeof(fName), "%s%s-%04d%02d%02d.log", PATH_logs, fName, logDate[0], logDate[1], logDate[2]);
	logFile = fopen(fName, io_append);
	
	if(!logFile)
	{
		// tworzymy plik, jezeli go nie ma
		fclose(fopen(fName, io_write));
		// otwieramy ponownie plik - tym razem innym parametrem
		logFile = fopen(fName, io_append);
	}
	
	if(numargs()>2)
	{
		va_format(string_LoggingBuffer, sizeof(string_LoggingBuffer), txt, va_start<2>);
		format(string_LoggingBuffer, sizeof(string_LoggingBuffer), "[%02d:%02d:%02d]: %s\n", logTime[0], logTime[1], logTime[2], string_LoggingBuffer);
		fwrite(logFile, string_LoggingBuffer);
	} else {
		format(string_LoggingBuffer, sizeof(string_LoggingBuffer), "[%02d:%02d:%02d]: %s\n", logTime[0], logTime[1], logTime[2], txt);
		fwrite(logFile, string_LoggingBuffer);
	}
	fclose(logFile);
	return 1;
}

#undef CLOG_SERVER_NAME
#undef CLOG_SQL_NAME
#undef CLOG_CMDS_NAME
#undef CLOG_DEBUG_NAME