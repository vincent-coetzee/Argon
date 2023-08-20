//
//  WhileStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class WhileStatement: Block
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
        parser.pushCurrentScope(block)
        defer
            {
            parser.popCurrentScope()
            }
        parser.parseParentheses
            {
            expression = parser.parseExpression(precedence: 0)
            }
        let whileBlock = Block()
        whileBlock.setParent(block)
        Block.parseBlockInner(block: whileBlock, using: parser)
        let statement = WhileStatement(expression: expression,block: whileBlock)
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
    
    public override func accept(visitor: Visitor)
        {
        visitor.enter(whileStatement: self)
        self.expression.accept(visitor: visitor)
        self.block.accept(visitor: visitor)
        visitor.exit(whileStatement: self)
        }
    }
