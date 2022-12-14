//
//  AvecLecteurInstance.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 30/11/2022.
//

import Foundation

/// Un type dont chaque instance fournit un lecteur capable de la relire elle-même
public protocol AvecLecteurInstance: Equatable, CustomStringConvertible {

    var lecteur: Lecteur<Self> { get }
    
    /// source pouvant être relue par le lecteur pour redonner une copie de self
    /// `Self.lecteur.lireTout(sourceRelisible) -> copie de self`
    var sourceRelisible: String { get }
    
    /// description est un code Swift dont l'évaluation donne une copie de self
    var description: String { get }
    
    init(_ sourceRelisible: String)
}

public extension AvecLecteurInstance {
    
    var lecteur: Lecteur<Self> {
        self.sourceRelisible.lecteur
            .mapValeur { string in
                Self(string)
            }
    }

}
