//
//  LetNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class LetStatement: Statement
    {
    private let expression: Expression?
    private let type: TypeNode?
    private let variableName: String
    
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected,message: "Identifier expected after 'LET'.")
        let name = identifier.lastPart
        var alreadyDefined = false
        if parser.currentScope.lookupNode(atName: name).isNotNil
            {
            alreadyDefined = true
            parser.lodgeIssue(code: .nodeAlreadyDefined,message: "A symbol with identifier '\(name)' is already defined.",location: location)
            }
        var variableType: TypeNode?
        if parser.token.isScope
            {
            parser.nextToken()
            variableType = parser.parseType()
            }
        var expression: Expression?
        if !parser.token.isEquals && variableType.isNil
            {
            parser.lodgeIssue(code: .typeOrAssignmentExpected,message: "If there is no type defined for the variable then an assignment must follow the identifier.",location: location)
            }
        else if parser.token.isEquals
            {
            parser.nextToken()
            expression = parser.parseExpression(precedence: 0)
            }
        let statement = LetStatement(variableName: identifier.lastPart,type: variableType,expression: expression)
        statement.addDeclaration(location)
        if !alreadyDefined
            {
            let variable = Variable(name: identifier.lastPart,type: variableType,expression: expression)
            variable.addDeclaration(location)
            parser.currentScope.addNode(variable)
            }
        block.addStatement(statement)
        }
        
    public init(variableName: String,type: TypeNode?,expression: Expression?)
        {
        self.variableName = variableName
        self.type = type
        self.expression = expression
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as? Expression
        self.type = coder.decodeObject(forKey: "type") as? TypeNode
        self.variableName = coder.decodeObject(forKey: "variableName") as! String
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        coder.encode(self.type,forKey: "type")
        coder.encode(self.variableName,forKey: "variableName")
        super.encode(with: coder)
        }
    }
