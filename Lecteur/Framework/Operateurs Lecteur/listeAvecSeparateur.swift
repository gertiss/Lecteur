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
    func listeNonVideAvecSeparateur(_ separateur: String) -> Lecteur<[Valeur]> {
        listeNonVideAvecSeparateur(Token(separateur).lecteur)
    }
    
    /// Valeur (separateur Valeur)*
    func listeNonVideAvecSeparateur<T>(_ separateur: Lecteur<T>) -> Lecteur<[Valeur]> {
        self.suiviDe(separateur.suiviDe(self).liste())
            .mapValeur{ (premier, couplesSepVal) in
                // on ignore les séparateurs
                let suite = couplesSepVal.map { sepVal in sepVal.1 }
                return [premier] + suite
            }
    }

    
    /// listeAvecSeparateur | Vide
    func listeAvecSeparateur(_ separateur: String) -> Lecteur<[Valeur]> {
        self.listeNonVideAvecSeparateur(Token(separateur).lecteur).ou(Vide.lecteur)
            .mapValeur { choixListeOuVide in
                switch choixListeOuVide {
                case .cas0(let liste):
                    return liste
                case .cas1(_): // vide
                    return []
                }
            }
    }
    
    func listeAvecSeparateur<T>(_ separateur: Lecteur<T>) -> Lecteur<[Valeur]> {
        self.listeNonVideAvecSeparateur(separateur).ou(Vide.lecteur)
            .mapValeur{ choixListeOuVide in
                switch choixListeOuVide {
                case .cas0(let liste):
                    return liste
                case .cas1(_): // vide
                    return []
                }

            }
    }

    
    
}
