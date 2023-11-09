//
//  MakeExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/08/2023.
//

import Foundation

public class MakeExpression: Expression
    {
    public override var description: String
        {
        "MAKE(\(self.arguments[0].description))"
        }
        
    public override var symbolType: ArgonType!
        {
        get
            {
            self.typeNode.baseType
            }
        set
            {
            }
        }
        
    public let typeNode: ArgonType
    public let arguments: Expressions
    
    init(type: ArgonType,arguments: Expressions)
        {
        self.typeNode = type
        self.arguments = arguments
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.typeNode = coder.decodeObject(forKey: "type") as! ArgonType
        self.arguments = coder.decodeObject(forKey: "arguments") as! Expressions
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.typeNode,forKey: "type")
        coder.encode(self.arguments,forKey: "arguments")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(makeExpression: self)
        }
    }