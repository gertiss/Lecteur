//
//  entreParentheses.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 25/11/2022.
//

import Foundation

public extension Lecteur {
    
    /// `self.avecEncadrement(ouvrante, fermante).lire(source)`
    /// lit une ouvrante, puis self puis une fermante
    /// et compile en ignorant ouvrante et fermante
    func avecEncadrement<Esp: UnEspacement>(ouvrante: String, fermante: String, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        avecEncadrement(prefixe: Token(ouvrante).lecteur, suffixe: Token(fermante).lecteur, espacement: espacement)
    }
        
    func avecEncadrement<O, F, Esp: UnEspacement>(prefixe: Lecteur<O>, suffixe: Lecteur<F>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self  {
        prefixe
            .enIgnorantSuffixe(espacement)
            .mapErreur { erreur in
                Erreur(message: "On attend \(prefixe.attendu)", reste: erreur.reste)
            }
            .suiviDe2(self, suffixe.enIgnorantPrefixe(espacement))
            .mapValeur { (ouvrante, valeur, fermante) in
                valeur
            }
    }
    
}
