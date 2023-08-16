//
//  EnumerationCase.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class EnumerationCase: NSObject,NSCoding
    {
    public var encoding: String
        {
        "p\(self.name.symbolString)_"
        }
        
    public let name: String
    public let instanceValue: ValueBox
    public var associatedTypes = TypeNodes()
    
    public init(name: String,associatedTypes: TypeNodes = [],instanceValue: ValueBox)
        {
        self.associatedTypes = associatedTypes
        self.name = name
        self.instanceValue = instanceValue
        }
        
    required public init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.associatedTypes = coder.decodeObject(forKey: "associatedTypes") as! TypeNodes
        self.instanceValue = coder.decodeValueBox(forKey: "instanceValue")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.instanceValue,forKey: "instanceValue")
        coder.encode(self.name,forKey: "name")
        coder.encode(self.associatedTypes,forKey: "associatedTypes")
        }
    }

public typealias EnumerationCases = Array<EnumerationCase>
