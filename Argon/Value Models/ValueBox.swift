//
//  ValueBox.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/07/2023.
//

import Foundation

public enum ValueBox: Hashable
    {
    public static func == (lhs: ValueBox, rhs: ValueBox) -> Bool
        {
        switch(lhs,rhs)
            {
            case(.none,.none):
                return(true)
            case(.void,.void):
                return(true)
            case(.integer(let integer1),.integer(let integer2)):
                return(integer1 == integer2)
            case(.uInteger(let integer1),.uInteger(let integer2)):
                return(integer1 == integer2)
            case(.string(let integer1),.string(let integer2)):
                return(integer1 == integer2)
            case(.path(let integer1),.path(let integer2)):
                return(integer1 == integer2)
            case(.boolean(let integer1),.boolean(let integer2)):
                return(integer1 == integer2)
            case(.character(let integer1),.character(let integer2)):
                return(integer1 == integer2)
            case(.byte(let integer1),.byte(let integer2)):
                return(integer1 == integer2)
            case(.atom(let integer1),.atom(let integer2)):
                return(integer1 == integer2)
            case(.float(let integer1),.float(let integer2)):
                return(integer1 == integer2)
            case(.method(let integer1),.method(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.function(let integer1),.method(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.class(let integer1),.class(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.enumeration(let integer1),.enumeration(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.enumerationCase(let integer1),.enumerationCase(let integer2)):
                return(integer1 == integer2)
            case(.identifier(let integer1),.identifier(let integer2)):
                return(integer1 == integer2)
            case(.variable(let integer1),.variable(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.constant(let integer1),.constant(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.date(let integer1),.date(let integer2)):
                return(integer1 == integer2)
            case(.time(let integer1),.time(let integer2)):
                return(integer1 == integer2)
            case(.dateTime(let integer1),.dateTime(let integer2)):
                return(integer1 == integer2)
            default:
                return(false)
            }
        }
    
    case none
    case integer(Int64)
    case uInteger(UInt64)
    case string(String)
    case path(String)
//    case enumerationInstance(EnumerationType,EnumerationCase)
    case boolean(Bool)
    case void
    case character(UInt16)
    case byte(UInt8)
    case atom(String)
    case float(Argon.Float)
    case method(MethodType)
    case function(FunctionType)
    case `class`(ClassType)
    case enumeration(EnumerationType)
    case enumerationCase(EnumerationCase)
    case identifier(Identifier)
    case variable(Variable)
    case constant(Constant)
    case date(Argon.Date)
    case time(Argon.Time)
    case dateTime(Argon.DateTime)
    case text(String)
    
    public var isAtom: Bool
        {
        switch(self)
            {
            case .atom:
                return(true)
            default:
                return(false)
            }
        }
        
    public var atom: String
        {
        switch(self)
            {
            case .atom(let symbol):
                return(symbol)
            default:
                fatalError("atom called on ValueBox and it's not an atom.")
            }
        }
        
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
        
    public func hash(into hasher:inout Hasher)
        {
        switch(self)
            {
            case(.none):
                hasher.combine("NONE")
            case(.void):
                hasher.combine("VOID")
            case(.integer(let integer1)):
                hasher.combine("INTEGER")
                hasher.combine(integer1)
            case(.uInteger(let integer1)):
                hasher.combine("UINTEGER")
                hasher.combine(integer1)
            case(.string(let integer1)):
                hasher.combine("STRING")
                hasher.combine(integer1)
            case(.path(let integer1)):
                hasher.combine("PATH")
                hasher.combine(integer1)
            case(.boolean(let integer1)):
                hasher.combine("BOOLEAN")
                hasher.combine(integer1)
            case(.character(let integer1)):
                hasher.combine("CHARACTER")
                hasher.combine(integer1)
            case(.byte(let integer1)):
                hasher.combine("BYTE")
                hasher.combine(integer1)
            case(.atom(let integer1)):
                hasher.combine("ATOM")
                hasher.combine(integer1)
            case(.float(let integer1)):
                hasher.combine("FLOAT")
                hasher.combine(integer1)
            case(.method(let integer1)):
                hasher.combine("METHOD")
                hasher.combine(integer1.typeHash)
            case(.class(let integer1)):
                hasher.combine("CLASS")
                hasher.combine(integer1.typeHash)
            case(.enumeration(let integer1)):
                hasher.combine("ENUMERATION")
                hasher.combine(integer1.typeHash)
            case(.enumerationCase(let integer1)):
                hasher.combine("ENUMERATIONCASE")
                hasher.combine(integer1)
            case(.identifier(let integer1)):
                hasher.combine("IDENTIFIER")
                hasher.combine(integer1)
            case(.variable(let integer1)):
                hasher.combine("VARIABLE")
                hasher.combine(integer1)
            case(.constant(let integer1)):
                hasher.combine("CONSTANT")
                hasher.combine(integer1)
            case(.date(let integer1)):
                hasher.combine("DATE")
                hasher.combine(integer1)
            case(.time(let integer1)):
                hasher.combine("DATE")
                hasher.combine(integer1)
            case(.dateTime(let integer1)):
                hasher.combine("DATETIME")
                hasher.combine(integer1)
            case(.function(let integer1)):
                hasher.combine("FUNCTION")
                hasher.combine(integer1.typeHash)
            case(.text(let integer1)):
                hasher.combine("TEXT")
                hasher.combine(integer1)
            }
        }
    }
