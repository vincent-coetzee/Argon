//
//  SeparatorToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/05/2023.
//

import Foundation

public class SeparatorToken: Token
    {
    public override var isComma: Bool
        {
        self.matchString == ","
        }
        
    public override var tokenName: String
        {
        "SeparatorToken"
        }
        
    public override var styleElement: StyleElement
        {
        .colorSeparator
        }
        
    public override var tokenType: TokenType
        {
        .separator
        }
    }
