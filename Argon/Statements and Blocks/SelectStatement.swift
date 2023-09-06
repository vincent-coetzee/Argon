//
//  SelectStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class SelectBlock: Block
    {
    private let expression: Expression
    
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
        visitor.enter(selectBlock: self)
        self.expression.accept(visitor: visitor)
        visitor.exit(selectBlock: self)
        }
    }
    
fileprivate typealias SelectBlocks = Array<SelectBlock>

extension SelectBlocks
    {
    public func accept(visitor: Visitor)
        {
        for block in self
            {
            block.accept(visitor: visitor)
            }
        }
    }

public class SelectStatement: Statement
    {
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var expression: Expression!
        var selectBlocks = SelectBlocks()
        parser.parseParentheses
            {
            expression = parser.parseExpression(precedence: 0)
            }
        parser.parseBraces
            {
            repeat
                {
                let blockLocation = parser.token.location
                let block = self.parseSelectBlock(using: parser)
                block.location = blockLocation
                selectBlocks.append(block)
                }
            while !parser.token.isEnd && !parser.token.isRightBrace
            }
        let statement = SelectStatement(expression: expression)
        statement.location = location
        statement.selectBlocks = selectBlocks
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
        
    private static func parseSelectBlock(using parser: ArgonParser) -> SelectBlock
        {
        let location = parser.token.location
        if !parser.token.isWhen
            {
            parser.lodgeError( code: .whenExpected, location: location)
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
        let selectBlock = SelectBlock(expression: expression)
        selectBlock.addDeclaration(location)
        Block.parseBlockInner(block: selectBlock, using: parser)
        return(selectBlock)
        }
        
    private let expression: Expression
    private var selectBlocks = SelectBlocks()
    
    public init(expression: Expression)
        {
        self.expression = expression
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as! Expression
        self.selectBlocks = coder.decodeObject(forKey: "selectBlocks") as! SelectBlocks
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        coder.encode(self.selectBlocks,forKey: "selectBlocks")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(selectStatement: self)
        self.expression.accept(visitor: visitor)
        self.selectBlocks.accept(visitor: visitor)
        visitor.exit(selectStatement: self)
        }
    }
