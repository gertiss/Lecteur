//
//  Choix.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 24/11/2022.
//

import Foundation

// Permet de représenter les résultats des opérateurs ou, ou2, ou3

public enum Choix<Valeur0, Valeur1> {
    case cas0(Valeur0)
    case cas1(Valeur1)
}

public enum Choix2<Valeur0, Valeur1, Valeur2> {
    case cas0(Valeur0)
    case cas1(Valeur1)
    case cas2(Valeur2)
}

public enum Choix3<Valeur0, Valeur1, Valeur2, Valeur3> {
    case cas0(Valeur0)
    case cas1(Valeur1)
    case cas2(Valeur2)
    case cas3(Valeur3)
}


