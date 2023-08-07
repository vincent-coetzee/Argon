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

    public override var styleElement: StyleElement
        {
        .colorDate
        }
        
    public override var tokenType: TokenType
        {
        .literalDate
        }
        
    public override var tokenName: String
        {
        "DateToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.date(Argon.Date(string: self.matchString))
        }
    }
