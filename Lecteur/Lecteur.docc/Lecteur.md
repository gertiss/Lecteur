# Framework Lecteur

## Exemple

Soit le type `Personne(nom, age)`

Si ce type est programmé d'une certaine manière, on peut écrire :

		switch Personne.lireInstance("Toto 10") {
			case .succes(let lu):
				print(lu.valeur) // la valeur lue : Personne("Toto", 10)
			case .echec(let erreur):
				print(erreur.message) // "On attend une Personne"
		}
			
On décrit ici les outils permettant de programmer un type pour cela.

## Types avec langage

Un type programmé d'une certaine manière peut définir un langage permettant de représenter ses instances, et être capable de lire un texte dans ce langage pour créer une instance.

Pour lire, il fournit une static func `lireInstance(source)` qui retourne un compte rendu de lecture de type `Lecture<Self>` qui peut indiquer un succès ou un échec. 

Si succès, on obtient une instance de `Lu<Self>(valeur, reste)`, où valeur est l'instance de Self créée par lecture de la source et reste le reste de la source après la lecture de l'instance. 

Si échec, on obtient une instance de `Erreur(message, reste)`, où message explique l'erreur et où reste indique ce qui n'a pas pu être lu dans la source.

On peut considérer que la fonction `lireInstance` est la définition algorithmique d'un langage.

## Lecteur

Un moyen possible pour définir cette fonction `lireInstance` est de définir une static func `lecteur` de type `Lecteur<Self>` et d'utiliser `Self.lecteur.lire(source)`

Le type générique `Lecteur<Valeur>` possède une static func `lire(source)` capable de lire une source pour en extraire une instance de `Valeur`. Cette fonction retourne un compte rendu de lecture sous la forme d'une instance de `Lecture<Valeur>`

Pour déclarer qu'un type possède un lecteur de type `Lecteur<Self>` capable de lire ses instances, on le déclare conforme au protocole `AvecLecteur`, ce qui impose différentes contraintes.

## PEG (Parsing Expression Grammar)

Le type `Lecteur` fournit de utilitaires de lecture conformes à la définition théorique d'une PEG (Parsing Expression Grammar). Il s'agit en gros d'une grammaire de type BNF dans laquelle l'opérateur de choix | est ordonné, déterministe, non commutatif. Il fournit la première solution la plus longue qu'il trouve dans l'ordre des clauses.

An atomic parsing expression consists of:

    - any terminal symbol,
    - any nonterminal symbol
    - the empty string ε.

Given any existing parsing expressions e, e1, and e2, a new parsing expression can be constructed using the following operators:

    - Sequence: e1 e2
    - Ordered choice: e1 / e2
    - Zero-or-more: e*
    - One-or-more: e+
    - Optional: e?
    - And-predicate: &e
    - Not-predicate: !e


Ici "symbole" veut dire : une instance du type Lecteur.

## AvecLecteur

Pour créer des instances de `Lecteur`, on dispose de types vérifiant le protocole `AvecLecteur` ou `AvecLecteurRegex`. Lorsqu'un type `T` est conforme à un de ces protocoles, il a un lecteur associé en variable static : `T.lecteur`, de type `Lecteur<T>`. La lecture d'une source par ce lecteur s'écrit `T.lecteur.lire(source)` et donne une instance de `Lecture<T>`, qui est une enum `.succes(Lu<T>`) ou `.echec(Erreur)`. En cas de succès `.succes(lu)`, la valeur associée est `lu.valeur` et elle est de type `T`.

Un "symbole terminal" est un lecteur obtenu par la méthode d'instance de String  `lecteur`. `string.lecteur` donne un lecteur qui reconnaît uniquement cette string. La valeur retournée est la string elle-même.

Un "symbole non terminal" est un lecteur obtenu par la méthode static lecteur d'un type conforme à `AvecLecteur` ou `AvecLecteurRegex`

Le "symbole vide" est le lecteur qui réussit toujours sans rien consommer et qui fournit comme valeur la String vide.

Les opérateurs de base sont : 

    - e1.suiviDe(e2) . Valeur lue : (E1, E2)
    - e1.ou(e2) Valeur lue: enum cas0(E1) cas1(E2)
    - e.liste() . Valeur lue : [E] éventuellement vide
    - e.listeNonVide() . Valeur lue : [E] non vide
    - e.optionnel() . Valeur lue : E?
    - e.present() . Valeur lue ""
    - e.absent() . Valeur lue ""


Il y a d'autres opérateurs, dérivés des précédents :

	- e.listeAvecSeparateur(string) . Valeur lue [E], séparateurs ignorés
	- e.avecEncadrement(encadrement) . Valeur lue E, encadrement ignoré
	- e.ou2(e1, e2)
	- e.ou3(e1, e2, e3)
	- e.suiviDe2(e1, e2)
	- e.suiviDe3(e1, e2, e3)
	
	
Et d'autres encore : listeAvecSeparateur, suiviDeAvecSeparateur, avecPrefixe, avecSuffixe, enIgnorantPrefixe, enIgnorantSuffixe, enIgnorantEncadrement.

Une méthode adaptée pour créer un lecteur est de partir de lecteurs déjà définis et de les enchaîner par un pipe-line d'opérateurs.

## Détails lexicaux

Chaque opérateur introduit un paramètre `espacement`, qui décrit ce qu'on peut écrire entre ses éléments (par exemple entre les éléments d'une séquence ou d'une liste). Un espacement est toujours optionnel et réussit toujours (il peut lire une String vide). Il s'agit en général d'espaces ou tabs ou returns.

A distinguer du concept de "séparateur" ou d'"encadrement", qui sont obligatoires. Comme dans `listeAvecSeparateur`.
