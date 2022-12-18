//
//  UnEspacement.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/12/2022.
//

import Foundation

/// UnEspacement est une Valeur AvecLecteur dont le lecteur lit des espaces, tabs, et éventuellement des returns.  Cette lecture réussit toujours, même si la source ne contient aucun espace, tab , return.
public protocol UnEspacement: AvecLecteur {
}

extension Lecteur where Valeur: UnEspacement {
    
    public func resteApresLecture(_ source: String) -> String {
        let lecture = lire(source)
        assert(lecture.estSucces)
        return lecture.lu!.reste
    }
}
