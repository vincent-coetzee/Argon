//
//  BitSetInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/08/2023.
//

import Foundation

public class BitSetInstance: GenericTypeInstance
    {
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
        
    public override var encoding: String
        {
        return("w\(self.genericTypes[0].encoding)_\(self.genericTypes[1].encoding)_")
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(bitSetInstance: self)
        }
    }
