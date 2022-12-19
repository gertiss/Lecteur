//
//  Erreur.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 18/11/2022.
//

import Foundation

/// Erreur d'analyse syntaxique d'un texte source.
/// "reste" est le suffixe de la source qu'on n'a pas pu lire.
public struct Erreur {
    public let message: String
    public let reste: String
    
    public init(message: String, reste: String) {
        self.message = message
        self.reste = reste
    }
}

