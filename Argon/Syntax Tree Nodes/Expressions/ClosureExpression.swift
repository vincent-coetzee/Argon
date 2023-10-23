//
//  ClosureExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/08/2023.
//

import Foundation

public class ClosureExpression: Expression
    {
    public override var description: String
        {
        "CLOSURE"
        }
        
    private let block: Block
    private let parameters: Parameters
    
    public init(block: Block,parameters: Parameters)
        {
        self.parameters = parameters
        self.block = block
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.parameters = coder.decodeObject(forKey: "parameters") as! Parameters
        self.block = coder.decodeObject(forKey: "block") as! Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.parameters,forKey: "parameters")
        coder.encode(self.block,forKey: "block")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(closureExpression: self)
        self.block.accept(visitor: visitor)
        }
    }
