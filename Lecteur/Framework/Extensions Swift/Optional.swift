//
//  Optional.swift
//  Lecteur
//
//  Created by Gérard Tisseau on 20/11/2022.
//

import Foundation

public extension Optional where Wrapped: AvecLecteur {
    
    var description: String {
        if let x = self { return x.description }
        return "nil"
    }
}


