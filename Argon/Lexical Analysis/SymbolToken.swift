//
//  SymbolToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class SymbolToken: Token
    {
    public override var symbol: Argon.Symbol
        {
        self.matchString
        }
        
    public override var isSymbol: Bool
        {
        true
        }
        
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var isOperand: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorSymbol
        }
        
    public override var tokenType: TokenType
        {
        if self.matchString == "#true" || self.matchString == "#false"
            {
            return(.literalBoolean)
            }
        return(.literalSymbol)
        }
        
    public override var tokenName: String
        {
        "SymbolToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.symbol(matchString)
        }
    }
