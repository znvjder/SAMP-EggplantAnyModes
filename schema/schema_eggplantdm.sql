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

-- table entries and exits
CREATE TABLE IF NOT EXISTS entries (
	id INT NOT NULL AUTO_INCREMENT,
	eClosed TINYINT(1) NOT NULL DEFAULT '0', -- (wejscie zamkniete) (jezeli wartosc tej kolumny bedzie wynosic 1 - nie wczytujemy do danych)
	eType TINYINT(1) NOT NULL DEFAULT '0', -- 0=pickup, 1=checkpoint
	enter TINYINT(1) NOT NULL DEFAULT '1', -- (wejscie) 1=otwarte, 0=zamkniete
	pickupid INT NOT NULL DEFAULT '19135',
	cpSize DECIMAL(3,2) NOT NULL DEFAULT '3.0', -- (wielkosc checkpointa)
	enterX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	enterY DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	enterZ DECIMAL(10,6) NOT NULL DEFAULT '3.0',
	enterAng DECIMAL(6,3) NOT NULL DEFAULT '90.0', -- rotacja peda
	exitX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	exitY DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	exitZ DECIMAL(10,6) NOT NULL DEFAULT '3.0',
	exitAng DECIMAL(6,3) NOT NULL DEFAULT '180.0', -- rotacja peda
	enterI SMALLINT NOT NULL DEFAULT '0', -- interior
	enterVW SMALLINT NOT NULL DEFAULT '0', -- virtual world\
	exitI SMALLINT NOT NULL DEFAULT '0', -- interior
	exitVW SMALLINT NOT NULL DEFAULT '0', -- virtual world
	label VARCHAR(128) NOT NULL DEFAULT 'brak', -- opis
	labelView DECIMAL(10,6) NOT NULL DEFAULT '50.0', -- streamdist labelu
	PRIMARY KEY (`id`)
) ENGINE=MyISAM;

-- table atms
CREATE TABLE IF NOT EXISTS atms (
	id INT NOT NULL AUTO_INCREMENT,
	fX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fY DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	fZ DECIMAL(10,6) NOT NULL DEFAULT '3.0',
	fRX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRY DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRZ DECIMAL(10,6) NOT NULL DEFAULT '90.0',
	interior SMALLINT NOT NULL DEFAULT '1',
	vw SMALLINT NOT NULL DEFAULT '0',
	opis VARCHAR(32) NOT NULL DEFAULT 'brak opisu',
	spawned TINYINT(1) NOT NULL DEFAULT '1', -- 0-pomijamy 1-tworzymy
	PRIMARY KEY (`id`)
) ENGINE=MyISAM;

-- table audiozones
CREATE TABLE IF NOT EXISTS audiozones(
	id INT NOT NULL AUTO_INCREMENT,
	zoneType TINYINT(1) NOT NULL DEFAULT '0', -- 0=circle, 1=rectangle, 2=sphere
	rectanglePos VARCHAR(52) NOT NULL DEFAULT '-0.0;-0.0;1.0;1.0;', -- minx, miny, maxx, maxy
	circlePos VARCHAR(48) NOT NULL DEFAULT '0.0;0.0;40.0;', -- x, y, r
	spherePos VARCHAR(48) NOT NULL DEFAULT '0.0;0.0;1.0;40.0;', -- x, y, z, r
	streamURL VARCHAR(48) NOT NULL DEFAULT 'unkown',
	audioEffect TINYINT(1) NOT NULL DEFAULT '-1', -- standardowo brak efektu
	audio3DPos VARCHAR(48) NOT NULL DEFAULT '0.0;0.0;0.0;0.0;',
	vw SMALLINT NOT NULL DEFAULT '0',
	interior SMALLINT NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
);

-- table playerClothes
CREATE TABLE IF NOT EXISTS playerClothes(
	id INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL DEFAULT '0',
	attached TINYINT(1) NOT NULL DEFAULT '1',
	idx TINYINT NOT NULL DEFAULT '0',
	modelid SMALLINT UNSIGNED NOT NULL DEFAULT '1',
	bone TINYINT NOT NULL DEFAULT '1', -- http://wiki.sa-mp.com/wiki/Bone_IDs
	fX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fY DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fZ DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRY DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRZ DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fSX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fSY DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fSZ DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	mcolor1 VARCHAR(17) NOT NULL DEFAULT '0xffffffff', -- argb
	mcolor2 VARCHAR(17) NOT NULL DEFAULT '0xffffffff', -- argb
	PRIMARY KEY (`id`)
);

-- table objects
CREATE TABLE IF NOT EXISTS objects(
	id INT NOT NULL AUTO_INCREMENT,
	spawn TINYINT(1) NOT NULL DEFAULT '1', -- 0=nie tworzymy, 1=tworzymy
	modelid SMALLINT UNSIGNED NOT NULL DEFAULT '1',
	fX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fY DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fZ DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRY DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fRZ DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	-- object material
	mt_idx TINYINT SIGNED NOT NULL DEFAULT '-1',
	mt_modelid SMALLINT UNSIGNED NOT NULL DEFAULT '1',
	mt_txdname VARCHAR(32) NOT NULL DEFAULT 'none',
	mt_texture VARCHAR(32) NOT NULL DEFAULT 'none',
	mt_color INT NOT NULL DEFAULT '0',
	-- text material
	mtxt_idx TINYINT SIGNED NOT NULL DEFAULT '-1', 
	mtxt_text VARCHAR(64) NOT NULL DEFAULT 'unkown',
	mtxt_msize TINYINT UNSIGNED NOT NULL DEFAULT '90', -- wartosci rzedu 10-140 (default: OBJECT_MATERIAL_SIZE_256x128)
	mtxt_font VARCHAR(18) NOT NULL DEFAULT 'Arial',
	mtxt_fsize TINYINT UNSIGNED NOT NULL DEFAULT '24',
	mtxt_fbold TINYINT UNSIGNED NOT NULL DEFAULT '0',
	mtxt_fcolor VARCHAR(17) NOT NULL DEFAULT '0xffffffff', -- argb
	mtxt_fbcolor VARCHAR(17) NOT NULL DEFAULT '0xffffffff', -- argb
	mtxt_falign TINYINT UNSIGNED NOT NULL DEFAULT '0', -- align type: 0=left, 1=center, 2=right
	--
	vw TINYINT UNSIGNED NOT NULL DEFAULT '0',
	interior TINYINT UNSIGNED NOT NULL DEFAULT '0',
	owningHouseID SMALLINT UNSIGNED NOT NULL DEFAULT '0', -- tworzenie obiektu w domu(?)
	PRIMARY KEY (`id`)
);

-- table mapicons
CREATE TABLE IF NOT EXISTS mapicons (
	id INT NOT NULL AUTO_INCREMENT,
	fX DECIMAL(10,6) NOT NULL DEFAULT '0.0',
	fY DECIMAL(10,6) NOT NULL DEFAULT '1.0',
	fZ DECIMAL(10,6) NOT NULL DEFAULT '3.0',
	iconType SMALLINT NOT NULL,
	iconColor TINYINT NOT NULL DEFAULT '0',
	iconView DECIMAL(8,4) NOT NULL DEFAULT '8500.0',
	interior SMALLINT NOT NULL DEFAULT '0',
	vw SMALLINT NOT NULL DEFAULT '0',
	opis VARCHAR(32) NOT NULL DEFAULT 'brak opisu',
	PRIMARY KEY (`id`)
) ENGINE=MyISAM;

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
