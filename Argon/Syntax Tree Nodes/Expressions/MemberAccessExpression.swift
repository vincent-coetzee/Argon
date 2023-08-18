//
//  MemberAccessExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/08/2023.
//

import Foundation

public class MemberAccessExpression: BinaryExpression
    {
    public override var lValue: Expression?
        {
        self.left.lValue
        }
    }
