//
//  avecMarqueFin.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 07/12/2022.
//

import Foundation

public extension Lecteur {
    
    /// Un lecteur qui lit une Valeur suivie d'une marque de fin (ignorée dans le résultat)
    func avecMarqueFin<T>(_ lecteurFin: Lecteur<T>) -> Self {
        self.suiviDe(lecteurFin)
            .mapValeur { (valeur, marque) in
                return valeur
            }
    }
    
    func avecMarqueFin(_ marque: String) -> Self {
        avecMarqueFin(Token(marque).lecteur)
    }

    
}
