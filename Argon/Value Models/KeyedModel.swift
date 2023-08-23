//
//  KeyedModel.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/08/2023.
//

import Foundation

public class KeyedModel<Kind,ValueType>: Model
    {
    public var keyPath: WritableKeyPath<Kind,ValueType>
    public var model: Kind
    
    public var value: ValueType
        {
        get
            {
            self.model[keyPath: self.keyPath]
            }
        set
            {
            self.model[keyPath: self.keyPath] = newValue
            self.dependents.changed(aspect: keyPath., with: <#T##Any?#>, from: <#T##Model#>
            }
        }
    
    public var dependentKey: Int = DependentSet.nextDependentKey
    public var dependents = DependentSet()
    
    public init(keyPath: WritableKeyPath<Kind,ValueType>,model: Kind) where Kind:AnyObject
        {
        self.keyPath = keyPath
        self.model = model
        let name = keyPath.)
        }
    }
