//
//  present.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 19/11/2022.
//

import Foundation

public extension Lecteur {
    
    /// Exige que la source commence par un préfixe conforme à self.
    /// Mais ne consomme rien et rend Vide si succès.
    /// C'est un opérateur de pré-lecture (lookahead)
    func present() -> Lecteur<Vide> {
        
        Lecteur<Vide> { source in
            let lecture = self.lire(source)
            guard lecture.estSucces else {
                return .echec(Erreur(message: "On attend \(self.attendu)", reste: source))
            }
            return .succes(Lu<Vide>(valeur: Vide(), reste: source))
        }
    }
}
