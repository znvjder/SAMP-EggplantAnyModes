/*
	@file: /internal/CAccounts.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

// TODO:
// (gotowe) 1) Wykonac tabele z uzytkownikami
// (wip) 2) Oprogramowac te funkcje

#define MAX_LOGIN_ATTEMPTS (4)

stock CAccounts_Init() 
{
	new tmpResult;
	CMySQL_Query("SELECT COUNT(*) FROM accounts;", -1);
	mysql_store_result();
	tmpResult=mysql_fetch_int();
	mysql_free_result();
	printf("[CAccounts]: Number of registered accounts %d", tmpResult);
}

stock CAccounts_Exit() 
{
	// TODO:
	// Zapisywanie statystyk wszystkich graczy
	//theplayer::foreach(i) {
	//	theplayer::CAccounts_saveData(playerid);
	//}
}

stock theplayer::isRegistered(playerid) 
{
	new bool:v=false;
	CMySQL_Query("SELECT 1 FROM accounts WHERE nickname='%s' LIMIT 1;", -1, PlayerData[playerid][epd_nickname]);
	mysql_store_result();
	if(mysql_num_rows()) v=true;
	mysql_free_result();
	return v;
}

stock theplayer::getAccountIDByName(szNick[]) 
{
	CMySQL_Query("SELECT id FROM accounts WHERE nickname='%s' LIMIT 1;", -1, szNick);
	mysql_store_result();
	new tmpResult;
	if(mysql_num_rows()) tmpResult=mysql_fetch_int();
	mysql_free_result();
	return tmpResult;
}

stock theplayer::getAccountID(playerid) 
{
	if(PlayerData[playerid][epd_accountID]>0) return PlayerData[playerid][epd_accountID];
	CMySQL_Query("SELECT id FROM accounts WHERE nickname='%s' LIMIT 1;", -1, PlayerData[playerid][epd_nickname]);
	mysql_store_result();
	new tmpResult;
	if(mysql_num_rows()) tmpResult=mysql_fetch_int();
	mysql_free_result();
	return tmpResult;
}

stock theplayer::isAccountExists(szAccount[]) 
{
	if(isnull(szAccount)) return false;
	new bool:v=false;
	CMySQL_Query("SELECT 1 FROM accounts WHERE nickname='%s' LIMIT 1;", -1, szAccount);
	mysql_store_result();
	if(mysql_num_rows()) v=true;
	mysql_free_result();
	return v;
}

stock theplayer::onEventLogin(playerid, input[], bool:autologin=false) {
	if(!autologin) 
	{
		if(isnull(input)) 
		{
			theplayer::sendMessage(playerid, COLOR_ERROR, "Nie wpisano has³a.");
			theplayer::showLoginDialog(playerid);
			return false;
		} 
		else if(!(6<=strlen(input)<=16)) 
		{
			theplayer::sendMessage(playerid, COLOR_ERROR, "Wprowadzone has³o jest zbyt krótkie lub za d³ugie...");
			theplayer::showLoginDialog(playerid);
			return false;
		}
		
		new bool:success=false, esc_input[26];
		mysql_real_escape_string(input, esc_input);
		CMySQL_Query("SELECT (password=SHA1(MD5('%s'))) AS validpwd FROM accounts WHERE nickname='%s';", -1, esc_input, PlayerData[playerid][epd_nickname]);
		mysql_store_result();
		success=!!mysql_fetch_int();
		mysql_free_result();
		
		if(success)
		{
			theplayer::loadAccountData(playerid);
			PlayerData[playerid][epd_accountID]=theplayer::getAccountID(playerid);
			theplayer::setAccountDataString(playerid, "NOW()", false, "ts_last");
			theplayer::setAccountDataString(playerid, "visits+1", false, "visits");
			theplayer::setAccountDataString(playerid, PlayerData[playerid][epd_addressIP], true, "ip_last");
			theplayer::setAccountDataString(playerid, PlayerData[playerid][epd_serialID], true, "serial_last");
			theplayer::sendMessage(playerid, COLOR_INFO1, "Zalogowano pomyœlnie. Ostatnia wizyta na serwerze: %s", theplayer::getAccountDataString(playerid, "ts_last"));
			
			bit_unset(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG);
			bit_set(PlayerData[playerid][epd_properties], PLAYER_ISLOGGED);
			OnPlayerRequestClass(playerid, 0);
		} else {
			if(++PlayerData[playerid][epd_loginAttempts]>=MAX_LOGIN_ATTEMPTS) 
			{
				theplayer::hideDialog(playerid);
				theplayer::sendMessage(playerid, COLOR_ERROR, "Wykorzysta³eœ maksymaln¹ iloœæ prób zalogowañ na to konto.");
				// TODO: Informowanie administracji o tym przypadku
				theadmins::sendMessage(COLOR_ERROR, RANK_MASTERADMIN, "Próba zalogowania na konto <b>%s<b> z adresu IP: <b>%s</b> - wyrzucony.", PlayerData[playerid][epd_nickname], PlayerData[playerid][epd_addressIP]);
				theplayer::kick(playerid);
				return false;
			}
			theplayer::sendMessage(playerid, COLOR_ERROR, "Wprowadzone has³o jest nieprawid³owe. Spróbuj ponownie.");
			theplayer::showLoginDialog(playerid);
		}
	} else {
		theplayer::loadAccountData(playerid);
		PlayerData[playerid][epd_accountID]=theplayer::getAccountID(playerid);
		theplayer::setAccountDataString(playerid, "NOW()", false, "ts_last");
		theplayer::setAccountDataString(playerid, "visits+1", false, "visits");
		theplayer::setAccountDataString(playerid, PlayerData[playerid][epd_addressIP], true, "ip_last");
		theplayer::setAccountDataString(playerid, PlayerData[playerid][epd_serialID], true, "serial_last");
		theplayer::sendMessage(playerid, COLOR_INFO1, "Zalogowano automatycznie. Ostatnia wizyta na serwerze: %s", theplayer::getAccountDataString(playerid, "ts_last"));
			
		bit_unset(PlayerData[playerid][epd_properties], PLAYER_INLOGINDIALOG);
		bit_set(PlayerData[playerid][epd_properties], PLAYER_ISLOGGED);
		OnPlayerRequestClass(playerid, 0);
	}
	return true;
}

stock theplayer::onEventRegister(playerid, input[]) 
{
	if(isnull(input)) 
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Nie wpisano has³a.");
		theplayer::showRegisterDialog(playerid);
		return false;
	} 
	else if(!(6<=strlen(input)<=16))
	{
		theplayer::sendMessage(playerid, COLOR_ERROR, "Wprowadzone has³o jest zbyt krótkie lub za d³ugie...");
		theplayer::showRegisterDialog(playerid);
		return false;
	}
	
	new esc_passwd[26], cSerial[32];
	mysql_real_escape_string(input, esc_passwd);
	GetPlayerClientId(playerid, cSerial, 32);
	CMySQL_Query("INSERT INTO accounts (nickname, password, ip_register, ip_last, ts_register, ts_last, serial_registered, serial_last, skin) VALUES ('%s', SHA1(MD5('%s')), '%s', '%s', NOW(), NOW(), '%s', '%s', %d);", -1,
		PlayerData[playerid][epd_nickname], 
		esc_passwd, 
		PlayerData[playerid][epd_addressIP], 
		PlayerData[playerid][epd_addressIP], 
		cSerial, 
		cSerial, 
		GetPlayerSkin(playerid)
	);
	PlayerData[playerid][epd_accountID]=mysql_insert_id();
	CMySQL_Query("INSERT INTO players_weapons SET owner='%d'", PlayerData[playerid][epd_accountID]);
	
	ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Panel rejestracji", 
		"Gratulacje! Dzisiejszego dnia dokona³eœ(aœ) dobrego wyboru, rejestruj¹c u nas konto.\nMamy nadzieje, ¿e bêdzie Ci siê dobrze graæ.\n\
		Nic innego ¿yczyæ nie mo¿emy, prócz przyjmnej gry na naszym serwerze!\nW ramach nagrody za za³o¿enie u nas konta, dostajesz 500 RP + 1000$ na lekki start!", 
		"Zamknij", ""
	);
	return true;
}

stock theplayer::hideDialog(playerid) 
{
	ShowPlayerDialog(playerid, DIALOG_BLANK, 0, "", "", "", "");
}

stock theplayer::showLoginDialog(playerid) 
{
	ShowPlayerDialog(playerid, 
		DIALOG_LOGIN, 
		DIALOG_STYLE_PASSWORD, 
		"Panel logowania", 
		"Witaj ponownie!\nKonto o tym nicku zosta³o ju¿ zarejestrowane.\n\
		Je¿eli nie jesteœ w³aœcicielem tego konta, wyjdŸ z serwera i zmieñ nick.\n\
		Pamietaj, ¿e ka¿da próba logowania jest rejestrowana.\nW wiêkszoœci przypadków mo¿e to wi¹zaæ siê z poniesiem odpowiednich konsekwencji.\n\
		Poni¿ej wpisz swoje has³o podane przy rejestracji.", 
		"Zaloguj", "Wyjdz");
}

stock theplayer::showRegisterDialog(playerid) 
{
	ShowPlayerDialog(playerid, 
		DIALOG_REGISTER, 
		DIALOG_STYLE_PASSWORD, 
		"Panel rejestracji konta", 
		"Witamy w panelu rejestracji konta! :)\nDecydujac siê na rejestracje otrzymasz pe³ny dostêp do wszystkich funkcji serwera.\n\
		Dodatkowo, gdy Twoje konto zostanie zarejestrowane - dostaniesz 500 RP nagrody - nie czekaj!\nPoni¿ej wpisz swoje has³o, za pomoc¹ którego bêdziesz móg³ siê logowaæ.\n\
		Pamiêtaj, ¿e Twoje has³o MUSI mieæ co najmniej 6 do 16 znaków. Has³o mo¿e sk³adaæ siê ze znaków specjalnych.", "Rejestruj", "Anuluj");
	
	// W razie, gdybyœ zapomnia³ has³a - serwer automatycznie powiadomi Ciê o próbie zalogowania na Twoje konto i w tej bêdzie znajdowaæ siê link, do mo¿liwego zresetowania has³a.
}

stock theplayer::loadAccountData(playerid) 
{
	new tmpBuf[128], tmpPos[32], haveVIP;
	CMySQL_Query("SELECT skin, respect, level, hp, armour, pos, bank_money, wallet_money, spawnType, admin, IFNULL(DATEDIFF(vip, NOW()), '-1') FROM accounts WHERE nickname='%s' LIMIT 1;", -1, PlayerData[playerid][epd_nickname]);
	mysql_store_result();
	if(mysql_num_rows()) mysql_fetch_row(tmpBuf, "|");
	mysql_free_result();
	sscanf(tmpBuf, "p<|>dddffs[32]ddddd", 
		PlayerData[playerid][epd_lastSkin],
		PlayerData[playerid][epd_levelRP],
		PlayerData[playerid][epd_respect],
		PlayerData[playerid][epd_lastHealth],
		PlayerData[playerid][epd_lastArmour],
		tmpPos,
		PlayerData[playerid][epd_bankMoney],
		PlayerData[playerid][epd_walletMoney],
		PlayerData[playerid][epd_spawnType],
		PlayerData[playerid][epd_admin],
		haveVIP
	);
	sscanf(tmpPos, "p<;>ffff", PlayerData[playerid][epd_lastPos][0], PlayerData[playerid][epd_lastPos][1], PlayerData[playerid][epd_lastPos][2], PlayerData[playerid][epd_lastPos][3]);
	if(haveVIP>0) PlayerData[playerid][epd_haveVip]=true;
}

stock theplayer::loadWeaponsData(playerid) 
{
	new tmpBuf[64+128];
	CMySQL_Query("SELECT weapons, ammo FROM players_weapons WHERE owner='%d' LIMIT 1;", -1, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	if(mysql_num_rows()) mysql_fetch_row(tmpBuf, "|");
	mysql_free_result();
	new tmpBufWeapons[64], tmpBufAmmo[128], tmpWeapons[13], tmpAmmo[13];
	sscanf(tmpBuf, "p<|>s[64]s[128]", tmpBufWeapons, tmpBufAmmo);
	sscanf(tmpBufWeapons, "p<;>a<d>[13]", tmpWeapons);
	sscanf(tmpBufAmmo, "p<;>a<d>[13]", tmpAmmo);
	
	for(new i; i<=sizeof(tmpWeapons)-1; i++) 
	{
		GivePlayerWeapon(playerid, tmpWeapons[i], tmpAmmo[i]);
	}
	SetPlayerArmedWeapon(playerid, 0);
}

stock theplayer::setAccountDataInt(playerid, data, column[]) 
{
	CMySQL_Query("UPDATE accounts SET %s='%d' WHERE id='%d';", -1, column, data, PlayerData[playerid][epd_accountID]);
}

stock theplayer::setAccountDataString(playerid, data[], bool:useApostrofy=false, column[]) 
{
	if(useApostrofy) CMySQL_Query("UPDATE accounts SET %s='%s' WHERE id='%d';", -1, column, data, PlayerData[playerid][epd_accountID]);
	else CMySQL_Query("UPDATE accounts SET %s=%s WHERE id='%d';", -1, column, data, PlayerData[playerid][epd_accountID]);
}

stock theplayer::getAccountDataInt(playerid, column[]) 
{
	new tmpResult;
	CMySQL_Query("SELECT %s FROM accounts WHERE id='%d' LIMIT 1;", -1, column, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	if(mysql_num_rows()) tmpResult=mysql_fetch_int();
	mysql_free_result();
	return tmpResult;
}

stock theplayer::getAccountDataString(playerid, column[]) 
{
	new tmpResult[32];
	CMySQL_Query("SELECT %s FROM accounts WHERE id='%d' LIMIT 1;", -1, column, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	if(mysql_num_rows()) mysql_fetch_row(tmpResult);
	mysql_free_result();
	return tmpResult;
}

stock theplayer:getAccountDataFloat(playerid, column[]) 
{
	new tmpResult[22];
	CMySQL_Query("SELECT %s FROM accounts WHERE id='%d' LIMIT 1;", -1, column, PlayerData[playerid][epd_accountID]);
	mysql_store_result();
	if(mysql_num_rows()) mysql_fetch_row(tmpResult);
	mysql_free_result();
	return floatstr(tmpResult);
}

stock theplayer::showProfileStat(playerid=INVALID_PLAYER_ID, playerName[]="") 
{
	// TODO:
	// Zaprogramowac
	/*if(playerid != INVALID_PLAYER_ID) {	
		new profileStat[512] = "Szczegó³y konta %s (Online/Offline):\n\n\
			KONTO:\nIdentyfikator: %d, ranga: %s, ranga spo³eczna: %s,\
			Ostatnio widziany(a): %s, u¿ywany skin: %d\n\
			Ping: %dms, ilosc FPS: %d/s\n\n\
			ZNAJOMI:\nLiczba znajomych: %d\n\n'
			GANG:\nAktualny gang: %s, ranga w gangu: %s\n\n";
	} else {
		new profileStat[512] = "Szczegó³y konta %s (Online/Offline):\n\n\
			KONTO:\nIdentyfikator: %d, ranga: %s, ranga spo³eczna: %s,\
			Ostatnio widziany(a): %s, u¿ywany skin: %d\n\n\
			ZNAJOMI:\nLiczba znajomych: %d\n\n'
			GANG:\nAktualny gang: %s, ranga w gangu: %s\n\n";
	}*/
}

#undef MAX_LOGIN_ATTEMPTS