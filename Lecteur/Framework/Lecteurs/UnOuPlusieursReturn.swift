//
//  UnOuPlusieursReturn.swift
//  Karaoke_FW
//
//  Created by Gérard Tisseau on 03/12/2022.
//

import Foundation
import RegexBuilder



public struct UnOuPlusieursReturn: AvecLecteurRegex {
    
    public typealias SortieRegex = Substring
    public static let regex = Regex<Substring> {
        CharacterClass.newlineSequence
        ZeroOrMore { CharacterClass.caractereEspaceOuTabOuReturn }
    }

    
    public static func valeur(_ sortie: Substring) -> UnOuPlusieursReturn {
        Self()
    }

    public var sourceRelisible: String {
        "\n"
    }
    
    public var description: String {
        "UnOuPlusieursReturn()"
    }
}

