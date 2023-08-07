//
//  StringToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class StringToken: Token
    {
    public override var isOperand: Bool
        {
        true
        }
        
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var isStringValue: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorString
        }
        
    public override var tokenType: TokenType
        {
        .literalString
        }
        
    public override var tokenName: String
        {
        "StringToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.string(matchString)
        }
    }
