//
//  TupleType.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/09/2023.
//

import Foundation

public class TupleType: StructuredType
    {
    public init(associatedTypes: ArgonTypes)
        {
        super.init(name: Argon.nextIndex(named: "TUPLE"),genericTypes: associatedTypes)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public func associatedType(at: Int) -> ArgonType
        {
        self.genericTypes[at]
        }
    }
