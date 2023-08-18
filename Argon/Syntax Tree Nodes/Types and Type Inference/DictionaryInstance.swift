//
//  DictionaryInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/08/2023.
//

import Foundation

public class DictionaryInstance: GenericTypeInstance
    {
    public override var encoding: String
        {
        return("X\(self.genericTypes[0].encoding)_")
        }
    }
