-- Evan Cariou et Eloi Cossec 1B2
-- SAE 2.04 - Partie 2 : Peuplement de la base parcoursup2


SET search_path TO parcoursup2;


-- TABLE TEMPORAIRE : on y charge toutes les donnees du CSV

DROP TABLE IF EXISTS import_data;
CREATE TABLE import_data(
    session_annee                                        numeric(4)    NOT NULL,
    etablissement_statut                                 varchar(40)   NOT NULL,
    etablissement_code_uai                               varchar(10)   NOT NULL,
    etablissement_nom                                    varchar(150)  NOT NULL,
    departement_code                                     varchar(5)    NOT NULL,
    departement_nom                                      varchar(50)   NOT NULL,
    region_nom                                           varchar(50)   NOT NULL,
    academie_nom                                         varchar(50)   NOT NULL,
    commune_nom                                          varchar(100)  NOT NULL,
    filiere_libelle                                      varchar(300)  NOT NULL,
    selectivite                                          varchar(40)   NOT NULL,
    filiere_libelle_tres_abrege                          varchar(20)   NOT NULL,
    filiere_libelle_detaille                             varchar(400)  NOT NULL,
    filiere_libelle_abrege                               varchar(100)  NOT NULL,
    filiere_libelle_detaille_bis                         varchar(200)  NOT NULL,
    filiere_libelle_tres_detaille                        varchar(400),
    coordonnees_gps                                      varchar(30)   NOT NULL,
    capacite                                             integer       NOT NULL,
    effectif_total_candidats                             integer       NOT NULL,
    effectif_total_candidates                            integer       NOT NULL,
    effectif_candidat_neo_bac_classes_type_general       integer       NOT NULL,
    effectif_candidat_neo_bac_classes_type_techno        integer       NOT NULL,
    effectif_candidat_neo_bac_classes_type_pro           integer       NOT NULL,
    effectif_candidat_classes_type_autres                integer       NOT NULL,
    effectif_admis_neo_bac_selon_mention_sans_info       integer       NOT NULL,
    effectif_admis_neo_bac_selon_mention_sans_mention    integer       NOT NULL,
    effectif_admis_neo_bac_selon_mention_assez_bien      integer       NOT NULL,
    effectif_admis_neo_bac_selon_mention_bien            integer       NOT NULL,
    effectif_admis_neo_bac_selon_mention_tres_bien       integer       NOT NULL,
    effectif_admis_neo_bac_selon_mention_tres_bien_fel   integer       NOT NULL,
    regroupement_1                                       varchar(100),
    rang_dernier_appele_groupe1                          integer,
    regroupement_2                                       varchar(100),
    rang_dernier_appele_groupe2                          integer,
    regroupement_3                                       varchar(100),
    rang_dernier_appele_groupe3                          integer,
    list_com                                             varchar(50)   NOT NULL,
    tri                                                  varchar(25)   NOT NULL,
    cod_aff_form                                         varchar(20)   NOT NULL,
    concours_communs_banque_epreuve                      varchar(200),
    url_formation                                        varchar(200)
);


-- Import des donnees du CSV dans la table temporaire

WbImport -file=./fr-esr-parcoursup_2022.csv
         -header=true
         -delimiter=';'
         -quoteChar='"'
         -table=import_data
         -schema=parcoursup2
         -mode=insert
         -emptyStringIsNull=true
         -multiLine=true
         -filecolumns=session_annee, etablissement_statut, etablissement_code_uai, etablissement_nom,
                      departement_code, departement_nom, region_nom, academie_nom, commune_nom,
                      filiere_libelle, selectivite, filiere_libelle_tres_abrege, filiere_libelle_detaille,
                      filiere_libelle_abrege, filiere_libelle_detaille_bis, filiere_libelle_tres_detaille,
                      coordonnees_gps, capacite, effectif_total_candidats, effectif_total_candidates,
                      effectif_total_phase_principale, effectif_internat_phase_principale,
                      effectif_neo_bac_general_phase_principale, effectif_neo_bac_general_phase_principale_boursier,
                      effectif_neo_bac_techno_phase_principale, effectif_neo_bac_techno_principale_boursier,
                      effectif_neo_bac_pro_phase_principale, effectif_neo_bac_pro_phase_principale_boursier,
                      effectif_total_autres_phase_principale, effectif_total_phase_complementaire,
                      effectif_neo_bac_general_phase_complementaire, effectif_neo_bac_techno_phase_complementaire,
                      effectif_neo_bac_pro_phase_complementaire, effectif_total_autres_phase_complementaire,
                      effectif_total_classes_phase_principale, effectif_total_classes_phase_complementaire,
                      effectif_total_classes_internat_cpge, effectif_total_classes_hors_internat_cpge,
                      effectif_candidat_neo_bac_classes_type_general,
                      effectif_candidat_neo_bac_boursiers_classes_type_general,
                      effectif_candidat_neo_bac_classes_type_techno,
                      effectif_candidat_neo_bac_boursiers_classes_type_techno,
                      effectif_candidat_neo_bac_classes_type_pro,
                      effectif_candidat_neo_bac_boursiers_classes_type_pro,
                      effectif_candidat_classes_type_autres,
                      effectif_total_proposition_admission, effectif_total_admis, effectif_total_admises,
                      effectif_total_admis_phase_principale, effectif_total_admis_phase_complementaire,
                      effectif_proposition_admis_ouverture_procedure_principale, effectif_proposition_admis_avant_bac,
                      effectif_proposition_admis_avant_fin_procedure_principale, effectif_admis_en_internat,
                      effectif_total_admis_boursiers_neo_bac, effectif_total_admis_neo_bac,
                      effectif_admis_neo_bac_type_general, effectif_admis_neo_bac_type_techno,
                      effectif_admis_neo_bac_type_pro, effectif_admis_neo_bac_type_autres,
                      effectif_admis_neo_bac_selon_mention_sans_info,
                      effectif_admis_neo_bac_selon_mention_sans_mention,
                      effectif_admis_neo_bac_selon_mention_assez_bien,
                      effectif_admis_neo_bac_selon_mention_bien,
                      effectif_admis_neo_bac_selon_mention_tres_bien,
                      effectif_admis_neo_bac_selon_mention_tres_bien_fel,
                      effectif_admis_neo_bac_avec_mention_bac_general,
                      effectif_admis_neo_bac_avec_mention_bac_techno,
                      effectif_admis_neo_bac_avec_mention_bac_pro,
                      effectif_admis_meme_etablissement, effectif_admises_meme_etablissement,
                      effectif_admis_meme_academie, effectif_admis_meme_academie_pcv,
                      pourcent_proposition_admis_ouverture_procedure_principale, pourcent_proposition_avant_bac,
                      pourcent_proposition_admis_avant_fin_procedure_principale, pourcent_admises,
                      pourcent_neo_bac_admis_meme_academie, pourcent_neo_bac_admis_meme_academie_pcv,
                      pourcent_neo_bac_admis_meme_etablissement_bts_cpge, pourcent_neo_bac_admis_boursiers,
                      pourcent_neo_bac, pourcent_neo_bac_mention_sans_info, pourcent_neo_bac_mention_sans,
                      pourcent_neo_bac_mention_assez_bien, pourcent_neo_bac_mention_bien,
                      pourcent_neo_bac_mention_tres_bien, pourcent_neo_bac_mention_tres_bien_felicitations,
                      pourcent_neo_bac_general, pourcent_neo_bac_general_avec_mention, pourcent_neo_bac_techno,
                      pourcent_neo_bac_techno_avec_mention, pourcent_neo_bac_pro, pourcent_neo_bac_pro_avec_mention,
                      effectif_candidats_terminale_generale_avec_proposition_admis,
                      effectif_candidats_terminale_generale_boursiers_avec_proposition_admis,
                      effectif_candidats_terminale_techno_avec_proposition_admis,
                      effectif_candidats_terminale_techno_boursiers_avec_proposition_admis,
                      effectif_candidats_terminale_pro_avec_proposition_admis,
                      effectif_candidats_terminale_pro_boursiers_avec_proposition_admis,
                      effectif_autres_candidats_avec_proposition_admis,
                      regroupement_1, rang_dernier_appele_groupe1,
                      regroupement_2, rang_dernier_appele_groupe2,
                      regroupement_3, rang_dernier_appele_groupe3,
                      list_com, tri, cod_aff_form, concours_communs_banque_epreuve, url_formation,
                      taux_acces,
                      part_terminale_generale_en_position_admis_phase_principale,
                      part_terminale_techno_en_position_admis_phase_principale,
                      part_terminale_pro_en_position_admis_phase_principale,
                      etablissement_id_paysage, composante_id_paysage
         -importColumns=session_annee, etablissement_statut, etablissement_code_uai, etablissement_nom,
                      departement_code, departement_nom, region_nom, academie_nom, commune_nom,
                      filiere_libelle, selectivite, filiere_libelle_tres_abrege, filiere_libelle_detaille,
                      filiere_libelle_abrege, filiere_libelle_detaille_bis, filiere_libelle_tres_detaille,
                      coordonnees_gps, capacite, effectif_total_candidats, effectif_total_candidates,
                      effectif_candidat_neo_bac_classes_type_general,
                      effectif_candidat_neo_bac_classes_type_techno,
                      effectif_candidat_neo_bac_classes_type_pro,
                      effectif_candidat_classes_type_autres,
                      effectif_admis_neo_bac_selon_mention_sans_info,
                      effectif_admis_neo_bac_selon_mention_sans_mention,
                      effectif_admis_neo_bac_selon_mention_assez_bien,
                      effectif_admis_neo_bac_selon_mention_bien,
                      effectif_admis_neo_bac_selon_mention_tres_bien,
                      effectif_admis_neo_bac_selon_mention_tres_bien_fel,
                      regroupement_1, rang_dernier_appele_groupe1,
                      regroupement_2, rang_dernier_appele_groupe2,
                      regroupement_3, rang_dernier_appele_groupe3,
                      list_com, tri, cod_aff_form, concours_communs_banque_epreuve, url_formation;


-- Tables sans clé étrangères

-- Regions
INSERT INTO _region (region_nom)
SELECT DISTINCT region_nom
FROM import_data;

-- Academies
INSERT INTO _academie (academie_nom)
SELECT DISTINCT academie_nom
FROM import_data;

-- Etablissements (le schema officiel ne stocke PAS l'academie ici)
INSERT INTO _etablissement (etablissement_code_uai, etablissement_nom, etablissement_statut)
SELECT DISTINCT etablissement_code_uai, etablissement_nom, etablissement_statut
FROM import_data;

-- Filieres (le filiere_id est genere automatiquement par SERIAL)
INSERT INTO _filiere (filiere_libelle, filiere_libelle_tres_abrege, filiere_libelle_abrege, filiere_libelle_detaille_bis)
SELECT DISTINCT filiere_libelle, filiere_libelle_tres_abrege, filiere_libelle_abrege, filiere_libelle_detaille_bis
FROM import_data;

-- Session : le create officiel ne la remplit pas, on le fait ici
INSERT INTO _session (session_annee)
SELECT DISTINCT session_annee
FROM import_data;

-- Valeur de la partie 1
INSERT INTO _type_bac (type_bac) VALUES
    ('Bac général'),
    ('Bac technologique'),
    ('Bac professionnel'),
    ('Autres');

INSERT INTO _mention_bac (libelle_mention) VALUES
    ('Sans information'),
    ('Sans mention'),
    ('Assez bien'),
    ('Bien'),
    ('Très bien'),
    ('Très bien avec félicitations du jury');

-- Regroupements
INSERT INTO _regroupement (libelle_regroupement)
SELECT DISTINCT regroupement_1 FROM import_data WHERE regroupement_1 IS NOT NULL
UNION
SELECT DISTINCT regroupement_2 FROM import_data WHERE regroupement_2 IS NOT NULL
UNION
SELECT DISTINCT regroupement_3 FROM import_data WHERE regroupement_3 IS NOT NULL;


-- Table avec cle etrangeres

-- Departements (cle etrangere vers _region)
INSERT INTO _departement (departement_code, departement_nom, region_nom)
SELECT DISTINCT departement_code, departement_nom, region_nom
FROM import_data;

-- Communes (cle etrangere vers _departement)
INSERT INTO _commune (commune_nom, departement_code)
SELECT DISTINCT commune_nom, departement_code
FROM import_data;

-- Formation : on recupere le filiere_id avec un INNER JOIN sur les 4 libelles.

INSERT INTO _formation (
    cod_aff_form,
    filiere_libelle_detaille,
    coordonnees_gps,
    list_com,
    concours_communs_banques_epreuves,
    url_formation,
    tri,
    filiere_id,
    etablissement_code_uai,
    commune_nom,
    departement_code,
    academie_nom
)
SELECT DISTINCT
    i.cod_aff_form,
    i.filiere_libelle_detaille,
    i.coordonnees_gps,
    i.list_com,
    i.concours_communs_banque_epreuve,
    i.url_formation,
    i.tri,
    f.filiere_id,
    i.etablissement_code_uai,
    i.commune_nom,
    i.departement_code,
    i.academie_nom

FROM import_data i
INNER JOIN _filiere f 
    ON f.filiere_libelle = i.filiere_libelle
    AND f.filiere_libelle_tres_abrege  = i.filiere_libelle_tres_abrege
    AND f.filiere_libelle_abrege       = i.filiere_libelle_abrege
    AND f.filiere_libelle_detaille_bis = i.filiere_libelle_detaille_bis;




-- Admissions generalites
INSERT INTO _admissions_generalites (cod_aff_form, session_annee, selectivite, capacite,
                                     effectif_total_candidats, effectif_total_candidates)
SELECT cod_aff_form, session_annee, selectivite, capacite,
       effectif_total_candidats, effectif_total_candidates
FROM import_data;

-- Admissions selon le type de bac
INSERT INTO _admissions_selon_type_neo_bac (cod_aff_form, session_annee, type_bac, effectif_candidat_neo_bac_classes)
SELECT cod_aff_form, session_annee, 'Bac général',       effectif_candidat_neo_bac_classes_type_general FROM import_data
UNION ALL
SELECT cod_aff_form, session_annee, 'Bac technologique', effectif_candidat_neo_bac_classes_type_techno  FROM import_data
UNION ALL
SELECT cod_aff_form, session_annee, 'Bac professionnel', effectif_candidat_neo_bac_classes_type_pro     FROM import_data
UNION ALL
SELECT cod_aff_form, session_annee, 'Autres',            effectif_candidat_classes_type_autres          FROM import_data;

-- Effectif selon la mention au bac
INSERT INTO _effectif_selon_mention (cod_aff_form, session_annee, libelle_mention, effectif_admis_neo_bac_selon_mention)
SELECT cod_aff_form, session_annee, 'Sans information',effectif_admis_neo_bac_selon_mention_sans_info     
FROM import_data

UNION ALL

SELECT cod_aff_form, session_annee, 'Sans mention', effectif_admis_neo_bac_selon_mention_sans_mention  
FROM import_data

UNION ALL

SELECT cod_aff_form, session_annee, 'Assez bien', effectif_admis_neo_bac_selon_mention_assez_bien 
FROM import_data

UNION ALL

SELECT cod_aff_form, session_annee, 'Bien', effectif_admis_neo_bac_selon_mention_bien 
FROM import_data

UNION ALL

SELECT cod_aff_form, session_annee, 'Très bien', effectif_admis_neo_bac_selon_mention_tres_bien     
FROM import_data

UNION ALL

SELECT cod_aff_form, session_annee, 'Très bien avec félicitations du jury', effectif_admis_neo_bac_selon_mention_tres_bien_fel 
FROM import_data;

-- Rang du dernier appele selon le regroupement
INSERT INTO _rang_dernier_appele_selon_regroupement (cod_aff_form, session_annee, libelle_regroupement, rang_dernier_appele)
SELECT cod_aff_form, session_annee, regroupement_1, rang_dernier_appele_groupe1
FROM import_data
WHERE regroupement_1 IS NOT NULL AND rang_dernier_appele_groupe1 IS NOT NULL

UNION ALL

SELECT cod_aff_form, session_annee, regroupement_2, rang_dernier_appele_groupe2
FROM import_data
WHERE regroupement_2 IS NOT NULL AND rang_dernier_appele_groupe2 IS NOT NULL

UNION ALL

SELECT cod_aff_form, session_annee, regroupement_3, rang_dernier_appele_groupe3
FROM import_data
WHERE regroupement_3 IS NOT NULL AND rang_dernier_appele_groupe3 IS NOT NULL;


-- Suppression de la table tampon
DROP TABLE import_data;

COMMIT;
