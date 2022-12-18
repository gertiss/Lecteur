//
//  avecPrefixe.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 08/12/2022.
//

import Foundation

public extension Lecteur {
    
    /// Un lecteur qui lit un préfixe (ignoré dans le résultat) suivi d'une Valeur
    func avecPrefixe<T, Esp: UnEspacement>(_ lecteurDebut: Lecteur<T>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        lecteurDebut.suiviDe(self, espacement: espacement)
            .mapValeur { (marque, valeur) in
                return valeur
            }
    }
    
    func avecprefixe<Esp: UnEspacement>(_ marque: String, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        avecPrefixe(marque.lecteur, espacement: espacement)
    }
}
