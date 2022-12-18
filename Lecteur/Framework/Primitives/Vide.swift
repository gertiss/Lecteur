//
//  Vide.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 18/12/2022.
//

import Foundation


/// Un lecteur qui réussit toujours et qui ne consomme rien.
/// Retourne la valeur compilée Vide()
struct Vide {
    
    static let lecteur = Lecteur<Vide> { source in
            .succes(Lu(valeur: Vide(), reste: source))
    }
    
    var sourceRelisible: String {
        ""
    }
    
    var description: String {
        "Vide()"
    }
    
}
