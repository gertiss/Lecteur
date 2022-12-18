//
//  espaceOuTab.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation
import RegexBuilder

public extension CharacterClass {
    
    static let caractereEspaceOuTab: CharacterClass =
        .anyOf(" \t")
    
    static let caractereEspaceOuTabOuReturn: CharacterClass =
        .anyOf(" \t\n")
    
}

// MARK: - Regex. Global

/// Réussit toujours. Peut être vide
let espacesOuTabs = Regex<Substring> {
    ZeroOrMore { CharacterClass.caractereEspaceOuTab }
}


/// Réussit toujours. Peut être vide
let espacesOuTabsOuReturns = Regex<Substring> {
    ZeroOrMore { CharacterClass.caractereEspaceOuTabOuReturn }
}


/// Un return obligatoire éventuellement suivi d'espaces ou tabs ou returns.
/// Peut servir pour indiquer la fin d'un texteEnLigne
let unOuPlusieursReturns = Regex<Substring> {
    CharacterClass.newlineSequence
    ZeroOrMore { CharacterClass.caractereEspaceOuTabOuReturn }
}

