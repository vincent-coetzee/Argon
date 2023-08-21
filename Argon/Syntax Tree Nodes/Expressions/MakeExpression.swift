//
//  MakeExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/08/2023.
//

import Foundation

public class MakeExpression: Expression
    {
    private let clazz: Class?
    private let arguments: Expressions
    
    init(class: Class?,arguments: Expressions)
        {
        self.clazz = `class`
        self.arguments = arguments
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.clazz = coder.decodeObject(forKey: "class") as? Class
        self.arguments = coder.decodeObject(forKey: "arguments") as! Expressions
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.clazz,forKey: "class")
        coder.encode(self.arguments,forKey: "arguments")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(makeExpression: self)
        }
    }
