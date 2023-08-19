//
//  HandleStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class HandleStatement: Statement
    {
    private var inductionVariable: Variable
    private var handlerBlock: Block
    private var signals: Strings
    
    public init(signals: Strings,handlerBlock: Block,inductionVariable: Variable)
        {
        self.inductionVariable = inductionVariable
        self.signals = signals
        self.handlerBlock = handlerBlock
        super.init()
        }
    
    required init(coder: NSCoder)
        {
        self.inductionVariable = coder.decodeObject(forKey: "inductionVariable") as! Variable
        self.signals = coder.decodeObject(forKey: "signals") as! Strings
        self.handlerBlock = coder.decodeObject(forKey: "handlerBlock") as! Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.inductionVariable,forKey: "inductionVariable")
        coder.encode(self.signals,forKey: "signals")
        coder.encode(self.handlerBlock,forKey: "handlerBlock")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var symbols = Symbols()
        parser.parseParentheses
            {
            repeat
                {
                parser.parseComma()
                if parser.token.isSymbolValue
                    {
                    symbols.append(parser.token.symbolValue)
                    parser.nextToken()
                    }
                else
                    {
                    parser.lodgeIssue( code: .symbolExpected, location: location)
                    }
                }
            while parser.token.isComma && !parser.token.isEnd
            }
        var identifier: String!
        var handleBlock: Block!
        var variable: Variable!
        parser.parseBraces
            {
            if !parser.token.isInto
                {
                parser.lodgeIssue( code: .intoExpected, location: location)
                }
            else
                {
                parser.nextToken()
                }
            parser.parseParentheses
                {
                if !parser.token.isIdentifier
                    {
                    parser.lodgeIssue( code: .identifierExpected, location: location)
                    identifier = Argon.nextIndex(named: "symbolValue")
                    }
                else
                    {
                    identifier = parser.token.identifier.lastPart
                    parser.nextToken()
                    }
                }
            handleBlock = Block()
            variable = Variable(name: identifier,type: ArgonModule.shared.symbolType,expression: nil)
            handleBlock.addLocal(variable)
            Block.parseBlockInner(block: handleBlock,using: parser)
            }
        let statement = HandleStatement(signals: symbols, handlerBlock: handleBlock,inductionVariable: variable)
        statement.addDeclaration(location)
        statement.inductionVariable = variable
        block.addStatement(statement)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(handleStatement: self)
        self.inductionVariable.accept(visitor: visitor)
        self.handlerBlock.accept(visitor: visitor)
        visitor.exit(handleStatement: self)
        }
    }
