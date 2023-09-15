//
//  TypeVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/02/2023.
//

import Foundation

public class TypeVariable: ArgonType
    {
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
