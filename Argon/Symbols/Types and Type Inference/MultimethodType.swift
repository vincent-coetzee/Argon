//
//  MultimethodType.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/09/2023.
//

import Foundation

public class MultimethodType: StructuredType
    {
    public var signatures: MethodSignatures
        {
        self.methods.map{$0.signature}
        }
        
    public override var styleElement: StyleElement
        {
        .colorMultimethod
        }
        
    public override var isMultimethod: Bool
        {
        true
        }
        
    public private(set) var methods = Methods()
    
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.methods = coder.decodeObject(forKey: "methods") as! Methods
        super.init(coder: coder)
        }
        
    public required init(name: String,genericTypes: ArgonTypes)
        {
        super.init(name: name,genericTypes: genericTypes)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.methods,forKey: "methods")
        }
        
    public override func configure(nodeView: SymbolViewCell)
        {
        nodeView.leftPane.stringValue = "\(Swift.type(of: self))(\(self.name))"
        nodeView.imageName = "IconMethod"
        }
        
    public func addMethod(_ method: MethodType)
        {
        method.setContainer(self)
        self.methods.append(method)
        }
        
    public func method(at signature: MethodSignature) -> MethodType?
        {
        for method in self.methods
            {
            if method.signature == signature
                {
                return(method)
                }
            }
        return(nil)
        }
        
    public func appending(contentsOf method: MultimethodType?) -> Self
        {
        let newMethod = MultimethodType(name: self.name)
        guard let method = method else
            {
            newMethod.methods = self.methods
            return(newMethod as! Self)
            }
        newMethod.methods = self.methods.appending(contentsOf: method.methods)
        return(newMethod as! Self)
        }
        
    public func append(contentsOf method: MultimethodType?)
        {
        guard let method = method else
            {
            return
            }
        self.methods.append(contentsOf: method.methods)
        }
        
    public override var astLabel: String
        {
        "MultimethodType \(self.name)"
        }
        
    public override var children: Symbols
        {
        self.methods
        }
    }

public typealias Multimethods = Array<MultimethodType>

extension Multimethods
    {
    public init(_ method: MultimethodType)
        {
        self.init()
        self.append(method)
        }
        
    public func accept(visitor: Visitor)
        {
        for method in self
            {
            method.accept(visitor: visitor)
            }
        }
    
    public func appending(contentsOf methods: Multimethods?) -> Self
        {
        guard let methods = methods else
            {
            return(self)
            }
        var newMethods = self
        for method in methods
            {
            newMethods.append(method)
            }
        return(newMethods)
        }
    }
