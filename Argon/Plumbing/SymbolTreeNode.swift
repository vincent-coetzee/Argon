//
//  SymbolTreeNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/09/2023.
//

import Foundation


public class SymbolTreeNode
    {
    private enum Entry
        {
        public var isNode: Bool
            {
            switch(self)
                {
                case .node:
                    return(true)
                default:
                    return(false)
                }
            }
            
        public var isSymbol: Bool
            {
            switch(self)
                {
                case .symbol:
                    return(true)
                default:
                    return(false)
                }
            }
            
        public var nodeValue: SymbolTreeNode?
            {
            switch(self)
                {
                case .node(let node):
                    return(node)
                default:
                    return(nil)
                }
            }
            
        public var symbolValue: Symbol?
            {
            switch(self)
                {
                case .symbol(let node):
                    return(node)
                default:
                    return(nil)
                }
            }
            
        public var methodValue: MultimethodType?
            {
            switch(self)
                {
                case .symbol(let node):
                    return(node as? MultimethodType)
                default:
                    return(nil)
                }
            }
            
        case symbol(Symbol)
        case node(SymbolTreeNode)
        }
        
    private var root: SymbolTreeNode
        {
        if self.parent.isNil
            {
            return(self)
            }
        return(self.parent!.root)
        }
        
    public var isRoot: Bool
        {
        self.parent.isNil
        }
        
    public var path: Identifier
        {
        self.isRoot ? Identifier.rootIdentifier : (self.parent!.path + self.key)
        }
        
    public weak var parent: SymbolTreeNode?
    public let key: String
    private var entries: Dictionary<String,Entry>?
    
    init(key: String)
        {
        self.key = key
        }
        
    @discardableResult
    public func insert(symbol: Symbol) -> SymbolTreeNode
        {
        if self.entries.isNil
            {
            self.entries = Dictionary<String,Entry>()
            }
        self.entries?[symbol.name] = .symbol(symbol)
        return(self)
        }
        
    @discardableResult
    public func insert(symbol: Symbol,at identifier: Identifier) -> SymbolTreeNode
        {
        assert(identifier.lastPart == symbol.name,"identifier.lastPart(\(identifier.lastPart)) != symbol.name(\(symbol.name)) and it should be.")
        assert(!identifier.isEmpty,"identifier is empty in SymbolTreeNode.insert(symbol:identifier:).")
        if identifier.isRooted
            {
            return(self.root.insert(symbol: symbol,at: identifier.cdr))
            }
        if self.entries.isNil
            {
            self.entries = Dictionary<String,Entry>()
            }
        let aKey = identifier.car!
        if identifier.count == 1
            {
            self.entries?[aKey] = Entry.symbol(symbol)
            return(self)
            }
        if let entry = self.entries?[aKey]
            {
            assert(entry.isNode,"symbolTreeNode.entry is not a node and it should be.")
            return(entry.nodeValue!.insert(symbol: symbol,at: identifier.cdr))
            }
        let node = SymbolTreeNode(key: aKey)
        self.entries?[aKey] = .node(node)
        node.parent = self
        return(node.insert(symbol: symbol,at: identifier.cdr))
        }
        
    public func lookupSymbol(at identifier: Identifier) -> Symbol?
        {
        guard !identifier.isEmpty else
            {
            return(nil)
            }
        if identifier.isRooted
            {
            return(self.root.lookupSymbol(at: identifier.cdr))
            }
        guard self.entries.isNotNil else
            {
            return(nil)
            }
        if let entry = self.entries?[identifier.car!]
            {
            if identifier.count == 1
                {
                return(entry.symbolValue)
                }
            return(entry.nodeValue?.lookupSymbol(at: identifier.cdr))
            }
        return(nil)
        }
        
    public func lookupSymbol(at name: String) -> Symbol?
        {
        return(self.entries?[name]?.symbolValue)
        }
        
    public func lookupMethod(at identifier: Identifier) -> MultimethodType?
        {
        self.lookupSymbol(at: identifier) as? MultimethodType
        }
    //
    //
    // Looking up methods by identifier will find all the methods in the node specified by
    // the path in the identifier excluding the last part of the identifier. For example
    //
    // let's say we have an identifier that looks as follows
    //
    // //Weather/Forecasting/calculateRainfallProbability
    //
    // this will return all the methods in the Forecasting module ( located in the
    // Weather module ) with the name of "calculateRainfallProbability".
    //
    // To lookup all the methods with a specific name that are in scope in the
    // container that contains the specified node use the lookupMethods(at: String).
    //
    //
    public func lookupMultimethod(at identifier: Identifier) -> MultimethodType?
        {
        if self.entries.isNil || identifier.isEmpty
            {
            return(nil)
            }
        if identifier.isRooted
            {
            return(self.root.lookupMultimethod(at: identifier.cdr))
            }
        if let entry = self.entries?[identifier.car!]
            {
            if identifier.count == 1,let method = entry.methodValue
                {
                return(method)
                }
            if let method = entry.nodeValue?.lookupMethod(at: identifier.cdr)
                {
                return(method)
                }
            }
        return(nil)
        }
    //
    //
    // lookupMultimethod(at: String) returns all the methods with the specified name
    // that are in scope to the node that this is called on. The methods both in this
    // node and in this node's parents with the same name as the specified name will
    // be returned. lookupMethods(at: Identifier) will return only the methods  with the
    // specified name in the container delineated by the path portion of the identifier.
    //
    //
    public func lookupMultimethod(at name: String) -> MultimethodType
        {
        let method = self.parent?.lookupMultimethod(at: name) ?? MultimethodType(name: name)
        guard let someEntries = self.entries else
            {
            return(method)
            }
        return(method.appending(contentsOf: someEntries[name]?.methodValue))
        }
    }
