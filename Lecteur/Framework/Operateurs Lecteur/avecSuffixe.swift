//
//  avecSuffixe.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 07/12/2022.
//

import Foundation

public extension Lecteur {
    
    /// Un lecteur qui lit une Valeur suivie d'un suffixe (ignoré dans le résultat)
    func avecSuffixe<T, Esp: UnEspacement>(_ lecteurFin: Lecteur<T>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        self.suiviDe(lecteurFin, espacement: espacement)
            .mapValeur { (valeur, marque) in
                return valeur
            }
    }
    
    func avecSuffixe<Esp: UnEspacement>(_ marque: String, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        avecSuffixe(marque.lecteur, espacement: espacement)
    }

    
}
