//
//  ArgonModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/01/2023.
//

import Foundation
        
public class ArgonModule: Module
    {
    public static let shared =
        {
        let module = ArgonModule(name: "Argon")
        module.initializeModule()
        return(module)
        }()
    
    public static var classType: TypeNode { ArgonModule.shared.lookupNode(atName: "Class") as! TypeNode}
    public static var voidType: TypeNode { ArgonModule.shared.lookupNode(atName: "Void") as! TypeNode}
    public static var objectType: TypeNode { ArgonModule.shared.lookupNode(atName: "Object") as! TypeNode}
    public static var objectClass: ClassType { ArgonModule.shared.lookupNode(atName: "Object") as! ClassType}
    public static var stringType: TypeNode { ArgonModule.shared.lookupNode(atName: "String") as! TypeNode}
    public static var floatType: TypeNode { ArgonModule.shared.lookupNode(atName: "Float") as! TypeNode}
    public static var integerType: TypeNode { ArgonModule.shared.lookupNode(atName: "Integer") as! TypeNode}
    public static var booleanType: TypeNode { ArgonModule.shared.lookupNode(atName: "Boolean") as! TypeNode}
    
    private static func systemClass(named name: String,superclassesNamed: Array<String> = [],slots: Slots = Slots(),generics: TypeNodes = TypeNodes()) -> ClassType
        {
        guard let aClass = self.lookupNode(atName: name) else
            {
            let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! ClassType}
            let aClass = ClassType(name: name,superclasses: classes)
            self._systemTypes[name] = aClass
            return(aClass)
            }
        return(aClass as! ClassType)
        }
        
    private static func systemAliasedType(named name: String,toTypeNamed typeName: String) -> AliasedType
        {
        guard let anAlias = self.lookupNode(atName: name) as? AliasedType else
            {
            guard let baseType = self.lookupNode(atName: typeName) else
                {
                fatalError()
                }
            let typeAlias = AliasedType(name: name,baseType: baseType)
            self._systemTypes[typeName] = typeAlias
            return(typeAlias)
            }
        return(anAlias)
        }
        
    private static var _systemTypes = Dictionary<String,TypeNode>()
    
    private static func lookupNode(atName: String) -> TypeNode?
        {
        self._systemTypes[atName]
        }
        
    public var symbolType: TypeNode
        {
        return(self.lookupNode(atName: "Symbol") as! TypeNode)
        }
        
    public var classType: TypeNode
        {
        return(self.lookupNode(atName: "Class") as! TypeNode)
        }
        
    public var discreteType: TypeNode
        {
        return(self.lookupNode(atName: "DiscreteType") as! TypeNode)
        }
        
    public var integerType: TypeNode
        {
        return(self.lookupNode(atName: "Integer") as! TypeNode)
        }
        
    public var integer8Type: TypeNode
        {
        return(self.lookupNode(atName: "Integer8") as! TypeNode)
        }
        
    public var integer16Type: TypeNode
        {
        return(self.lookupNode(atName: "Integer16") as! TypeNode)
        }
        
    public var integer32Type: TypeNode
        {
        return(self.lookupNode(atName: "Integer32") as! TypeNode)
        }
        
    public var integer64Type: TypeNode
        {
        return(self.lookupNode(atName: "Integer64") as! TypeNode)
        }
        
    public var stringType: TypeNode
        {
        return(self.lookupNode(atName: "String") as! TypeNode)
        }
        
    public var uIntegerType: TypeNode
        {
        return(self.lookupNode(atName: "UInteger") as! TypeNode)
        }
        
    public var uInteger8Type: TypeNode
        {
        return(self.lookupNode(atName: "UInteger8") as! TypeNode)
        }
        
    public var uInteger16Type: TypeNode
        {
        return(self.lookupNode(atName: "UInteger16") as! TypeNode)
        }
        
    public var uInteger32Type: TypeNode
        {
        return(self.lookupNode(atName: "UInteger32") as! TypeNode)
        }
        
    public var uInteger64Type: TypeNode
        {
        return(self.lookupNode(atName: "UInteger64") as! TypeNode)
        }
        
    public func initializeModule()
        {
        self.addSystemClass(named: "Object",superclassesNamed: [])
        self.addSystemClass(named: "String",superclassesNamed: ["Object"])
        self.addSystemClass(named: "Symbol",superclassesNamed: ["String"])
        self.addSystemClass(named: "Boolean",superclassesNamed:["Object"])
        self.addSystemClass(named: "Void",superclassesNamed:["Object"])
        self.addSystemClass(named: "Stream",superclassesNamed: ["Object"])
        self.addSystemClass(named: "ReadStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "WriteStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "File",superclassesNamed: ["ReadStream","WriteStream"])
        self.addSystemClass(named: "Magnitude",superclassesNamed:["Object"])
        self.addSystemClass(named: "Number",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "FixedPointNumber",superclassesNamed:["Number"])
        self.addSystemClass(named: "FloatingPointNumber",superclassesNamed:["Number"])
        self.addSystemClass(named: "Integer8",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "Integer16",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "Integer32",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "Integer64",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "UInteger8",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "UInteger16",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "UInteger32",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "UInteger64",superclassesNamed:["FixedPointNumber"])
        self.addSystemClass(named: "Float16",superclassesNamed:["FloatingPointNumber"])
        self.addSystemClass(named: "Float32",superclassesNamed:["FloatingPointNumber"])
        self.addSystemClass(named: "Float64",superclassesNamed:["FloatingPointNumber"])
        self.addSystemClass(named: "Date",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "Time",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "DateTime",superclassesNamed:["Date","Time"])
        self.addSystemClass(named: "Slot",superclassesNamed: ["Object"]).slot("name",self.stringType)
        self.addSystemClass(named: "Class",superclassesNamed: ["Object"]).slot("name",self.stringType)
        self.addSystemClass(named: "EnumerationCase",superclassesNamed: ["Object"]).slot("name",self.stringType)
        self.addSystemClass(named: "Enumeration",superclassesNamed: ["Object"]).slot("name",self.stringType).slot("rawType",self.discreteType)
        self.addSystemClass(named: "Collection",superclassesNamed: ["Object"],generics: []).slot("count",self.integer64Type)
        self.addSystemClass(named: "IndexedCollection",superclassesNamed: ["Collection"],generics: [])
        self.addSystemClass(named: "Array",superclassesNamed: ["IndexedCollection"],generics: [.newTypeVariable(name: "Element"),.newTypeVariable(name: "Index")])
        self.addSystemClass(named: "Set",superclassesNamed: ["Collection"],generics: [.newTypeVariable(name: "Element")])
        self.addSystemClass(named: "List",superclassesNamed: ["Collection"],generics: [.newTypeVariable(name: "Element")])
        self.addSystemClass(named: "Dictionary",superclassesNamed: ["Collection"],generics: [.newTypeVariable(name: "Element"),.newTypeVariable(name: "Key")])
        self.addSystemClass(named: "Pointer",superclassesNamed: ["Object"],generics: [.newTypeVariable(name: "Element")])
        self.addSystemAliasedType(named: "Byte",toTypeNamed: "UInteger8")
        self.addSystemAliasedType(named: "Character",toTypeNamed: "UInteger16")
        self.addSystemAliasedType(named: "Integer",toTypeNamed: "Integer64")
        self.addSystemAliasedType(named: "UInteger",toTypeNamed: "UInteger64")
        self.addSystemAliasedType(named: "Float",toTypeNamed: "Float64")
        }
        
    @discardableResult
    private func addSubType(named name: String,baseType: TypeNode,minimum: ValueBox,maximum: ValueBox) -> TypeNode
        {
        fatalError()
        }
        
    @discardableResult
    private func addBasicSystemType(named name: String,rawType: RawType) -> BasicType
        {
        let aType = BasicType(name: name,rawType: rawType)
        self.addNode(aType)
        aType.isSystemNode = true
        return(aType)
        }
        
    @discardableResult
    private func addSystemClass(named name: String,superclassesNamed: Array<String>,generics: TypeNodes = []) -> ClassType
        {
        let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! ClassType}
        let aClass = ClassType(name: name,superclasses: classes,generics: generics)
        self.addNode(aClass)
        aClass.isSystemNode = true
        return(aClass)
        }
        
    private func addGenericSystemClass(named name: String,superclassesNamed: Array<String>,generics: Array<String>)
        {
        let generics = generics.map{self.lookupNode(atName: $0) as! TypeNode}
        let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! ClassType}
        let aClass = ClassType(name: name,superclasses: classes,generics: generics)
        aClass.isSystemNode = true
        self.addNode(aClass)
        }
        
    private func addSystemAliasedType(named name: String,toTypeNamed typeName: String)
        {
        let baseType = self.lookupNode(atName: typeName) as! TypeNode
        let typeAlias = AliasedType(name: name,baseType: baseType)
        typeAlias.isSystemNode = true
        self.addNode(typeAlias)
        }
        
    public override func lookupNode(atName name: String) -> SyntaxTreeNode?
        {
        for node in self.containedNodes
            {
            if node.name == name
                {
                return(node)
                }
            }
        return(nil)
        }
        
    public func isSystemClass(named: String) -> Bool
        {
        if let aClass = self.lookupNode(atName: named)
            {
            if aClass.isSystemNode,aClass is ClassType
                {
                return(true)
                }
            }
        return(false)
        }
        
    public func isSystemEnumeration(named: String) -> Bool
        {
        if let enumeration = self.lookupNode(atName: named)
            {
            if enumeration.isSystemNode,enumeration is EnumerationType
                {
                return(true)
                }
            }
        return(false)
        }
        
    public func isSystemAliasedType(named: String) -> Bool
        {
        if let type = self.lookupNode(atName: named)
            {
            if type.isSystemNode,type is AliasedType
                {
                return(true)
                }
            }
        return(false)
        }
    }
