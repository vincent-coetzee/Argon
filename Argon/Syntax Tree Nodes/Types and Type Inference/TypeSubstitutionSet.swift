//
//  SubstitutionSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/08/2023.
//

import Foundation

public class TypeSubstitutionSet
    {
    public static let initialSet = TypeSubstitutionSet()
    
    public static func newTypeVariable(named: String) -> TypeVariable
        {
        Self.initialSet.newTypeVariable(named: named)
        }
        
    public static func newTypeVariable() -> TypeVariable
        {
        Self.initialSet.newTypeVariable(named: Argon.nextIndex(named: "TYPEVAR"))
        }
        
    private var typeVariables = Set<TypeVariable>()
    
    public func newTypeVariable(named: String) -> TypeVariable
        {
        let index = Argon.nextIndex
        let name = "\(named)\(index)"
        let variable = TypeVariable(name: name)
        variable.setIndex(index)
        self.typeVariables.insert(variable)
        return(variable)
        }
        
    public func setValue(of: TypeVariable,to: ArgonType)
        {
        fatalError("This needs to be implemented.")
        }
    }
