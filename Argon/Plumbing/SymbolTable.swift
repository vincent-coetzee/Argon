//
//  SymbolTable.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/09/2023.
//

import Foundation

public class SymbolTable: NSObject,NSCoding
    {
    private var symbols = SyntaxTreeNodes()
    private var _parent: SyntaxTreeNode?
    
    private var rootModule: RootModule
        {
        self._parent!.rootModule
        }
        
    public var slots: Slots
        {
        self.symbols.compactMap{$0 as? Slot}
        }
        
    public var enumerationCases: EnumerationCases
        {
        self.symbols.compactMap{$0 as? EnumerationCase}
        }
        
    public var parent: SyntaxTreeNode?
        {
        get
            {
            return(self._parent)
            }
        set
            {
            self._parent = newValue
            for symbol in self.symbols
                {
                symbol.setParent(newValue)
                }
            }
        }
        
    public override init()
        {
        super.init()
        }
        
    public init(with: SyntaxTreeNodes)
        {
        super.init()
        for symbol in with
            {
            self.symbols.append(symbol)
            }
        }
        
    public required init(coder: NSCoder)
        {
        self.symbols = coder.decodeObject(forKey: "symbols") as! SyntaxTreeNodes
        super.init()
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.symbols,forKey: "symbols")
        }
        
    public init(parent: SyntaxTreeNode?)
        {
        self._parent = parent
        }
        
    public func addNode(_ node: SyntaxTreeNode)
        {
        self.symbols.append(node)
        node.setParent(self._parent)
        }
        
    public func addSymbol(_ node: SyntaxTreeNode)
        {
        self.symbols.append(node)
        node.setParent(self._parent)
        }
        
    public func lookupNode(atName: String) -> SyntaxTreeNode?
        {
        for node in self.symbols
            {
            if node.name == atName && !(node.isMethod || node.isFunction)
                {
                return(node)
                }
            }
        return(self._parent?.lookupNode(atName: atName))
        }
        
    public func lookupSymbol(atName: String) -> SyntaxTreeNode?
        {
        for node in self.symbols
            {
            if node.name == atName && !(node.isMethod || node.isFunction)
                {
                return(node)
                }
            }
        return(self._parent?.lookupNode(atName: atName))
        }
        
    public func lookupMethods(atName name: String) -> Methods
        {
        var methods = self._parent?.lookupMethods(atName: name) ?? Methods()
        for node in self.symbols
            {
            if node.name == name && (node.isMethod || node.isFunction)  
                {
                methods.append(node as! MethodType)
                }
            }
        return(methods)
        }
        
    public var methods: Methods
        {
        self.symbols.filter{$0.isMethod}.map{$0 as! MethodType}
        }
        
    public var modules: Modules
        {
        self.symbols.filter{$0.isModule}.map{$0 as! Module}
        }
        
    public func forEach(_ closure: (SyntaxTreeNode) -> Void)
        {
        for node in self.symbols
            {
            closure(node)
            }
        }
        
    public func detect(_ closure: (SyntaxTreeNode) -> Bool) -> SyntaxTreeNode?
        {
        for node in self.symbols
            {
            if closure(node)
                {
                return(node)
                }
            }
        return(nil)
        }
        
    public func accept(visitor: Visitor)
        {
        for node in self.symbols
            {
            node.accept(visitor: visitor)
            }
        }
        
    public func removeRootModule()
        {
        var newSymbols = SyntaxTreeNodes()
        for symbol in self.symbols
            {
            if symbol.name != ""
                {
                newSymbols.append(symbol)
                }
            }
        }
        
    public func lookupNode(atIdentifier identifier: Identifier) -> SyntaxTreeNode?
        {
        self.lookupSymbol(atIdentifier: identifier)
        }
        
        
    public func lookupSymbol(atIdentifier identifier: Identifier) -> SyntaxTreeNode?
        {
        if identifier.isEmpty
            {
            return(nil)
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupNode(atIdentifier: identifier.cdr))
            }
        if let node = self.lookupNode(atName: identifier.car!)
            {
            if identifier.cdr.isEmpty
                {
                return(node)
                }
            else
                {
                return(node.lookupNode(atIdentifier: identifier.cdr))
                }
            }
        return(nil)
        }
        
    public func lookupMethods(atIdentifier identifier: Identifier) -> Methods
        {
        if identifier.isEmpty
            {
            return(Methods())
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupMethods(atIdentifier: identifier.cdr))
            }
        if let node = self.lookupNode(atName: identifier.car!)
            {
            if identifier.cdr.count == 1
                {
                return(node.lookupMethods(atName: identifier.lastPart))
                }
            else
                {
                return(node.lookupMethods(atIdentifier: identifier.cdr))
                }
            }
        return(Methods())
        }
    }
