//
//  MultimethodType.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/09/2023.
//

import Foundation

public class MultimethodType: StructuredType
    {
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
        
    public func addMethod(_ method: MethodType)
        {
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
