//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class CompositeSyntaxTreeNode: SyntaxTreeNode
    {
    internal var symbols = SyntaxTreeNodes()
    
    init(name: String,parent: SyntaxTreeNode? = nil)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func dump(indent: String)
        {
        fatalError()
        }
        
    public override func addSymbol(_ symbol: SyntaxTreeNode)
        {
        self.symbols.append(symbol)
        symbol.setContainer(self)
        }
        
    public override func lookupSymbol(atName: String) -> SyntaxTreeNode?
        {
        for node in self.symbols
            {
            if node.name == atName && !(node.isMethod || node.isFunction)
                {
                return(node)
                }
            }
        return(self.container?.lookupSymbol(atName: atName))
        }
        
    public override func lookupMethods(atName name: String) -> Methods
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
        
    public override func accept(visitor: Visitor)
        {
        for symbol in self.symbols
            {
            symbol.accept(visitor: visitor)
            }
        }
    }
