//
//  Couple.swift
//  Mots
//
//  Created by Gérard Tisseau on 16/11/2022.
//

import Foundation

/// Les opérateurs de séquences :
/// `a b, a b c, a b c d`
/// `a.suiviDe(b), a.suiviDe2(b, c), a.suiviDe3(b, c, d)`

public extension Lecteur  {
    
    func suiviDe<Valeur1>(_ lecteur1: Lecteur<Valeur1>) -> Lecteur<(Valeur, Valeur1)> {
        typealias Valeur0 = Valeur
        return .init { source in
            self.lire(source)
                .puis { lu1 in
                    lecteur1.lire(lu1.reste)
                        .mapValeur { valeur1 in
                            // la valeur finale de succès
                            (lu1.valeur, valeur1)
                        }
                }
        }
    }

    func suiviDe2<Valeur1, Valeur2>(_ lecteur1: Lecteur<Valeur1>, _ lecteur2: Lecteur<Valeur2>) -> Lecteur<(Valeur, Valeur1, Valeur2)> {
        typealias Valeur0 = Valeur

        return .init { source in
            self.suiviDe(lecteur1)
                .lire(source)
                .puis { valeur01 in // valeur01: (Valeur0, Valeur1)
                    lecteur2.lire(valeur01.reste)
                        .mapValeur { valeur2 in
                            // La valeur finale de succès
                            (valeur01.valeur.0, valeur01.valeur.1, valeur2)
                        }
                }
        }
    }

    func suiviDe3<Valeur1, Valeur2, Valeur3>(_ lecteur1: Lecteur<Valeur1>, _ lecteur2: Lecteur<Valeur2>, _ lecteur3: Lecteur<Valeur3>) -> Lecteur<(Valeur, Valeur1, Valeur2, Valeur3)> {
        typealias Valeur0 = Valeur
        
        return .init { source in
            self.suiviDe(lecteur1).lire(source)
                .puis { valeur01 in // valeur01: (Valeur0, Valeur1)
                    lecteur2.lire(valeur01.reste)
                        .mapValeur { valeur2 in
                            // La valeur finale de succès
                            (valeur01.valeur.0, valeur01.valeur.1, valeur2)
                        }
                }
                .puis { valeur012 in // valeur012: (Valeur0, Valeur1, Valeur2)
                    lecteur3.lire(valeur012.reste)
                        .mapValeur { valeur3 in
                            (valeur012.valeur.0, valeur012.valeur.1, valeur012.valeur.2, valeur3)
                        }
                }
        }
    }
    
}

