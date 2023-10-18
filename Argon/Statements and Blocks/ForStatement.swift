//
//  ForStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/09/2023.
//

import Foundation

public class ForStatement: Block
    {
    private let expression: Expression
    private let inductionVariableName: Identifier
    
    public init(inductionVariableName: Identifier,expression: Expression)
        {
        self.inductionVariableName = inductionVariableName
        self.expression = expression
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as! Expression
        self.inductionVariableName = coder.decodeObject(forKey: "inductionVariableName") as! Identifier
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        coder.encode(self.inductionVariableName,forKey: "inductionVariableName")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        parser.expect(tokenType: .IN,error: .inExpected)
        let statement = ForStatement(inductionVariableName: identifier,expression: parser.parseExpression())
        statement.location = location
        parser.parseBraces
            {
            Block.parseBlockInner(block: statement, using: parser)
            }
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
    
    public override func accept(visitor: Visitor)
        {
        visitor.visit(forStatement: self)
        }
    }
