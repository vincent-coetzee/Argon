//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class Method: SyntaxTreeNode
    {
    public var parameters = Parameters()
    public var returnType = ArgonModule.voidType
    
    public override var valueBox: ValueBox
        {
        .method(self)
        }
    }
