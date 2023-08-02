//
//  ParseOperand.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/05/2023.
//

import Foundation

public enum Operand
    {
    case integer(Argon.Integer)
    case float(Argon.Float)
    case string(Argon.String)
    case boolean(Argon.Boolean)
    case byte(Argon.Byte)
    case character(Argon.Character)
    case variable(Argon.String)
    case method(Argon.String)
    case identifier(Identifier)
    }
