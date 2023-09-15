//
//  ArrayTypeInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class ArrayInstanceType: GenericInstanceType
    {
    public override var isArrayType: Bool
        {
        true
        }
        
    public override var isSystemNode: Bool
        {
        get
            {
            true
            }
        set
            {
            }
        }
        
    public required init(elementType: ArgonType,indexType: ArgonType)
        {
        super.init(parentType: ArgonModule.arrayType,types: [elementType,indexType])
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public required init(parentType: ArgonType,types: ArgonTypes)
        {
        super.init(parentType: parentType,types: types)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public func setIndexType(_ type: ArgonType)
        {
        var types = self.genericTypes
        types[1] = type
        self.setGenericTypes(types)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(arrayInstanceType: self)
        }
        
//    internal override func mangleName(_ aName: String) -> String
//        {
//        let typeNames = "2" + self.genericTypes[0]._mangledName + self.indexType._mangledName
//        let someName = ArgonModule.encoding(for: "Array")!
//        return("\(someName)\(typeNames)")
//        }
    }
