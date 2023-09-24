//
//  Metaclass.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class MetaclassType: ClassType
    {
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("CLASS")
        hasher.combine(self.parent)
        hasher.combine(self.name)
        for aType in self.genericTypes
            {
            hasher.combine(aType)
            }
        return(hasher.finalize())
        }
        
    public init(name: String,superclasses: ClassTypes,genericTypes: ArgonTypes)
        {
        super.init(name: name,superclasses: superclasses,genericTypes: genericTypes)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public func 
    }
