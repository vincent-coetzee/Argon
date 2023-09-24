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
    private let instanceType: ConcreteType
    
    init(name: String,instanceType: ConcreteType,typeVariables: TypeVariables)
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
        
    public override func instanciate(withTypes: ArgonTypes,in set: TypeSubstitutionSet) throws -> ArgonType
        {
        if withTypes.count != self.typeVariables.count
            {
            let variableNames = "<" + self.typeVariables.map{$0.name}.joined(separator: ",") + ">"
            let genericNames = "<" + withTypes.map{$0.name}.joined(separator: ",") + ">"
            let message = "Type Variables and generic types mismatch. Expected \(variableNames) found \(genericNames)."
            throw(CompilerError(code: .typeVariableGenericMismatch, message: message, location: .zero))
            }
            let instanciatedTypes = zip(self.typeVariables,withTypes).map{ set.mapTypeVariable($0.0,toType: $0.1)}
        TypeRegistry.registerType(try self.instanceType.instanciate(withTypes: withTypes))
        }
    }
