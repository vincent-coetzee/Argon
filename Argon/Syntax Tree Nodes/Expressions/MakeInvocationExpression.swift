//
//  MakeInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class MakeInvocationExpression: MethodInvocationExpression
    {
    public init(arguments: Arguments)
        {
        super.init(methodName: "MAKE",arguments: arguments)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
    }
