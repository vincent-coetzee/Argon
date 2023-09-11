//
//  LoopStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/09/2023.
//

import Foundation

public class LoopStatement: Block
    {
    private let initializers: InductionVariables
    private let adjustments: Expressions
    private let termination: Expression
    
    public init(initializers: InductionVariables,adjustments: Expressions,termination: Expression)
        {
        self.initializers = initializers
        self.adjustments = adjustments
        self.termination = termination
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.initializers = coder.decodeObject(forKey: "initializers") as! InductionVariables
        self.adjustments = coder.decodeObject(forKey: "adjustments") as! Expressions
        self.termination = coder.decodeObject(forKey: "termination") as! Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.initializers,forKey: "initializers")
        coder.encode(self.adjustments,forKey: "adjustments")
        coder.encode(self.termination,forKey: "termination")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var initializers = InductionVariables()
        var adjustments = Expressions()
        var termination: Expression!
        parser.parseParentheses
            {
            initializers = self.parseInitializers(using: parser)
            parser.parseSemicolon()
            adjustments = self.parseAdjustments(using: parser)
            parser.parseSemicolon()
            termination = parser.parseExpression()
            }
        let statement = LoopStatement(initializers: initializers, adjustments: adjustments, termination: termination)
        parser.parseBraces
            {
            Block.parseBlockInner(block: statement, using: parser)
            }
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
        
    private class func parseInitializers(using parser: ArgonParser) -> InductionVariables
        {
        var initializers = InductionVariables()
        while !parser.token.isSemicolon && !parser.token.isEnd
            {
            initializers.append(self.parseInductionVariableInitialization(using: parser))
            parser.parseComma()
            }
        if parser.token.isSemicolon
            {
            parser.nextToken()
            }
        return(initializers)
        }
        
    private class func parseInductionVariableInitialization(using parser: ArgonParser) -> InductionVariable
        {
        let location = parser.token.location
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected)
        var type: TypeNode?
        var expression: Expression?
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
        let variable = InductionVariable(name: identifier.lastPart, type: type, expression: expression)
        variable.addDeclaration(location)
        return(variable)
        }
        
    private class func parseAdjustments(using parser: ArgonParser) -> Expressions
        {
        var expressions = Expressions()
        repeat
            {
            parser.parseComma()
            expressions.append(parser.parseExpression())
            }
        while parser.token.isComma && !parser.token.isEnd
        return(expressions)
        }
    
    public override func accept(visitor: Visitor)
        {
        visitor.enter(loopStatement: self)
        visitor.exit(loopStatement: self)
        }
    }
