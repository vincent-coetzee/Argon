//
//  Variable.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/07/2023.
//

import Foundation

public class Variable: SyntaxTreeNode
    {
    public let type: TypeNode?
    public let expression: Expression?
    
    public init(name: String,type: TypeNode?,expression: Expression?)
        {
        self.type = type
        self.expression = expression
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.type = coder.decodeObject(forKey: "type") as? TypeNode
        self.expression = coder.decodeObject(forKey: "expression") as? Expression
        super.init(coder: coder)
        }
    
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.type,forKey: "type")
        coder.encode(self.expression,forKey: "expression")
        super.encode(with: coder)
        }

    }

public typealias Variables = Array<Variable>
