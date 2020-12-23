/******************************
** File: PARTIE2.SQL
** Desc: Fichier contenant les procédures et les contraintes en SQL(Deuxièmepartie du projet ).
** Auth: AZZOUG Aghilas
** Date: 12/2020
*******************************/

/********Procédures et fonctions PL/SQL************/
/* --1)
  Conversion en format JSON 
*/

/*une methode qui n'est pas demandé: car ce n'est pas une fonction , la réponse elle vient juste après*/
SELECT id_video,id_emission,titre AS "info.titre",description_video AS "info_description",multilangue,localisation,date_p_duffision,duree,format_image FROM video
FOR JSON PATH;

/*avec une fonction comme l'ennoncé nous l'a demandé

m'inspirant de ce modele comme vu au cours: 
SELECT JSON_OBJECT (
    KEY 'deptno' IS d.department_id FORMAT JSON,
    KEY 'deptname' IS d.department_name FORMAT JSON
    ) "Department Objects"
  FROM departments d
  ORDER BY d.department_id;
Department Objects */ 

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE convertir_videoJson(id IN number)
IS BEGIN
  SELECT
   --spool export.json;
    JSON_OBJECT(
      'idvideo',id_video,'idemission',id_emission,'info_titre',titre,
      'info_description',description_video,'langue',multilangue,'lieu',localisation ,
      'date',date_p_duffision,'durevideo',duree,'le_format',format_image 
    )AS JSON
  FROM video WHERE id_video = id;
  -- spool off;
END;


--------------------------------------------------

/* --2)
    Définir une procédure qui généra un texte initial de la newsletter 
    en y ajoutant la liste de toute les sortie de la semaine
*/
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ma_newsletter_info
RETURN CHAR is
  cursor newsletter_curseur is
    SELECT* FROM video where (sysdate - date_p_duffision) < 8;
    news_row newsletter_curseur%ROWTYPE;
    notifications CHAR;
BEGIN
  notifications := 'les videos de la semaine :\n';
  FOR news_row IN newsletter_curseur
  LOOP
      notifications := notifications  news_row.titre;
      notifications := notifications  '\n';
  END LOOP;
  RETURN notifications;
END;
-----------------------------------------------------------------------
/* --3)
  Générer la liste des vidéos populaires, conseillé pour un utilisateur, 
  c’est à dire fonction des catégories de vidéos qu’il suit.
*/
SET SERVEROUTPUT ON
/*modèle de fonction trouvé en ligne- sources mentionnée sur le rapport */
create or replace procedure populaire(id_pop IN NUMBER) as
    cursor curseur_pop is
    select id_type from preference where preference.id_utilisateur=id_pop and emission.id_type = preference.id_type;
    cursor curseur_video is select * from video;
    tube varchar(60);
BEGIN
    for k in curseur_pop
    loop
      for i in curseur_video
      loop
      begin
      resultat r;
          select id_video into tube from video where  video.id_video=i.id_video and video.id_emission=k.id_emission;
          dbms_output.put_line(tube);
          exception
              when others then
                  rollback to resultat r;
          END;
      END loop;
    END loop;
END;
/
----------------------------------------------------------------------------
----------------------------------------------------------------------------
/*
  Contraintes d'intégrité du projet
*/
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- 1). 
/*
  Un utilisateur aura un maximum de 300 vidéos en favoris
*/
-- à trouver dans le fichier table, la contrainte tout en bas --
--ALTER TABLE utilisateurs ADD CONSTRAINT CK_nombreDeVideoAimee CHECK((nombreDeVideoAimee >= 0) AND (nombreDeVideoAimee < 301));

CREATE OR REPLACE TRIGGER checkLimiteFavoris
  BEFORE INSERT ON favoris
  FOR EACH ROW
    declare  
    nb_videoliked INTEGER;
  BEGIN
    SELECT count(id_utilisteur) into nb_videoliked FROM favoris
    WHERE id_utilisateur = :new.id_utilisateur
    group by id_utilisateur
        
  IF nb_videolikee >= 300 THEN
        RAISE_APPLICATION_ERROR(-20004, 'IMPOSSIBLE D AJOUTER UNE VIDEO AU FAVORIS,IL Y A 300 DEJA, ESPACE REMPLI!!!');
  END IF;
END;
/
SHOW ERRORS
---------------------------------------------------------------------------

/* --2)
  Si une diffusion d’une émission est ajoutée, les dates de disponibilités seront mises à jour.
  La nouvelle date de fin de disponibilité sera la date de la dernière diffusion plus 14 jours.
*/
CREATE OR REPLACE PROCEDURE UPDATEETEMPS AS
delai number;
CURSOR cur1 IS SELECT duree from video for update of
date_p_duffision;
BEGIN
  open cur1;
  LOOP
  fetch cur1 into duree;
  if cur1%notfound then exit; end if;
  IF date_p_duffision =sysdate THEN update video set duree =
  date_p_duffision+14 where current of cur1;
  Commit;
  END IF;
  END LOOP;
  close cur1;
END UPDATEETEMPS;

/* -- 3)
  La suppression d’une vidéo entraînera son archivage dans 
  une tables des vidéos qui ne sontplus accessibles par le site de replay
*/
CREATE OR REPLACE TRIGGER archiver_video
    BEFORE DELETE
       ON video
       FOR EACH ROW
    BEGIN
        insert into videoArchivee(id_video,id_emission,titre,description_video,multilangue,localisation,date_p_duffision,duree,format_image)
        values (:old.id_video, :old.id_emission,:old.titre,:old.description_video,:old.multilangue,:old.localisation,:old.date_p_duffision,:old.duree,:old.format_image);
        DBMS_OUTPUT.PUT_LINE('video au n° '|| :old.id_video || ' Est archivée');
END;
/
-- Test
delete from video where id_video = 2;
select * from videoArchivee where id_video = 2;
---------------------------------------------------------------------------------
/* -- 4)
  Afin de limiter le spam de visionnage, 
  un utilisateur ne pourra pas lancer plus de  3visionnages par minutes.
*/

tempsactuel = current_timestamp - 1;
nombre_visionage = 0;

CREATE OR REPLACE TRIGGER visionage_controle
  BEFORE INSERT ON historique
  FOR EACH ROW
  DECLARE
    delai INTEGER;
    date_visio DATE;
  BEGIN
    SELECT max(date_visionnage) INTO date_visio FROM historique WHERE id_utilisateur = :new.id_utilisateur;
    delai := SYSDATE - date_visio
    IF delai >=0  THEN
      IF (tempsactuel - current_timestamp < interval '1' minute)THEN
        IF nombre_visionage< 3 THEN
            INSERT INTO historique VALUES (id_historique, id_video, id_utilisateur,current_date);
        ELSE
        RAISE_APPLICATION_ERROR(-20004, 'Vous nepouvez pas regarder 3 videos en une minutes, attendez!');
        END IF;
      ELSE
        nombre_visionage = 1;
        INSERT INTO historique VALUES (id_historique, id_video, id_utilisateur,current_date);
      END IF;
    END IF;
END;
/
SHOW ERRORS







/* OLD VERSION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/********Procédures et fonctions PL/SQL************/
/* --1)
  Conversion en format JSON 
*/
/*avec une fonction comme demandé */ 
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION convertir_videoJson(id IN number)
IS BEGIN
  SELECT
   --spool export.json;
    JSON_OBJECT(
      'idvideo',id_video,
      'idemission',id_emission,
      'info_titre',titre,
      'info_description',description_video,
      'langue',multilangue,
      'lieu',localisation ,
      'date',date_p_duffision,
      'durevideo',duree,
      'le_format',format_image 
    )AS JSON
  FROM video WHERE id_video = id;
  -- spool off;
END;

/*une methode de plus pas demandée: ce n'est pas une fonction une requete directe*/
SELECT id_video,id_emission,titre AS "info.titre",description_video AS "info_description",multilangue,localisation,date_p_duffision,duree,format_image FROM video
FOR JSON PATH;
--------------------------------------------------

/* --2)
    Définir une procédure qui généra un texte initial de la newsletter 
    en y ajoutant la liste de toute les sortie de la semaine
*/
CREATE OR REPLACE FUNCTION ma_newsletter_info
RETURN CHAR is
  cursor newsletter_curseur is
    SELECT* FROM video
    where (sysdate - date_p_duffision) < 8;
    news_row newsletter_curseur%ROWTYPE;
    notifications CHAR;
BEGIN
  notifications := 'les videos de la semaine :\n';
  FOR news_row IN newsletter_curseur
  LOOP
      notifications := notifications  news_row.titre;
      notifications := notifications  '\n';
  END LOOP;
  RETURN notifications;
END;
-----------------------------------------------------------------------
/* --3)
  Générer la liste des vidéos populaires, conseillé pour un utilisateur, 
  c’est à dire fonction des catégories de vidéos qu’il suit.
*/

SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION POPULAIRE(id_u IN INTEGER)
RETURN CHAR IS
    CURSOR type_curseur IS
        SELECT * FROM utilisateurs
        NATURAL JOIN preference
        WHERE utilisateurs.id_utilisateur  = id_u;
    type_row type_curseur%ROWTYPE;
    CURSOR curseur_populaire IS
        SELECT * FROM pop_video;
    pop_row curseur_populaire%ROWTYPE;
    notifications CHAR;
BEGIN
    notifications := 'les videos populaires qui peuvent vous interesser :\n';
    FOR type_row IN type_curseur
    LOOP
        FOR pop_row IN curseur_populaire
        LOOP
            IF (type_row.id_type = pop_row.id_type)
            THEN
                notifications := notifications  pop_row.titre;
                --le saut de ligne pour mieux former la liste--
                notifications := notifications  '\n';
            END IF;
        END LOOP;
    END LOOP;
    RETURN notifications;
END;
/

----------------------------------------------------------------------------
----------------------------------------------------------------------------
/*
  Contraintes d'intégrité du projet
*/
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- 1). 
/*
  Un utilisateur aura un maximum de 300 vidéos en favoris
*/
-- à trouver dans le fichier table, la contrainte tout en bas --
--ALTER TABLE utilisateurs ADD CONSTRAINT CK_nombreDeVideoAimee CHECK((nombreDeVideoAimee >= 0) AND (nombreDeVideoAimee < 301));

CREATE OR REPLACE TRIGGER checkLimiteFavoris
  BEFORE INSERT ON favoris
  FOR EACH ROW
    declare  
    nb_videoliked INTEGER;
  BEGIN
    SELECT count(id_utilisteur) into nb_videoliked FROM favoris
    WHERE id_utilisateur = :new.id_utilisateur
    group by id_utilisateur
        
  IF nb_videolikee >= 300 THEN
        RAISE_APPLICATION_ERROR(-20004, 'IMPOSSIBLE D AJOUTER UNE VIDEO AU FAVORIS,IL Y A 300 DEJA, ESPACE REMPLI!!!');
  END IF;
END;
/
SHOW ERRORS
---------------------------------------------------------------------------

/* --2)
  Si une diffusion d’une émission est ajoutée, les dates de disponibilités seront mises à jour.
  La nouvelle date de fin de disponibilité sera la date de la dernière diffusion plus 14 jours.
*/


/* -- 3)
  La suppression d’une vidéo entraînera son archivage dans 
  une tables des vidéos qui ne sontplus accessibles par le site de replay
*/
CREATE OR REPLACE TRIGGER archiver_video
    BEFORE DELETE
       ON video
       FOR EACH ROW
    BEGIN
        insert into videoArchivee(id_video,id_emission,titre,description_video,multilangue,localisation,date_p_duffision,duree,format_image)
        values (:old.id_video, :old.id_emission,:old.titre,:old.description_video,:old.multilangue,:old.localisation,:old.date_p_duffision,:old.duree,:old.format_image);
        DBMS_OUTPUT.PUT_LINE('video au n° '|| :old.id_video || ' Est archivée');
END;
/
-- Test
delete from video where id_video = 2;
select * from videoArchivee where id_video = 2;
---------------------------------------------------------------------------------
/* -- 4)
  Afin de limiter le spam de visionnage, 
  un utilisateur ne pourra pas lancer plus de  3visionnages par minutes.
*/

timestp = current_timestamp - 1;
nombre_visionage = 0;

CREATE OR REPLACE TRIGGER visionage_controle
  BEFORE INSERT ON historique
  FOR EACH ROW
  DECLARE
    delai INTEGER;
    date_vis DATE;
  BEGIN
    SELECT max(date_visionnage) INTO date_vis FROM historique WHERE id_utilisateur = :new.id_utilisateur;
    delai := SYSDATE - date_vis
    IF delai >=0  THEN
      IF (timestp - current_timestamp < interval '1' minute)THEN
        IF nombre_visionage< 3 THEN
            INSERT INTO historique VALUES (id_historique, id_video, id_utilisateur,current_date);
        ELSE
        RAISE_APPLICATION_ERROR(-20004, 'Vous nepouvez pas regarder 3 videos en une minutes, attendez!');
         END IF;
      ELSE
        nombre_visionage = 1;
        INSERT INTO historique VALUES (id_historique, id_video, id_utilisateur,current_date);
      END IF;
    END IF;
END;
/
SHOW ERRORS
*/
