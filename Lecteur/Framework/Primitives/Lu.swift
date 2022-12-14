//
//  Lu LuListe.swift
//  Mots
//
//  Created by Gérard Tisseau on 13/11/2022.
//

import Foundation

/// Le résultat d'une lecture d'une source String si succès :
/// La valeur compilée qu'on a extraite, le reste de la source
public struct Lu<Valeur> {
    public var valeur: Valeur
    public var reste: String
    
    public init(valeur: Valeur, reste: String) {
        self.valeur = valeur
        self.reste = reste
    }
}

public extension Lu {
    
    func map<NewValeur>(_ f: (Valeur) -> NewValeur) -> Lu<NewValeur> {
        Lu<NewValeur>(valeur: f(valeur), reste: reste)
    }
    
    func puis<NewValeur>(_ f: (Valeur) -> Lu<NewValeur>) -> Lu<NewValeur> {
        return f(valeur)
    }
}

