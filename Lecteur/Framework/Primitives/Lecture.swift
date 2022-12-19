//
//  Lecture.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/11/2022.
//

import Foundation

/// Un résultat de lecture d'un texte source
public enum Lecture<Valeur> {
    case succes(Lu<Valeur>)
    case echec(Erreur)
    
}


// MARK: - Monade

public extension Lecture {
    
    /// Le flatMap d'une monade
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
    
    /// Transforme lu si succes, transmet l'erreur sinon
    func mapLu<NewValeur>(_ f: (Lu<Valeur>) -> Lu<NewValeur>) -> Lecture<NewValeur> {
        switch self {
        case .echec(let erreur):
            return .echec(erreur)
        case .succes(let lu):
            return .succes(f(lu))
        }
    }
    
    /// Transforme la valeur si succes, transmet l'erreur sinon
    func mapValeur<NewValeur>(_ f: (Valeur) -> NewValeur) -> Lecture<NewValeur> {
        switch self {
        case .echec(let erreur):
            return .echec(erreur)
        case .succes(let lu):
            return .succes(lu.map(f))
        }
    }
    
    /// Transforme l'erreur si échec, transmet le succès sinon
    func mapErreur(_ f: (Erreur) -> Erreur) -> Lecture<Valeur> {
        switch self {
        case .succes(_):
            return self
        case .echec(let erreur):
            let nouvelleErreur = f(erreur)
            return .echec(nouvelleErreur)
        }
    }
    
    /// Retourne toujours un succès, même si on part d'une erreur.
    /// Utilisé par l'opérateur "optionnel"
    func transformerEnSucces<NewValeur>(transformerValeur: (Valeur) -> NewValeur, transformerErreur: (Erreur) -> NewValeur) -> Lecture<NewValeur> {
        switch self {
        case .succes(let lu):
            return .succes(lu.map(transformerValeur))
        case .echec(let erreur):
            return Lecture<NewValeur>.succes(Lu<NewValeur>(valeur: transformerErreur(erreur), reste: erreur.reste))
        }
    }
}

// MARK: comptes rendus toujours définis

public extension Lecture {
    
    var estSucces: Bool {
        switch self {
        case .succes(_): return true
        case .echec(_): return false
        }
    }
    
    var estEchec: Bool {
        switch self {
        case .succes(_): return false
        case .echec(_): return true
        }
    }
    
    /// Il y a toujours un reste, soit après succès soit après échec
    var reste: String {
        switch self {
        case .succes(let lu): return lu.reste
        case .echec(let erreur): return erreur.reste
        }
    }
    
    /// Compte rendu de la lecture sous forme de String. Réussit toujours.
    var texte: String {
        switch self {
        case .succes(let lu):
            return "􀆅 \(lu.valeur) 􀄫\"\(lu.reste)\""
        case .echec(let erreur):
            
            return "􀅾 \(erreur.message) 􀄫\"\(erreur.reste)\""
        }
    }
}


// MARK: comptes rendus optionnels

extension Lecture {

    /// lu si succès, nil si échec
    var lu: Lu<Valeur>? {
        switch self {
        case .succes(let lu): return lu
        case .echec(_): return nil
        }
    }
    
    /// La valeur si succès, nil si échec
    /// Attention : la valeur peut elle-même être un Optional, qui peut être nil
    /// donc ce n'est pas cette fonction qu'il faut tester pour savoir s'il y a succès.
    /// Pour tester le succès, utiliser estSucces
    var valeur: Valeur? {
        switch self {
        case .succes(let lu): return lu.valeur
        case .echec(_): return nil
        }
    }
    
    /// L'erreur si échec, nil si succès
    var erreur: Erreur? {
        switch self {
        case .succes(_): return nil
        case .echec(let err): return err
        }
    }
}
