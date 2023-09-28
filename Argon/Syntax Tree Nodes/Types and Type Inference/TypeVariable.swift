//
//  TypeVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/02/2023.
//

import Foundation

public class TypeVariable: ArgonType
    {
    public enum Value
        {
        case unbound
        case bound(ArgonType)
        case assigned(TypeVariable)
        }
        
    public var isBound: Bool
        {
        switch(self.value)
            {
            case .bound:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isUnbound: Bool
        {
        switch(self.value)
            {
            case .unbound:
                return(true)
            default:
                return(false)
            }
        }
        
    public override var symbolType: ArgonType
        {
        get
            {
            switch(self.value)
                {
                case .bound(let type):
                    return(type.symbolType)
                case .assigned(let variable):
                    return(variable.symbolType)
                case .unbound:
                    fatalError("symbolType may not be invoked on an unbound type variable.")
                }
            }
        set
            {
            }
        }
        
    public var value: Value = .unbound
    public var bindingSet: TypeSubstitutionSet
    
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine(self.name)
        return(hasher.finalize())
        }
        
    fileprivate init(name: String,bindingSet: TypeSubstitutionSet)
        {
        self.bindingSet = bindingSet
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.bindingSet = coder.decodeObject(forKey: "bindingSet") as! TypeSubstitutionSet
        super.init(coder: coder)
        }
        
    public func isBound(inSet set: TypeSubstitutionSet) -> Bool
        {
        self.bindingSet.index == set.index
        }
    }

public typealias TypeVariables = Array<TypeVariable>

public extension TypeSubstitutionSet
    {
    func newTypeVariable(named: String) -> TypeVariable
        {
        let variable = TypeVariable(name: named,bindingSet: self)
        self.setTypeVariable(variable,atName: named)
        return(variable)
        }
        
    func newTypeVariable() -> TypeVariable
        {
        self.newTypeVariable(named: Argon.nextIndex(named: "TYPEVAR"))
        }
    }
