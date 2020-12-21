/******************************
** File: TESTS.SQL
** Desc: Fichier contenant les insertions de tables et les requêtes SQL.
** Auth: AZZOUG Aghilas
** Date: 10/2020
*******************************/

-- INSERTION DE TABLES

-- TYPES CATEGORIES
insert into types values(1,'science');
insert into types values(2,'music');
insert into types values(3,'nature');
insert into types values(4,'sociale');
insert into types values(5,'romanesque');
insert into types values(6,'cinema');
insert into types values(7,'litterature');

-- UTILISATEURS
insert into utilisateurs values (1,'linus','admin','linus','moi','toto@email.com',sysdate,'0',3,'france');
insert into utilisateurs values (2,'fieldman','admin','fieldman','rien','jojo@email.com',sysdate,'1',40,'usa');
insert into utilisateurs values (3,'einstein','admin','einstein','moi','moi@email.com',sysdate,'0',12,'allemagne');
insert into utilisateurs values (4,'curie','admin','curie','pasmoi','chez@email.com',sysdate,'1',14,'france');
insert into utilisateurs values (5,'max','admin','max','moi','cmoto@email.com',sysdate,'0',1,'allemagne');
insert into utilisateurs values (6,'marie','admin','marie','moi','cheto@email.com',sysdate,'1',15,'pologne');
insert into utilisateurs values (7,'hugo','admin','hugo','moi','chetoto@email.com',sysdate,'1',7,'france');
insert into utilisateurs values (8,'aghiles','admin','aghiles','moi','to@email.com',sysdate,'1',0,'allemagne');
insert into utilisateurs values (9,'frey','admin','frey','moi','toopp@email.com',sysdate,'1',17,'allemagne');
insert into utilisateurs values (10,'ronse','admin','ronse','moi','chez-mo@email.com',sysdate,'0',23,'france');

-- EMISSION


insert into emission values(1,'fight club',6);
insert into emission values(2,'titanic',6);
insert into emission values(3,'dr.pol',3);
insert into emission values(4,'e=mc2',1);
insert into emission values(5,'hans zimmer',2);
insert into emission values(6,'chopin',2);
insert into emission values(7,'bach',2);
insert into emission values(8,'les miserbles',7);
insert into emission values(9,'breve histoire',7);
insert into emission values(10,'wilde',7);
insert into emission values(11,'resto coeur',4);
insert into emission values(12,'two love',5);
insert into emission values(13,'survivalist',3);


--VIDEO
insert into video values (1,1,'brad ou norton','comparaison jeu acteur','1','usa',sysdate,'4000','mp4');
insert into video values (2,1,'David Finher','le genie du réalisateur','0','usa',sysdate,'85000','mp4');
insert into video values (3,2,'dicaprio','comment il a accepté le role de Cameron','1','usa',sysdate+2,'95000','hd');
insert into video values (4,3,'le sauvetage de la vache','maladie de vche folel','0','cananda',sysdate+8,'88880','4k');
insert into video values (5,4,'relativité','indeterminime de heiseinberg','1','usa',sysdate+9,'44000','mp4');
insert into video values (6,5,'music gladiator','inspiration','0','allemagne',sysdate+12,'5000','hd');
insert into video values (7,6,'la note','sonata','0','allemagne',sysdate+2,'4800','mp4');
insert into video values (8,7,'philosophie de musique','spirituel','0','allemagne',sysdate+6,'4000','hd');
insert into video values (9,8,'la plume de hugo','consequence politique','1','france',sysdate,'40050','mp4');
insert into video values (10,9,'promenade anglaise','lecture','1','france',sysdate,'7000','mp4');
insert into video values (11,10,'wild et schakespear','ecriture','0','espagne',sysdate,'40890','4k');
insert into video values (12,11,'france en scicilie','colluche','1','italie',sysdate+11,'9600','mp4');
insert into video values (13,12,'comedie','romanse a Nothing','1','france',sysdate,'40400','mp4');
insert into video values (14,12,'revisitr theatre','romeo et juliere','1','france',sysdate+9,'404800','mp4');
insert into video values (15,13,'apocalypse','ushwaya','1','france',sysdate,'1120','hd');

-- Historique 
insert into historique values (1,1,'brad ou norton',1,sysdate);
insert into historique values (2,2,'titanic',2,sysdate+5);
insert into historique values (3,1,'brad ou norton',1,sysdate+5);
insert into historique values (4,1,'brad ou norton',2,sysdate+6)
insert into historique values (5,1,'brad ou norton',1,sysdate+6);
insert into historique values (6,3,'dicaprio',1,sysdate+7);
insert into historique values (7,5,'relativité',3,sysdate+7);
insert into historique values (8,15,'apocalypse',8,sysdate+9);
insert into historique values (9,11,'wild et schakespear',2,sysdate+10);
insert into historique values (10,7,'la note',10,sysdate+15);
insert into historique values (11,7,'la note',4,sysdate+18);
insert into historique values (12,7,'la note',5,sysdate+18);
insert into historique values (13,11,'wild et schakespear',6,sysdate+19);
insert into historique values (14,7,'la note',7,sysdate+19);
insert into historique values (13,7,'la note',9,sysdate+19);
-- Favoris 
insert into favoris values (1,5);
insert into favoris values (1,8);
insert into favoris values (2,9);
insert into favoris values (3,10);
insert into favoris values (1,6);
insert into favoris values (8,5);
insert into favoris values (4,7);
insert into favoris values (4,5);
insert into favoris values (3,5);
insert into favoris values (1,11);
insert into favoris values (3,14);
insert into favoris values (8,6);
insert into favoris values (9,5);
insert into favoris values (4,15);
insert into favoris values (10,5);
insert into favoris values (8,11);

-- Preferences categories
insert into preferences values (1,1);
insert into preferences values (1,2);
insert into preferences values (2,2);
insert into preferences values (2,4);
insert into preferences values (3,1);
insert into preferences values (4,1);
insert into preferences values (4,2);
insert into preferences values (4,5);
insert into preferences values (5,5);
insert into preferences values (5,7);
insert into preferences values (6,6);
insert into preferences values (7,6);
insert into preferences values (7,1);
insert into preferences values (8,7);
insert into preferences values (9,5);
insert into preferences values (10,3);

-- Follow abonnement
insert into follow values (1,1);
insert into follow values (2,3);
insert into follow values (3,1);
insert into follow values (3,3);
insert into follow values (4,4);
insert into follow values (5,6);
insert into follow values (5,7);
insert into follow values (6,5);
insert into follow values (7,5);
insert into follow values (8,7);
insert into follow values (9,4);
insert into follow values (10,2);