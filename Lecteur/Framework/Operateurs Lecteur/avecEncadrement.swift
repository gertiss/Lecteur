//
//  entreParentheses.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 25/11/2022.
//

import Foundation

public extension Lecteur {
    
    func avecEncadrement(ouvrante: String, fermante: String) -> Self {
        avecEncadrement(ouvrante: Token(ouvrante).lecteur, fermante: Token(fermante).lecteur)
    }
        
    func avecEncadrement<O, F>(ouvrante: Lecteur<O>, fermante: Lecteur<F>) -> Self  {
        ouvrante.mapErreur { erreur in
            Erreur(message: "On attend \(ouvrante.attendu)", reste: erreur.reste)
        }
        .suiviDe2(self, fermante)
            .mapValeur { (ouvrante, valeur, fermante) in
                valeur
            }
    }
    
}
