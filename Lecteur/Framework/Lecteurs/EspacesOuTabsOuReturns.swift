//
//  EspacesOuTabsOuReturns.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/12/2022.
//

import Foundation
import RegexBuilder

/// Représente une suite éventuellement vide de `.espaceOuTab`
/// La lecture retourne la valeur `EspacesOuTabs()`
public struct EspacesOuTabsOuReturns: AvecLecteurRegex, UnEspacement {
    
    public init() {
        
    }
    
    public static func valeur(_ sortie: Substring) -> EspacesOuTabsOuReturns {
        EspacesOuTabsOuReturns()
    }
    
    /// Réussit toujours. Peut être vide
    public static let regex = espacesOuTabsOuReturns
    
    public var sourceRelisible: String {
        ""
    }
    
    public var description: String {
        "EspacesOuTabsOuReturns()"
    }
    
}
