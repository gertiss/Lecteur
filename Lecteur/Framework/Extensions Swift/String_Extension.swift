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
    

    /// Supprime le préfixe s'il existe.
    func sansPrefixe(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    /// Si le texte n'est pas un suffixe, on retourne nil
    /// Sinon on retourne le préfixe avant le texte (texte exclu). Peut être vide.
    /// Equation : self = prefixeAvant(texte) + texte
    func prefixeAvant(_ texte: String) -> String? {
        if !self.hasSuffix(texte) {
            return nil
        }
        let longueurPrefixe = self.count - texte.count
        let prefixe =  String(self.prefix(longueurPrefixe))
        return prefixe
    }
    
    /// Vérifie les niveaux de parenthésage pour le couple (ouvrante, fermante).
    /// ouvrante doit être différente de fermante, sinon erreur.
    /// La contrainte doit être respectée même en cas d'échappements.
    func validiteParenthesage(ouvrante: Character, fermante: Character) -> Result<Bool, String> {
        assert(ouvrante != fermante)
        var niveau = 0
        for caractere in self {
            if caractere == ouvrante {
                niveau += 1
                continue
            }
            if caractere == fermante {
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
    
    /// Les parenthésages standards définis à l'aide d'un seul caractère
    static let parenthesages: [(Character, Character)] = [
        ("{", "}"), ("(", ")"), ("[", "]"), ("«", "»")
    ]
    
    /// On vérifie tous les parenthésages prédéfinis dans String.parenthesages
    /// Si erreur, on retourne la première erreur
    func validiteParenthesages() -> Result<Bool, String> {
        for (ouvrante, fermante) in String.parenthesages {
            let validite = validiteParenthesage(ouvrante: ouvrante, fermante: fermante)
            switch validite {
            case .success(_): continue
            case .failure(let erreur): return .failure(erreur)
            }
        }
        return .success(true)
    }

}

// MARK: - Lecture
    
/// `"abc".lecteur.lire(source) -> Lecture<String>`
/// Ou bien `"abc".lire(source) -> Lecture<String>`
extension String: AvecLecteurInstance {
    
    public init(sourceRelisible: String) {
        self = sourceRelisible
    }

    public var lecteur: Lecteur<String> {
        Lecteur(lire: self.lire)
    }
    
    public var sourceRelisible: String {
        self
    }
    
    /// La source doit commencer par self
    /// On ne consomme que self
    public func lire(_ source: String) -> Lecture<String> {
        guard source.hasPrefix(self) else {
            return .echec(Erreur(message: "On attend \"\(self)\"", reste: source))
        }
        return .succes(Lu(valeur: self, reste: source.sansPrefixe(self)))
    }

}


   
