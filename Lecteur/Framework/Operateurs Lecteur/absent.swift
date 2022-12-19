//
//  absent.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 19/11/2022.
//

import Foundation

public extension Lecteur {
    
    /// Exige que la source ne commence pas par un préfixe conforme à self.
    /// Mais ne consomme rien et rend "" si succès.
    /// C'est un opérateur de pré-lecture (lookahead)
    func absent() -> Lecteur<String> {
        
        Lecteur<String> { source in
            let lecture = self.lire(source)
            guard lecture.estEchec else {
                return .echec(Erreur(message: "On n'attend pas \(self.attendu)", reste: source))
            }
            return .succes(Lu<String>(valeur: "", reste: source))
        }
    }
}
