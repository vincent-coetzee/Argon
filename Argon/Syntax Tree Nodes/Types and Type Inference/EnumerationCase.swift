//
//  EnumerationCase.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class EnumerationCase: NSObject,NSCoding
    {
    public let name: String
    public let type: TypeNode
    public var associatedTypes = TypeNodes()
    
    public init(name: String,type: TypeNode,associatedTypes: TypeNodes = [])
        {
        self.name = name
        self.type = type
        }
        
    required public init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.type = coder.decodeObject(forKey: "type") as! TypeNode
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.name,forKey: "name")
        coder.encode(self.type,forKey: "type")
        }
    }

public typealias EnumerationCases = Array<EnumerationCase>
