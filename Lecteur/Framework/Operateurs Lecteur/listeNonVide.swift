//
//  listeNonVide.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 19/11/2022.
//

import Foundation

/// L'opérateur de répétition `+`

public extension Lecteur where Valeur: AvecLecteur {
    
    func listeNonVide<Esp: UnEspacement>(espacement: Esp = EspacesOuTabs()) -> Lecteur<[Valeur]> {
        .init { source in
            // On essaye de lire une première valeur.
            let lecturePremiereValeur = self.lire(source)
            guard let premiereValeur =  lecturePremiereValeur.valeur else {
                // On n'a rien lu. Echec
                return .echec(lecturePremiereValeur.erreur!)
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
            return .succes(Lu(valeur: [premiereValeur] + resteDesValeurs, reste: lectureReste.reste)
            )
        }
    }

}
