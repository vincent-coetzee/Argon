//
//  RepeatStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class RepeatStatement: Block
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
        let firstLocation = parser.token.location
        parser.nextToken()
        let repeatBlock = Block.parseBlock(using: parser)
        let location = parser.token.location
        if !parser.token.isWhile
            {
            parser.lodgeIssue(code: .whileExpectedAfterRepeatBlock,location: location)
            }
        else
            {
            parser.nextToken()
            }
        var expression: Expression!
        parser.parseParentheses
            {
            expression = parser.parseExpression(precedence: 0)
            }
        let statement = RepeatStatement(expression: expression,block: repeatBlock)
        statement.addDeclaration(firstLocation)
        block.addStatement(statement)
        }
        
    public override func accept(visitor: Visitor)
        {
        self.block.accept(visitor: visitor)
        self.expression.accept(visitor: visitor)
        visitor.visit(repeatStatement: self)
        }
    }
