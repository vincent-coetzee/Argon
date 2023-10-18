//
//  PrefixExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class PrefixExpression: Expression
    {
    public let `operator`: TokenType
    public let right: Expression
    public var method: MultimethodType?
    
    public init(operator: TokenType,right: Expression)
        {
        self.right = right
        self.operator = `operator`
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.right = coder.decodeObject(forKey: "right") as! Expression
        let type = coder.decodeInteger(forKey: "tokenType")
        self.operator = TokenType(rawValue: type)!
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.right,forKey: "right")
        coder.encode(self.operator.rawValue,forKey: "tokenType")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(prefixExpression: self)
        self.right.accept(visitor: visitor)
        }
        
    public func setMethod(_ method: MultimethodType?)
        {
        self.method = method
        }
    }
    
