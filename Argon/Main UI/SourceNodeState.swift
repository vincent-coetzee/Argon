//
//  SourceNodeState.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/09/2023.
//

import Foundation

public struct SourceNodeState: OptionSet
    {
    public static let showingIssues = SourceNodeState(rawValue: 1 << 0)
    public static let showingInferredTypes = SourceNodeState(rawValue: 1 << 1)
    
    public var rawValue: Int = 0
    
    public init(rawValue: Int)
        {
        self.rawValue = rawValue
        }
    }
