//
//  ListInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/08/2023.
//

import Foundation

public class ListInstance: GenericTypeInstance
    {
    public override var encoding: String
        {
        return("Z\(self.elementType.encoding).")
        }
    }
