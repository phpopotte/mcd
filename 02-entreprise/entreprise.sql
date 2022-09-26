--  Pour faire un commentaire en sql

-- connection à mysql avec xampp
-- ouvrir un invite de commande et taper la ligne suivante
-- cd c:\xampp\mysql\bin        (puis entré)

-- vous êtes à présent à la racine du dossier bin de mysql qui contient l'executable de mysql
-- pour s'y connecter entrer:
-- mysql.exe  -u root

-- ***********************************************
--  REQUETES GENERALES
-- *************************************************

-- Créer et utiliser une BDD :
CREATE DATABASE entreprise;   -- créé une BDD nommée 'entreprise'
    -- Les requêtes SQL ne sont pas sensibles à la casse,mais par convention on met les mots clés en majuscules

SHOW DATABASES; -- permet d'afficher BDD existantes

USE entreprise; -- utiliser la BDD 'entreprise'

-- on copie/colle le script 'entreprise_employes.sql' (fichier source de la BDD entreprise)

-- Voir les tables de la BDD
SHOW TABLES; --affiche les tables de la BDD entreprise
-- MariaDB [entreprise]> SHOW tables;
-- +----------------------+
-- | Tables_in_entreprise |
-- +----------------------+
-- | employes             |
-- +----------------------+

-- Pour observer le détail (structure d'une table)
DESC employes;  -- montre la structure de la table employés de la BDD entreprise
-- MariaDB [entreprise]> DESC employes;
-- +---------------+---------------+------+-----+---------+----------------+
-- | Field         | Type          | Null | Key | Default | Extra          |
-- +---------------+---------------+------+-----+---------+----------------+
-- | id_employes   | int(3)        | NO   | PRI | NULL    | auto_increment |
-- | prenom        | varchar(20)   | YES  |     | NULL    |                |
-- | nom           | varchar(20)   | YES  |     | NULL    |                |
-- | sexe          | enum('m','f') | NO   |     | NULL    |                |
-- | service       | varchar(30)   | YES  |     | NULL    |                |
-- | date_embauche | date          | YES  |     | NULL    |                |
-- | salaire       | float         | YES  |     | NULL    |                |
-- +---------------+---------------+------+-----+---------+----------------+

-- Supprimer des éléments :
DROP DATABASE nom_de_la_bdd; -- Supprime la BDD qui s'appelle nom_de_la_bdd

DROP TABLE nom_de_la_table; -- Supprime la table qui se nomme nom_de_la_table

TRUNCATE nom_de_la_table;  -- Vide tout les enregistrement d'une table sans supprimer la table


-- *********************************************
-- REQUETES D'AFFICHAGE OU DE SELECTION
-- *********************************************

-- SELECT
SELECT nom, prenom FROM employes;-- affiche le nom et prénom des employes.
-- SELECT est toujours suivi des colonnes d'affichage demandées puis du mot clé FROM suivi du nom de la table dans laquelle se trouvent ces données

-- afficher le nom, le prenom, l'id_employes et le service des employes
SELECT nom, prenom, service, id_employes FROM employes;

-- afficher tou les services des employes
SELECT service FROM employes; -- affiche tout les services des 20 enregistrements de la table avec certains doublons

-- DISTINCT
SELECT DISTINCT service FROM employes; -- affiche les différents services dédoublonnées de nos 20 enregistrements

-- * pour ALL
SELECT * FROM employes; -- affiche toutes les colonnes de la table

-- clause WHERE (condition en SQL)
SELECT nom, prenom FROM employes WHERE service='informatique';-- affiche le nom et le prénom de tout les employes à condition qu'ils parti du service 'informatique'

-- BETWEEN
SELECT * FROM employes WHERE date_embauche BETWEEN '2006-01-01' AND '2010-12-31';
-- affiche toutes les informations (toutes les colonnes) des employes (des enregistrements) de la table employes dont la date d'embauche (colonne date_embauche) se trouve entre le 01-01-2006 et 31-12-2010 (de 2006 à 2010)

-- LIKE
SELECT prenom FROM employes WHERE prenom LIKE 's%';-- affiche tout les employes dont le prenom commence par s

SELECT prenom FROM employes WHERE prenom LIKE '%e';-- affiche tout les employes dont le prenom se termine par e

SELECT prenom FROM employes WHERE prenom LIKE '%-%';-- affiche les employes ayant un prenom composé séparé par '-'

-- Opérateurs de comparaison :
--  <
--  >
--  <=
--   >=
--  !=  ou <> pour different de
--   =

SELECT nom, prenom FROM employes WHERE service!='informatique';-- tout les employes dont le service est different de 'informatique'

SELECT * FROM employes WHERE salaire > 3000; -- affiche tout les employes dont le salaire est superieur à 3000 euros

-- ORDER BY
SELECT * FROM employes ORDER BY salaire ASC; -- affiche tout les employes ordonnés par salaire ascendant (du plus petit au plus grand). A savoir ASC n'est pas necessaire car definit par defaut si non précisé

SELECT * FROM employes ORDER BY salaire DESC;-- affiche tout les employes ordonnés par salaire descendant (du plus grand au plus petit). DESC est obligatoire si souhaité en ordre décroissant

SELECT * FROM employes ORDER BY salaire ASC, prenom DESC; --affiche tout les employes ordonnés par salaire ascendant (du plus petit au plus grand) puis par prénom décroissant (de z à a) sur tout les salaires identiques

-- LIMIT
SELECT * FROM employes ORDER BY salaire DESC LIMIT 1;-- Affiche le premier résultat de la requête de tout les employes ordonnés par salaire decroissant (donc l'employé dont le salaire est le plus élevé)
--equivaut à
SELECT * FROM employes ORDER BY salaire DESC LIMIT 0,1;-- le 0 correspond à l'OFFSET, c'est à dire le point de départ (on compte à partir de 0) . Le 1 correspond au nombre de lignes que l'on souhaite afficher

-- l'alias avec AS (renommage de colonne)
SELECT nom, prenom, salaire*12 AS salaire_annuel FROM employes;-- l'alias permet de renommer la colonne 'salaire*12' en 'salaire_annuel'

-- Attention à l'ordre
--  SELECT .... FROM ....WHERE.... LIKE ...ORDER BY....LIMIT....

-- SUM
SELECT SUM(salaire*12) FROM employes; -- affiche la somme des salaires annuels de tout les employes
-- SUM() est une fonction d'agregat native d'SQL donc les () doivent être collé au nom de la fonction SUM

--   MIN et MAX
SELECT MIN(salaire) FROM employes; -- affiche le salaire le plus bas de la table employes

SELECT MAX(salaire) FROM employes; -- affiche le salaire le plus élevé de la table employes

SELECT prenom, nom, MIN(salaire) FROM employes ORDER BY prenom DESC , nom DESC;-- cette requête sort une erreur ou un resultat incohérent (dépendant de la sensibilité des serveurs) car les fonctions de calculs ne peuvent être croisées avec un autre champs dans la requête de SELECT

-- il nous faut donc passer par la requête suivante
SELECT nom, prenom, salaire FROM employes ORDER BY salaire ASC LIMIT 1;

-- AVG (pour average = moyenne)
SELECT AVG(salaire) FROM employes; -- affiche la moyenne des salaires des employes

-- ROUND
SELECT ROUND(AVG(salaire), 1) FROM employes;-- affiche la moyenne des salaire arrondie à 1 chiffre après la virgule

-- COUNT
SELECT COUNT(id_employes) FROM employes WHERE sexe='f'; -- on affiche le nombre d'employées de sexe feminin

-- IN
SELECT * FROM employes WHERE service IN ('comptabilite', 'informatique');-- affiche les informations  des employes travaillant ou dans service comptabilité ou informatique

-- NOT IN
SELECT * FROM employes WHERE service NOT IN ('comptabilite', 'informatique');-- affiche les informations  des employes ne travaillant ni dans service comptabilité ni dans le service informatique informatique

-- AND et OR
SELECT * FROM employes WHERE service='commercial' AND salaire<=2000; -- affiche tout les employes du service commercial dont le salaire est inferieur ou egal à 2000

SELECT * FROM employes WHERE service='production' AND salaire=1900 OR salaire =2300;
-- REVIENT à écrire
SELECT * FROM employes WHERE (service='production' AND salaire=1900) OR salaire =2300;

-- GROUP BY
SELECT service, COUNT(id_employes)  FROM employes GROUP BY service; -- affiche le nombre d'employes par service. GROUP BY est utilisé obligatoirment avec les fonctions d'agregat quand on souhaite les croiséees avec un autre champs ( donc obligatoire avec MIN, MAX, SUM, COUNT, AVG )

-- GROUP BY ... HAVING
SELECT service , COUNT(id_employes) AS nombre FROM employes GROUP BY service  HAVING nombre =1;-- ffiche le nombre d'employes par service à la condition que ce nombre soit egal à 1
-- HAVING remplace la clause WHERE à l'intérieur d'un GROUP BY

-- Attention à l'ordre :
-- SELECT .... FROM .... WHERE ... GROUP BY ....HAVING.... ORDER BY ... LIMIT 


-- ***************************
-- Exercices
-- ***************************
-- 1. Afficher le service de l'employé 547
SELECT service AS service_employe_547 FROM employes WHERE id_employes = 547;

-- 2. Afficher la date d'embauche d'Amandine
SELECT date_embauche AS date_embauche_Amendine FROM employes WHERE prenom = "Amandine";

-- 3. Afficher le nombre de commerciaux
SELECT COUNT(id_employes) AS nb_commerciaux FROM employes WHERE service = "commercial";

-- 4. Afficher le salaire des commerciaux sur 1 année
SELECT salaire*12 AS salaire_annuel_commerciaux FROM employes WHERE service = 'commerciaux';

-- 5. Afficher le salaire moyen par service
SELECT service, ROUND(AVG(salaire)) AS salaire_moyen_par_service FROM employes GROUP BY employes.service;

-- 6. Afficher le nombre de recrutement sur 2010
SELECT COUNT(id_employes) AS nb_recrutement_2010 FROM employes WHERE date_embauche BETWEEN '2010-01-01' AND '2010-12-31';

-- 7. Afficher le nombre de services DIFFERENTS
SELECT COUNT(DISTINCT service) AS nb_services FROM employes;

-- 8. Afficher le nombre d'employés par service
SELECT service, COUNT(id_employes) AS n_employes_service FROM employes GROUP BY service;

-- 9. Afficher les informations de l'employé du service commercial gagnant le salaire le plus élevé
SELECT * FROM employes WHERE service = 'commercial' ORDER BY salaire DESC LIMIT 1;

-- 10. Afficher l'employé ayant été embauché en dernier
SELECT * FROM employes ORDER BY date_embauche DESC LIMIT 1;
