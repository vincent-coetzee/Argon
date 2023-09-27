//
//  Metaclass.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class MetaclassType: ClassType
    {
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("METACLASS")
        hasher.combine(self.identifier)
        return(hasher.finalize())
        }
    }

