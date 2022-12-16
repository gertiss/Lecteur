# ``Lecteur``

Des utilitaires de lecture conformes à la définition théorique d'une PEG (Parsing Expression Grammar)

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

Pour créer des instances de `Lecteur`, on dispose de types vérifiant le protocole `AvecLecteur` ou `AvecLecteurRegex`. Lorsqu'un type `T` est conforme à un de ces protocoles, il a un lecteur associé en variable static : `T.lecteur`, de type `Lecteur<T>`. La lecture d'une source par ce lecteur s'écrit `T.lecteur.lire(source)` et donne une instance de `Lecture<T>`, qui est une enum `.succes(Lu<T>`) ou `.echec(Erreur`). En cas de succès `.succes(lu)`, la valeur associée est `lu.valeur` et elle est de type `T`.

Un "symbole terminal" est un lecteur obtenu par la méthode d'instance de String  `lecteur`. `string.lecteur` donne un lecteur qui reconnaît uniquement cette string, en ignorant les espaces ou tab qui sont avant et après. La valeur retournée est la string elle-même.

Un "symbole non terminal" est un lecteur obtenu par la méthode lecteur d'un type conforme à `AvecLecteur` ou `AvecLecteurRegex`

Le "symbole vide" est le lecteur obtenu par méthode `lecteur` du type `EspacesOuTabs`. Il reconnaît toute suite d'espaces ou tabs et fournit comme valeur `EspacesOuTabs()`.

Les opérateurs de base sont : 

    - Sequence: e1 e2  -> e1.suiviDe(e2) . Valeur lue : (E1, E2)
    - Ordered choice: e1 / e2   -> e1.ou(e2) Valeur lue: enum cas0(E1) cas1(E2)
    - Zero-or-more: e* -> e.liste() . Valeur lue : [E]
    - One-or-more: e+ -> e.listeNonVide() . Valeur lue : [E]
    - Optional: e? -> e.optionnel() . Valeur lue : E?
    - And-predicate: &e -> e.present() . Valeur lue EspacesOuTabs
    - Not-predicate: !e -> e.absent() . Valeur lue EspacesOuTabs


Il y a d'autres opérateurs, dérivés des précédents :

	- e.listeAvecSeparateur(string) . Valeur lue [E], séparateurs ignorés
	- e.avecEncadrement(encadrement) . Valeur lue E, encadrement ignoré
	- e.ou2(e1, e2)
	- e.ou3(e1, e2, e3)
	- e.suiviDe2(e1, e2)
	- e.suiviDe3(e1, e2, e3)
