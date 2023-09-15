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
        
    public var location: Location = .zero
    public let name: String
    public let instanceValue: ValueBox
    public var associatedTypes = ArgonTypes()
    public var enumerationType: EnumerationType
    
    public init(name: String,enumeration: EnumerationType,associatedTypes: ArgonTypes = [],instanceValue: ValueBox)
        {
        self.enumerationType = enumeration
        self.associatedTypes = associatedTypes
        self.name = name
        self.instanceValue = instanceValue
        }
        
    required public init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.associatedTypes = coder.decodeObject(forKey: "associatedTypes") as! ArgonTypes
        self.instanceValue = coder.decodeValueBox(forKey: "instanceValue")
        self.enumerationType = coder.decodeObject(forKey: "enumerationType") as! EnumerationType
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.instanceValue,forKey: "instanceValue")
        coder.encode(self.name,forKey: "name")
        coder.encode(self.associatedTypes,forKey: "associatedTypes")
        coder.encode(self.enumerationType,forKey: "enumerationType")
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("ENUMERATIONCASE")
        hasher.combine(self.enumerationType)
        hasher.combine(self.name)
        return(hasher.finalize())
        }
    }

public typealias EnumerationCases = Array<EnumerationCase>
