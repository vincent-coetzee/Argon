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
    public static var objectClass: Class { ArgonModule.shared.lookupNode(atName: "Object") as! Class}
    public static var stringType: TypeNode { ArgonModule.shared.lookupNode(atName: "String") as! TypeNode}
    public static var floatType: TypeNode { ArgonModule.shared.lookupNode(atName: "Float") as! TypeNode}
    public static var integerType: TypeNode { ArgonModule.shared.lookupNode(atName: "Integer") as! TypeNode}
    public static var booleanType: TypeNode { ArgonModule.shared.lookupNode(atName: "Boolean") as! TypeNode}
    public static var arrayType: TypeNode { ArgonModule.shared.lookupNode(atName: "Array") as! TypeNode}
    public static var byteType: TypeNode { ArgonModule.shared.lookupNode(atName: "Byte") as! TypeNode}
    public static var characterType: TypeNode { ArgonModule.shared.lookupNode(atName: "Character") as! TypeNode}
    public static var symbolType: TypeNode { ArgonModule.shared.lookupNode(atName: "Symbol") as! TypeNode}
    public static var uIntegerType: TypeNode { ArgonModule.shared.lookupNode(atName: "UInteger") as! TypeNode}
    
    private static func systemClass(named name: String,superclassesNamed: Array<String> = [],slots: Slots = Slots(),generics: TypeNodes = TypeNodes()) -> Class
        {
        guard let aClass = self.lookupNode(atName: name) else
            {
            let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! Class}
            let aClass = Class(name: name,superclasses: classes)
            self._systemTypes[name] = aClass
            return(aClass)
            }
        return(aClass as! Class)
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
        
    public var enumerationBaseType: Class
        {
        return(self.lookupNode(atName: "EnumerationBase") as! Class)
        }
        
    public var enumerationType: Class
        {
        return(self.lookupNode(atName: "Enumeration") as! Class)
        }
        
    public var objectType: Class
        {
        return(self.lookupNode(atName: "Object") as! Class)
        }
        
    public var floatType: TypeNode
        {
        return(self.lookupNode(atName: "Float") as! TypeNode)
        }
        
    public var symbolType: TypeNode
        {
        return(self.lookupNode(atName: "Symbol") as! TypeNode)
        }
        
    public var dateType: TypeNode
        {
        return(self.lookupNode(atName: "Date") as! TypeNode)
        }
        
    public var timeType: TypeNode
        {
        return(self.lookupNode(atName: "Time") as! TypeNode)
        }
        
    public var dateTimeType: TypeNode
        {
        return(self.lookupNode(atName: "DateTime") as! TypeNode)
        }
        
    public var stringType: TypeNode
        {
        return(self.lookupNode(atName: "String") as! TypeNode)
        }
        
    public var booleanType: TypeNode
        {
        return(self.lookupNode(atName: "Boolean") as! TypeNode)
        }
        
    public var byteType: TypeNode
        {
        return(self.lookupNode(atName: "Byte") as! TypeNode)
        }
        
    public var characterType: TypeNode
        {
        return(self.lookupNode(atName: "Character") as! TypeNode)
        }
        
    public var classType: TypeNode
        {
        return(self.lookupNode(atName: "Class") as! TypeNode)
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
        
    public var monthType: TypeNode
        {
        return(self.lookupNode(atName: "Month") as! TypeNode)
        }
        
    public var voidType: Class
        {
        return(self.lookupNode(atName: "Void") as! Class)
        }
        
    public func initializeModule()
        {
        self.addSystemClass(named: "Object",superclassesNamed: [])
        self.addSystemClass(named: "EnumerationBase",superclassesNamed: ["Object"])
        self.addSystemClass(named: "String",superclassesNamed: ["Object","EnumerationBase"],encoding: "S")
        self.addSystemClass(named: "Symbol",superclassesNamed: ["String"])
        self.addSystemClass(named: "Boolean",superclassesNamed:["Object"])
        self.addSystemClass(named: "Void",superclassesNamed:["Object"])
        self.addSystemClass(named: "Stream",superclassesNamed: ["Object"])
        self.addSystemClass(named: "ReadStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "WriteStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "File",superclassesNamed: ["ReadStream","WriteStream"])
        self.addSystemClass(named: "Magnitude",superclassesNamed:["Object"])
        self.addSystemClass(named: "Number",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "FixedPointNumber",superclassesNamed:["Number","EnumerationBase"])
        self.addSystemClass(named: "FloatingPointNumber",superclassesNamed:["Number"])
        self.addSystemClass(named: "Integer8",superclassesNamed:["FixedPointNumber"],encoding: "A")
        self.addSystemClass(named: "Integer16",superclassesNamed:["FixedPointNumber"],encoding: "B")
        self.addSystemClass(named: "Integer32",superclassesNamed:["FixedPointNumber"],encoding: "C")
        self.addSystemClass(named: "Integer64",superclassesNamed:["FixedPointNumber"],encoding: "D")
        self.addSystemClass(named: "UInteger8",superclassesNamed:["FixedPointNumber"],encoding: "E")
        self.addSystemClass(named: "UInteger16",superclassesNamed:["FixedPointNumber"],encoding: "F")
        self.addSystemClass(named: "UInteger32",superclassesNamed:["FixedPointNumber"],encoding: "G")
        self.addSystemClass(named: "UInteger64",superclassesNamed:["FixedPointNumber"],encoding: "H")
        self.addSystemClass(named: "Float16",superclassesNamed:["FloatingPointNumber"],encoding: "I")
        self.addSystemClass(named: "Float32",superclassesNamed:["FloatingPointNumber"],encoding: "J")
        self.addSystemClass(named: "Float64",superclassesNamed:["FloatingPointNumber"],encoding: "K")
        self.addSystemClass(named: "Date",superclassesNamed:["Magnitude"],encoding: "L")
        self.addSystemClass(named: "Time",superclassesNamed:["Magnitude"],encoding: "M")
        self.addSystemClass(named: "DateTime",superclassesNamed:["Date","Time"],encoding: "N")
        self.addSystemClass(named: "Slot",superclassesNamed: ["Object"],encoding: "O").slot("name",self.stringType)
        self.addSystemClass(named: "Class",superclassesNamed: ["Object"]).slot("name",self.stringType)
        self.addSystemClass(named: "Metaclass",superclassesNamed: ["Class"]).slot("name",self.stringType)
        self.addSystemClass(named: "EnumerationCase",superclassesNamed: ["Object"],generics: [.newTypeVariable(named: "BaseType")]).slot("name",self.stringType)
        self.addSystemClass(named: "Enumeration",superclassesNamed: ["Object"],generics: [.newTypeVariable(named: "BaseType")]).slot("name",self.stringType)
        self.addSystemClass(named: "Collection",superclassesNamed: ["Object"],generics: []).slot("count",self.integer64Type)
        self.addSystemClass(named: "IndexedCollection",superclassesNamed: ["Collection"],generics: [])
        self.addSystemClass(named: "Array",superclassesNamed: ["IndexedCollection"],generics: [.newTypeVariable(named: "Element"),.newTypeVariable(named: "Index")])
        self.addSystemClass(named: "Set",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Element")],instanceType: SetInstance.self)
        self.addSystemClass(named: "List",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Element")],instanceType: ListInstance.self)
        self.addSystemClass(named: "Dictionary",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Element"),.newTypeVariable(named: "Key")],instanceType: DictionaryInstance.self)
        self.addSystemClass(named: "Pointer",superclassesNamed: ["Object"],generics: [.newTypeVariable(named: "Element")],instanceType: PointerInstance.self)
        self.addSystemClass(named: "BitSet",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Element"),.newTypeVariable(named: "Key")],instanceType: BitSetInstance.self)
        self.addSystemAliasedType(named: "Byte",toTypeNamed: "UInteger8",encoding: "P")
        self.addSystemAliasedType(named: "Character",toTypeNamed: "UInteger16",encoding: "Q")
        self.addSystemAliasedType(named: "Integer",toTypeNamed: "Integer64",encoding: "R")
        self.addSystemAliasedType(named: "UInteger",toTypeNamed: "UInteger64",encoding: "T")
        self.addSystemAliasedType(named: "Float",toTypeNamed: "Float64",encoding: "U")
        
        self.addSystemEnumeration(named: "Month", cases: ["#January","#February","#March","#April","#May","#June","#July","#August","#September","#October","#November","#December"])
        
        self.addSystemConstant(named: "$TODAY",ofTypeNamed: "Date")
        self.addSystemConstant(named: "$NOW",ofTypeNamed: "Time")
        self.addSystemConstant(named: "$PI",ofTypeNamed: "Float")
        
        self.addNode(VoidType(name: "Void",superclasses: [self.objectType]))
        }
        
    public func initializeMetaclasses()
        {
        self.symbolTable.doNodes
            {
            node in
            if let aClass = node as? Class
                {
                let metaclass = Metaclass(class: aClass)
                metaclass.setType(self.classType)
                aClass.setType(metaclass)
                }
            else if let enumeration = node as? Enumeration
                {
                let metaclass = Metaclass(class: self.enumerationType)
                metaclass.setType(self.classType)
                enumeration.setType(metaclass)
                }
            }
        }
        
    public func initializeSystemMethods()
        {
        self.addSystemMethod(named: "string").parameter(.integerType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.uIntegerType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.characterType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.byteType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.booleanType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.symbolType).returnType(.stringType)
        
        self.addSystemMethod(named: "date").parameter(.stringType).returnType(.dateType)
        self.addSystemMethod(named: "date").parameter(.integerType).returnType(.dateType)
        self.addSystemMethod(named: "date").parameter(.uIntegerType).returnType(.dateType)
        
        self.addSystemMethod(named: "time").parameter(.stringType).returnType(.timeType)
        self.addSystemMethod(named: "time").parameter(.integerType).returnType(.timeType)
        self.addSystemMethod(named: "time").parameter(.uIntegerType).returnType(.timeType)
        
        self.addSystemMethod(named: "dateTime").parameter(.stringType).returnType(.dateTimeType)
        self.addSystemMethod(named: "dateTime").parameter(.integerType).returnType(.dateTimeType)
        self.addSystemMethod(named: "dateTime").parameter(.uIntegerType).returnType(.dateTimeType)
        
        self.addSystemMethod(named: "integer").parameter(.stringType).returnType(.integerType)
        self.addSystemMethod(named: "integer").parameter(.uIntegerType).returnType(.integerType)
        self.addSystemMethod(named: "integer").parameter(.characterType).returnType(.integerType)
        self.addSystemMethod(named: "integer").parameter(.byteType).returnType(.integerType)
        self.addSystemMethod(named: "integer").parameter(.booleanType).returnType(.integerType)
        self.addSystemMethod(named: "integer").parameter(.symbolType).returnType(.integerType)

        self.addSystemMethod(named: "character").parameter(.integerType).returnType(.characterType)
        self.addSystemMethod(named: "character").parameter(.byteType).returnType(.characterType)
        self.addSystemMethod(named: "character").parameter(.uIntegerType).returnType(.characterType)

        self.addSystemMethod(named: "byte").parameter(.integerType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.stringType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.uIntegerType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.characterType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.booleanType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.symbolType).returnType(.byteType)

        self.addSystemMethod(named: "uInteger").parameter(.stringType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.integerType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.characterType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.byteType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.symbolType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.booleanType).returnType(.uIntegerType)

        self.addSystemMethod(named: "boolean").parameter(.symbolType).returnType(.booleanType)

        self.addSystemMethod(named: "symbol").parameter(.integerType).returnType(.symbolType)
        self.addSystemMethod(named: "symbol").parameter(.uIntegerType).returnType(.symbolType)
        self.addSystemMethod(named: "symbol").parameter(.stringType).returnType(.symbolType)
        self.addSystemMethod(named: "symbol").parameter(.characterType).returnType(.symbolType)
        self.addSystemMethod(named: "symbol").parameter(.booleanType).returnType(.symbolType)
        self.addSystemMethod(named: "symbol").parameter(.byteType).returnType(.symbolType)
        
        self.addSystemMethod(named: "year").parameter(.dateType).returnType(.integerType)
        self.addSystemMethod(named: "month").parameter(.dateType).returnType(.integerType)
        self.addSystemMethod(named: "day").parameter(.dateType).returnType(.integerType)
        self.addSystemMethod(named: "monthElement").parameter(.dateType).returnType(.monthType)
        
        self.addSystemMethod(named: "hour").parameter(.timeType).returnType(.integerType)
        self.addSystemMethod(named: "minute").parameter(.timeType).returnType(.integerType)
        self.addSystemMethod(named: "second").parameter(.timeType).returnType(.integerType)
        self.addSystemMethod(named: "millisecond").parameter(.timeType).returnType(.integerType)
        
        self.addSystemMethod(named: "year?").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "month?").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "day?").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "monthElement?").parameter(.dateTimeType).returnType(.monthType)
        
        self.addSystemMethod(named: "hour?").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "minute?").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "second?").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "millisecond?").parameter(.dateTimeType).returnType(.integerType)
        
        self.addSystemMethod(named: "sin?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "cos?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "tan?").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "asin?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "acos?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "atan?").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "log?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ln?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exp?").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "log2?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ln2?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exp2?").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "log10?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ln10?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exp10?").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "mantissa?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exponent?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "isFinite?").parameter(.floatType).returnType(.booleanType)
        self.addSystemMethod(named: "isInfinite?").parameter(.floatType).returnType(.booleanType)
        self.addSystemMethod(named: "isNan?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "signBit?").parameter(.floatType).returnType(.integerType)
        self.addSystemMethod(named: "isNormal?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ceiling?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "floor?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "fmod?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "remainder?").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "maximum?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "minimum?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "maximum?").parameter(.integerType).returnType(.integerType)
        self.addSystemMethod(named: "minimum?").parameter(.integerType).returnType(.integerType)
        
        self.addSystemMethod(named: "squareRoot?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "absoluteValue?").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "squareRoot?").parameter(.integerType).returnType(.integerType)
        self.addSystemMethod(named: "absoluteValue?").parameter(.integerType).returnType(.integerType)
        
        }
        
    @discardableResult
    private func addSubType(named name: String,baseType: TypeNode,minimum: ValueBox,maximum: ValueBox) -> TypeNode
        {
        fatalError()
        }
        
//    @discardableResult
//    private func addBasicSystemType(named name: String,rawType: RawType) -> BasicType
//        {
//        let aType = BasicType(name: name,rawType: rawType)
//        self.addNode(aType)
//        aType.isSystemNode = true
//        return(aType)
//        }
        
    @discardableResult
    private func addSystemClass(named name: String,superclassesNamed: Array<String>,generics: TypeNodes = [],encoding: String? = nil,instanceType: GenericTypeInstance.Type? = nil) -> Class
        {
        let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! Class}
        let aClass = Class(name: name,superclasses: classes,generics: generics)
        self.addNode(aClass)
        aClass.isSystemNode = true
        aClass.setEncoding(encoding)
        aClass.setInstanceType(instanceType)
        return(aClass)
        }
        
    @discardableResult
    private func addSystemEnumeration(named name: String,cases: Symbols,generics: TypeNodes = []) -> Enumeration
        {
        var actualCases = EnumerationCases()
        var index = 0
        for aCase in cases
            {
            actualCases.append(EnumerationCase(name: aCase, instanceValue: .integer(Argon.Integer(index))))
            index += 1
            }
        let aClass = Enumeration(name: name,cases: actualCases)
        self.addNode(aClass)
        aClass.isSystemNode = true
        return(aClass)
        }
        
    private func addGenericSystemClass(named name: String,superclassesNamed: Array<String>,generics: Array<String>)
        {
        let generics = generics.map{self.lookupNode(atName: $0) as! TypeNode}
        let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! Class}
        let aClass = Class(name: name,superclasses: classes,generics: generics)
        aClass.isSystemNode = true
        self.addNode(aClass)
        }
        
    private func addSystemAliasedType(named name: String,toTypeNamed typeName: String,encoding: String? = nil)
        {
        let baseType = self.lookupNode(atName: typeName) as! TypeNode
        let typeAlias = AliasedType(name: name,baseType: baseType)
        typeAlias.isSystemNode = true
        typeAlias.setEncoding(encoding)
        self.addNode(typeAlias)
        }
        
    private func addSystemConstant(named name: String,ofTypeNamed typeName: String)
        {
        let baseType = self.lookupNode(atName: typeName) as! TypeNode
        let constant = Constant(name: name,type: baseType,expression: nil)
        constant.isSystemNode = true
        self.addNode(constant)
        }
        
        
    public func addSystemMethod(named: String) -> SystemMethod
        {
        let method = SystemMethod(name: named)
        self.addNode(method)
        return(method)
        }
        
    public override func lookupNode(atName name: String) -> SyntaxTreeNode?
        {
        if let node = self.symbolTable.lookupNode(atName: name)
            {
            return(node)
            }
        return(nil)
        }
        
    public override func lookupMethods(atName name: String) -> Methods
        {
        return(self.symbolTable.lookupMethods(atName: name))
        }
        
    public func isSystemClass(named: String) -> Bool
        {
        if let aClass = self.lookupNode(atName: named)
            {
            if aClass.isSystemNode,aClass is Class
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
            if enumeration.isSystemNode,enumeration is Enumeration
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
