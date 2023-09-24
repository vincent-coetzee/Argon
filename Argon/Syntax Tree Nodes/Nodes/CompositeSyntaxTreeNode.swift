//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class CompositeSyntaxTreeNode: SyntaxTreeNode
    {
    init(name: String,parent: SyntaxTreeNode? = nil)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func dump(indent: String)
        {
        fatalError()
        }
    }
