//
//  Erreur.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 18/11/2022.
//

import Foundation

public struct Erreur {
    public let message: String
    public let reste: String
    
    public init(message: String, reste: String) {
        self.message = message
        self.reste = reste
    }
}

