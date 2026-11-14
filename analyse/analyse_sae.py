# SAE 2.04 - Partie 3 : analyse statistique
# Population : formations Parcoursup 2022 des Cotes-d'Armor (dep 22)
# Y  : total des candidats
# X : capacite, candidates, bac general, bac techno

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import numpy.linalg as la


# Fonctions de statistiques
def moyenne(tableau):
    somme = 0
    for valeur in tableau:
        somme = somme + valeur
    return somme / len(tableau)


def variance(tableau):
    moy = moyenne(tableau)
    somme = 0
    for valeur in tableau:
        somme = somme + (valeur - moy) ** 2
    return somme / len(tableau)


def covariance(tableau1, tableau2):
    moy1 = moyenne(tableau1)
    moy2 = moyenne(tableau2)
    somme = 0
    for i in range(len(tableau1)):
        somme = somme + (tableau1[i] - moy1) * (tableau2[i] - moy2)
    return somme / len(tableau1)


# A. Les donnees
pd.set_option("display.max_columns", None)   # afficher toutes les colonnes
pd.set_option("display.width", 200)

donnees_df = pd.read_csv("ParcoursupCotesArmor.csv")
print("---- A. LES DONNEES ----")
print(donnees_df.head())    # affiche l'en tete du csv  

donnees_ar = donnees_df.to_numpy() # ar = array
nb_formations = donnees_ar.shape[0]
print("Nombre de formations :", nb_formations)

capacite_ar        = donnees_ar[:, 0]   # capacite d'accueil
total_candidats_ar = donnees_ar[:, 1]   # Y : nombre total de candidats
candidates_ar      = donnees_ar[:, 2]   # nombre de candidates (filles)
bac_general_ar     = donnees_ar[:, 3]   # candidats venant d'un bac general
bac_techno_ar      = donnees_ar[:, 4]   # candidats venant d'un bac techno

# moyenne et variance de chaque variable (avec nos fonctions)
print()
print("Statistiques par variable :")
print("capacite        -> moyenne :", round(moyenne(capacite_ar), 1),        "| variance :", round(variance(capacite_ar), 1))
print("total candidats -> moyenne :", round(moyenne(total_candidats_ar), 1), "| variance :", round(variance(total_candidats_ar), 1))
print("candidates      -> moyenne :", round(moyenne(candidates_ar), 1),      "| variance :", round(variance(candidates_ar), 1))
print("bac general     -> moyenne :", round(moyenne(bac_general_ar), 1),     "| variance :", round(variance(bac_general_ar), 1))
print("bac techno      -> moyenne :", round(moyenne(bac_techno_ar), 1),      "| variance :", round(variance(bac_techno_ar), 1))


# B. Representations graphiques
print()
print("---- B. GRAPHIQUES ----")

# boites a moustaches : total des candidats / candidates
plt.boxplot([total_candidats_ar, candidates_ar])
plt.xticks([1, 2], ["candidats", "candidates"])
plt.title("Candidats et candidates")
plt.show()

# boites a moustaches : bac general / bac techno
plt.boxplot([bac_general_ar, bac_techno_ar])
plt.xticks([1, 2], ["bac general", "bac techno"])
plt.title("Candidats bac general et bac techno")
plt.show()

# nuage de points : total des candidats en fonction des candidates
plt.scatter(candidates_ar, total_candidats_ar)
plt.xlabel("candidates")
plt.ylabel("total candidats")
plt.title("Total candidats / candidates")
plt.show()

# nuage de points : total des candidats en fonction de la capacite
plt.scatter(capacite_ar, total_candidats_ar)
plt.xlabel("capacite")
plt.ylabel("total candidats")
plt.title("Total candidats / capacite")
plt.show()


# C. Regression lineaire multiple
# matrice X : 1ere colonne de 1 (pour la constante) + les 4 variables explicatives
matriceX_ar = np.ones((nb_formations, 5))
matriceX_ar[:, 1] = capacite_ar
matriceX_ar[:, 2] = candidates_ar
matriceX_ar[:, 3] = bac_general_ar
matriceX_ar[:, 4] = bac_techno_ar

matriceY_ar = total_candidats_ar   # la variable a expliquer

# formule du Cours 3 : parametres = (tX X)^-1  tX  Y, calculee avec des boucles
# produit tX * X  ->  matrice 5x5
txx_ar = np.zeros((5, 5))
for a in range(5):
    for b in range(5):
        somme = 0
        for i in range(nb_formations):
            somme = somme + matriceX_ar[i, a] * matriceX_ar[i, b]
        txx_ar[a, b] = somme

# produit tX * Y  ->  5 valeurs
txy_ar = np.zeros(5)
for a in range(5):
    somme = 0
    for i in range(nb_formations):
        somme = somme + matriceX_ar[i, a] * matriceY_ar[i]
    txy_ar[a] = somme

# inverse de (tX X)  (compliqué a faire avec une simple boucle)
inverse_ar = la.inv(txx_ar)

# matrice parametres (A) = inverse * txy  ->  5 valeurs
parametres_ar = np.zeros(5)
for a in range(5):
    somme = 0
    for b in range(5):
        somme = somme + inverse_ar[a, b] * txy_ar[b]
    parametres_ar[a] = somme

print()
print("---- C. REGRESSION : parametres ----")
print("constante   :", round(parametres_ar[0], 2))
print("capacite    :", round(parametres_ar[1], 3))
print("candidates  :", round(parametres_ar[2], 3))
print("bac general :", round(parametres_ar[3], 3))
print("bac techno  :", round(parametres_ar[4], 3))


# D. Coefficient de correlation multiple
# candidats estimes par le modele, calcules formation par formation
candidats_estimes_ar = np.zeros(nb_formations)
for i in range(nb_formations):
    candidats_estimes_ar[i] = (
        parametres_ar[0] + parametres_ar[1] * capacite_ar[i]
                         + parametres_ar[2] * candidates_ar[i]
                         + parametres_ar[3] * bac_general_ar[i]
                         + parametres_ar[4] * bac_techno_ar[i]
    )

# R = correlation entre les vrais candidats et les candidats estimes
R = covariance(matriceY_ar, candidats_estimes_ar) / (variance(matriceY_ar) * variance(candidats_estimes_ar)) ** 0.5
R2 = R ** 2
print()
print("---- D. CORRELATION MULTIPLE ----")
print("R  =", round(R, 3))
print("R2 =", round(R2, 3), " soit", round(R2 * 100, 1), "%")