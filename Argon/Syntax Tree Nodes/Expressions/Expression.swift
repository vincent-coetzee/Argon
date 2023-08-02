//
//  Expression.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/01/2023.
//

import Foundation

public class Expression: SyntaxTreeNode
    {
    public var isRValue: Bool
        {
        false
        }
        
    public var isLValue: Bool
        {
        false
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public init()
        {
        super.init(name: "")
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
    }
