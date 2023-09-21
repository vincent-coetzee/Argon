//
//  NodeContainer.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/09/2023.
//

import Foundation

public class SymbolEntry
    {
    var name: String
    var node: SyntaxTreeNode?
    var methods = Methods()
    
    init(name: String)
        {
        self.name = name
        }
    }
    
public typealias SymbolEntries = Dictionary<String,SymbolEntry>

public protocol NodeContainer: AnyObject
    {
    var symbolEntries: SymbolEntries { get set }
    var parent: Parent! { get }
    func lookupNode(atName: String) -> SyntaxTreeNode?
    func lookupMethods(atName: String) -> Methods
    func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
    func lookupMethods(atIdentifier: Identifier) -> Methods
    func addNode(_ node: SyntaxTreeNode)
    }
    
extension NodeContainer
    {
    public func addNode(_ symbol: SyntaxTreeNode)
        {
        var entry: SymbolEntry!
        if self.symbolEntries[symbol.name].isNil
            {
            entry = SymbolEntry(name: symbol.name)
            var nodes = self.symbolEntries
            nodes[symbol.name] = entry
            self.symbolEntries = nodes
            }
        else
            {
            entry = self.symbolEntries[symbol.name]
            }
        if let method = symbol as? MethodType
            {
            entry!.methods.append(method)
            }
        else
            {
            entry!.node = symbol
            }
        symbol.setParent(self)
        NodeChangeSet.currentChangeSet.insert(symbol)
        }
        
    public func lookupNode(atName someName: String) -> SyntaxTreeNode?
        {
        if let entry = self.symbolEntries[someName]
            {
            return(entry.node)
            }
        return(self.parent.lookupNode(atName: someName))
        }
        
    public func lookupMethods(atName someName: String) -> Methods
        {
        var methods = self.parent.lookupMethods(atName: someName)
        if let entry = self.symbolEntries[someName]
            {
            methods.append(contentsOf: entry.methods)
            }
        return(methods)
        }
    }
