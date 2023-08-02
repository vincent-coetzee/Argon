//
//  Statement.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class Statement: SyntaxTreeNode
    {   
    public init()
        {
        super.init(name: "")
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

public typealias Statements = Array<Statement>
