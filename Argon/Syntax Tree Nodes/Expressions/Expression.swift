//
//  Expression.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/01/2023.
//

import Foundation

public class Expression: Symbol
    {
    public var isRValue: Bool
        {
        false
        }
        
    public var isLValue: Bool
        {
        false
        }
        
    public var isIdentifierExpression: Bool
        {
        false
        }
        
    public var lValue: Expression?
        {
        nil
        }
        
    public var rValue: Expression?
        {
        nil
        }
        
    public var leftSide: Expression?
        {
        nil
        }
        
    public var rightSide: Expression?
        {
        nil
        }
        
    public var isAssignmentExpression: Bool
        {
        false
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public init()
        {
        super.init(name: "")
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        fatalError("This methods should have been overridden in a subclass")
        }
    }

public typealias Expressions = Array<Expression>

extension Expressions
    {
    public init(_ expression: Expression)
        {
        self.init()
        self.append(expression)
        }
        
    public func accept(visitor: Visitor)
        {
        for expression in self
            {
            expression.accept(visitor: visitor)
            }
        }
    }
