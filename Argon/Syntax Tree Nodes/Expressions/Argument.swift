//
//  Argument.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class Argument: NSObject,NSCoding
    {
    public let name: String
    public let value: Expression
    
    init(name: String,value: Expression)
        {
        self.name = name
        self.value = value
        }
        
    public required init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.value = coder.decodeObject(forKey: "value") as! Expression
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.name,forKey: "name")
        coder.encode(self.value,forKey: "value")
        }
    }

public typealias Arguments = Array<Argument>
