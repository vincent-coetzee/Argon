//
//  ByteToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class ByteToken: Token
    {
    public override var isOperand: Bool
        {
        true
        }
        
    public override var operand: Operand
        {
        .byte(Argon.Byte(self.matchString)!)
        }
        
    public override var styleElement: StyleElement
        {
        .colorByte
        }
        
    public override var tokenType: TokenType
        {
        .literalByte
        }
        
    public override var tokenName: String
        {
        "ByteToken"
        }
        
    public override var valueBox: ValueBox
        {
        ValueBox.byte(Argon.Byte(matchString)!)
        }
    }
