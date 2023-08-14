//
//  ForkStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/08/2023.
//

import Foundation

public class ForkStatement: Statement
    {
    private let block: Block
    
    public init(block: Block)
        {
        self.block = block
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.block = coder.decodeObject(forKey: "block") as! Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.block,forKey: "block")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var forkBlock: Block?
        parser.parseParentheses
            {
            parser.parseBraces
                {
                forkBlock = Block.parseBlock(using: parser)
                }
            }
        let statement = ForkStatement(block: forkBlock!)
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
        
    public override func accept(visitor: Visitor)
        {
        self.block.accept(visitor: visitor)
        visitor.visit(forkStatement: self)
        }
    }
