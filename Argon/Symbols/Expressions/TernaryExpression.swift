//
//  TernaryExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class TernaryExpression: Expression
    {
    private let thenArm: Expression
    private let `operator`: TokenType
    private let elseArm: Expression
    
    public init(operator: TokenType,then: Expression,else: Expression)
        {
        self.thenArm = then
        self.operator = `operator`
        self.elseArm = `else`
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.thenArm = coder.decodeObject(forKey: "thenArm") as! Expression
        self.operator = TokenType(rawValue: coder.decodeInteger(forKey: "operator"))!
        self.elseArm = coder.decodeObject(forKey: "elseArm") as! Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.thenArm,forKey: "thenArm")
        coder.encode(self.operator,forKey: "operator")
        coder.encode(self.elseArm,forKey: "elseArm")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(ternaryExpression: self)
        self.thenArm.accept(visitor: visitor)
        self.elseArm.accept(visitor: visitor)
        }
    }
