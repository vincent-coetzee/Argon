//
//  CommentToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

public class CommentToken: Token
    {
    public override var styleElement: StyleElement
        {
        .colorComment
        }
        
    public override var tokenType: TokenType
        {
        .comment
        }
        
    public override var tokenName: String
        {
        "CommentToken"
        }
        
    public override var isCommentToken: Bool
        {
        true
        }
    }
