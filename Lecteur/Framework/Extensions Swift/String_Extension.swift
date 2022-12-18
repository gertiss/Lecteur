//
//  String_Error.swift
//  Mots
//
//  Created by Gérard Tisseau on 14/11/2022.
//

import Foundation

extension String: Error { }

// MARK: - Prefixes

public extension String {
    

    /// Supprime le préfixe s'il existe. Elague le résultat.
    func sansPrefixe(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    /// Si le texte n'est pas un suffixe, on retourne nil
    /// Sinon on retourne le préfixe avant le texte (texte exclu), non élagué. Peut être vide.
    func prefixeAvant(_ texte: String) -> String? {
        if !self.hasSuffix(texte) {
            return nil
        }
        let longueurPrefixe = self.count - texte.count
        let prefixe =  String(self.prefix(longueurPrefixe))
        return prefixe
    }
    
    func validiteParenthesage(ouvrante: String, fermante: String) -> Result<Bool, String> {
        var niveau = 0
        for caractere in self {
            if String(caractere) == ouvrante {
                niveau += 1
                continue
            }
            if String(caractere) == fermante {
                niveau -= 1
                if niveau < 0 {
                    return .failure("Erreur de parenthésage: une occurrence de \"\(fermante)\" mal placée, ou une occurrence de \"\(ouvrante)\" oubliée")
                }
            }
        }
        if niveau == 0 { return .success(true) }
        if niveau > 0 {
            return .failure("Erreur de parenthésage: il manque \(niveau) \"\(fermante)\"")
        }
        return .failure("Erreur de parenthésage: il y a \(-niveau) \"\(fermante)\" en trop")
    }

}

// MARK: - Lecture
    
/// `"abc".lecteur.lire(source) -> Lecture<String>`
/// Ou bien `"abc".lire(source) -> Lecture<String>`
/// Accepte et ignore espaceOuTab avant et après (élague avant et élague après)
extension String: AvecLecteurInstance {
    
    public var lecteur: Lecteur<String> {
        Lecteur(lire: self.lire)
    }
    
    public var sourceRelisible: String {
        self
    }
    
    /// La source doit commencer par self
    public func lire(_ source: String) -> Lecture<String> {
        let flux = source
        guard flux.hasPrefix(self) else {
            return .echec(Erreur(message: "On attend \"\(self)\"", reste: source))
        }
        return .succes(Lu(valeur: self, reste: flux.sansPrefixe(self)))
    }
    
    public init(sourceRelisible: String) {
        self = sourceRelisible
    }

}


   
