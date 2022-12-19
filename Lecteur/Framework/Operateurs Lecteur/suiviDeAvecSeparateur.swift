//
//  coupleAvecSeparateur.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 08/12/2022.
//

import Foundation

public extension Lecteur  {
    
    func suiviDeAvecSeparateur<Separateur, Valeur1, Esp: UnEspacement>(lecteur1: Lecteur<Valeur1>, separateur: Lecteur<Separateur>, espacement: Esp = EspacesOuTabs()) -> Lecteur<(Valeur, Valeur1)> {
                
        self.suiviDe2(separateur, lecteur1, espacement: espacement)
            .mapValeur { (valeur, sep, valeur1) in
                // On ignore le séparateur
                (valeur, valeur1)
            }
    }
}
