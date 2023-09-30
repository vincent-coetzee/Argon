//
//  PostfixExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class PostfixExpression: Expression
    {
    public let `operator`: TokenType
    public let left: Expression
    public var method: MultimethodType?
    
    public init(left: Expression,operator: TokenType)
        {
        self.left = left
        self.operator = `operator`
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.left = coder.decodeObject(forKey: "left") as! Expression
        let type = coder.decodeInteger(forKey: "tokenType")
        self.operator = TokenType(rawValue: type)!
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.left,forKey: "left")
        coder.encode(self.operator.rawValue,forKey: "tokenType")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(postfixExpression: self)
        self.left.accept(visitor: visitor)
        visitor.exit(postfixExpression: self)
        }
        
    public func setMethod(_ method: MultimethodType?)
        {
        self.method = method
        }
    }
    
