//
//  listeNew.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 24/11/2022.
//

import Foundation

/// L'opérateur de répétition `*` : `a*`
/// `a.liste()`
public extension Lecteur {
    
    func liste<Esp: UnEspacement>(espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Lecteur<[Valeur]> {
        .init { source in
            
            // On essaye de lire une première valeur.
            let lecturePremiereValeur = self.lire(source)
            guard let premiereValeur =  lecturePremiereValeur.valeur else {
                // On n'a rien lu. Succès avec liste vide
                return .succes(Lu(valeur: [], reste: source))
            }
            // On a lu un premier element : premiereValeur.
            // On essaye de lire récursivement le reste des valeurs
            // après un espacement
            let resteApresEspacement = espacement.resteApresLecture(lecturePremiereValeur.reste)
            let lectureReste = self.liste(espacement: espacement).lire(resteApresEspacement)
            guard let resteDesValeurs = lectureReste.valeur else {
                fatalError("La lecture d'une liste devrait toujours réussir")
            }
            // Succès final
            // Effet de bord : l'espacement après la liste est consommé
            return .succes(Lu(valeur: [premiereValeur] + resteDesValeurs, reste: lectureReste.reste)
            )
        }
    }
    
}
