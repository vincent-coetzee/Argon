//
//  MethodSignature.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/08/2023.
//

import Foundation

public class MethodSignature: NSObject,NSCoding
    {
    private(set) var name: String
    private(set) var parameterTypes: TypeNodes
    private(set) var returnType: TypeNode?
    
    public init(name: String,parameterTypes: TypeNodes = [],returnType: TypeNode? = nil)
        {
        self.name = name
        self.parameterTypes = parameterTypes
        self.returnType = returnType
        }
        
    public required init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.parameterTypes = coder.decodeObject(forKey: "parameterTypes") as! TypeNodes
        self.returnType = coder.decodeObject(forKey: "returnType") as? TypeNode
        super.init()
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.name,forKey: "name")
        coder.encode(self.parameterTypes,forKey: "parameterTypes")
        coder.encode(self.returnType,forKey: "returnType")
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine(super.hash)
        hasher.combine(self.name)
        for type in self.parameterTypes
            {
            hasher.combine(type)
            }
        hasher.combine(returnType)
        return(hasher.finalize())
        }
    }

public typealias MethodSignatures = Array<MethodSignature>
