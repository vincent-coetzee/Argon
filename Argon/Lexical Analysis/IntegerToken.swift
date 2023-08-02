//
//  IntegerToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class IntegerToken: Token
    {
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var operand: Operand
        {
        .integer(Argon.Integer(self.matchString)!)
        }
        
    public override var isOperand: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorInteger
        }
        
    public override var tokenType: TokenType
        {
        .literalInteger
        }
        
    public override var tokenName: String
        {
        "IntegerToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.integer(Argon.Integer(matchString)!)
        }
    }
