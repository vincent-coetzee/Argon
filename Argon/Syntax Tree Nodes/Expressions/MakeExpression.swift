//
//  MakeExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/08/2023.
//

import Foundation

public class MakeExpression: Expression
    {
    private let classExpression: Expression
    private let arguments: Expressions
    
    init(classExpression: Expression,arguments: Expressions)
        {
        self.classExpression = classExpression
        self.arguments = arguments
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.classExpression = coder.decodeObject(forKey: "classExpression") as! Expression
        self.arguments = coder.decodeObject(forKey: "arguments") as! Expressions
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.classExpression,forKey: "classExpression")
        coder.encode(self.arguments,forKey: "arguments")
        super.encode(with: coder)
        }
    }
