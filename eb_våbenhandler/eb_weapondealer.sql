INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_weapondealer','Våbenhandler',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_weapondealer','Våbenhandler',1)
;

INSERT INTO `jobs` (name, label) VALUES
	('weapondealer','Våbenhandler')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('weapondealer',0,'elev','Elev',0,'{}','{}'),
	('weapondealer',1,'medarbejder','Medarbejder',0,'{}','{}'),
	('weapondealer',2,'ledelse','Ledelse',0,'{}','{}'),
	('weapondealer',3,'boss','Chef',0,'{}','{}')
;