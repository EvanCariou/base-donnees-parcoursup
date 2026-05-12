-- INITIALISATION DU SCHÉMA
DROP SCHEMA IF EXISTS parcoursup CASCADE;
CREATE SCHEMA parcoursup;
SET search_path TO parcoursup;



-- Région
CREATE TABLE _region (
    region_nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_region PRIMARY KEY (region_nom)
);

-- Académie
CREATE TABLE _academie (
    academie_nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_academie PRIMARY KEY (academie_nom)
);

-- Département (appartient à une région)
CREATE TABLE _departement (
    departement_code VARCHAR(5)  NOT NULL,
    departement_nom  VARCHAR(50) NOT NULL,
    region_nom       VARCHAR(50) NOT NULL,

    CONSTRAINT pk_departement PRIMARY KEY (departement_code),
    CONSTRAINT fk_departement_region
        FOREIGN KEY (region_nom) REFERENCES _region(region_nom)
);

-- Commune (appartient à un département)
CREATE TABLE _commune (
    commune_nom      VARCHAR(100) NOT NULL,
    departement_code VARCHAR(5)   NOT NULL,

    CONSTRAINT pk_commune PRIMARY KEY (commune_nom, departement_code),
    CONSTRAINT fk_commune_departement
        FOREIGN KEY (departement_code) REFERENCES _departement(departement_code)
);

-- Établissement (appartient à une académie)
CREATE TABLE _etablissement (
    etablissement_code_uai VARCHAR(10)  NOT NULL,
    etablissement_nom      VARCHAR(200),
    etablissement_statut   VARCHAR(30),
    academie_nom           VARCHAR(50),

    CONSTRAINT pk_etablissement PRIMARY KEY (etablissement_code_uai),
    CONSTRAINT fk_etablissement_academie
        FOREIGN KEY (academie_nom) REFERENCES _academie(academie_nom)
);



-- table filiere
CREATE TABLE _filiere (
    filiere_id                   SERIAL,
    filiere_libelle              VARCHAR(100),
    filiere_libelle_tres_abrege  VARCHAR(20),
    filiere_libelle_abrege       VARCHAR(50),
    filiere_libelle_detaille_bis VARCHAR(200),

    CONSTRAINT pk_filiere PRIMARY KEY (filiere_id)
);

-- Session (année ParcourSup)
CREATE TABLE _session (
    session_annee INT NOT NULL,
    CONSTRAINT pk_session PRIMARY KEY (session_annee)
);

-- Type de baccalauréat
CREATE TABLE _type_bac (
    type_bac VARCHAR(25) NOT NULL,
    CONSTRAINT pk_type_bac PRIMARY KEY (type_bac)
);

-- Mention au bac
CREATE TABLE _mention_bac (
    libelle_mention VARCHAR(50) NOT NULL,
    CONSTRAINT pk_mention_bac PRIMARY KEY (libelle_mention)
);

-- Regroupement
CREATE TABLE _regroupement (
    libelle_regroupement VARCHAR(100) NOT NULL,
    CONSTRAINT pk_regroupement PRIMARY KEY (libelle_regroupement)
);



-- table formation
CREATE TABLE _formation (
    cod_aff_form                    VARCHAR(20)  NOT NULL,
    filiere_libelle_detaille        VARCHAR(300),
    coordonnees_gps                 VARCHAR(30),
    list_com                        VARCHAR(50),
    concours_communs_banque_epreuve VARCHAR(200),
    url_formation                   VARCHAR(200),
    tri                             VARCHAR(10),
    filiere_id                      INT          NOT NULL,
    etablissement_code_uai          VARCHAR(10)  NOT NULL,
    commune_nom                     VARCHAR(100),
    departement_code                VARCHAR(5),

    CONSTRAINT pk_formation PRIMARY KEY (cod_aff_form),
    CONSTRAINT fk_formation_filiere
        FOREIGN KEY (filiere_id) REFERENCES _filiere(filiere_id),
    CONSTRAINT fk_formation_etablissement
        FOREIGN KEY (etablissement_code_uai) REFERENCES _etablissement(etablissement_code_uai),
    CONSTRAINT fk_formation_commune
        FOREIGN KEY (commune_nom, departement_code) REFERENCES _commune(commune_nom, departement_code)
);



-- TABLES ADMISSIONS_GENERALITES
CREATE TABLE _admissions_generalites (
    cod_aff_form              VARCHAR(20) NOT NULL,
    session_annee             INT         NOT NULL,
    selectivite               VARCHAR(40),
    capacite                  INT,
    effectif_total_candidats  INT,
    effectif_total_candidates INT,

    CONSTRAINT pk_admissions_generalites PRIMARY KEY (cod_aff_form, session_annee),
    CONSTRAINT fk_adm_gen_formation
        FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_adm_gen_session
        FOREIGN KEY (session_annee) REFERENCES _session(session_annee)
);

-- table admission selon le type de bac
CREATE TABLE _admissions_selon_type_neo_bac (
    cod_aff_form                      VARCHAR(20) NOT NULL,
    session_annee                     INT         NOT NULL,
    type_bac                          VARCHAR(25) NOT NULL,
    effectif_candidat_neo_bac_classes INT,

    CONSTRAINT pk_admissions_selon_type_neo_bac PRIMARY KEY (cod_aff_form, session_annee, type_bac),
    CONSTRAINT fk_adm_type_bac_formation
        FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_adm_type_bac_session
        FOREIGN KEY (session_annee) REFERENCES _session(session_annee),
    CONSTRAINT fk_adm_type_bac_type_bac
        FOREIGN KEY (type_bac) REFERENCES _type_bac(type_bac)
);

-- table d'effectif selon la mention
CREATE TABLE _effectif_selon_mention (
    cod_aff_form                         VARCHAR(20) NOT NULL,
    session_annee                        INT         NOT NULL,
    libelle_mention                      VARCHAR(50) NOT NULL,
    effectif_admis_neo_bac_selon_mention INT,

    CONSTRAINT pk_effectif_selon_mention PRIMARY KEY (cod_aff_form, session_annee, libelle_mention),
    CONSTRAINT fk_eff_mention_formation
        FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_eff_mention_session
        FOREIGN KEY (session_annee) REFERENCES _session(session_annee),
    CONSTRAINT fk_eff_mention_mention
        FOREIGN KEY (libelle_mention) REFERENCES _mention_bac(libelle_mention)
);

-- table du dernier rang appelé selon le regroupement
CREATE TABLE _rang_dernier_appele_selon_regroupement (
    cod_aff_form         VARCHAR(20)  NOT NULL,
    session_annee        INT          NOT NULL,
    libelle_regroupement VARCHAR(100) NOT NULL,
    rang_dernier_appele  INT,

    CONSTRAINT pk_rang_dernier_appele PRIMARY KEY (cod_aff_form, session_annee, libelle_regroupement),
    CONSTRAINT fk_rang_formation
        FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_rang_session
        FOREIGN KEY (session_annee) REFERENCES _session(session_annee),
    CONSTRAINT fk_rang_regroupement
        FOREIGN KEY (libelle_regroupement) REFERENCES _regroupement(libelle_regroupement)
);


-- DONNÉES DE RÉFÉRENCE

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

INSERT INTO _session (session_annee) VALUES (2022);
