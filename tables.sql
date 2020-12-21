/******************************
** File: TABLES.SQL
** Desc: Fichier contenant les tables et les contraintes en SQL.
** Auth: AZZOUG Aghilas
** Date: 10/2020
*******************************/

-- Création de table "utlisateurs". Table qui permet à garder les utilisateurs
-- et ses données. Présence de newsletter ; pour determiner si un user accepte de recevoir
-- des notifications ou pas (news)
CREATE TABLE utilisateurs 
(
    id_utilisateur         NUMBER NOT NULL,
    login                  VARCHAR2(60) NOT NULL,
    motdepass              VARCHAR2(60) NOT NULL,
    nom                    VARCHAR2(20),
    prenom                 VARCHAR2(20),
    email                  VARCHAR2(50) NOT NULL,
    dateNaissance          DATE,
    newsletter             CHAR(1) DEFAULT '0',
    nombreDeVideoAimee     NUMBER NOT NULL,
    nationalite            VARCHAR(30)     
);

-- Création de table "types". Table qui permet à garder les types/catégories des
-- émssions.
CREATE TABLE types 
(
    id_type   NUMBER NOT NULL,
    nom_type     VARCHAR2(30)
);

-- Création de table "emission". Table qui permet de connaitre des information sur le contenu 
-- des émssions et catehorie ...
create table emission(
    id_emission    integer not null,
    nom_emission   varchar(60) not null,
    id_type        NUMBER NOT NULL  
);


-- Création de table "video". Table qui permet de voir les information sur
-- la video.
CREATE TABLE video 
(
    id_video       NUMBER NOT NULL,
    id_emission    integer not null,
    titre          VARCHAR2(100),
    description_video    VARCHAR2(500),
    multilangue       CHAR(1) DEFAULT '0',
    localisation   VARCHAR2(250),
    date_p_duffision     DATE NOT NULL,
    duree   NUMBER NOT NULL,
    format_image   VARCHAR(10) NOT NULL
);

-- Mise en place la table videoArchives
-- vu la nécessité de vouloir récuperer les videos vues 
-- qui furent supprimés dans replay
CREATE TABLE historique 
(   id_historique      NUMBER NOT NULL,
    id_video           NUMBER NOT NULL,
    nom_video          VARCHAR2(100),
    id_utilisateur     NUMBER NOT NULL,
    date_visionnage    DATE NOT NULL
);

-- Mise en place la table Favoris pour pouvoir
-- avoir une listes des videos likées (aimées)
--  elle sera liée à la page associée au user
CREATE TABLE favoris 
(   
    id_utilisateur    NUMBER NOT NULL,
    id_video     NUMBER NOT NULL,
    PRIMARY KEY(id_utilisateur,id_video)
);

-- Mise en place la table preference pour 
-- que le user puisse indiquer ses preferences de categories(types)
CREATE TABLE preferences 
(
    id_utilisateur    NUMBER NOT NULL,
    id_type           NUMBER NOT NULL,
    PRIMARY KEY(id_utilisateur,id_type)
);

-- Création de table "follow". Table qui permet de voir les utilisateurs
-- abonnés à cette emission
CREATE TABLE follow 
(
    id_utilisateur     NUMBER NOT NULL,
    id_emission        NUMBER NOT NULL
);

-- cette table servira pour la partie 2 
-- Création de table "videoArchivee
-- elle permet de faire le transfère des videos supprimées
-- pour enfin de les récupérer, seront en dehors du replay

CREATE TABLE  videoArchivee
(
    id_video       NUMBER NOT NULL,
    id_emission    integer not null,
    titre          VARCHAR2(100),
    description_video    VARCHAR2(500),
    multilangue       CHAR(1) DEFAULT '0',
    localisation   VARCHAR2(250),
    date_p_duffision     DATE NOT NULL,
    duree   NUMBER NOT NULL,
    format_image   VARCHAR(10) NOT NULL
);
/*----------------------------------------------------------------------------
                                CONTRAINTES
-----------------------------------------------------------------------------*/
/*user*/
ALTER TABLE utilisateurs 
    ADD CONSTRAINT utilisateurs_pk PRIMARY KEY (id_utilisateur);
ALTER TABLE utilisateurs 
    ADD CONSTRAINT utilisateurs_u UNIQUE (login);
ALTER TABLE utilisateurs 
    ADD CONSTRAINT EMAIL_U UNIQUE (email);
ALTER TABLE utilisateurs
    ADD CONSTRAINT CK_EMAIL CHECK (email LIKE '%_@_%');
ALTER TABLE utilisateurs
    ADD CONSTRAINT CK_nombreDeVideoAimee CHECK((nombreDeVideoAimee >= 0) AND (nombreDeVideoAimee < 301));

/*emission*/
ALTER TABLE emission 
    ADD CONSTRAINT emission_pk PRIMARY KEY (id_emission);
    /*cette contrainte réferencie la colonne idtype dans la table emissions*/  
ALTER TABLE emission 
    ADD CONSTRAINT emission_nom_emission_u UNIQUE (nom_emission);
ALTER TABLE emission 
    ADD CONSTRAINT fk_emission_types FOREIGN KEY (id_type) REFERENCES types ON DELETE CASCADE;

/*######ALTER TABLE emission  ADD CONSTRAINT emission_ck CHECK (allowSimult BETWEEN 0 AND 1);*/

/*Types*/
ALTER TABLE types 
    ADD CONSTRAINT type_pk PRIMARY KEY (id_type);


/*video*/
ALTER TABLE video 
    ADD CONSTRAINT video_pk PRIMARY KEY (id_video);
ALTER TABLE video 
    ADD CONSTRAINT video_titre_u UNIQUE(titre);
ALTER TABLE video 
    ADD CONSTRAINT fk_video_emission FOREIGN KEY (id_emission) REFERENCES emission ON DELETE CASCADE;

/*historique*/
ALTER TABLE historique 
    ADD CONSTRAINT historique_pk PRIMARY KEY (id_historique);
ALTER TABLE historique
    ADD CONSTRAINT fk_historique_video FOREIGN KEY (id_video) REFERENCES video;
ALTER TABLE historique
    ADD CONSTRAINT fk_historique_utilisateur FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs;

/*favoris*/
ALTER TABLE favoris 
    ADD CONSTRAINT fk_favoris_utilisateurs FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs;
ALTER TABLE favoris
    ADD CONSTRAINT fk_favoris_video FOREIGN KEY (id_video) REFERENCES video;

/*preferences*/
ALTER TABLE preferences 
    ADD CONSTRAINT fk_utilisateurs_types_u FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs;
ALTER TABLE preferences
    ADD CONSTRAINT fk_utilisateurs_types FOREIGN KEY (id_type) REFERENCES types;

/*follow*/
ALTER TABLE follow 
    ADD CONSTRAINT utilisateurs_follow_pk PRIMARY KEY (id_utilisateur, id_emission);


CREATE SEQUENCE seq_utilisateurs start with 1 increment by 1;
CREATE SEQUENCE seq_emission start with 1 increment by 1;
CREATE SEQUENCE seq_types start with 1 increment by 1;
CREATE SEQUENCE seq_video start with 1 increment by 1;
CREATE SEQUENCE seq_historique start with 1 increment by 1;


/* 0o_______o0__________________0o_________________o0___________________0_o__________________
comme pas demandé, j'en ai fait que de sexmples, mais aps sur tout
~~~la  comparaison date de creation de chaine doit etre inferieur a celle creation de video 
~~~date de historique superieur de creation de video
~~~unicité dans les id */
