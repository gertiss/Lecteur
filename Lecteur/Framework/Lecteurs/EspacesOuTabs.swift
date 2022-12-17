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
public struct EspacesOuTabs: AvecLecteurRegex {
    
    public init() {
        
    }
    
    public static func valeur(_ sortie: (Substring, String)) -> EspacesOuTabs {
        EspacesOuTabs()
    }
    
    public static func == (lhs: EspacesOuTabs, rhs: EspacesOuTabs) -> Bool {
        true
    }
    
    public typealias SortieRegex = (Substring, String) // Attention : équivalent à Substring
    
    public static let regex = Regex<(Substring, String)> {
        Capture {
            ZeroOrMore { CharacterClass.caractereEspaceOuTab }
        } transform: {
            String($0)
        }
    }
    
    public var sourceRelisible: String {
        ""
    }
    
    public var description: String {
        "EspacesOuTabs()"
    }
    
    
}
