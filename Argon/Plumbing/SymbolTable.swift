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
    
    private var rootModule: RootModule
        {
        self.owner.rootModule
        }
        
    public var slots: Slots
        {
        self.symbols.compactMap{$0 as? Slot}
        }
        
    public var enumerationCases: EnumerationCases
        {
        self.symbols.compactMap{$0 as? EnumerationCase}
        }
                
    private let owner: SyntaxTreeNode?
    private let supertypes: ArgonTypes
    
    public override init()
        {
        super.init()
        }
        
    public init(owner: SyntaxTreeNode? = nil,supertypes: ArgonTypes = ArgonTypes())
        {
        self.owner = owner
        self.supertypes = supertypes
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
        self.owner = coder.decodeObject(forKey: "owner") as? SyntaxTreeNode
        self.supertypes = coder.decodeObject(forKey: "supertypes") as! ArgonTypes
        super.init()
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.owner,forKey: "owner")
        coder.encode(self.symbols,forKey: "symbols")
        coder.encode(self.supertypes,forKey: "supertypes")
        }
        
    public func addSymbol(_ node: SyntaxTreeNode)
        {
        self.symbols.append(node)
        node.setContainer(self.owner)
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
        for someClass in self.supertypes
            {
            if let symbol = someClass.lookupSymbol(atName: atName)
                {
                return(symbol)
                }
            }
        return(self.container?.lookupSymbol(atName: atName))
        }
        
    public func lookupMethods(atName name: String) -> Methods
        {
        var methods = self.container?.lookupMethods(atName: name) ?? Methods()
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
        
//    public func lookupNode(atIdentifier identifier: Identifier) -> SyntaxTreeNode?
//        {
//        self.lookupSymbol(atIdentifier: identifier)
//        }
//        
        
    public func lookupSymbol(atIdentifier identifier: Identifier) -> SyntaxTreeNode?
        {
        if identifier.isEmpty
            {
            return(nil)
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupSymbol(atIdentifier: identifier.cdr))
            }
        if let node = self.lookupSymbol(atName: identifier.car!)
            {
            if identifier.cdr.isEmpty
                {
                return(node)
                }
            else
                {
                return(node.lookupSymbol(atIdentifier: identifier.cdr))
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
        if let node = self.lookupSymbol(atName: identifier.car!)
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
