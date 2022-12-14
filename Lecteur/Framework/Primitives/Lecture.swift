//
//  Lecture.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/11/2022.
//

import Foundation

public enum Lecture<Valeur> {
    case succes(Lu<Valeur>)
    case echec(Erreur)
    
}


// MARK: - Monade

public extension Lecture {
    
    func puis<NewValeur>(_ f: (Lu<Valeur>) -> Lecture<NewValeur>) -> Lecture<NewValeur> {
        switch self {
        case .echec(let erreur):
            return .echec(erreur)
        case .succes(let lu):
            switch f(lu) {
            case .echec(let nouvelleErreur):
                return .echec(nouvelleErreur)
            case .succes(let nouveauLu):
                return .succes(nouveauLu)
            }
        }
    }
    
    func mapLu<NewValeur>(_ f: (Lu<Valeur>) -> Lu<NewValeur>) -> Lecture<NewValeur> {
        switch self {
        case .echec(let erreur):
            return .echec(erreur)
        case .succes(let lu):
            return .succes(f(lu))
        }
    }
    
    func mapValeur<NewValeur>(_ f: (Valeur) -> NewValeur) -> Lecture<NewValeur> {
        switch self {
        case .echec(let erreur):
            return .echec(erreur)
        case .succes(let lu):
            return .succes(lu.map(f))
        }
    }
    
    func mapErreur(_ f: (Erreur) -> Erreur) -> Lecture<Valeur> {
        switch self {
        case .succes(_):
            return self
        case .echec(let erreur):
            let nouvelleErreur = f(erreur)
            return .echec(nouvelleErreur)
        }
    }
    
    func transformerEnSucces<NewValeur>(transformerValeur: (Valeur) -> NewValeur, transformerErreur: (Erreur) -> NewValeur) -> Lecture<NewValeur> {
        switch self {
        case .succes(let lu):
            return .succes(lu.map(transformerValeur))
        case .echec(let erreur):
            return Lecture<NewValeur>.succes(Lu<NewValeur>(valeur: transformerErreur(erreur), reste: erreur.reste))
        }
    }
}

public extension Lecture {
    
    var lu: Lu<Valeur>? {
        switch self {
        case .succes(let lu):
            return lu
        case .echec(_):
            return nil
        }
    }
    
    var reste: String {
        lu?.reste  ??  erreur!.reste
    }
    
    var valeur: Valeur? {
        lu?.valeur
    }
    

    var erreur: Erreur? {
        switch self {
        case .succes(_):
            return nil
        case .echec(let err):
            return err
        }
    }
    
    var estSucces: Bool {
        lu != nil
    }
    
    var estEchec: Bool {
        erreur != nil
    }
        
    var texte: String {
        switch self {
        case .succes(let lu):
            return "􀆅 \(lu.valeur) 􀄫\"\(lu.reste)\""
        case .echec(let erreur):
            
            return "􀅾 \(erreur.message) 􀄫\"\(erreur.reste)\""
        }
    }

}
