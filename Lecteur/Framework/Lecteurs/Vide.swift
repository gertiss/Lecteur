//
//  Vide.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation
import RegexBuilder

/// Est considéré comme vide dans une source une suite éventuellement vide de `.espaceOuTab`
/// La lecture retourne la valeur `Vide()`
public struct Vide: AvecLecteurRegex {
    
    public init() {
        
    }
    
    public static func valeur(_ sortie: (Substring, String)) -> Vide {
        Vide()
    }
    
    public static func == (lhs: Vide, rhs: Vide) -> Bool {
        true
    }
    
    public typealias SortieRegex = (Substring, String) // Attention : équivalent à Substring
    
    public static let regex = Regex<(Substring, String)> {
        Capture {
            ZeroOrMore { CharacterClass.espaceOuTab }
        } transform: {
            String($0)
        }
    }
    
    public var sourceRelisible: String {
        ""
    }
    
    public var description: String {
        "Vide()"
    }
    
    
}
