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
        let identifier = token.identifier
        parser.nextToken()
        let expression = IdentifierExpression(identifier: identifier)
        expression.addDeclaration(location)
        guard let symbol = parser.currentScope.lookupNode(atName: identifier.lastPart) else
            {
            parser.lodgeIssue(code: .undefinedSymbol,location: location)
            return(expression)
            }
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
        let location = parser.token.location
        parser.nextToken()
        return(PrefixExpression(operator: token.tokenType,right: parser.parseExpression(precedence: self.precedence)).addDeclaration(location))
        }
    }
    
public class LiteralParser: PrefixParser
    {
    public func parse(parser: ArgonParser,token: Token) -> Expression
        {
        let location = parser.token.location
        let valueBox = token.valueBox
        parser.nextToken()
        return(LiteralExpression(value: valueBox).addDeclaration(location))
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
        let location = parser.token.location
        parser.nextToken()
        return(PostfixExpression(left: left,operator: token.tokenType).addDeclaration(location))
        }
    }

public class AssignmentParser: InfixParser
    {
    public let precedence = Precedence.assignment
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        let right = parser.parseExpression(precedence: Precedence.assignment - 1)
        if !left.isLValue
            {
            parser.lodgeIssue( code: .lValueExpectedOnLeft,location: location)
            }
        return(AssignmentExpression(left: left, right: right).addDeclaration(location))
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
        let location = parser.token.location
        let right = parser.parseExpression(precedence: Precedence.assignment - (self.isRightAssociative ? 1 : 0))
        return(BinaryExpression(left: left, operator: token.tokenType, right: right).addDeclaration(location))
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
            parser.lodgeIssue( code: .rightParenthesisExpected,location: location)
            }
        return(expression.addDeclaration(location))
        }
    }
    
public class MakeParser: PrefixParser
    {
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        var mainExpression: Expression!
        var arguments = Expressions()
        parser.parseParentheses
            {
            mainExpression = parser.parseExpression(precedence: 0)
            while parser.token.isComma && !parser.token.isEnd
                {
                parser.parseComma()
                arguments.append(parser.parseExpression())
                }
            }
        let expression = MakeExpression(classExpression: mainExpression,arguments: arguments)
        return(expression.addDeclaration(location))
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
            parser.lodgeIssue( code: .colonExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        let `else` = parser.parseExpression(precedence: Precedence.ternary - 1)
        return(TernaryExpression(operator: .ternary, then: then, else:  `else`).addDeclaration(location))
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
            parser.lodgeIssue(code: .identifierExpected,location: location)
            methodName = Argon.nextIndex(named: "METHOD")
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
            parser.lodgeIssue(code: .rightParenthesisExpected,location: location)
            }
        return(MethodInvocationExpression(methodName: methodName,arguments: arguments).addDeclaration(location))
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
            parser.lodgeIssue(code: .rightBracketExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        return(ArrayAccessExpression(array: left,memberIndex: index).addDeclaration(location))
        }
    }
    
public struct MemberAccessParser: InfixParser
    {
    public let precedence = Precedence.memberAccess
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = token.location
        let `operator` = token.tokenType
        let member = parser.parseExpression(precedence: 0)
        return(MemberAccessExpression(left: left,operator: `operator`,right: member).addDeclaration(location))
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
            parser.lodgeIssue( code: .intoExpected, location: location)
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
                    parser.lodgeIssue( code: .identifierExpected, location: location)
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
                    parser.lodgeIssue( code: .scopeOperatorExpected, location: location)
                    }
                let type = parser.parseType()
                parameters.append(Parameter(definedByPosition: true,externalName: name, internalName: name, type: type))
                }
            while !parser.token.isEnd && !parser.token.isRightParenthesis
            }
        let block = Block()
        Block.parseBlockInner(block: block,using: parser)
        return(ClosureExpression(block: block,parameters: parameters).addDeclaration(location))
        }
    }
