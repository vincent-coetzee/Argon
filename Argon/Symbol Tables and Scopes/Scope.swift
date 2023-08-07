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
    func addNode(_ symbol: SyntaxTreeNode)
    func lookupMethods(atName: String) -> Methods
    func lookupNode(atName: String) -> SyntaxTreeNode?
    func lookupMethods(atIdentifier: Identifier) -> Methods
    func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
    }
    
public extension Scope
    {
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
                if let scope = self.lookupNode(atName: identifier.firstPart) as? Scope
                    {
                    scope.addNode(node,atIdentifier: identifier.remainingPart)
                    return
                    }
                else
                    {
                    fatalError("Attempt to add node to invalid scope path.")
                    }
                }
            }
        }
        
    func lookupNode(atIdentifier identifier: Identifier) -> SyntaxTreeNode?
        {
        guard !identifier.isEmpty else
            {
            return(nil)
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupNode(atIdentifier: identifier.remainingPart))
            }
        let part = identifier.firstPart
        let remainder = identifier.remainingPart
        let symbol = self.lookupNode(atName: part)
        guard symbol.isNotNil else
            {
            return(nil)
            }
        if remainder.isEmpty
            {
            return(symbol)
            }
        return((symbol as? Scope)?.lookupNode(atIdentifier: remainder))
        }
        
    func lookupMethods(atIdentifier identifier: Identifier) -> Methods
        {
        guard !identifier.isEmpty else
            {
            return(Methods())
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupMethods(atIdentifier: identifier.remainingPart))
            }
        let part = identifier.firstPart
        let remainder = identifier.remainingPart
        let methods = self.lookupMethods(atName: part)
        if remainder.isEmpty
            {
            return(methods)
            }
        return(Methods())
        }
    }
