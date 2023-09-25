//
//  TextToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 25/09/2023.
//

import Foundation

public class TextToken: Token
    {
    public override var isTextValue: Bool
        {
        true
        }
        
    public override var isTextToken: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorText
        }
        
    public override var tokenType: TokenType
        {
        .literalText
        }
        
    public override var tokenName: String
        {
        "TextToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.text(matchString)
        }
    }
