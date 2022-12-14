//
//  espaceOuTab.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation
import RegexBuilder

public extension CharacterClass {
    static let espaceOuTab = CharacterClass.anyOf(" \t")
}
