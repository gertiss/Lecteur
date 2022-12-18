//
//  LecteurString.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 13/12/2022.
//

import Foundation
import RegexBuilder


/// Un Token a une variable stockée sourceRelisible.
/// On initialise un Token par Token("abc").
/// Cette instance possède une variable lecteur, capable de lire sourceRelisible
/// optionnellement encadrée par des espaces ou tabs.
/// Donc `Token("abc").lire("  abc  ")` réussit, et la valeur capturée est `"abc"`.Toute la chaîne `"  abc  "` est consommée.
/// `Token("abc").lire("xyz")` échoue et le message est : on attend "abc"
public struct Token: AvecLecteurInstance {
    
    public var sourceRelisible: String
    
    public init(_ sourceRelisible: String) {
        self.sourceRelisible = sourceRelisible
    }

    public var description: String {
        "Token(\"\(sourceRelisible)\")"
    }
    
    /// On accepte sourceRelisible et uniquement elle
    public var regex: Regex<Substring> {
        Regex {
            sourceRelisible
        }
    }
    
    public var lecteur: Lecteur<Self> {
        Lecteur<Self>(attendu: sourceRelisible) { source in
            guard let match = source.prefixMatch(of: regex)?.output else {
                return .echec(Erreur(message: "On attend \"\(sourceRelisible)\"", reste: source))
            }
            return .succes(Lu(valeur: self, reste: source.sansPrefixe(String(match))))
        }
    }

    
}
