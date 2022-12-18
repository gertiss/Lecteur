//
//  ignore.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 18/12/2022.
//

import Foundation

public extension Lecteur {
    
    /// `self.ignore().lire(source)` lit dans la source la plus grande String conforme à self et rend comme valeur compilée la String vide. Réussit toujours.
    /// Cela permet d'avancer dans la lecture en consommant une séquence sans la prendre en compte.
    func ignore() -> Lecteur<String> {
        Lecteur<String> { source in
            if source.isEmpty {
                return .succes(Lu(valeur: "", reste: ""))
            }
            let lecture = self.lire(source)
            guard let lu = lecture.lu else {
                return .succes(Lu(valeur: "", reste: source))
            }
            return .succes(Lu(valeur: "", reste: lu.reste))
        }
    }
    
    /// `self.enIgnorantPrefixe(prefixe).lire(source)`  lit la source en ignorant le préfixe et en le consommant puis en lisant self
    /// L'espacement après le préfixe est consommé après avoir lu le préfixe et avant de lire self
    /// Donc la pattern est : préfixe espacement self
    /// La valeur compilée est juste self

    func enIgnorantPrefixe<P, Esp: UnEspacement>(_ prefixe: Lecteur<P>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        prefixe.ignore()
            .suiviDe2(espacement, self)
            .mapValeur { (ignore, esp, valeur) in
                valeur
            }
    }
 
    
    /// `self.enIgnorantSuffixe(suffixe).lire(source)` lit la source  en lisant self puis en ignorant le suffixe et en le consommant.
    /// L'espacement avant le suffixe est consommé après avoir lu self et avant de lire le suffixe
    /// Donc le pattern est :  self espacement suffixe
    /// La valeur compilée est juste self
    func enIgnorantSuffixe<P, Esp: UnEspacement>(_ suffixe: Lecteur<P>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        self
            .suiviDe2(espacement, suffixe.ignore())
            .mapValeur { (valeur, esp, ignore) in
                valeur
            }
    }
    
    /// `self.enIgnorantEncadrement(neutre).lire(source)` lit la source en ignorant le préfixe neutre, puis en lisant self, puis en ignorant le suffixe neutre
    /// Les espacements après le préfixe et avant le suffixe sont consommés.
    /// Donc le pattern est  : préfixe espacement self espacement suffixe
    /// La valeur compilée est juste self
    func enIgnorantEncadrement<O, F, Esp: UnEspacement>(prefixe: Lecteur<O>, suffixe: Lecteur<F>, espacement: Lecteur<Esp> = EspacesOuTabs.lecteur) -> Self {
        self.enIgnorantPrefixe(prefixe, espacement: espacement).enIgnorantSuffixe(suffixe, espacement: espacement)
    }

}
