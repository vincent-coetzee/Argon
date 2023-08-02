//
//  ValueWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/07/2023.
//

import Foundation

public indirect enum ValueWrapper
    {
    case integer(Argon.Integer)
    case float(Argon.Float)
    case string(Argon.String)
    case symbol(Argon.Symbol)
    case boolean(Argon.Boolean)
    case character(Argon.Character)
    case byte(Argon.Byte)
    case object(ClassType,AnyObject)
    case enumeration(Any)
    }
