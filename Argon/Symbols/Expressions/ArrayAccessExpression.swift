//
//  ArrayAccessExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 29/07/2023.
//

import Foundation

public class ArrayAccessExpression: BinaryExpression
    {
    public override var description: String
        {
        self.left.description + "[\(self.right.description)]"
        }
        
    public var array: Expression
        {
        self.left
        }
        
    public var memberIndex: Expression
        {
        self.right
        }
        
    public override var lValue: Expression?
        {
        self.left.lValue
        }
        
    public init(array: Expression,memberIndex: Expression)
        {
        super.init(left: array,right: memberIndex)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(arrayAccessExpression: self)
        self.left.accept(visitor: visitor)
        self.right.accept(visitor: visitor)
        }
    }