//
//  BasicType.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class BasicType: TypeNode
    {
    public private(set) var rawType: RawType = .void
    
    public init(name: String,rawType: RawType)
        {
        self.rawType = rawType
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.rawType = coder.decodeRawType(forKey: "rawType")
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.rawType,forKey: "rawType")
        super.encode(with: coder)
        }
    }

