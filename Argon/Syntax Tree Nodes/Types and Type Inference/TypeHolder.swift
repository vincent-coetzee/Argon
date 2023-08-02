//
//  TypeHolder.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/07/2023.
//

import Foundation

public class TypeHolder: TypeNode
    {
    public var actualType: TypeNode?
    
    public required init(coder: NSCoder)
        {
        self.actualType = coder.decodeObject(forKey: "actualType") as? TypeNode
        super.init(coder: coder)
        }
        
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.actualType,forKey: "actualType")
        super.encode(with: coder)
        }
        
    public override func become<T>(_ newKind: T.Type) -> T?
        {
        guard self.actualType.isNotNil else
            {
            return(nil)
            }
        return(self.actualType as! T)
        }
    }
