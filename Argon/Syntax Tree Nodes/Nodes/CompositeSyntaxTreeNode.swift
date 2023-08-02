//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation
    
public class CompositeSyntaxTreeNode: SyntaxTreeNode,Scope
    {
    internal var containedNodes: Array<SyntaxTreeNode> = []
    
    public func addNode(_ symbol: SyntaxTreeNode)
        {
        self.containedNodes.append(symbol)
        symbol.setParent(self)
        }
        
    public func lookupNode(atName name: String) -> SyntaxTreeNode?
        {
        for node in self.containedNodes
            {
            if node.name == name
                {
                return(node)
                }
            }
        return(self.module.lookupNode(atName: name))
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)\(type(of: self))(\(self.name))")
        let newIndent = indent + "\t"
        for node in self.containedNodes
            {
            node.dump(indent: newIndent)
            }
        }
    }
