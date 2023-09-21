//
//  SymbolTable.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/09/2023.
//

import Foundation

public class SymbolTable
    {
    private var symbols = SyntaxTreeNodes()
    private var parent: SyntaxTreeNode?
    
    public init(parent: SyntaxTreeNode?)
        {
        self.parent = parent
        }
        
    public func addNode(_ node: SyntaxTreeNode)
        {
        self.symbols.append(node)
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
        return(self.parent?.lookupNode(atName: atName))
        }
        
    public func lookupMethods(atName name: String) -> Methods
        {
        var methods = self.parent?.lookupMethods(atName: name) ?? Methods()
        for node in self.symbols
            {
            if (node.isMethod || node.isFunction) && node.name == name
                {
                methods.append(node as! MethodType)
                }
            }
        return(methods)
        }
        
    public func forEach(_ closure: (SyntaxTreeNode) -> Void)
        {
        for node in self.symbols
            {
            closure(node)
            }
        }
        
    public func accept(visitor: Visitor)
        {
        for node in self.symbols
            {
            node.accept(visitor: visitor)
            }
        }
        
    public func flush()
        {
        for symbol in self.symbols
            {
            symbol.
            }
        }
    }
