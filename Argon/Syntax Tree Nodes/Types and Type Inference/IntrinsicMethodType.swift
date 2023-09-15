//
//  IntrinsicMethodType.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/09/2023.
//

import Foundation

public class IntrinsicOperation: NSObject,NSCoding
    {
    public required init(coder: NSCoder)
        {
        }
        
    public func encode(with coder: NSCoder)
        {
        }
    }
    
public typealias IntrinsicOperations = Array<IntrinsicOperation>

public class IntrinsicMethodType: MethodType
    {        
    public override var isIntrinsic: Bool
        {
        true
        }
        
    public var operations = IntrinsicOperations()
    
    public required init(coder: NSCoder)
        {
        self.operations = coder.decodeObject(forKey: "operations") as! IntrinsicOperations
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.operations,forKey: "operations")
        super.encode(with: coder)
        }
    }
