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
        let indexEncoding = self.indexType.encoding
        "f\(self.name)_"
        }
        
    private var indexType: Argon.ArrayIndex = .none
    
    public required init(originalType: TypeNode,types: TypeNodes)
        {
        super.init(originalType: originalType,types: types)
        }
        
    public required init(coder: NSCoder)
        {
        self.indexType = coder.decodeArrayIndex(forKey: "indexType")
        super.init(coder: coder)
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
