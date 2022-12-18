//
//  Lecteur.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/11/2022.
//

import Foundation


public struct Lecteur<Valeur> {
    
    public let lire: (String) -> Lecture<Valeur>
    
    /// Le texte à afficher dans le message "On attend ..."
    public var attendu: String
    
    public init(attendu: String? = nil, lire: @escaping (String) -> Lecture<Valeur>) {
        self.attendu = attendu == nil ? "\(Valeur.self)" : attendu!.debugDescription
        self.lire = lire
    }
                
}


// MARK: - Monade

public extension Lecteur {
    
    func puis<NewValeur>(_ f: @escaping (Valeur) -> Lecteur<NewValeur>) -> Lecteur<NewValeur> {
        return Lecteur<NewValeur> { source in
            lire(source).puis { lu in  return f(lu.valeur).lire(lu.reste) }
        }
    }
    
    func mapValeur<NewValeur>(_ f: @escaping (Valeur) -> NewValeur) -> Lecteur<NewValeur> {
        Lecteur<NewValeur> { source in
            switch lire(source) {
            case .echec(let erreur):
                return .echec(erreur)
            case .succes(let lu):
                return .succes(lu.map(f))
            }
        }
    }
    
    func mapErreur(_ f: @escaping (Erreur) -> Erreur) -> Lecteur<Valeur> {
        Lecteur<Valeur> { source in
            switch lire(source) {
            case .echec(let erreur):
                return .echec(f(erreur))
            case .succes(let lu):
                return .succes(lu)
            }
        }
    }

    
    /// Produit un effet de bord et retourne self
    func effet(_ f: @escaping (Valeur) -> Void) -> Self {
        let _ = self.mapValeur { valeur in f(valeur) }
        return self
    }
    
    func lireTout(_ source: String) -> Lecture<Valeur>  {
        let lecture = lire(source)
        switch lecture  {
        case .echec(_):
            return lecture
        case .succes(let lu):
            if lu.reste.isEmpty { return lecture }
            else {
                let reste = lu.reste
                switch reste.validiteParenthesage(ouvrante: "{", fermante: "}") {
                case .failure(let message):
                    return .echec(Erreur(message: "On attend \(Valeur.self) et rien après. " + message, reste: reste))
                case .success(_):
                    return .echec(Erreur(message: "On attend \(Valeur.self) et rien après", reste: reste))
                }

            }
        }
    }
    
}
