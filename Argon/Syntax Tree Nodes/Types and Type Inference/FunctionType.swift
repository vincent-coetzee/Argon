//
//  Function.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/07/2023.
//

import Foundation

public class FunctionType: CallableTypeNode
    {
    public var signature: MethodSignature
        {
        MethodSignature(name: self.name,parameterTypes: [])
        }
        
    public override var isFunction: Bool
        {
        return(true)
        }
        
    public override var encoding: String
        {
        let inners = self.parameters.map{$0.type.encoding}
        let string = inners.joined(separator: "_")
        let returnTypeString = self.returnType.isNil ? ArgonModule.shared.voidType.encoding : self.returnType!.encoding
        return("a\(self.name)_\(string)_\(returnTypeString)_")
        }
    }
