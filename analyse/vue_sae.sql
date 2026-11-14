-- SAE 2.04 - Partie 3 : vue extraite de la base parcoursup2
-- Population : formations Parcoursup 2022 des Cotes-d'Armor  -> 105 formations
-- 5 variables numeriques 

SET search_path TO parcoursup2;

DROP VIEW IF EXISTS vue_sae;

CREATE VIEW vue_sae AS
SELECT
    g.capacite                            AS capacite,
    g.effectif_total_candidats            AS effectif_total_candidats,   -- Y (a expliquer)
    g.effectif_total_candidates           AS effectif_total_candidates,  -- X2
    bg.effectif_candidat_neo_bac_classes  AS nb_bac_general,             -- X3
    bt.effectif_candidat_neo_bac_classes  AS nb_bac_techno               -- X4
FROM _admissions_generalites g
    JOIN _formation f
        ON f.cod_aff_form = g.cod_aff_form
    -- candidats neo-bacheliers generaux classes
    JOIN _admissions_selon_type_neo_bac bg
        ON bg.cod_aff_form = g.cod_aff_form
       AND bg.session_annee = g.session_annee
       AND bg.type_bac = 'Bac général'
    
    -- candidats neo-bacheliers technologiques classes
    JOIN _admissions_selon_type_neo_bac bt
        ON bt.cod_aff_form = g.cod_aff_form
       AND bt.session_annee = g.session_annee
       AND bt.type_bac = 'Bac technologique'
WHERE f.departement_code = '22';

-- verification : doit afficher 105
SELECT count(*) FROM vue_sae;

-- Export de la vue vers le .csv (separateur virgule, avec en-tete).
-- Le fichier produit se lit directement avec :  pd.read_csv("ParcoursupCotesArmor.csv")
WbExport -type=text
         -file=./ParcoursupCotesArmor.csv
         -delimiter=','
         -header=true
         -encoding=UTF-8;
SELECT * FROM vue_sae;
