//
//  ConstructorType.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/09/2023.
//

import Foundation

public class ConcreteType: StructuredType
    {
    }
    
public class ConstructorType: ArgonType
    {
    private let typeVariables: TypeVariables
    private let instanceType: ArgonType
    
    init(name: String,instanceType: ArgonType,typeVariables: TypeVariables)
        {
        self.instanceType = instanceType
        self.typeVariables = typeVariables
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.instanceType = coder.decodeObject(forKey: "instanceType") as! ConcreteType
        self.typeVariables = coder.decodeObject(forKey: "typeVariables") as! TypeVariables
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.instanceType,forKey: "instanceType")
        coder.encode(self.typeVariables,forKey: "typeVariables")
        super.encode(with: coder)
        }
        
    public override func instanciate(with types: ArgonTypes,in set: TypeSubstitutionSet) throws -> ArgonType
        {
        if types.count != self.typeVariables.count
            {
            let variableNames = "<" + self.typeVariables.map{$0.name}.joined(separator: ",") + ">"
            let genericNames = "<" + types.map{$0.name}.joined(separator: ",") + ">"
            let message = "Type variables and generic types mismatch. Expected \(variableNames) found \(genericNames)."
            throw(CompilerError(code: .typeVariableGenericMismatch, message: message, location: .zero))
            }
        for (typeVariable,solution) in zip(self.typeVariables,types)
            {
            set.setValue(of: typeVariable, to: solution)
            }
        return(TypeRegistry.registerType(try self.instanceType.instanciate(with: types,in: set)))
        }
    }
