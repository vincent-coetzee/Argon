//
//  ArrayTypeInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/08/2023.
//

import Foundation

public class ArrayTypeInstance: TypeNode
    {
    private let originalType: TypeNode
    private let indexType: Argon.ArrayIndex
    
    public init(originalType: TypeNode,indexType: Argon.ArrayIndex)
        {
        self.originalType = originalType
        self.indexType = indexType
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.originalType = coder.decodeObject(forKey: "originalType") as! TypeNode
        self.indexType = coder.decodeArrayIndex(forKey: "indexType")
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.originalType,forKey: "originalType")
        coder.encode(self.indexType,forKey: "indexType")
        super.encode(with: coder)
        }
    }
