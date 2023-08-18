//
//  StaticStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 17/08/2023.
//

import Foundation

public class StaticStatement: Statement
    {
    private let expression: Expression
    
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        parser.nextToken()
        let expression = parser.parseExpression()
        let statement = StaticStatement(expression: expression)
        block.addStatement(statement)
        }
        
    public class override func parse(using parser: ArgonParser)
        {
        parser.nextToken()
        let expression = parser.parseExpression()
        let statement = StaticStatement(expression: expression)
        parser.currentScope.addNode(statement)
        }
        
    public init(expression: Expression)
        {
        self.expression = expression
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as! Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        self.expression.accept(visitor: visitor)
        visitor.visit(staticStatement: self)
        }
    }
