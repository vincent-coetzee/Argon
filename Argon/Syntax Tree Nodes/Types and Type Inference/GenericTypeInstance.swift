//
//  GenericTypeInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/08/2023.
//

import Foundation

internal class TypePair: NSObject,NSCoding
    {
    public var typeVariable: TypeVariable
    public var concreteType: TypeNode
    
    public required init(coder: NSCoder)
        {
        self.typeVariable = coder.decodeObject(forKey: "typeVariable") as! TypeVariable
        self.concreteType = coder.decodeObject(forKey: "concreteType") as! TypeNode
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.typeVariable,forKey: "typeVariable")
        coder.encode(self.concreteType,forKey: "concreteType")
        }
    }
    
internal typealias TypePairs = Array<TypePair>

public class GenericTypeInstance: TypeNode
    {
    public override var encoding: String
        {
        "e\(self.name)."
        }
        
    private let originalType: TypeNode
    private let types: TypeNodes
    
    public required init(originalType: TypeNode,types: TypeNodes)
        {
        self.types = types
        self.originalType = originalType
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.originalType = coder.decodeObject(forKey: "orginalType") as! TypeNode
        self.types = coder.decodeObject(forKey: "types") as! TypeNodes
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.originalType,forKey: "originalType")
        coder.encode(self.types,forKey: "types")
        super.encode(with: coder)
        }
    }
