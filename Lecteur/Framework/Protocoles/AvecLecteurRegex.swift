//
//  AvecLecteurRegex.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 21/11/2022.
//

import Foundation
import RegexBuilder

public protocol AvecLecteurRegex: AvecLecteur {
    
    /// Doit être un tuple avec au moins deux éléments dont le premier élément est Substring.
    /// En Swift, il n'existe pas de tuple avec un seul élément : (T) équivaut à T.
    /// Ici, cela revient à dire que le Regex doit avoir au moins une capture.
    associatedtype SortieRegex

    static var regex: Regex<SortieRegex> { get }
    
    /// Si succès, compilation de la sortie en une instance de Self
    static func valeur(_ sortie: SortieRegex) -> Self
}


public extension AvecLecteurRegex {
    
    static func sortieRegex(_ source: String) -> SortieRegex? {
        source.prefixMatch(of: Self.regex)?.output
    }
    
    
    /// Cela rend la capture globale, premier élément du tuple de sortie : `sortie.0`
    /// Tout ce code signifie `String(sortie.0)`, mais calculé dynamiquement avec Mirror
    /// Il y a beaucoup de vérifications paranoïaques, sans doute inutiles.
    /// Est utilisé pour calculer le reste du match
    static func captureGlobale(sortie: SortieRegex) -> String {
        let mirror = Mirror(reflecting: sortie)
        if mirror.estStringOuSubstring {
            return "\(sortie)"
        }
        guard mirror.estTupleAvecPremierStringOuSubstring else {
            fatalError("On attend un tuple avec le premier composant String ou Substring et pas \"\(sortie)\"")
        }
        let valeur0 = mirror.children.first!.value
        return "\(valeur0)"
    }
    

    static func reste(source: String, sortie: SortieRegex) -> String {
        source.sansPrefixe(captureGlobale(sortie: sortie))
    }


    static var lecteur: Lecteur<Self> {
        Lecteur<Self>{ source in
            guard let sortie = sortieRegex(source) else {
                return .echec(Erreur(message: "On attend \(Self.self)", reste: source))
            }
            let reste = reste(source: source, sortie: sortie)
            let valeur = valeur(sortie)
            return .succes(Lu(valeur: valeur, reste: reste))
        }
    }
}
