//
//  ProjectControllerState.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/10/2023.
//

import Foundation

public struct ProjectEditorState: OptionSet
    {
    public static let kShowIssues = ProjectEditorState(rawValue: 1 << 1)
    public static let kShowTypes = ProjectEditorState(rawValue: 1 << 2)
    
    public var rawValue: UInt64 = 0
    
    public init(rawValue: UInt64)
        {
        self.rawValue = rawValue
        }
    }
