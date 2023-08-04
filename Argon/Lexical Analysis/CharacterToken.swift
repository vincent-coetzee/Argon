//
//  CharacterToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class CharacterToken: Token
    {
    public override var isOperand: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorCharacter
        }
        
    public override var tokenType: TokenType
        {
        .literalCharacter
        }
        
    public override var tokenName: String
        {
        "CharacterToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.character(Argon.Character(matchString)!)
        }
    }
