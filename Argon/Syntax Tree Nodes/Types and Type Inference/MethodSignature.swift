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
    private(set) var parameterTypes: ArgonTypes
    private(set) var returnType: ArgonType?
    
    public init(name: String,parameterTypes: ArgonTypes = [],returnType: ArgonType? = nil)
        {
        self.name = name
        self.parameterTypes = parameterTypes
        self.returnType = returnType
        }
        
    public required init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.parameterTypes = coder.decodeObject(forKey: "parameterTypes") as! ArgonTypes
        self.returnType = coder.decodeObject(forKey: "returnType") as? ArgonType
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
        
    public override func isEqual(_ other: Any?) -> Bool
        {
        if let signature = other as? MethodSignature
            {
            if signature.name != self.name
                {
                return(false)
                }
            if signature.parameterTypes.count != self.parameterTypes.count
                {
                return(false)
                }
            for (this,other) in zip(self.parameterTypes,signature.parameterTypes)
                {
                if this != other
                    {
                    return(false)
                    }
                }
            if signature.returnType != self.returnType
                {
                return(false)
                }
            return(true)
            }
        return(false)
        }
    }

public typealias MethodSignatures = Array<MethodSignature>
