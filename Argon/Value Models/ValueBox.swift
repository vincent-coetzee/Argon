//
//  ValueBox.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/07/2023.
//

import Foundation

public enum ValueBox
    {
    case none
    case integer(Int64)
    case uInteger(UInt64)
    case string(String)
    case object(ObjectInstance)
    case enumerationInstance(EnumerationInstance)
    case boolean(Bool)
    case void
    case character(UInt16)
    case byte(UInt8)
    case symbol(String)
    case float(Argon.Float)
    case method(Method)
    case `class`(ClassType)
    case enumeration(EnumerationType)
    }
