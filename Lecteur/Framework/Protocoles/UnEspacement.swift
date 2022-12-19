//
//  UnEspacement.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/12/2022.
//

import Foundation
import RegexBuilder

/// UnEspacement possède un lecteur qui lit des espaces, tabs, et éventuellement des returns.  Cette lecture réussit toujours, même si la source ne contient aucun espace, tab , return.
/// Cela traduit la notion de "neutre"
/// Exemples : `EspacesOuTabs, EspacesOuTabsOuReturns`
public protocol UnEspacement {
    static var regex:  Regex<Substring> { get }
    static var characterClass: CharacterClass { get }
    var sourceRelisible: String { get }
    func resteApresLecture(_ source: String) -> String
}

public extension UnEspacement {
    static var lecteur: Lecteur<String> {
        Lecteur<String> {source in
            // la lecture réussit toujours
            let sortie = source.prefixMatch(of: regex)!.output
            let reste = source.sansPrefixe(String(sortie))
            return Lecture<String>.succes(Lu(valeur: "", reste: reste))
        }
    }
    
    var lecteur: Lecteur<String> {
        Self.lecteur
    }
    
    /// Réussit toujours. La capture peut être vide.
    static var regex: Regex<Substring> {
            Regex<Substring> {
                ZeroOrMore { characterClass }
        }
    }
    
    var sourceRelisible: String {
        ""
    }
    
    func resteApresLecture(_ source: String) -> String {
        let lecture = Self.lecteur.lire(source)
        assert(lecture.estSucces) // Un espacement doit toujours réussir
        return lecture.lu!.reste
    }
}

