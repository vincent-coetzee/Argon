//
//  LocationReference.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/07/2023.
//

import Foundation

public enum NodeReference
    {
    case declaration(Location)
    case reference(Location)
    }

public typealias NodeReferences = Array<NodeReference>
