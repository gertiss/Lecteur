//
//  Mirror.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 07/12/2022.
//

import Foundation

extension Mirror {
    
    var estStringOuSubstring: Bool {
        displayStyle == nil
        && ["String", "Substring"].contains("\(subjectType)")
    }
    
    var estTupleAvecPremierStringOuSubstring: Bool {
        guard displayStyle == .tuple else { return false }
        let composants = children
        guard composants.count > 0 else { return false }
        // On prend le Mirror du premier composant
        guard let composant0 = composants.first else {
            return false
        }
        // Il doit avoir un label
        guard let label0 = composant0.label else {
            return false
        }
        // On vérifie qu'il a bien le label ".0"
        guard label0 == ".0" else { return false }
        // On inspecte la valeur du premier composant
        let valeur0 = composant0.value
        let mirror0 = Mirror(reflecting: valeur0)
        // On vérifie qu'il représente bien une String ou une Substring
        return mirror0.estStringOuSubstring
    }
    
}
