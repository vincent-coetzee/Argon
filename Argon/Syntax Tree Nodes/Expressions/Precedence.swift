//
//  Precedence.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public struct Precedence
    {
    public static let none              = 0
    public static let assignment        = 200
    public static let ternary           = 300
    public static let boolean           = 400
    public static let logical           = 500
    public static let addition          = 600
    public static let multiplication    = 700
    public static let power             = 800
    public static let operatorAssign    = 900
    public static let relational        = 1000
    public static let prefix            = 1100
    public static let postfix           = 1200
    public static let closure           = 1300
    public static let invocation        = 1400
    public static let arrayAccess       = 1500
    public static let memberAccess      = 1600
    }

