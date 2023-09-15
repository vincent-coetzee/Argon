//
//  GenericTypeInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/08/2023.
//

import Foundation

//internal class TypePair: NSObject,NSCoding
//    {
//    public var typeVariable: TypeVariable
//    public var concreteType: BaseType
//
//    public required init(coder: NSCoder)
//        {
//        self.typeVariable = coder.decodeObject(forKey: "typeVariable") as! TypeVariable
//        self.concreteType = coder.decodeObject(forKey: "concreteType") as! BaseType
//        }
//
//    public func encode(with coder: NSCoder)
//        {
//        coder.encode(self.typeVariable,forKey: "typeVariable")
//        coder.encode(self.concreteType,forKey: "concreteType")
//        }
//    }
//
//internal typealias TypePairs = Array<TypePair>

public class GenericInstanceType: StructuredType
    {
    public override var typeHash: Int
        {
        var hasher = Hasher()
        hasher.combine(super.typeHash)
        hasher.combine(self.parentType.typeHash)
        return(hasher.finalize())
        }
        
    public override var parentType: ArgonType
        {
        self._parentType
        }
        
    public override var isGenericType: Bool
        {
        true
        }
        
    private let _parentType: ArgonType
    
    public required init(parentType: ArgonType,types: ArgonTypes)
        {
        self._parentType = parentType
        super.init(name: "GenericInstance(of: \(parentType.name))")
        self.setGenericTypes(types)
        }
        
    public required init(coder: NSCoder)
        {
        self._parentType = coder.decodeObject(forKey: "parentType") as! ArgonType
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self._parentType,forKey: "parentType")
        super.encode(with: coder)
        }
    }
