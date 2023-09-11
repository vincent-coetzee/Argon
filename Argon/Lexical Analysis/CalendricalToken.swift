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
        let scanner = Scanner(string: self.matchString)
//        let day = scanner.scanInt()
        let delimeter = scanner.scanCharacter()
        if delimeter == ":"
            {
            return(true)
            }
        return(false)
        }
        
    public var isDate: Bool
        {
        let scanner = Scanner(string: self.matchString)
//        let day = scanner.scanInt()
        let delimeter = scanner.scanCharacter()
        if delimeter == "/"
            {
            return(true)
            }
        return(false)
        }
        
    public var isDateTime: Bool
        {
        let scanner = Scanner(string: self.matchString)
//        let day = scanner.scanInt()
        var delimeter = scanner.scanCharacter()
        if delimeter == ":"
            {
            return(false)
            }
        guard delimeter == "/" else
            {
            return(false)
            }
//        let month = scanner.scanInt()
        delimeter = scanner.scanCharacter()
        guard delimeter == "/" else
            {
            return(false)
            }
//        let year = scanner.scanInt()
        guard !scanner.isAtEnd else
            {
            return(false)
            }
//        delimeter = scanner.scanCharacter()
        guard delimeter == " " else
            {
            return(false)
            }
//        let hour = scanner.scanInt()
        delimeter = scanner.scanCharacter()
        guard delimeter == ":" else
            {
            return(false)
            }
//        let minute = scanner.scanInt()
        delimeter = scanner.scanCharacter()
        guard delimeter == ":" else
            {
            return(false)
            }
//        let second = scanner.scanInt()
        delimeter = scanner.scanCharacter()
        if delimeter == ":"
            {
//            let milliseconds = scanner.scanInt()
            delimeter = scanner.scanCharacter()
            }
        guard delimeter == ")" else
            {
            return(false)
            }
        return(true)
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
