//
//  TimeToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class TimeToken: Token
    {
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var timeValue: Argon.Time
        {
        Argon.Time(string: self.matchString)
        }

    public override var styleElement: StyleElement
        {
        .colorDate
        }
        
    public override var tokenType: TokenType
        {
        .literalTime
        }
        
    public override var tokenName: String
        {
        "TimeToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.time(Argon.Time(string: self.matchString))
        }
    }
