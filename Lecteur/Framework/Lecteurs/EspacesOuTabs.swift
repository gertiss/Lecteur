//
//  EspacesOuTabs.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation
import RegexBuilder

/// Représente une suite éventuellement vide de `.espaceOuTab`
public struct EspacesOuTabs: UnEspacement {
    public static let characterClass =  CharacterClass.caractereEspaceOuTab
    
    public init() {
        
    }
        
    public var description: String {
        "EspacesOuTabs()"
    }
    
}
