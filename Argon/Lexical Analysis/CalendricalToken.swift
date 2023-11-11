//
//  DateTimeToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class CalendricalToken: Token
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

    public var isTime: Bool
        {
        return(Argon.timeRegex.firstMatch(in: self.matchString, range: NSRange(location: 0,length: self.matchString.count)).isNotNil)
        }
        
    public var isDate: Bool
        {
        return(Argon.dateRegex.firstMatch(in: self.matchString, range: NSRange(location: 0,length: self.matchString.count)).isNotNil)
        }
        
    public var isDateTime: Bool
        {
        return(Argon.dateTimeRegex.firstMatch(in: self.matchString, range: NSRange(location: 0,length: self.matchString.count)).isNotNil)
        }
        
    public override var styleElement: StyleElement
        {
        .colorCalendrical
        }
        
    public override var tokenType: TokenType
        {
        if self.isTime
            {
            return(.literalTime)
            }
        else if self.isDate
            {
            return(.literalDate)
            }
        else if self.isDateTime
            {
            return(.literalDateTime)
            }
        else
            {
            return(.error)
            }
        }
        
    public override var tokenName: String
        {
        "CalendricalToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.dateTime(self.dateTimeValue)
        }
    }
