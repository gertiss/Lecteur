//
//  avecMarqueDebut.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 08/12/2022.
//

import Foundation

public extension Lecteur {
    
    /// Un lecteur qui lit une marque de début (ignorée dans le résultat) suivie d'une Valeur
    func avecMarqueDebut<T>(_ lecteurDebut: Lecteur<T>) -> Self {
        lecteurDebut.suiviDe(self)
            .mapValeur { (marque, valeur) in
                return valeur
            }
    }
    
    func avecMarqueDebut(_ marque: String) -> Self {
        avecMarqueDebut(Token(marque).lecteur)
    }
}
