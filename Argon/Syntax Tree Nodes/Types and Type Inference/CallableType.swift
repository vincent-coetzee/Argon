//
//  ExecutableTypeNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/08/2023.
//

import Foundation

public class CallableType: ArgonType
    {
    public override var hash: Int
        {
        var hasher = Hasher()
        let kind = Swift.type(of: self) == MethodType.self ? "METHOD" : "FUNCTION"
        hasher.combine(kind)
        hasher.combine(self.parent)
        hasher.combine(self.name)
        for parameter in self.parameters
            {
            hasher.combine(parameter.type.typeHash)
            }
        hasher.combine(returnType.typeHash)
        return(hasher.finalize())
        }
        
    public private(set) var parameters = Parameters()
    public private(set) var returnType: ArgonType = ArgonModule.shared.voidType
    
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.parameters = coder.decodeObject(forKey: "parameters") as! Parameters
        self.returnType = coder.decodeObject(forKey: "returnType") as! ArgonType
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.parameters,forKey: "parameters")
        coder.encode(self.returnType,forKey: "returnType")
        super.encode(with: coder)
        }
        
    public func setParameters(_ parameters: Parameters)
        {
        self.parameters = parameters
        }
        
    public func addParameter(_ parameter: Parameter)
        {
        self.parameters.append(parameter)
        }
        
    public func setReturnType(_ returnType: ArgonType?)
        {
        self.returnType = returnType.isNil ? ArgonModule.shared.voidType : returnType!
        }
        
    @discardableResult
    public func parameter(_ name: String,_ type: ArgonType) -> Self
        {
        self.addParameter(Parameter(definedByPosition: false, externalName: name, internalName: name, type: type))
        return(self)
        }
        
    @discardableResult
    public func parameter(_ type: ArgonType) -> Self
        {
        self.addParameter(Parameter(definedByPosition: true, externalName: "", internalName: "", type: type))
        return(self)
        }
        
    @discardableResult
    public func returnType(_ type: ArgonType) -> Self
        {
        self.setReturnType(type)
        return(self)
        }
        
        
//    internal override func mangleName(_ aName: String) -> String
//        {
//        let parameterTypes = self.parameters.map{$0.type.mangledName}.joined(separator: "")
//        guard let someName = ArgonModule.encoding(for: aName) else
//            {
//            return("\(self.name.count)x\(self.name)\(self.parameters.count + 1)x\(self.returnType.mangledName)\(parameterTypes)")
//            }
//        return("\(someName)\(self.parameters.count + 1)x\(self.returnType.mangledName)\(parameterTypes)")
//        }
    }
