//
//  TypeVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/02/2023.
//

import Foundation

public class TypeVariable: ArgonType
    {
    public enum TypeVariableValue
        {
        case unbound
        case bound(ArgonType)
        case linked(TypeVariable)
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine(self.name)
        return(hasher.finalize())
        }
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public init(name: String,index: Int)
        {
        super.init(index: index,name: name)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
    }

public typealias TypeVariables = Array<TypeVariable>
