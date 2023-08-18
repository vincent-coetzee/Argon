//
//  DateTimeToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class DateTimeToken: Token
    {
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var dateTimeValue: Argon.DateTime
        {
        let pieces = self.matchString.components(separatedBy: " ")
        if pieces.count != 2
            {
            return(Argon.DateTime(date: Argon.Date.nullDate,time: Argon.Time.nullTime))
            }
        let date = Argon.Date(matchString: pieces[0])
        let time = Argon.Time(matchString: pieces[1])
        return(Argon.DateTime(date: date,time: time))
        }

    public override var styleElement: StyleElement
        {
        .colorDate
        }
        
    public override var tokenType: TokenType
        {
        .literalDateTime
        }
        
    public override var tokenName: String
        {
        "DateTimeToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.dateTime(self.dateTimeValue)
        }
    }
