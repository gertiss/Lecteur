//
//  UneExpr.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 18/11/2022.
//

import Foundation

public protocol AvecLecteur: Equatable, CustomStringConvertible {

    /// Self.lecteur.lireTout(source).valeur donne une instance de Self si succès
    static var lecteur: Lecteur<Self> { get }
    
    /// source pouvant être relue par le lecteur pour redonner une copie de self
    /// `Self.lecteur.lireTout(sourceRelisible) -> copie de self`
    var sourceRelisible: String { get }
    
    /// description est un code Swift dont l'évaluation donne une copie de sel
    var description: String { get }
    
    static func erreurSiReste(_ reste: String) -> Erreur
}

public extension AvecLecteur {
    
    static var lire: Lecteur<Self> {
        Lecteur {
            source in
            Self.lecteur.lire(source)
        }
    }
    
    static func lireTout(_ source: String) -> Lecture<Self> {
        Self.lecteur.lireTout(source)
    }

    static func erreurSiReste(_ reste: String) -> Erreur {
        Erreur(message: "On attend \(Self.self) et rien après", reste: reste)
    }
    
    static func lecturePrefixe(_ source: String) -> Lecture<Self> {
        lecteur.lire(source)
    }
    
    static func lectureTotale(_ source: String) -> Lecture<Self> {
        lecteur.lireTout(source)
    }

    static func instancePrefixe(_ source: String) -> Self? {
        lecturePrefixe(source).valeur
    }
    
    static func instanceTotale(_ source: String) -> Self? {
        lectureTotale(source).valeur
    }
        
    static var nom: String { "\(Self.self)" }
    
}



