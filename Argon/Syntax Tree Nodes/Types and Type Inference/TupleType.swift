//
//  TupleType.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/09/2023.
//

import Foundation

public class TupleType: StructuredType
    {
    public override var isMakeable: Bool
        {
        true
        }
        
    public override var symbolType: ArgonType
        {
        get
            {
            ArgonType.tupleType
            }
        set
            {
            }
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("TUPLE")
        hasher.combine(self.identifier)
        for aType in self.genericTypes
            {
            hasher.combine(aType)
            }
        return(hasher.finalize())
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public required init(name: String,genericTypes: ArgonTypes)
        {
        super.init(name: name,genericTypes: genericTypes)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public func associatedType(at: Int) -> ArgonType
        {
        self.genericTypes[at]
        }
        
    public override func typeConstructor() -> ArgonType
        {
        return(TypeConstructor(name: self.name,constructedType: .tuple(self)))
        }
        
    public override func clone() -> Self
        {
        TupleType(name: self.name,genericTypes: self.genericTypes) as! Self
        }
    
    }
