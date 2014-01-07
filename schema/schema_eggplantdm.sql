-- 	@name: schema dla eggplantDM
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
	`ts_register` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`ts_last` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`isonline` TINYINT(1) NOT NULL DEFAULT '1',
	`skin` SMALLINT NOT NULL DEFAULT '1',
	`respect` UNSIGNED INT NOT NULL DEFAULT '0',
	`level` UNSIGNED SMALLINT NOT NULL DEFAULT '1',
	`hp` DECIMAL(4,1) NOT NULL DEFAULT '99.9', -- potrzebne do CAC'a
	`armour` DECIMAL(4,1) NOT NULL DEFAULT '99.9', -- potrzebne do CAC'a
	`bank_money` INT NOT NULL DEFAULT '0',
	`wallet_money` INT NOT NULL DEFAULT '150',
	`pos` VARCHAR(64) NOT NULL DEFAULT '0.0;0.0;3.0;90.0;',
	`spawnType` TINYNT(1) NOT NULL DEFAULT '0', -- 1) Spawn w ostatnim miejscu 2) Spawn w domu
	`admin` TINYINT(4) NOT NULL DEFAULT '0', -- 1) Moderator 2) Admin 3) Master admin 4) Owner/developer
	`vip` TIMESTAMP NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY (`nickname`),
	KEY `respect and money` (`respect`, `money`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- TODO: dodac konto dewelopera

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
	PRIMARY KEY (`id`),
);

-- table vehicles
CREATE TABLE IF NOT EXISTS vehicles (
	`id` INT NOT NULL AUTO_INCREMENT,
	`model` SMALLINT NOT NULL DEFAULT '400',
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
	`tuning` VARCHAR(255) NOT NULL DEFAULT '0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;'
	`hp` DECIMAL(10,6) NOT NULL DEFAULT '3000.0', -- zycie pojazdu
	`owner` INT NOT NULL DEFAULT '0', -- 0 == brak wlasiciciela
	PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;