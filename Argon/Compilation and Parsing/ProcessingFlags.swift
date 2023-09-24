//
//  Flags.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/09/2023.
//

import Foundation

public struct ProcessingFlags: OptionSet
    {
    public typealias RawValue = UInt64
    
    public var rawValue: UInt64
    
    public init(rawValue: UInt64)
        {
        self.rawValue = 0
        }

    public static let semanticsChecked = ProcessingFlags(rawValue: 1 << 0)
    public static let typesInferenced = ProcessingFlags(rawValue: 1 << 1)
    public static let typesChecked = ProcessingFlags(rawValue: 1 << 2)
    }
