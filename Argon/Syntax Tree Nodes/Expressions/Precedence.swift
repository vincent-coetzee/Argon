//
//  Precedence.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public struct Precedence
    {
    public static let assignment        = 100
    public static let ternary           = 200
    public static let boolean           = 300
    public static let logical           = 400
    public static let addition          = 500
    public static let multiplication    = 600
    public static let power             = 700
    public static let operatorAssign    = 800
    public static let relational        = 900
    public static let prefix            = 1000
    public static let postfix           = 1100
    public static let closure           = 1200
    public static let invocation        = 1300
    public static let arrayAccess       = 1400
    public static let memberAccess      = 1500
    }

