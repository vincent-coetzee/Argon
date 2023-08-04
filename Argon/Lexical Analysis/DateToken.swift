//
//  DateToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class DateToken: Token
    {
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var dateValue: Argon.Date
        {
        Argon.Date(string: self.matchString)
        }
        
    public override var isOperand: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorDate
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
        ValueBox.integer(Argon.Integer(self.matchString)!)
        }
    }
