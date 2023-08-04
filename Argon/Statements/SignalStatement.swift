//
//  SignalStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class SignalStatement: Statement
    {
    private let symbol: Argon.Symbol
    
    public init(symbol: Argon.Symbol)
        {
        self.symbol = symbol
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.symbol = coder.decodeObject(forKey: "symbol") as! Argon.Symbol
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
        var symbol: Argon.Symbol!
        parser.parseParentheses
            {
            if !parser.token.isSymbolValue
                {
                parser.lodgeIssue( code: .symbolExpected, location: location)
                symbol = Argon.nextIndex(named: "SYMBOL")
                }
            else
                {
                symbol = parser.token.symbolValue
                parser.nextToken()
                }
            }
        let statement = SignalStatement(symbol: symbol)
        statement.addDeclaration(location)
        block.addStatement(statement)
        }
    }
