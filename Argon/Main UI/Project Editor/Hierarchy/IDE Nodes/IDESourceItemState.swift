//
//  SourceState.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/10/2023.
//

import Foundation

public struct IDESourceItemState: OptionSet
    {
    public static let kNothing = IDESourceItemState(rawValue: 1 << 0)
    public static let kAdded = IDESourceItemState(rawValue: 1 << 1)
    public static let kModified = IDESourceItemState(rawValue: 1 << 2)
    
    public var rawValue: UInt8
    
    public init(rawValue: UInt8)
        {
        self.rawValue = rawValue
        }
    }
