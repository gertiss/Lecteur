//
//  EspacesOuTabs.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation
import RegexBuilder

/// Représente une suite éventuellement vide de `.espaceOuTab`
/// La lecture retourne la valeur `EspacesOuTabs()`
public struct EspacesOuTabs: AvecLecteurRegex, UnEspacement {
    
    public init() {
        
    }
    
    public static func valeur(_ sortie: Substring) -> EspacesOuTabs {
        EspacesOuTabs()
    }
    
    public static func == (lhs: EspacesOuTabs, rhs: EspacesOuTabs) -> Bool {
        true
    }
        
    /// Réussit toujours. Peut être vide
    public static let regex = espacesOuTabs
    
    public var sourceRelisible: String {
        ""
    }
    
    public var description: String {
        "EspacesOuTabs()"
    }
    
}
