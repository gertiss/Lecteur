//
//  Optionnel.swift
//  Mots
//
//  Created by Gérard Tisseau on 16/11/2022.
//

import Foundation


public extension Lecteur {
    
    func optionnel() -> Lecteur<Valeur?>  {
        Lecteur<Valeur?> { source in
            self.lire(source)
                .transformerEnSucces(
                    transformerValeur: { Optional($0) },
                    transformerErreur: { _ in nil })
            
        }
    }
    
    
}
