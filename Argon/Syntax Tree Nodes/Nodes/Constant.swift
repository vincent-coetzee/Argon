//
//  ConstantNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation
    
public class Constant: Variable
    {
    public class override func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        let name = identifier.lastPart
        var expression: Expression?
        var type: TypeNode?
        if parser.token.isScope
            {
            parser.nextToken()
            type = parser.parseType()
            if parser.token.isAssign
                {
                parser.nextToken()
                expression = parser.parseExpression(precedence: 0)
                }
            }
        else if parser.token.isAssign
            {
            parser.nextToken()
            expression = parser.parseExpression(precedence: 0)
            }
        else
            {
            parser.lodgeIssue(phase: .declaration,code: .constantMustBeInitialised,message: "Constants must be initialised at the same time that they are declared.",location: location)
            expression = Expression()
            }
        let constant = Constant(name: name,type: type,expression: expression!)
        if parser.isDeclaring
            {
            parser.addNode(constant)
            }
        }
    }

public typealias Constants = Array<Constant>
