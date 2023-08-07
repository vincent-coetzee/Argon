//
//  Function.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/07/2023.
//

import Foundation

public class Function: CallableTypeNode
    {
    public var signature: MethodSignature
        {
        MethodSignature(name: self.name,parameterTypes: [])
        }
        
    public override var isFunction: Bool
        {
        return(true)
        }
    }
