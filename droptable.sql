/******************************
** File: DROPTABLE.SQL
** Desc: Fichier contenant les suppressions de tables.
** Auth: AZZOUG AGHILAS
** Date: 10/2020
*******************************/

-- SUPPRESSION DE TABLES

delete TABLE utilisateurs;
delete TABLE emission;
delete TABLE video;
delete TABLE favoris;
delete TABLE types;
delete TABLE follow;
delete TABLE preferences;
delete TABLE historique;
delete SEQUENCE seq_utilisateurs;
delete SEQUENCE seq_emission;
delete SEQUENCE seq_video;
delete SEQUENCE seq_type;

-- SUPPRIMER LES CONTENUS
DROP TABLE utilisateurs;
DROP TABLE emission;
DROP TABLE video;
DROP TABLE favoris;
DROP TABLE types;
DROP TABLE follow;
DROP TABLE preferences;
DROP TABLE historique;
DROP SEQUENCE seq_utilisateurs;
DROP SEQUENCE seq_emission;
DROP SEQUENCE seq_video;
DROP SEQUENCE seq_type;
