//
//  ObjectInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class ObjectInstance: NSObject,NSCoding
    {
    public private(set) var `class`: Class
    
    public required init(coder: NSCoder)
        {
        self.class = coder.decodeObject(forKey: "class") as! Class
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.class,forKey: "class")
        }
    }
