//
//  Parser.swift
//  Argon
//
//  Created by Vincent Coetzee on 25/07/2023.
//

import Foundation

public protocol PrefixParser
    {
    func parse(parser: ArgonParser,token: Token) -> Expression
    }
    
public protocol InfixParser
    {
    var precedence: Int { get }
    func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
    }

public class IdentifierParser: PrefixParser
    {
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        var value = ValueBox.none
        let identifier = token.identifier
        if parser.isApplying
            {
            if let object = parser.currentScope.lookupNode(atIdentifier: identifier)
                {
                value = object.valueBox
                }
            else
                {
                parser.lodgeIssue(phase: .application,code: .undefinedSymbol,message: "Undefined symbol '\(identifier.description)'",location: location)
                }
            }
        parser.nextToken()
        let expression = IdentifierExpression(identifier: identifier)
        expression.setIdentifierValue(value)
        return(expression)
        }
    }

public class PrefixOperatorParser: PrefixParser
    {
    private let precedence: Int
    
    public init(precedence: Int)
        {
        self.precedence = precedence
        }
        
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        parser.nextToken()
        return(PrefixExpression(operator: token.tokenType,right: parser.parseExpression(precedence: self.precedence)))
        }
    }
    
public class LiteralParser: PrefixParser
    {
    public func parse(parser: ArgonParser,token: Token) -> Expression
        {
        let valueBox = token.valueBox
        parser.nextToken()
        return(LiteralExpression(value: valueBox))
        }
    }

public class PostfixOperatorParser: InfixParser
    {
    public let precedence: Int
    
    public init(precedence: Int)
        {
        self.precedence = precedence
        }
        
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        parser.nextToken()
        return(PostfixExpression(left: left,operator: token.tokenType))
        }
    }

public class AssignmentParser: InfixParser
    {
    public let precedence = Precedence.assignment
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        let right = parser.parseExpression(precedence: Precedence.assignment - 1)
        if !left.isRValue
            {
            parser.lodgeIssue(phase: .declaration, code: .lValueExpectedOnLeft,location: location)
            }
        return(AssignmentExpression(left: left, right: right))
        }
    }

public class BinaryOperatorParser: InfixParser
    {
    public let precedence: Int
    private let isRightAssociative: Bool
    
    public init(precedence: Int,isRightAssociative: Bool)
        {
        self.precedence = precedence
        self.isRightAssociative = isRightAssociative
        }
        
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let right = parser.parseExpression(precedence: Precedence.assignment - (self.isRightAssociative ? 1 : 0))
        return(BinaryExpression(left: left, operator: token.tokenType, right: right))
        }
    }
    
public class GroupParser: PrefixParser
    {
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        let expression = parser.parseExpression(precedence: 0)
        if parser.token.isRightParenthesis
            {
            parser.nextToken()
            }
        else
            {
            parser.lodgeIssue(phase: .declaration, code: .rightParenthesisExpected,location: location)
            }
        return(expression)
        }
    }
    
public class TernaryParser: InfixParser
    {
    public let precedence = Precedence.ternary
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        let then = parser.parseExpression(precedence: 0)
        if !parser.token.isColon
            {
            parser.lodgeIssue(phase: .declaration, code: .colonExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        let `else` = parser.parseExpression(precedence: Precedence.ternary - 1)
        return(TernaryExpression(operator: .ternary, then: then, else:  `else`))
        }
    }

public class MethodInvocationParser: InfixParser
    {
    public let precedence = Precedence.invocation
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        var methodName = ""
        if !token.isIdentifier
            {
            parser.lodgeIssue(phase: .declaration,code: .identifierExpected,location: location)
            methodName = Argon.nextIndex(named: "METH")
            }
        else
            {
            methodName = parser.token.identifier.lastPart
            parser.nextToken()
            }
        var arguments = Arguments()
        parser.nextToken()
        if !parser.token.isRightParenthesis
            {
            while !parser.token.isRightParenthesis && parser.token.isComma
                {
                if parser.token.isComma
                    {
                    parser.nextToken()
                    }
                arguments.append(parser.parseArgument())
                }
            }
        if parser.token.isRightParenthesis
            {
            parser.nextToken()
            }
        else
            {
            parser.lodgeIssue(phase: .declaration,code: .rightParenthesisExpected,location: location)
            }
        return(MethodInvocationExpression(methodName: methodName,arguments: arguments))
        }
    }

public struct ArrayReferenceParser: InfixParser
    {
    public let precedence = Precedence.arrayAccess
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        let index = parser.parseExpression(precedence: 0)
        if !parser.token.isRightBracket
            {
            parser.lodgeIssue(phase: .declaration,code: .rightBracketExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        return(ArrayAccessExpression(array: left,memberIndex: index))
        }
    }

public struct ClosureParser: PrefixParser
    {
    public let precedence: Int
    
    public init(precedence: Int)
        {
        self.precedence = precedence
        }
        
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        if !parser.token.isInto
            {
            parser.lodgeIssue(phase: .declaration, code: .intoExpected, location: location)
            }
        else
            {
            parser.nextToken()
            }
        var name: String!
        var parameters = Parameters()
        parser.parseParentheses
            {
            repeat
                {
                parser.parseComma()
                if !parser.token.isIdentifier
                    {
                    parser.lodgeIssue(phase: .declaration, code: .identifierExpected, location: location)
                    name = Argon.nextIndex(named: "ID")
                    }
                else
                    {
                    name = parser.token.identifier.lastPart
                    parser.nextToken()
                    }
                if parser.token.isScope
                    {
                    parser.nextToken()
                    }
                else
                    {
                    parser.lodgeIssue(phase: .declaration, code: .scopeOperatorExpected, location: location)
                    }
                let type = parser.parseType()
                parameters.append(Parameter(externalName: name, internalName: name, type: type))
                }
            while !parser.token.isEnd && !parser.token.isRightParenthesis
            }
        let block = Block()
        Block.parseBlockInner(block: block,using: parser)
        return(ClosureExpression(block: block,parameters: parameters))
        }
    }
