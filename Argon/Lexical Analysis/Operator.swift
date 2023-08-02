//
//  Operator.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/05/2023.
//

import Foundation

public struct Operator
    {
    public let tokenType: TokenType
    public let precedence: Int
    
    public init(tokenType: TokenType,precedence: Int)
        {
        self.tokenType = tokenType
        self.precedence = precedence
        }
    }
