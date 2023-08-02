//
//  AliasType.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/07/2023.
//

import Foundation

public class AliasedType: StructuredType
    {
    public init(name: String,baseType: TypeNode)
        {
        super.init(name: name,generics: [baseType])
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        }
    }
    
public typealias AliasedTypes = Array<AliasedType>
