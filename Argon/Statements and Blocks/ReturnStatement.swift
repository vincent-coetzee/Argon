//
//  ReturnStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class ReturnStatement: Statement
    {
    public override var containsReturnStatement: Bool
        {
        true
        }

    public let expression: Expression
    
    public class func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var expression: Expression?
        parser.parseParentheses
            {
            expression = parser.parseExpression()
            }
        let statement = ReturnStatement(expression: expression!)
        statement.location = location
        statement.addDeclaration(location)
        block.addStatement(statement)
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
        visitor.enter(returnStatement: self)
        self.expression.accept(visitor: visitor)
        visitor.exit(returnStatement: self)
        }
    }
