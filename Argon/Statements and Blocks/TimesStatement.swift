//
//  TimeStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class TimesStatement: Block
    {
    private let expression: Expression
    private let block: Block
    
    public init(expression: Expression,block: Block)
        {
        self.expression = expression
        self.block = block
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as! Expression
        self.block = coder.decodeObject(forKey: "block") as! Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        coder.encode(self.block,forKey: "block")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var expression: Expression = Expression()
        parser.parseParentheses
            {
            expression = parser.parseExpression(precedence: 0)
            }
        let whileBlock = Block.parseBlock(using: parser)
        whileBlock.location = location
        let statement = TimesStatement(expression: expression,block: whileBlock)
        statement.location = location
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(timesStatement: self)
        self.expression.accept(visitor: visitor)
        self.block.accept(visitor: visitor)
        }
    }
