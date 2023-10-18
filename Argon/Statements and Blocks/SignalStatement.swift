//
//  SignalStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class SignalStatement: Statement
    {
    private let symbol: Argon.Atom
    
    public init(symbol: Argon.Atom)
        {
        self.symbol = symbol
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.symbol = coder.decodeObject(forKey: "symbol") as! Argon.Atom
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.symbol,forKey: "symbol")
        super.encode(with: coder)
        }
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var symbol: Argon.Atom!
        parser.parseParentheses
            {
            if !parser.token.isAtomValue
                {
                parser.lodgeError( code: .atomExpected, location: location)
                symbol = Argon.nextIndex(named: "SYMBOL")
                }
            else
                {
                symbol = parser.token.atomValue
                parser.nextToken()
                }
            }
        let statement = SignalStatement(symbol: symbol)
        statement.location = location
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(signalStatement: self)
        }
    }
