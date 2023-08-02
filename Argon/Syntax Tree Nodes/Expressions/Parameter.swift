//
//  Parameter.swift
//  Argon
//
//  Created by Vincent Coetzee on 29/07/2023.
//

import Foundation

public class Parameter: NSObject,NSCoding
    {
    private let internalName: String
    private let externalName: String
    private let type: TypeNode
    
    init(externalName: String,internalName: String,type: TypeNode)
        {
        self.internalName = internalName
        self.externalName = externalName
        self.type = type
        }
        
    public required init(coder: NSCoder)
        {
        self.internalName = coder.decodeObject(forKey: "internalName") as! String
        self.externalName = coder.decodeObject(forKey: "externalName") as! String
        self.type = coder.decodeObject(forKey: "type") as! TypeNode
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.internalName,forKey: "internalName")
        coder.encode(self.externalName,forKey: "externalName")
        coder.encode(self.type,forKey: "type")
        }
    }

public typealias Parameters = Array<Parameter>

extension Parameters
    {
    public init(arguments: Arguments)
        {
        self.init()
        for argument in arguments
            {
            self.append(Parameter(externalName: argument.externalName, internalName: argument.internalName, type: TypeNode(name: Argon.nextIndex(named: "TYPE"))))
            }
        }
    }
