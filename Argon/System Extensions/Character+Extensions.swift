//
//  Character+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/09/2023.
//

import Foundation

extension Character
    {
    public var isEOF: Bool
        {
        self.asciiValue == 0
        }
        
    public var bracketKind: BracketMatcher.BracketKind
        {
        if self == "{" || self == "}"
            {
            return(.brace)
            }
        if self == "[" || self == "]"
            {
            return(.square)
            }
        if self == "(" || self == ")"
            {
            return(.parenthesis)
            }
        if self == "<" || self == ">"
            {
            return(.brocket)
            }
        fatalError("This should not have been called on a character that was not a bracket.")
        }
        
    public var isBracket: Bool
        {
        self == "{" || self == "}" || self == "[" || self == "]" || self == "(" || self == ")" || self == "<" || self == ">"
        }
    }
