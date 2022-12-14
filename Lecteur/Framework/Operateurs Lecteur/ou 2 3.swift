//
//  ou.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 19/11/2022.
//

import Foundation


/// Les opérateurs d'alternative : `a | b`, `a | b | c`,  `a | b | c | d`
/// `a.ou(b), a.ou2(b, c), a.ou3(b, c, d)`

public extension Lecteur {
    
    
    func ou<Valeur1>(_ lecteur1: Lecteur<Valeur1>) -> Lecteur<Choix<Valeur, Valeur1>> {
        return Lecteur<Choix<Valeur, Valeur1>> { source in
            // On essaye self
            let lecture0 = self.lire(source)
            if let valeur0 = lecture0.valeur {
                return .succes(Lu(valeur: .cas0(valeur0), reste: lecture0.reste))
            }
            // Echec de self. On essaye lecteur1
            let lecture1 = lecteur1.lire(source)
            if let valeur1 = lecture1.valeur {
                return .succes(Lu(valeur: .cas1(valeur1), reste: lecture1.reste))
            }
            // Echec des deux lecteurs
            return .echec(Erreur(message: "On attend \(self.attendu) ou \(lecteur1.attendu)", reste: source))
        }
    }
    
    func ou2<Valeur1, Valeur2>(_ lecteur1: Lecteur<Valeur1>, _ lecteur2: Lecteur<Valeur2>) -> Lecteur<Choix2<Valeur, Valeur1, Valeur2>> {
        return Lecteur<Choix2<Valeur, Valeur1, Valeur2>> { source in
            // On essaye self
            let lecture0 = self.lire(source)
            if let valeur0 = lecture0.valeur {
                return .succes(Lu(valeur: .cas0(valeur0), reste: lecture0.reste))
            }
            // Echec de self. On essaye lecteur1
            let lecture1 = lecteur1.lire(source)
            if let valeur1 = lecture1.valeur {
                return .succes(Lu(valeur: .cas1(valeur1), reste: lecture1.reste))
            }
            // Echec de lecteur1. On essaye lecteur2
            let lecture2 = lecteur2.lire(source)
            if let valeur2 = lecture2.valeur {
                return .succes(Lu(valeur: .cas2(valeur2), reste: lecture2.reste))
            }
            // Echec des trois lecteurs
            return .echec(Erreur(message: "On attend \(self.attendu) ou \(lecteur1.attendu) ou \(lecteur2.attendu)", reste: source))
        }
    }

    func ou3<Valeur1, Valeur2, Valeur3>(_ lecteur1: Lecteur<Valeur1>, _ lecteur2: Lecteur<Valeur2>, lecteur3: Lecteur<Valeur3>) -> Lecteur<Choix3<Valeur, Valeur1, Valeur2, Valeur3>> {
        return Lecteur<Choix3<Valeur, Valeur1, Valeur2, Valeur3>> { source in
            // On essaye self
            let lecture0 = self.lire(source)
            if let valeur0 = lecture0.valeur {
                return .succes(Lu(valeur: .cas0(valeur0), reste: lecture0.reste))
            }
            // Echec de self. On essaye lecteur1
            let lecture1 = lecteur1.lire(source)
            if let valeur1 = lecture1.valeur {
                return .succes(Lu(valeur: .cas1(valeur1), reste: lecture1.reste))
            }
           // Echec de lecteur1. On essaye lecteur2
            let lecture2 = lecteur2.lire(source)
            if let valeur2 = lecture2.valeur {
                return .succes(Lu(valeur: .cas2(valeur2), reste: lecture2.reste))
            }
            // Echec de lecteur2. On essaye lecteur3
            let lecture3 = lecteur3.lire(source)
            if let valeur3 = lecture3.valeur {
                return .succes(Lu(valeur: .cas3(valeur3), reste: lecture3.reste))
            }
            // Echec des quatre lecteurs
            return .echec(Erreur(message: "On attend \(self.attendu) ou \(lecteur1.attendu) ou \(lecteur2.attendu) ou \(lecteur3.attendu)", reste: source))
        }
    }


}

