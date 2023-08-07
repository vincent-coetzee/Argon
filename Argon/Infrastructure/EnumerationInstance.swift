//
//  EnumerationInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class EnumerationInstance: NSObject,NSCoding
    {
    public private(set) var enumeration: Enumeration
    public private(set) var enumerationCase: EnumerationCase
    
    public required init(coder: NSCoder)
        {
        self.enumeration = coder.decodeObject(forKey: "enumeration") as! Enumeration
        self.enumerationCase = coder.decodeObject(forKey: "enumerationCase") as! EnumerationCase
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.enumeration,forKey: "enumeration")
        coder.encode(self.enumerationCase,forKey: "enumerationCase")
        }
    }
