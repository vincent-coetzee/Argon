//
//  SymbolToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class AtomToken: Token
    {
    public override var atomValue: Argon.Atom
        {
        self.matchString
        }
        
    public override var isAtomValue: Bool
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
        .colorAtom
        }
        
    public override var tokenType: TokenType
        {
        if self.matchString == "#true" || self.matchString == "#false"
            {
            return(.literalBoolean)
            }
        return(.literalAtom)
        }
        
    public override var tokenName: String
        {
        "AtomToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.atom(matchString)
        }
    }
