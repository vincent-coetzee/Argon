//
//  SubType.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/08/2023.
//

import Foundation

public class SubType: AliasedType
    {
    public override var encoding: String
        {
        let baseTypeEncoding = self.baseType.encoding
        return("i\(baseTypeEncoding)_\(self.lowerBound.encoding)_\(self.upperBound.encoding)")
        }
        
    public let upperBound: ValueBox
    public let lowerBound: ValueBox
    
    public init(name: String,baseType: TypeNode,lowerBound: ValueBox,upperBound: ValueBox)
        {
        self.upperBound = upperBound
        self.lowerBound = lowerBound
        super.init(name: name,baseType: baseType)
        }
        
    public required init(coder: NSCoder)
        {
        self.lowerBound = coder.decodeValueBox(forKey: "lowerBound")
        self.upperBound = coder.decodeValueBox(forKey: "upperBound")
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.lowerBound,forKey: "lowerBound")
        coder.encode(self.upperBound,forKey: "upperBound")
        super.encode(with: coder)
        }
    }
