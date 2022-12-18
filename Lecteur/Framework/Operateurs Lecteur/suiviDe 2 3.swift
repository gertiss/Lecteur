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
/// Paramètre optionnel : espacement optionnel entre les éléments, espacesOuTabs par défaut

public extension Lecteur  {
    
    func suiviDe<Valeur1, Esp: UnEspacement>(_ lecteur1: Lecteur<Valeur1>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Lecteur<(Valeur, Valeur1)> {
        typealias Valeur0 = Valeur
        return .init { source in
            self.lire(source)
                .puis { lu1 in
                    /// On lit un espacement, ce qui réussit toujours, et on le consomme.
                    /// On garde la valeur lue dans lu1,
                    /// donc l'espacement est invisible dans le résultat.
                    let reste = espacement.resteApresLecture(lu1.reste)
                    return .succes(Lu<Valeur>(valeur: lu1.valeur, reste: reste))
                }
                .puis { lu1 in
                    lecteur1.lire(lu1.reste)
                        .mapValeur { valeur1 in
                            // la valeur finale de succès
                            (lu1.valeur, valeur1)
                        }
                }
        }
    }
    
    func suiviDe2<Valeur1, Valeur2, Esp: UnEspacement>(_ lecteur1: Lecteur<Valeur1>, _ lecteur2: Lecteur<Valeur2>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Lecteur<(Valeur, Valeur1, Valeur2)> {
        typealias Valeur0 = Valeur
        
        return .init { source in
            self.suiviDe(lecteur1) // Lecteur<(Valeur0, Valeur1)>
                .lire(source) // Lecture<(Valeur0, Valeur1)>
            // Espacement après (valeur0, valeur1)
                .puis { lu01 in // Lu<(Valeur0, Valeur1)>
                    return .succes(Lu(valeur: lu01.valeur, reste: espacement.resteApresLecture(lu01.reste)))
                }
                .puis { lu01 in // valeur01: (Valeur0, Valeur1)
                    lecteur2.lire(lu01.reste)
                        .mapValeur { valeur2 in
                            // La valeur finale de succès
                            (lu01.valeur.0, lu01.valeur.1, valeur2)
                        }
                }
        }
    }
    
    func suiviDe3<Valeur1, Valeur2, Valeur3, Esp: UnEspacement>(_ lecteur1: Lecteur<Valeur1>, _ lecteur2: Lecteur<Valeur2>, _ lecteur3: Lecteur<Valeur3>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Lecteur<(Valeur, Valeur1, Valeur2, Valeur3)> {
        typealias Valeur0 = Valeur
        
        return .init { source in
            self.suiviDe(lecteur1) // Lecteur<(Valeur0, Valeur1)>
            // On lit (valeur0, valeur1)
                .lire(source) // Lecture<(Valeur0, Valeur1)>
            // espacement après (valeur0, valeur1)
                .puis { lu01 in // Lu<(Valeur0, Valeur1)>
                    return .succes(Lu(valeur: lu01.valeur, reste: espacement.resteApresLecture(lu01.reste)))
                }
            // Lecture de valeur2
                .puis { lu01 in // Lu<(Valeur0, Valeur1)>
                    lecteur2.lire(lu01.reste)
                        .mapValeur { valeur2 in
                            (lu01.valeur.0, lu01.valeur.1, valeur2)
                        }
                }
            // Espacement après (valeur0, valeur1, valeur2)
                .puis { lu012 in // Lu<(Valeur0, Valeur1, Valeur2>)
                    return Lecture<(Valeur0, Valeur1, Valeur2)>.succes(Lu(valeur: lu012.valeur, reste: espacement.resteApresLecture(lu012.reste)))
                }
            // Lecture de valeur3
                .puis { lu012 in // (Valeur0, Valeur1, Valeur2)
                    lecteur3.lire(lu012.reste)
                        .mapValeur { valeur3 in
                            (lu012.valeur.0, lu012.valeur.1, lu012.valeur.2, valeur3)
                        }
                }
        }
    }
    
}

