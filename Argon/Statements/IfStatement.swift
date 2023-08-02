//
//  IfStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class IfStatement: Block
    {
    private let trueBlock: Block
    public var elseBlock: Block?
    private var condition: Expression
    
    init(condition: Expression,trueBlock: Block)
        {
        self.trueBlock = trueBlock
        self.condition = condition
        super.init()
        }
    
    required init(coder: NSCoder)
        {
        self.trueBlock = coder.decodeObject(forKey: "trueBlock") as! Block
        self.condition = coder.decodeObject(forKey: "condition") as! Expression
        self.elseBlock = coder.decodeObject(forKey: "elseBlock") as? Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.trueBlock,forKey: "trueBlock")
        coder.encode(self.condition,forKey: "condition")
        coder.encode(self.elseBlock,forKey: "elseBlock")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let condition = parser.parseExpression(precedence: 0)
        let trueBlock = Block.parseBlock(using: parser)
        var elseBlock:Block?
        if parser.token.isElse
            {
            parser.nextToken()
            elseBlock = Block.parseBlock(using: parser)
            }
        let statement = IfStatement(condition: condition,trueBlock: trueBlock)
        statement.elseBlock = elseBlock
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
    }
