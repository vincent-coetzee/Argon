//
//  ArrayAccessExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 29/07/2023.
//

import Foundation

public class ArrayAccessExpression: BinaryExpression
    {
    public var array: Expression
        {
        self.left
        }
        
    public var memberIndex: Expression
        {
        self.right
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
    }
