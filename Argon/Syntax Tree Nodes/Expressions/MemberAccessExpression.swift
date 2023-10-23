//
//  MemberAccessExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/08/2023.
//

import Foundation

public class MemberAccessExpression: BinaryExpression
    {
    public override var description: String
        {
        self.left.description + "->" + self.right.description
        }
        
    public override var lValue: Expression?
        {
        self.left.lValue
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(memberAccessExpression: self)
        self.left.accept(visitor: visitor)
        }
    }
