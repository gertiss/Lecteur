//
//  listeAvecSeparateur.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 23/11/2022.
//

import Foundation

public extension Lecteur  {
    
    /// `Valeur (separateur Valeur)*`
    /// Le séparateur est un Token, donc éventuellement encadré par des espaces ou tabs (mais pas return)
    func listeNonVideAvecSeparateur<Esp: UnEspacement>(_ separateur: String, espacement: Esp = EspacesOuTabs()) -> Lecteur<[Valeur]> {
        listeNonVideAvecSeparateur(separateur.lecteur, espacement:  espacement)
    }
    
    /// Valeur (separateur Valeur)*
    func listeNonVideAvecSeparateur<T, Esp: UnEspacement>(_ separateur: Lecteur<T>, espacement: Esp = EspacesOuTabs()) -> Lecteur<[Valeur]> {
        self.suiviDe(separateur.suiviDe(self).liste(espacement: espacement), espacement: espacement)
            .mapValeur{ (premier, couplesSepVal) in
                // on ignore les séparateurs
                let suite = couplesSepVal.map { sepVal in sepVal.1 }
                return [premier] + suite
            }
    }
    
    
    /// listeAvecSeparateur | EspacesOuTabs
    func listeAvecSeparateur<Esp: UnEspacement>(_ separateur: String, espacement: Esp = EspacesOuTabs()) -> Lecteur<[Valeur]> {
        listeAvecSeparateur(separateur.lecteur)
    }
    
    func listeAvecSeparateur<T, Esp: UnEspacement>(_ separateur: Lecteur<T>, espacement: Esp = EspacesOuTabs()) -> Lecteur<[Valeur]> {
        Lecteur<[Valeur]> { source in
            if let luNonVide = self.listeNonVideAvecSeparateur(separateur, espacement: espacement).lire(source).lu {
                return .succes(luNonVide)
            } else {
                return .succes(Lu(valeur: [], reste: source))
            }
        }
    }
}
