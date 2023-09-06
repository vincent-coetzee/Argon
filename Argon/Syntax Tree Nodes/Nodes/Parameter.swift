//
//  Parameter.swift
//  Argon
//
//  Created by Vincent Coetzee on 29/07/2023.
//

import Foundation

public class Parameter: Variable
    {
    private let internalName: String
    private let externalName: String?
    public let definedByPosition: Bool
    
    public override var description: String
        {
        if self.definedByPosition
            {
            return(self.type.name)
            }
        let aName = self.externalName.isNil ? "-\(self.internalName)" : "\(self.externalName!)"
        let typeName = self.type.name
        return("\(aName)::\(typeName)")
        }
        
    init(definedByPosition: Bool,externalName: String?,internalName: String,type: TypeNode)
        {
        self.definedByPosition = definedByPosition
        self.internalName = internalName
        self.externalName = externalName
        super.init(name: internalName,type: type,expression: nil)
        }
        
    public required init(coder: NSCoder)
        {
        self.definedByPosition = coder.decodeBool(forKey: "definedByPosition")
        self.internalName = coder.decodeObject(forKey: "internalName") as! String
        self.externalName = coder.decodeObject(forKey: "externalName") as? String
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.definedByPosition,forKey: "definedByPosition")
        coder.encode(self.internalName,forKey: "internalName")
        coder.encode(self.externalName,forKey: "externalName")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(parameter: self)
        }
    }

public typealias Parameters = Array<Parameter>

extension Parameters
    {
    public var location: Location
        {
        get
            {
            .zero
            }
        set
            {
            for parameter in self
                {
                parameter.location = newValue
                }
            }
        }
    }
    
//extension Parameters
//    {
//    public init(arguments: Arguments)
//        {
//        self.init()
//        for argument in arguments
//            {
//            self.append(Parameter(externalName: argument.externalName, internalName: argument.internalName, type: TypeNode(name: Argon.nextIndex(named: "TYPE"))))
//            }
//        }
//    }
