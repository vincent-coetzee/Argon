//
//  EndToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/01/2023.
//

import Foundation

public class EndToken: Token
    {
    public override var styleElement: StyleElement
        {
        .colorBackground
        }
        
    public override var isEnd: Bool
        {
        true
        }
        
    public override var tokenType: TokenType
        {
        .end
        }
        
    public override var tokenName: String
        {
        "EndToken"
        }
    }
