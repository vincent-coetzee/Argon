//
//  SymbolTable.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/01/2023.
//

import Foundation

public typealias SymbolDictionary = Dictionary<String,SyntaxTreeNode>

public protocol Scope: AnyObject
    {
    var rootModule: RootModule { get }
    var argonModule: ArgonModule { get }
    func addNode(_ symbol: SyntaxTreeNode)
    func lookupMethods(atName: String) -> Methods
    func lookupNode(atName: String) -> SyntaxTreeNode?
    func lookupMethods(atIdentifier: Identifier) -> Methods
    func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
    }
    
public extension Scope
    {
    var argonModule: ArgonModule
        {
        self.rootModule.argonModule
        }
        
    func addNode(_ node: SyntaxTreeNode,atIdentifier identifier: Identifier)
        {
        if identifier.isRooted
            {
            self.rootModule.addNode(node,atIdentifier: identifier.remainingPart)
            return
            }
        else
            {
            if identifier.count == 1
                {
                self.addNode(node)
                return
                }
            else
                {
                if let node = self.lookupNode(atName: identifier.firstPart)
                    {
                    (node as Scope).addNode(node,atIdentifier: identifier.remainingPart)
                    return
                    }
                else
                    {
                    fatalError("Attempt to add node to invalid scope path.")
                    }
                }
            }
        }
    }
