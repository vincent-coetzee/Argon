//
//  SubType.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/08/2023.
//

import Foundation

public class Subtype: ArgonType
    {
    public override var baseType: ArgonType
        {
        self._baseType.baseType
        }
        
    public let _baseType: ArgonType
    public let upperBound: ValueBox
    public let lowerBound: ValueBox
    
    public init(name: String,parentType: ArgonType,lowerBound: ValueBox,upperBound: ValueBox)
        {
        self.upperBound = upperBound
        self.lowerBound = lowerBound
        self._baseType = parentType
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.lowerBound = coder.decodeValueBox(forKey: "lowerBound")
        self.upperBound = coder.decodeValueBox(forKey: "upperBound")
        self._baseType = coder.decodeObject(forKey: "_baseType") as! ArgonType
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.lowerBound,forKey: "lowerBound")
        coder.encode(self.upperBound,forKey: "upperBound")
        coder.encode(self._baseType,forKey: "_baseType")
        super.encode(with: coder)
        }
    }
