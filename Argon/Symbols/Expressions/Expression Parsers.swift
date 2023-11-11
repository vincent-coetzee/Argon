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
        if identifier.lastPart == "nil"
            {
            return(NilExpression())
            }
        let expression = IdentifierExpression(identifier: identifier)
        expression.location = location
        expression.addDeclaration(location)
        guard let symbol = parser.currentScope.lookupSymbol(atName: identifier.lastPart) else
            {
            parser.lodgeError(code: .undefinedSymbol,message: "The symbol '\(identifier.description)' is undefined.",location: location)
            return(expression)
            }
        expression.setIdentifierValue(symbol.valueBox)
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
        let expression = PrefixExpression(operator: token.tokenType,right: parser.parseExpression(precedence: self.precedence)).addDeclaration(location)
        expression.location = location
        let method = parser.currentScope.lookupMethod(atName: token.matchString)
        if method.isNil
            {
            parser.lodgeError(code: .multimethodNotFound,location: location)
            }
        expression.setMethod(method)
        return(expression)
        }
    }
    
public class LiteralParser: PrefixParser
    {
    public func parse(parser: ArgonParser,token: Token) -> Expression
        {
        let location = parser.token.location
        let valueBox = token.valueBox
        parser.nextToken()
        if parser.token.isLeftParenthesis
            {
            return(self.parseAtomExpression(parser: parser,atom: valueBox.atom))
            }
        if valueBox.isAtom
            {
            let expression = AtomExpression(atom: valueBox.atom)
            expression.location = location
            return(expression)
            }
        let expression = LiteralExpression(value: valueBox).addDeclaration(location)
        expression.location = location
        return(expression)
        }
        
    private func parseAtomExpression(parser: ArgonParser,atom: String) -> Expression
        {
        let location = parser.token.location
        var values = Expressions()
        parser.nextToken()
        repeat
            {
            parser.parseComma()
            values.append(parser.parseExpression())
            }
        while parser.token.isComma && !parser.token.isEnd
        if parser.token.isRightParenthesis
            {
            parser.nextToken()
            }
        let expression = AtomExpression(atom: atom,values: values)
        expression.location = location
        return(expression)
        }
    }

public class PseudoVariableParser: PrefixParser
    {
    public func parse(parser: ArgonParser,token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        if parser.token.tokenType == .self
            {
            return(PseudoVariableExpression(pseudoVariable: .self))
            }
        return(PseudoVariableExpression(pseudoVariable: .super))
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
        let expression = PostfixExpression(left: left,operator: token.tokenType).addDeclaration(location)
        expression.setMethod(parser.currentScope.lookupMethod(atName: token.matchString))
        expression.location = location
        return(expression)
        }
    }

public class AssignmentParser: InfixParser
    {
    public let precedence = Precedence.assignment
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        let right = parser.parseExpression(precedence: Precedence.assignment - 1)
        let expression = AssignmentExpression(left: left, right: right).addDeclaration(location)
        expression.location = location
        return(expression)
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
        let expression = BinaryExpression(left: left, operator: token.tokenType, right: right).addDeclaration(location)
        let method = parser.currentScope.lookupMethod(atName: token.matchString)
        if method.isNil
            {
            parser.lodgeError(code: .multimethodNotFound,location: location)
            }
        expression.setMethod(method)
        expression.location = location
        return(expression)
        }
    }
    
public class GroupParser: PrefixParser
    {
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        let firstIndex = parser.tokenIndex
        parser.nextToken()
        let expression = parser.parseExpression(precedence: 0)
        var wasTuple = false
        var expressions = Expressions()
        if parser.token.isComma
            {
            wasTuple = true
            expressions.append(expression)
            repeat
                {
                parser.parseComma()
                expressions.append(parser.parseExpression())
                }
            while parser.token.isComma && !parser.token.isEnd
            }
        if parser.token.isRightParenthesis
            {
            parser.nextToken()
            }
        else
            {
            parser.lodgeError(code: .rightParenthesisExpected,location: location)
            }
        if !wasTuple
            {
            expression.addDeclaration(location)
            expression.location = location
            return(expression)
            }
        for index in firstIndex...parser.tokenIndex
            {
            parser.token(atIndex: index)?.setStyleElement(.colorTuple)
            }
        let tuple = TupleExpression(expressions: expressions)
        tuple.addDeclaration(location)
        tuple.location = location
        return(tuple)
        }
    }
    
public class MakeParser: PrefixParser
    {
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        var arguments = Expressions()
        var type: ArgonType!
        parser.parseParentheses
            {
            type = parser.parseType()
            while parser.token.isComma && !parser.token.isEnd
                {
                parser.parseComma()
                arguments.append(parser.parseExpression())
                }
            }
        let expression = MakeExpression(type: type,arguments: arguments)
        expression.location = location
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
            parser.lodgeError( code: .colonExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        let `else` = parser.parseExpression(precedence: Precedence.ternary - 1)
        let expression = TernaryExpression(operator: .ternary, then: then, else:  `else`).addDeclaration(location)
        expression.location = location
        return(expression)
        }
    }

public class MethodInvocationParser: InfixParser
    {
    public let precedence = Precedence.invocation
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        var methodName: Identifier!
        if parser.isNextTokenValid(atOffset: -2),parser.nextToken(atOffset: -2).isIdentifier
            {
            methodName = parser.nextToken(atOffset: -2).identifier
            parser.nextToken(atOffset: -2).setStyleElement(.colorInvocation)
            }
        else
            {
            parser.lodgeError(code: .identifierExpected,location: location)
            methodName = Identifier(string: Argon.nextIndex(named: "METHOD"))
            }
        var arguments = Arguments()
        if !parser.token.isRightParenthesis
            {
            repeat
                {
                parser.parseComma()
                arguments.append(parser.parseArgument())
                }
            while !parser.token.isRightParenthesis && parser.token.isComma
            }
        if parser.token.isRightParenthesis
            {
            parser.nextToken()
            }
        else
            {
            parser.lodgeError(code: .rightParenthesisExpected,location: location)
            }
        arguments.location = location
        let expression = MethodInvocationExpression(methodName: methodName,arguments: arguments).addDeclaration(location)
        if let method = parser.currentScope.lookupMethod(atIdentifier: methodName)
            {
            expression.setMethod(method)
            }
        else
            {
            parser.lodgeError(code: .multimethodNotFound,location: location)
            expression.setMethod(MultimethodType(name: methodName.lastPart))
            }
        expression.location = location
        return(expression)
        }
    }

public struct ArrayReferenceParser: InfixParser
    {
    public let precedence = Precedence.arrayAccess
    
    public func parse(parser: ArgonParser,left: Expression,token: Token) -> Expression
        {
        let location = parser.token.location
        let index = parser.parseExpression(precedence: 0)
        if !parser.token.isRightBracket
            {
            parser.lodgeError(code: .rightBracketExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        let expression = ArrayAccessExpression(array: left,memberIndex: index).addDeclaration(location)
        expression.location = location
        return(expression)
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
        let expression = MemberAccessExpression(left: left,operator: `operator`,right: member).addDeclaration(location)
        expression.location = location
        return(expression)
        }
    }

public struct ClosureParser: PrefixParser
    {
    public let precedence: Int
    
    public init(precedence: Int)
        {
        self.precedence = precedence
        }
        
    //
    // EBNF for clsoures
    //
    //
    // INDUCTION_VARIABLE_DECLARATION := IDENTIFIER [ :: TYPE ]
    // INDUCTION_VARIABLES_DECLARATION := INDUCTION_VARIABLE_DECLARATION | INDUCTION_VARIABLE_DECLARATION ',' INDUCTION_VARIABLE_DECLARATIONS
    // WITH_CLAUSE := ε | 'WITH' '(' INDUCTION_VARIABLE_DECLARATIONS ')'
    // CLOSURE_DECLARATION := '{' WITH_CLAUSE STATEMENTS '}'
    //
    //
    public func parse(parser: ArgonParser, token: Token) -> Expression
        {
        let location = parser.token.location
        parser.nextToken()
        var parameters = Parameters()
        if parser.token.isWith
            {
            parser.nextToken()
            var name: String!
            parser.parseParentheses
                {
                repeat
                    {
                    parser.parseComma()
                    if !parser.token.isIdentifier
                        {
                        parser.lodgeError( code: .identifierExpected, location: location)
                        name = Argon.nextIndex(named: "IDV")
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
                        parser.lodgeError( code: .scopeOperatorExpected, location: location)
                        }
                    let type = parser.parseType()
                    parameters.append(Parameter(definedByPosition: true,externalName: name, internalName: name, type: type))
                    }
                while parser.token.isComma
                }
            }
        let block = Block()
        block.location = location
        parameters.location = location
        Block.parseBlockInner(block: block,using: parser)
        if parser.token.isRightBrace
            {
            parser.nextToken()
            }
        else
            {
            parser.lodgeError(code: .rightBraceExpected,location: location)
            }
        let expression = ClosureExpression(block: block,parameters: parameters).addDeclaration(location)
        expression.location = location
        return(expression)
        }
    }
