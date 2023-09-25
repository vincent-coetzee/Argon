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
        hasher.combine(self.container)
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
        
    public override func instanciate(withTypes types: ArgonTypes) throws -> ArgonType
        {
        guard self.genericTypes.count == types.count else
            {
            throw(CompilerError(code: .typeVariableGenericMismatch, message: "The type constructor for '\(self.name)' expected \(self.genericTypes.count) generic types but found \(types.count).", location: .zero))
            }
        for (typeVariable,genericType) in zip(self.genericTypes,types)
            {
            
            }
        }
    }
