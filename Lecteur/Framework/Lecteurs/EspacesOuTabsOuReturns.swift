//
//  EspacesOuTabsOuReturns.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/12/2022.
//

import Foundation
import RegexBuilder

/// Représente une suite éventuellement vide de espaces ou tabs ou returns.
public struct EspacesOuTabsOuReturns: UnEspacement {
    
    public init() {
        
    }
        
    public static let characterClass = CharacterClass.caractereEspaceOuTabOuReturn
    
    
    public var description: String {
        "EspacesOuTabsOuReturns()"
    }
    
}
