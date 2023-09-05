//
//  SystemMethod.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class SystemMethodType: MethodType
    {
    public init(name: String,parameters: Parameters,returnType: TypeNode? = nil)
        {
        super.init(name: name)
        self.setParameters(parameters)
        self.setReturnType(returnType)
        }
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public init(name: String,_ parameterName: String,_ parameterType: TypeNode,returnType: TypeNode? = nil)
        {
        super.init(name: name)
        self.setParameters([Parameter(definedByPosition: false, externalName: parameterName,internalName: parameterName, type: parameterType)])
        self.setReturnType(returnType)
        }
        
    @discardableResult
    public func parameter(_ name: String,_ type: TypeNode) -> Self
        {
        self.addParameter(Parameter(definedByPosition: false, externalName: name, internalName: name, type: type))
        return(self)
        }
        
    @discardableResult
    public func parameter(_ type: TypeNode) -> Self
        {
        self.addParameter(Parameter(definedByPosition: true, externalName: "", internalName: "", type: type))
        return(self)
        }
        
    @discardableResult
    public func returnType(_ type: TypeNode) -> Self
        {
        self.setReturnType(type)
        return(self)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
    }
