//
//  Block.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class Block: Statement
    {
    public static override func parse(using parser: ArgonParser)
        {
        let block = Block()
        parser.currentScope.addSymbol(block)
        parser.pushCurrentScope(block)
        defer
            {
            parser.popCurrentScope()
            }
        parser.parseBraces
            {
            repeat
                {
                self.parseBlockEntry(block: block,using: parser)
                }
            while !parser.token.isRightBrace && !parser.token.isEnd
            }
        }
        
    public static func parseBlockInner(block: Block,using parser: ArgonParser)
        {
        parser.pushCurrentScope(block)
        defer
            {
            parser.popCurrentScope()
            }
        while !parser.token.isRightBrace && !parser.token.isEnd
            {
            self.parseBlockEntry(block: block,using: parser)
            }
        }
        
    public static func parseBlockEntry(block: Block,using parser: ArgonParser)
        {
        switch(parser.token.tokenType)
            {
            case(.identifier):
                AssignmentStatement.parse(into: block,using: parser)
            case(.WHILE):
                WhileStatement.parse(into: block,using: parser)
            case(.TIMES):
                TimesStatement.parse(into: block,using: parser)
            case(.LET):
                LetStatement.parse(into: block,using: parser)
            case(.HANDLE):
                HandleStatement.parse(into: block,using: parser)
            case(.IF):
                IfStatement.parse(into: block,using: parser)
            case(.SELECT):
                SelectStatement.parse(into: block,using: parser)
            case(.REPEAT):
                RepeatStatement.parse(into: block,using: parser)
            case(.SIGNAL):
                SignalStatement.parse(into: block,using: parser)
            case(.FORK):
                ForkStatement.parse(into: block,using: parser)
            case(.FOR):
                ForStatement.parse(into: block,using: parser)
            case(.LOOP):
                LoopStatement.parse(into: block,using: parser)
            case(.RETURN):
                ReturnStatement.parse(into: block,using: parser)
            case(.STATIC):
                StaticStatement.parse(into: block,using: parser)
            default:
                parser.lodgeError(code: .statementExpected,location: parser.token.location)
                parser.nextToken()
            }
        }
        
    public static func parseBlock(using parser: ArgonParser) -> Block
        {
        let block = Block()
        parser.pushCurrentScope(block)
        defer
            {
            parser.popCurrentScope()
            }
        parser.parseBraces
            {
            repeat
                {
                self.parseBlockEntry(block: block,using: parser)
                }
            while !parser.token.isRightBrace && !parser.token.isEnd
            }
        return(block)
        }
        
    public override var containsReturnStatement: Bool
        {
        for statement in self.statements
            {
            if statement.containsReturnStatement
                {
                return(true)
                }
            }
        return(false)
        }
        
    private var statements = Statements()
    private var symbols = Symbols()

    public override init()
        {
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.statements = coder.decodeObject(forKey: "statements") as! Statements
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.statements,forKey: "statements")
        super.encode(with: coder)
        }
        
    public func addStatement(_ statement: Statement)
        {
        self.statements.append(statement)
        statement.setContainer(self)
        }
        
    public func addLocal(_ variable: Variable)
        {
        self.symbols.append(variable)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(block: self)
        for statement in self.statements
            {
            statement.accept(visitor: visitor)
            }
        }
    }
