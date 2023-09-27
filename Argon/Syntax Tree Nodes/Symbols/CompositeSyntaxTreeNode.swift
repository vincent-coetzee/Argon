//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class CompositeSyntaxTreeNode: Symbol
    {
    internal var symbols = Symbols()
    
    init(name: String,parent: Symbol? = nil)
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
        
    public override func addSymbol(_ symbol: Symbol)
        {
        self.symbols.append(symbol)
        symbol.setContainer(self)
        }
        
    public override func lookupSymbol(atName: String) -> Symbol?
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
        
    public override func lookupMethods(atName someName: String) -> Methods
        {
        var methods = self.container?.lookupMethods(atName: someName) ?? Methods()
        methods.append(contentsOf: self.symbols.filter{$0.name == someName && ($0.isMethod || $0.isFunction)}.map{$0 as! MethodType})
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
