--	@name: schema dla eggplantDM
--	@author: l0nger <l0nger.programmer@gmail.com>
--	@licence: GPLv2
--	(c) 2013-2014, <l0nger.programmer@gmail.com>

-- table accounts
CREATE TABLE IF NOT EXISTS accounts (
	`id` INT NOT NULL AUTO_INCREMENT, -- 0 w tej kolumnie i tabeli musi byc PUSTE!
	`nickname` VARCHAR(24) NOT NULL,
	`password` VARCHAR(48) NOT NULL,
	`ip_register` VARCHAR(16) NOT NULL DEFAULT '0.0.0.0',
	`ip_last` VARCHAR(16) NOT NULL DEFAULT '0.0.0.0',
	`ts_register` TIMESTAMP DEFAULT 0,
	`ts_last` TIMESTAMP DEFAULT 0,
	`serial_registered` VARCHAR(32) NOT NULL DEFAULT 'unkown',
	`serial_last` VARCHAR(32) NOT NULL DEFAULT 'unkown',
	`isonline` TINYINT(1) NOT NULL DEFAULT '1',
	`skin` SMALLINT NOT NULL DEFAULT '1',
	`visits` INT NOT NULL DEFAULT '1',
	`respect` INT NOT NULL DEFAULT '0',
	`level` INT NOT NULL DEFAULT '1',
	`hp` DECIMAL(4,1) NOT NULL DEFAULT '99.9', -- potrzebne do CAC'a
	`armour` DECIMAL(4,1) NOT NULL DEFAULT '99.9', -- potrzebne do CAC'a
	`bank_money` INT NOT NULL DEFAULT '0',
	`wallet_money` INT NOT NULL DEFAULT '150',
	`pos` VARCHAR(64) NOT NULL DEFAULT '0.0;0.0;3.0;90.0;',
	`spawnType` TINYINT(1) NOT NULL DEFAULT '0', -- 1) Spawn w ostatnim miejscu 2) Spawn w domu
	`admin` TINYINT(4) NOT NULL DEFAULT '0', -- 1) Moderator 2) Admin 3) Master admin 4) Owner/developer
	`vip` TIMESTAMP DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE KEY (`nickname`),
	KEY `respect and money` (`respect`, `wallet_money`, `bank_money`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

INSERT INTO accounts (nickname, password, ip_register, ip_last, ts_register, ts_last, isonline, skin) VALUES ('dev', SHA1(MD5('dev-eggplant')), '127.0.0.1', '127.0.0.1', NOW(), NOW(), 0, 40);

-- table players_weapons
CREATE TABLE IF NOT EXISTS players_weapons (
	`id` INT NOT NULL AUTO_INCREMENT,
	`owner` INT NOT NULL DEFAULT '0',
	`weapons` VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0;0;0;0;0;0;0;',
	`ammo` VARCHAR(128) NOT NULL DEFAULT '0;0;0;0;0;0;0;0;0;0;0;0;0;',
	`skills` VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0;0;0;0;',
	PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- table houses
CREATE TABLE IF NOT EXISTS houses (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(48) NOT NULL DEFAULT 'Nowy dom!',
	`doors` TINYINT(1) NOT NULL DEFAULT '0',  -- wchodzenie do domu 0) nikt 1) znajomi 2) czlonkowie gangu 3) wszyscy (ew. zrobic domofon - podchodzisz do drzwi i informuje wlasciciela, ze gracz X chce wejsc do naszego domu - i tak zgoda tak/nie)
	`x` DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	`y` DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	`z` DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	`ang` DECIMAL(10,6) NOT NULL DEFAULT '90.0',
	`i` SMALLINT NOT NULL DEFAULT '1',
	`vw` SMALLINT NOT NULL DEFAULT '0', 
	`ex` DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	`ey` DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	`ez` DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	`eang` DECIMAL(10,6) NOT NULL DEFAULT '90.0',
	`owner` INT NOT NULL DEFAULT '0', -- brak wlasciciela jezeli 0
	`price` INT NOT NULL DEFAULT '100',
	`priceType` TINYINT NOT NULL DEFAULT '0', -- 0 == kupno za kase, 1 == kupno za RP (respect)
	PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- table friends
CREATE TABLE IF NOT EXISTS friends (
	ts_created TIMESTAMP,
	inviter SMALLINT NOT NULL DEFAULT '0', -- zapraszajacy
	invited SMALLINT NOT NULL DEFAULT '0', -- zaproszony
	accepted TINYINT NOT NULL DEFAULT '0' -- status akceptacji 0-nie, 1-tak
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- table vehicles
CREATE TABLE IF NOT EXISTS vehicles (
	`id` INT NOT NULL AUTO_INCREMENT,
	`modelid` SMALLINT NOT NULL DEFAULT '400',
	`fX` DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	`fY` DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	`fZ` DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	`fAng` DECIMAL(10,6) NOT NULL DEFAULT '90.0',
	`doors` TINYINT(1) NOT NULL DEFAULT '0', -- wchodzenie do pojazdow 0) nikt 1) znajomi 2) czlonkowie gangu 3) wszyscy
	`dmgPanels` SMALLINT NOT NULL DEFAULT '0', -- uszkodzenia zderzakow/masek/bagaznikow
	`dmgDoors` SMALLINT NOT NULL DEFAULT '0', -- uszkodzenia dzwi
	`dmgLights` SMALLINT NOT NULL DEFAULT '0', -- uszkodzenia swiatel
	`dmgTires` SMALLINT NOT NULL DEFAULT '0', -- uszkodzenia opon
	`color1` SMALLINT NOT NULL DEFAULT '200',
	`color2` SMALLINT NOT NULL DEFAULT '201',
	`tuning` VARCHAR(255) NOT NULL DEFAULT '0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;',
	`hp` DECIMAL(10,6) NOT NULL DEFAULT '3000.0',
	`owner` INT NOT NULL DEFAULT '0', -- brak wlasciciela jezeli 0
	PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;