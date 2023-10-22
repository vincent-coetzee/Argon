//
//  LetNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class LetStatement: Statement
    {
    private let expression: Expression
    
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let expression = parser.parseExpression()
        if !expression.isAssignmentExpression
            {
            parser.lodgeError(code: .assignmentExpressionExpected, location: location)
            }
        let statement = LetStatement(expression: expression)
        block.addStatement(statement)
        if let lValue = expression.lValue,let rValue = expression.rValue
            {
            if lValue.isIdentifierExpression
                {
                let identifier = (lValue as! IdentifierExpression).identifier
                parser.currentScope.addSymbol(Variable(name: identifier.lastPart, type: nil, expression: rValue))
                return
                }
            }
        parser.lodgeError(code: .invalidAssignmentExpression,location: location)
        }
        
    public class override func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let expression = parser.parseExpression()
        if !expression.isAssignmentExpression
            {
            parser.lodgeError(code: .assignmentExpressionExpected, location: location)
            }
        let statement = LetStatement(expression: expression)
        statement.location = location
        parser.currentScope.addSymbol(statement)
        if let lValue = expression.lValue,let rValue = expression.rValue
            {
            if lValue.isIdentifierExpression
                {
                let identifier = (lValue as! IdentifierExpression).identifier
                parser.currentScope.addSymbol(Variable(name: identifier.lastPart, type: nil, expression: rValue))
                return
                }
            }
        parser.lodgeError(code: .invalidAssignmentExpression,location: location)
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
        visitor.visit(letStatement: self)
        self.expression.accept(visitor: visitor)
        }
    }
