//
//  Argument.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class Argument: NSObject,NSCoding
    {
    public let internalName: String
    public let externalName: String
    public let value: Expression
    
    init(externalName: String,internalName: String,value: Expression)
        {
        self.internalName = internalName
        self.externalName = externalName
        self.value = value
        }
        
    public required init(coder: NSCoder)
        {
        self.internalName = coder.decodeObject(forKey: "internalName") as! String
        self.externalName = coder.decodeObject(forKey: "externalName") as! String
        self.value = coder.decodeObject(forKey: "value") as! Expression
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.internalName,forKey: "internalName")
        coder.encode(self.externalName,forKey: "externalName")
        coder.encode(self.value,forKey: "value")
        }
    }

public typealias Arguments = Array<Argument>
