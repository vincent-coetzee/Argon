//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation
    
internal class SymbolEntry
    {
    var name: String
    var node: SyntaxTreeNode?
    var methods = Methods()
    
    init(name: String)
        {
        self.name = name
        }
    }
    
public class CompositeSyntaxTreeNode: SyntaxTreeNode
    {
    internal var symbolEntries = Dictionary<String,SymbolEntry>()
    
    public override func addNode(_ symbol: SyntaxTreeNode)
        {
        var entry: SymbolEntry!
        if self.symbolEntries[symbol.name].isNil
            {
            entry = SymbolEntry(name: symbol.name)
            self.symbolEntries[symbol.name] = entry
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
        
    public override func lookupNode(atName someName: String) -> SyntaxTreeNode?
        {
        if let entry = self.symbolEntries[someName]
            {
            return(entry.node)
            }
        return(self.parent.lookupNode(atName: someName))
        }
        
    public override func lookupMethods(atName someName: String) -> Methods
        {
        var methods = self.parent.lookupMethods(atName: someName)
        if let entry = self.symbolEntries[someName]
            {
            methods.append(contentsOf: entry.methods)
            }
        return(methods)
        }
        
    public override func accept(visitor: Visitor)
        {
        for entry in self.symbolEntries.values
            {
            entry.node?.accept(visitor: visitor)
            for method in entry.methods
                {
                method.accept(visitor: visitor)
                }
            }
        }
        
    public override func dump(indent: String)
        {
        fatalError()
        }
    }
