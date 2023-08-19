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
        
    public override var isSystemNode: Bool
        {
        get
            {
            true
            }
        set
            {
            }
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(dictionaryInstance: self)
        }
    }
