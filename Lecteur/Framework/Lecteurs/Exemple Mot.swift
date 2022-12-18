//
//  Exemple.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/12/2022.
//

import Foundation

//
//  Exemple.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation
import RegexBuilder

/// Lit une suite non vide de caractères `.word` optionnellement encadrée par `.espaceOuTab`
/// Consomme les `.espaceOuTab` avant et après
/// "  abc  suite " est accepté, la valeur est "abc" et le reste est "suite ".
/// "abcsuite" est accepté avec valeur "abcsuite", reste vide
/// " " est refusé
/// " , suite" est refusé
struct Mot: AvecLecteurRegex {
    
    let texte: String
    
    init(_ texte:String) {
        self.texte = texte
    }
    
    typealias SortieRegex = (Substring, String)
    static let regex = Regex<(Substring, String)> {
        Capture {
            OneOrMore { .word }
        } transform: {
            String($0)
        }
    }
    
    static func valeur(_ sortie: (Substring, String)) -> Mot {
        Mot(sortie.1)
    }
    
    var sourceRelisible: String {
        texte
    }
    
    var description: String {
        "Mot(\(texte.debugDescription))"
    }
}
