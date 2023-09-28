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
    
    public let index = Argon.nextIndex
    
    private var typeVariables = Dictionary<String,TypeVariable>()
    private var bindings = Dictionary<Int,ArgonType>()
    
    public func bindValue(_ value: ArgonType,to variable: TypeVariable)
        {
        self.bindings[variable.index] = value
        }
        
    public func setTypeVariable(_ typeVariable: TypeVariable,atName: String)
        {
        self.typeVariables[atName] = typeVariable
        }
    }
