//
//  FunctionInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class FunctionInvocationExpression: Expression
    {
    public override func accept(visitor: Visitor)
        {
        visitor.visit(functionInvocationExpression: self)
        }
    }
