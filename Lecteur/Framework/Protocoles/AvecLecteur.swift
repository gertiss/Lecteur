//
//  UneExpr.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 18/11/2022.
//

import Foundation

public protocol AvecLecteur: Equatable, CustomStringConvertible {

    /// `Self.lecteur.lireTout(source).valeur` donne une instance de Self si succès
    static var lecteur: Lecteur<Self> { get }
    
    /// source pouvant être relue par le lecteur pour redonner une copie de self
    /// `Self.lecteur.lireTout(sourceRelisible) -> copie de self`
    var sourceRelisible: String { get }
    
    /// description est un code Swift dont l'évaluation donne une copie de self
    var description: String { get }
    
    /// Lit la source pour extraire un préfixe qui représente une instance
    static func lireInstance(_ source: String) -> Lecture<Self>
}

public extension AvecLecteur {
        
    static func lireInstance(_ source: String) -> Lecture<Self> {
        Self.lecteur.lire(source)
    }

    static func lireInstanceSansReste(_ source: String) -> Lecture<Self> {
        Self.lecteur.lireTout(source)
    }
    
    static var nom: String { "\(Self.self)" }
    
}



