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
    private var bindings = Dictionary<Identifier,ArgonType>()
    private var constraints = TypeConstraints()
    
    public func bindValue(_ value: ArgonType,to variable: TypeVariable)
        {
        self.bindings[variable.identifier] = value
        }
        
    public func setTypeVariable(_ typeVariable: TypeVariable,atName: String)
        {
        self.typeVariables[atName] = typeVariable
        }
        
    public func addConstraint(lhs: ArgonType,_ relationship: TypeConstraint.Relationship,rhs: ArgonType,origin: TypeConstraint.Origin)
        {
        let constraint = TypeConstraint(lhs: lhs, relationship, rhs: rhs, origin: origin)
        self.constraints.append(constraint)
        }
    }
