//
//  ValueBox.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/07/2023.
//

import Foundation

public enum ValueBox
    {
    public var encoding: String
        {
        switch(self)
            {
            case(.integer(let integer)):
                return("D\(integer)_")
            case(.enumerationCase(let aCase)):
                return(aCase.encoding)
            default:
                fatalError("Encoding was called on this ValueBox for a type that is not yet handled.")
            }
        }
        
    case none
    case integer(Int64)
    case uInteger(UInt64)
    case string(String)
    case object(ObjectInstance)
    case enumerationInstance(Enumeration,EnumerationCase)
    case boolean(Bool)
    case void
    case character(UInt16)
    case byte(UInt8)
    case symbol(String)
    case float(Argon.Float)
    case method(Method)
    case `class`(Class)
    case enumeration(Enumeration)
    case enumerationCase(EnumerationCase)
    case identifier(Identifier)
    case variable(Variable)
    case constant(Constant)
    case date(Argon.Date)
    case time(Argon.Time)
    case dateTime(Argon.DateTime)
    
    public var isInteger: Bool
        {
        switch(self)
            {
            case .integer:
                return(true)
            case .uInteger:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isIdentifier: Bool
        {
        switch(self)
            {
            case .identifier:
                return(true)
            default:
                return(false)
            }
        }
    }
