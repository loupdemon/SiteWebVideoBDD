/******************************
** File: REQUETE.SQL
** Desc: Fichier contenant les requetes demandées.
** Auth: AZZOUG AGHILAS
** Date: 10/2020
*******************************/

/*--requete 1 --nombre visionnage par categories dans les deux semaines passées */
select nom_type,count(*) from historique,video,emission,types where historique.id_video=video.id_video and video.id_emission=emission.id_emission and emission.id_type=types.id_type and (sysdate - date_visionnage)<14 group by nom_type;


/*--requete 2 -- nombre d'abonnements , favoris , de videos visionnées */
select id_utilisateur, count(*) AS nbfavoris from favoris group by id_utilisateur;
select id_utilisateur, count(*) AS nbabonnement from follow group by id_utilisateur;
select id_utilisateur, count(*) AS nbhistorique from historique group by id_utilisateur;

/* --en combinée --
select
    (select count(*) from favoris group by id_utilisateur )AS nbfavoris,
    (select count(*) from follow group by id_utilisateur )AS nbAbonnement ,
    (select count(*) from historique group by id_utilisateur )AS nbVisionnage from utilisateurs;*/

/*--resquete 3 -- nombre de visionnage par des users français et allemand et diff...*/

select nationalite,video.id_video,count(*)as compteur from utilisateurs ,historique , video where utilisateurs.id_utilisateur=historique.id_utilisateur and video.id_video= historique.id_video and (nationalite='france' or nationalite='allemagne') group by nationalite,video.id_video order by abs (compteur);


/*-- requete 4 -- les episodes d'emissios qui ont au moins deux fois plus de visionages que la moyenne des visionnages des aures epidodes de l'emssion */

select id_video ,count(*)from(select avg(cc)from (select count(*) as cc from historique) as average)from historique as counts where counts>=2*average;

select id_video ,count(*)from(select avg(cc)from (select count(*) from historique as cc) as average) as counts where counts>=2*average;

/*-- requete 5 -- lles 10 couples qui apparaissent le plus simltanement et souvent dans l'historique */
select id_video, Max(select count(*)id_video from historique) where historique.id_video=video.id_video  group bu id_utilisateur;
