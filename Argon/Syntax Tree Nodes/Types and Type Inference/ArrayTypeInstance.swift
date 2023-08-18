//
//  ArrayTypeInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class ArrayTypeInstance: GenericTypeInstance
    {
    public override var encoding: String
        {
        "Z\(self.indexType.encoding)_"
        }
        
    private var indexType: Argon.ArrayIndex = .none
    
    public required init(originalType: TypeNode,indexType: Argon.ArrayIndex)
        {
        self.indexType = indexType
        super.init(originalType: originalType,types: [])
        }
        
    public required init(coder: NSCoder)
        {
        self.indexType = coder.decodeArrayIndex(forKey: "indexType")
        super.init(coder: coder)
        }
        
    public required init(originalType: TypeNode,types: TypeNodes)
        {
        super.init(originalType: originalType,types: types)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.indexType,forKey: "indexType")
        super.encode(with: coder)
        }
        
    public func setIndexType(_ type: Argon.ArrayIndex)
        {
        self.indexType = type
        }
    }
