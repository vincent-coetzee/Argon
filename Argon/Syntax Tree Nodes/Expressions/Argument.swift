//
//  Argument.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class Argument: NSObject,NSCoding
    {
    public var location: Location = .zero
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
        
    public func accept(visitor: Visitor)
        {
        }
    }

public typealias Arguments = Array<Argument>

extension Arguments
    {
    public var location: Location
        {
        get
            {
            .zero
            }
        set
            {
            for argument in self
                {
                argument.location = newValue
                }
            }
        }
    }
