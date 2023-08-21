//
//  SymbolTable.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/08/2023.
//

import Foundation

internal class SymbolEntry: NSObject,NSCoding
    {
    var node: SyntaxTreeNode?
    var methods: Methods?
    
    public override init()
        {
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.node = coder.decodeObject(forKey: "node") as? Module
        self.methods = coder.decodeObject(forKey: "methods") as? Methods
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.node,forKey: "node")
        coder.encode(self.methods,forKey: "methods")
        }
        
    public func accept(visitor: Visitor)
        {
        self.node?.accept(visitor: visitor)
        self.methods?.accept(visitor: visitor)
        }
    }
    
fileprivate typealias SymbolEntries = Dictionary<String,SymbolEntry>

public class SymbolTable: NSObject,NSCoding
    {
    private var symbolEntries = SymbolEntries()
    
    public override init()
        {
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.symbolEntries = coder.decodeObject(forKey: "symbolEntries") as! SymbolEntries
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.symbolEntries,forKey: "symbolEntries")
        }
        
    public func flush()
        {
        self.symbolEntries = SymbolEntries()
        }

    public func addNode(_ node: SyntaxTreeNode)
        {
        var entry = self.symbolEntries[node.name]
        if entry.isNil
            {
            entry = SymbolEntry()
            self.symbolEntries[node.name] = entry
            }
        if node.isMethod || node.isFunction
            {
            if entry!.methods.isNil
                {
                entry!.methods = Methods()
                }
            let method = node as! Method
            entry!.methods!.append(method)
            }
        else
            {
            entry!.node = node
            }
        }
        
    public func doNodes(_ closure: (SyntaxTreeNode) -> Void)
        {
        for (_,entry) in self.symbolEntries
            {
            if entry.node.isNotNil
                {
                closure(entry.node!)
                }
            }
        }

    public func lookupMethods(atName name: String) -> Methods
        {
        guard let entry = self.symbolEntries[name] else
            {
            return([])
            }
        guard let methods = entry.methods else
            {
            return([])
            }
        return(methods)
        }
        
    public func lookupNode(atName name: String) -> SyntaxTreeNode?
        {
        guard let entry = self.symbolEntries[name] else
            {
            return(nil)
            }
        return(entry.node)
        }
        
    public func accept(visitor: Visitor)
        {
        for entry in self.symbolEntries.values
            {
            entry.accept(visitor: visitor)
            }
        }
    }
