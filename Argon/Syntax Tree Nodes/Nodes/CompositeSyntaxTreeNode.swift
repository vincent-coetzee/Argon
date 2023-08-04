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
        NodeChangeSet.currentChangeSet.insert(symbol)
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
        
    public func indexOfNode(_ node: SyntaxTreeNode)  -> Int?
        {
        if let index = self.containedNodes.firstIndex(of: node)
            {
            return(index)
            }
        fatalError("Attempt to remove node from containedNodes but it is not present")
//        return(nil)
        }
        
    public override func removeChildNode(_ node: SyntaxTreeNode)
        {
        if let index = self.indexOfNode(node)
            {
            self.containedNodes.remove(at: index)
            return
            }
        fatalError("Node to be removed not found in composite node containedNodes")
        }
    }
