CREATE TABLE Formation (
    cod_aff_from VARCHAR(25) PRIMARY KEY NOT NULL,
    filliere_libelle_detaille VARCHAR(50),
    coordonnes_gps VARCHAR(25),
    list_com VARCHAR(25),
    concour_communs_banque_eprevue VARCHAR(50),
    url_formation VARCHAR(25),
    tri VARCHAR(25)
);


CREATE TABLE Filiere (
    filiere_id INT PRIMARY KEY NOT NULL,
    filiere_libelle VARCHAR(50),
    filiere_libelle_tres_agrege VARCHAR(50),
    filiere_libelle_agrege VARCHAR(50),
    filiere_libelle_detaille_bis VARCHAR(50)
);


CREATE TABLE Etablissement (
    etablissement_code_ual VARCHAR PRIMARY KEY NOT NULL,
    etablissement_nom VARCHAR,
    etablissement_statut VARCHAR
);

CREATE TABLE Departement (
    departement_code VARCHAR PRIMARY KEY NOT NULL,
    departement_nom VARCHAR,
);

CREATE TABLE Region (
    region_nom VARCHAR PRIMARY KEY NOT NULL
);

CREATE TABLE Type_bac (
    type_bac VARCHAR PRIMARY KEY NOT NULL
);

CREATE TABLE Admissions_generalites (
    sedectivite VARCHAR,
    capacite INT,
    effectif_total_candidats INT,
    effectif_total_candidats INT
);

CREATE TABLE Session (

)

