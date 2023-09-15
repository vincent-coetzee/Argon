//
//  Parent.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/01/2023.
//

import Foundation

public enum Parent: Hashable,Comparable
    {
    public static func <(lhs: Parent,rhs: Parent) -> Bool
        {
        switch(lhs,rhs)
            {
            case(.symbol(let symbol1),.symbol(let symbol2)):
                return(symbol1 < symbol2)
            default:
                return(false)
            }
        }
        
    public static func ==(lhs: Parent,rhs: Parent) -> Bool
        {
        switch(lhs,rhs)
            {
            case(.block(let block1),.block(let block2)):
                return(block1 === block2)
            case(.none,.none):
                return(true)
            case(.symbol(let symbol1),.symbol(let symbol2)):
                return(symbol1 == symbol2)
            case(.expression(let expression1),.expression(let expression2)):
                return(expression1 == expression2)
            default:
                return(false)
            }
        }
        
    public var parentModules: Modules
        {
        switch(self)
            {
            case(.block(let block)):
                return(block.parentModules)
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
            case(.block(let block)):
                return(block.rootModule)
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
            case(.block(let block)):
                return(block.parent)
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
            case(.block(let block)):
                return(block.identifier)
            case(.none):
                return(Identifier(string: "\\"))
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
            case(.block(let block)):
                return(block.module)
            case(.none):
                fatalError("This should not occur")
            case(.symbol(let symbol)):
                return(symbol.module)
            case(.expression):
                fatalError("This should not occur")
            }
        }
        
    public var syntaxTreeNode: SyntaxTreeNode?
        {
        switch(self)
            {
            case(.symbol(let symbol)):
                return(symbol)
            default:
                return(nil)
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
        
//    public var _mangledName: String
//        {
//        switch(self)
//            {
//            case(.block):
//                fatalError("This should not occur")
//            case(.none):
//                return("")
//            case(.symbol(let symbol)):
//                return(symbol.mangledName)
//            case(.expression):
//                fatalError("This should not occur")
//            }
//        }
        
    case none
    case symbol(SyntaxTreeNode)
    case expression(Expression)
    case block(Block)
    
    public func removeNode(_ node: SyntaxTreeNode)
        {
        switch(self)
            {
            case .block:
                break
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
            case .block(let block):
                return(block.lookupNode(atName: atName))
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
            case .block(let block):
                return(block.lookupMethods(atName: atName))
            case .none:
                return(Methods())
            case .symbol(let symbol):
                return(symbol.lookupMethods(atName: atName))
            case .expression(let expression):
                return(expression.lookupMethods(atName: atName))
            }
        }
        
        
    public func hash(into hasher:inout Hasher)
        {
        hasher.combine("PARENT")
        switch(self)
            {
            case(.none):
                hasher.combine("NONE")
            case(.symbol(let symbol)):
                hasher.combine("SYMBOL")
                hasher.combine(symbol)
            case(.expression(let expression)):
                hasher.combine("EXPRESSION")
                hasher.combine(expression)
            case(.block(let block)):
                hasher.combine("BLOCK")
                hasher.combine(block)
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
            case(3):
                let block = self.decodeObject(forKey: key + "block") as! Block
                return(.block(block))
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
            case(.block(let block)):
                self.encode(3,forKey: key)
                self.encode(block,forKey: key + "block")
            }
        }
    }
