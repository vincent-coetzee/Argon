//
//  NodeChangeSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class NodeChangeSet
    {
    public static private(set) var currentChangeSet = NodeChangeSet()
    
    public static func makeChangeSet() -> NodeChangeSet
        {
        let newSet = NodeChangeSet()
        self.currentChangeSet = newSet
        return(newSet)
        }
        
    private var nodes = Set<SyntaxTreeNode>()
    
    public func insert(_ node: SyntaxTreeNode)
        {
        self.nodes.insert(node)
        }
        
//    public func remove(_ node: SyntaxTreeNode)
//        {
//        self.nodes.remove(node)
////        node.removeFromParent()
//        }
//        
//    public func removeAll()
//        {
//        var nodesToBeRemoved = Array<SyntaxTreeNode>()
//        for node in self.nodes
//            {
//            node.removeFromParent()
//            nodesToBeRemoved.append(node)
//            }
//        self.nodes = Set<SyntaxTreeNode>()
//        }
    }
