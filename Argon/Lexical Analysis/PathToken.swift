//
//  PathToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class PathToken: Token
    {
    public override var isPathValue: Bool
        {
        true
        }
        
    public override var pathValue: String
        {
        self.matchString
        }
    }
