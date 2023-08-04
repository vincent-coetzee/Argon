//
//  FloatToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class FloatToken: Token
    {
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
        .colorFloat
        }
        
    public override var tokenType: TokenType
        {
        .literalFloat
        }
        
    public override var tokenName: String
        {
        "FloatToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.float(Argon.Float(matchString)!)
        }
    }
