//
//  Lecteur.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 17/11/2022.
//

import Foundation

/// Utilisation : `let lecture = self.lire(source)`
/// On peut personnaliser le message d'erreur "On attend ..." en fournissant un paramètre String "attendu". Ce paramètre est optionnel et a une valeur par défaut.
/// Exemple d'init : `Lecteur(attendu: "ce qu'on attend") { source in ... }`
/// la closure rend une `Lecture<Valeur>`
public struct Lecteur<Valeur> {
    
    public let lire: (String) -> Lecture<Valeur>
    
    /// Le texte à afficher dans le message d'erreur  "On attend <attendu>"
    /// On lui attribue une valeur par défaut à l'init, qui est le nom du type Valeur.
    public var attendu: String
    
    public init(attendu: String? = nil, lire: @escaping (String) -> Lecture<Valeur>) {
        self.attendu = attendu == nil ? "\(Valeur.self)" : attendu!.debugDescription
        self.lire = lire
    }
                
}

public extension Lecteur {

    /// Appelle la fonction lire et vérifie qu'il y a succès et que le reste est vide.
    /// S'il y a succès et que le reste n'est pas vide, analyse le bon parenthésage dans le reste pour les symboles usuels de parenthésage {} () [] «». Cela permet d'affiner le message d'erreur.
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



// MARK: - Monade

public extension Lecteur {
    
    /// Le flatMap de la monade
    func puis<NewValeur>(_ f: @escaping (Valeur) -> Lecteur<NewValeur>) -> Lecteur<NewValeur> {
        return Lecteur<NewValeur> { source in
            lire(source).puis { lu in  return f(lu.valeur).lire(lu.reste) }
        }
    }
    
    /// Transforme la valeur si succès.
    /// Se contente de transmettre l'échec sinon, avec retypage.
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
    
    /// Transforme l'erreur si échec
    /// Se contente de transmettre le succès sinon.
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
}

