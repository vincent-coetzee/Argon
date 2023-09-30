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
        if symbol.isMethod
            {
            if let multimethod = self.lookupSymbol(atName: symbol.name) as? MultimethodType
                {
                multimethod.addMethod(symbol as! MethodType)
                return
                }
            let multimethod = MultimethodType(name: symbol.name)
            multimethod.addMethod(symbol as! MethodType)
            multimethod.setContainer(self)
            self.symbols.append(multimethod)
            return
            }
        self.symbols.append(symbol)
        symbol.setContainer(self)
        }
        
    public override func lookupSymbol(atName: String) -> Symbol?
        {
        for node in self.symbols
            {
            if node.name == atName
                {
                return(node)
                }
            }
        return(self.container?.lookupSymbol(atName: atName))
        }
        
    public override func lookupMethod(atName someName: String) -> MultimethodType?
        {
        let method = MultimethodType(name: someName)
        for symbol in self.symbols
            {
            if symbol.name == someName && symbol.isMultimethod
                {
                method.append(contentsOf: symbol as? MultimethodType)
                }
            }
        if let parentMethod = self.container?.lookupMethod(atName: someName) as? MultimethodType
            {
            let signatures = Set(method.signatures)
            for aMethod in parentMethod.methods
                {
                if !signatures.contains(aMethod.signature)
                    {
                    method.addMethod(aMethod)
                    }
                }
            }
        return(method)
        }
        
    public override func accept(visitor: Visitor)
        {
        for symbol in self.symbols
            {
            symbol.accept(visitor: visitor)
            }
        }
    }
