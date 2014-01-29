/*
	@file: /internal/CPlayerAchivement.p
	@author: 
		l0nger <l0nger.programmer@gmail.com>
		
	@licence: GPLv2
	
	(c) 2013-2014, <l0nger.programmer@gmail.com>
*/

/*

CREATE TABLE IF NOT EXISTS achievements(
	avtID INT NOT NULL AUTO_INCREMENT,
	description VARCHAR(64) NOT NULL, -- opis
	PRIMARY KEY (avtID)
);

CREATE TABLE IF NOT EXISTS userachievement(
	avtID INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL,
	date TIMESTAMP,
	remark VARCHAR(64), -- uwagi
	PRIMARY KEY (`avtID`),
	FOREIGN KEY (avtID) REFERENCES achievements(avtID)
);

*/