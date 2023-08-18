//
//  Parent.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/01/2023.
//

import Foundation

public enum Parent
    {
    public var parentModules: Modules
        {
        switch(self)
            {
            case(.none):
                return([])
            case(.symbol(let symbol)):
                return(symbol.parentModules)
            case(.expression(let expression)):
                return(expression.parentModules)
            }
        }
        
    public var rootModule: RootModule
        {
        switch(self)
            {
            case(.none):
                fatalError("This should not happen in practice.")
            case(.symbol(let symbol)):
                return(symbol.rootModule)
            case(.expression(let expression)):
                return(expression.rootModule)
            }
        }
        
    public var parent: Parent?
        {
        switch(self)
            {
            case(.none):
                return(nil)
            case(.symbol(let symbol)):
                return(symbol.parent)
            case(.expression(let expression)):
                return(expression.parent)
            }
        }
        
    public var identifier: Identifier
        {
        switch(self)
            {
            case(.none):
                return(Identifier(string: "//"))
            case(.symbol(let symbol)):
                return(symbol.identifier)
            case(.expression):
                fatalError("This should not occur")
            }
        }
        
    public var module: Module
        {
        switch(self)
            {
            case(.none):
                fatalError("This should not occur")
            case(.symbol(let symbol)):
                return(symbol.module)
            case(.expression):
                fatalError("This should not occur")
            }
        }
        
    public var isNone: Bool
        {
        switch(self)
            {
            case(.none):
                return(true)
            default:
                return(false)
            }
        }
        
    case none
    case symbol(SyntaxTreeNode)
    case expression(Expression)
    
    public func removeNode(_ node: SyntaxTreeNode)
        {
        switch(self)
            {
            case .none:
                break
            case .symbol(let symbol):
                symbol.removeChildNode(node)
            case .expression(let expression):
                expression.removeChildNode(node)
            }
        }
        
    public func lookupNode(atName: String) -> SyntaxTreeNode?
        {
        switch(self)
            {
            case .none:
                return(nil)
            case .symbol(let symbol):
                return(symbol.lookupNode(atName: atName))
            case .expression(let expression):
                return(expression.lookupNode(atName: atName))
            }
        }
        
    public func lookupMethods(atName: String) -> Methods
        {
        switch(self)
            {
            case .none:
                return(Methods())
            case .symbol(let symbol):
                return(symbol.lookupMethods(atName: atName))
            case .expression(let expression):
                return(expression.lookupMethods(atName: atName))
            }
        }
    }

public extension NSCoder
    {
    func decodeParent(forKey key: String) -> Parent
        {
        switch(self.decodeInteger(forKey: key))
            {
            case(0):
                return(.none)
            case(1):
                let symbol = self.decodeObject(forKey: key + "symbol") as! SyntaxTreeNode
                return(.symbol(symbol))
            case(2):
                let expression = self.decodeObject(forKey: key + "expression") as! Expression
                return(.expression(expression))
            default:
                fatalError("This should not happen, invalid key for Parent")
            }
        }
        
    func encode(_ parent: Parent,forKey key: String)
        {
        switch(parent)
            {
            case(.none):
                self.encode(0,forKey: key)
            case(.symbol(let symbol)):
                self.encode(1,forKey: key)
                self.encode(symbol,forKey: key + "symbol")
            case(.expression(let expression)):
                self.encode(2,forKey: key)
                self.encode(expression,forKey: key + "expression")
            }
        }
    }
