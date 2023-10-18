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
    public let staticVariable: StaticVariable
    
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        var expression: Expression?
        var type: ArgonType?
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
        statement.location = location
        block.rootModule.addGloballyInitialisedSymbol(statement.staticVariable)
        block.addSymbol(statement)
        }
        
    public class override func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        var expression: Expression?
        var type: ArgonType?
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
        parser.rootModule.addGloballyInitialisedSymbol(statement.staticVariable)
        statement.location = location
        parser.currentScope.addSymbol(statement)
        }
        
    public init(name: String,type: ArgonType?,expression: Expression?)
        {
        self.staticVariable = StaticVariable(name: name, type: type, expression: expression)
        self.expression = expression
        super.init()
        self.setName(name)
        }
        
    public required init(coder: NSCoder)
        {
        self.staticVariable = coder.decodeObject(forKey: "staticVariable") as! StaticVariable
        self.expression = coder.decodeObject(forKey: "expression") as? Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.staticVariable,forKey: "staticVariable")
        coder.encode(self.expression,forKey: "expression")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(staticStatement: self)
        self.expression?.accept(visitor: visitor)
        }
    }
