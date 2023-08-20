//
//  StaticStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 17/08/2023.
//

import Foundation

public class StaticStatement: Statement
    {
    private let expression: Expression?
    
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        var expression: Expression?
        var type: TypeNode?
        if parser.token.isScope
            {
            parser.nextToken()
            type = parser.parseType()
            }
        if parser.token.isAssign
            {
            parser.nextToken()
            expression = parser.parseExpression()
            }
        let statement = StaticStatement(name: identifier.lastPart,type: type,expression: expression)
        block.addNode(statement)
        }
        
    public class override func parse(using parser: ArgonParser)
        {
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        var expression: Expression?
        var type: TypeNode?
        if parser.token.isScope
            {
            parser.nextToken()
            type = parser.parseType()
            }
        if parser.token.isAssign
            {
            parser.nextToken()
            expression = parser.parseExpression()
            }
        let statement = StaticStatement(name: identifier.lastPart,type: type,expression: expression)
        parser.currentScope.addNode(statement)
        }
        
    public init(name: String,type: TypeNode?,expression: Expression?)
        {
        self.expression = expression
        super.init()
        self.setName(name)
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as? Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.type,forKey: "type")
        coder.encode(self.expression,forKey: "expression")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(staticStatement: self)
        self.expression?.accept(visitor: visitor)
        visitor.exit(staticStatement: self)
        }
    }
