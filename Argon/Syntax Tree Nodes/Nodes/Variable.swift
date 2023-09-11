//
//  Variable.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/07/2023.
//

import Foundation

public class Variable: SyntaxTreeNode
    {
    public let expression: Expression?
    
    public override init(name: String)
        {
        self.expression = nil
        super.init(name: name)
        }
        
    public init(name: String,type: TypeNode?,expression: Expression?)
        {
        self.expression = expression
        super.init(name: name)
        self.setType(type) 
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as? Expression
        super.init(coder: coder)
        }
    
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        super.encode(with: coder)
        }

    public override func accept(visitor: Visitor)
        {
        super.accept(visitor: visitor)
        visitor.visit(variable: self)
        }
    }

public typealias Variables = Array<Variable>

public class InductionVariable: Variable
    {
    }

public typealias InductionVariables = Array<InductionVariable>
