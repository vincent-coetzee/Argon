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
        module.initializeSystemClasses()
        return(module)
        }()
    
    public static var classType: ArgonType { ArgonModule.shared.lookupNode(atName: "Class") as! ArgonType}
    public static var voidType: ArgonType { ArgonModule.shared.lookupNode(atName: "Void") as! ArgonType}
    public static var objectType: ArgonType { ArgonModule.shared.lookupNode(atName: "Object") as! ArgonType}
    public static var objectClass: ClassType { ArgonModule.shared.lookupNode(atName: "Object") as! ClassType}
    public static var stringType: ArgonType { ArgonModule.shared.lookupNode(atName: "String") as! ArgonType}
    public static var floatType: ArgonType { ArgonModule.shared.lookupNode(atName: "Float") as! ArgonType}
    public static var integerType: ArgonType { ArgonModule.shared.lookupNode(atName: "Integer") as! ArgonType}
    public static var booleanType: ArgonType { ArgonModule.shared.lookupNode(atName: "Boolean") as! ArgonType}
    public static var arrayType: ArgonType { ArgonModule.shared.lookupNode(atName: "Array") as! ArgonType}
    public static var byteType: ArgonType { ArgonModule.shared.lookupNode(atName: "Byte") as! ArgonType}
    public static var characterType: ArgonType { ArgonModule.shared.lookupNode(atName: "Character") as! ArgonType}
    public static var symbolType: ArgonType { ArgonModule.shared.lookupNode(atName: "Symbol") as! ArgonType}
    public static var uIntegerType: ArgonType { ArgonModule.shared.lookupNode(atName: "UInteger") as! ArgonType}
    
    private static func systemClass(named name: String,superclassesNamed: Array<String> = [],slots: Slots = Slots(),generics: ArgonTypes = ArgonTypes()) -> ClassType
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
        
    public override var isArgonModule: Bool
        {
        true
        }
        
    private static var _systemTypes = Dictionary<String,ArgonType>()
    private static let _errorType = ErrorType(name: "Error")
    
    private static func lookupNode(atName: String) -> ArgonType?
        {
        self._systemTypes[atName]
        }
    
    public var errorType: ArgonType
        {
        Self._errorType
        }
        
    public var discreteType: ClassType
        {
        return(self.lookupNode(atName: "DiscreteType") as! ClassType)
        }
        
    public var enumerationType: ClassType
        {
        return(self.lookupNode(atName: "Enumeration") as! ClassType)
        }
        
    public var objectType: ClassType
        {
        return(self.lookupNode(atName: "Object") as! ClassType)
        }
        
    public var floatType: ArgonType
        {
        return(self.lookupNode(atName: "Float") as! ArgonType)
        }
        
    public var symbolType: ArgonType
        {
        return(self.lookupNode(atName: "Symbol") as! ArgonType)
        }
        
    public var dateType: ArgonType
        {
        return(self.lookupNode(atName: "Date") as! ArgonType)
        }
        
    public var timeType: ArgonType
        {
        return(self.lookupNode(atName: "Time") as! ArgonType)
        }
        
    public var dateTimeType: ArgonType
        {
        return(self.lookupNode(atName: "DateTime") as! ArgonType)
        }
        
    public var stringType: ArgonType
        {
        return(self.lookupNode(atName: "String") as! ArgonType)
        }
        
    public var booleanType: ArgonType
        {
        return(self.lookupNode(atName: "Boolean") as! ArgonType)
        }
        
    public var byteType: ArgonType
        {
        return(self.lookupNode(atName: "Byte") as! ArgonType)
        }
        
    public var characterType: ArgonType
        {
        return(self.lookupNode(atName: "Character") as! ArgonType)
        }
        
    public var metaclassType: ArgonType
        {
        return(self.lookupNode(atName: "Metaclass") as! ArgonType)
        }
        
    public var classType: ArgonType
        {
        return(self.lookupNode(atName: "Class") as! ArgonType)
        }
        
    public var integerType: ArgonType
        {
        return(self.lookupNode(atName: "Integer") as! ArgonType)
        }
        
    public var integer8Type: ArgonType
        {
        return(self.lookupNode(atName: "Integer8") as! ArgonType)
        }
        
    public var integer16Type: ArgonType
        {
        return(self.lookupNode(atName: "Integer16") as! ArgonType)
        }
        
    public var integer32Type: ArgonType
        {
        return(self.lookupNode(atName: "Integer32") as! ArgonType)
        }
        
    public var integer64Type: ArgonType
        {
        return(self.lookupNode(atName: "Integer64") as! ArgonType)
        }
        
    public var uIntegerType: ArgonType
        {
        return(self.lookupNode(atName: "UInteger") as! ArgonType)
        }
        
    public var uInteger8Type: ArgonType
        {
        return(self.lookupNode(atName: "UInteger8") as! ArgonType)
        }
        
    public var uInteger16Type: ArgonType
        {
        return(self.lookupNode(atName: "UInteger16") as! ArgonType)
        }
        
    public var uInteger32Type: ArgonType
        {
        return(self.lookupNode(atName: "UInteger32") as! ArgonType)
        }
        
    public var uInteger64Type: ArgonType
        {
        return(self.lookupNode(atName: "UInteger64") as! ArgonType)
        }
        
    public var monthType: ArgonType
        {
        return(self.lookupNode(atName: "Month") as! ArgonType)
        }
        
    public var voidType: ClassType
        {
        return(self.lookupNode(atName: "Void") as! ClassType)
        }
        
    public var fileType: ClassType
        {
        return(self.lookupNode(atName: "File") as! ClassType)
        }
        
    public var bufferType: ArgonType
        {
        return(self.lookupNode(atName: "Buffer") as! ArgonType)
        }
    
    private func initializeSystemClasses()
        {
        self.addSystemClass(named: "Object",superclassesNamed: [])
        self.addSystemClass(named: "Type",superclassesNamed: ["Object"])
        self.addSystemClass(named: "InvokableType",superclassesNamed: ["Type"])
        self.addSystemClass(named: "Function",superclassesNamed: ["InvokableType"])
        self.addSystemClass(named: "Method",superclassesNamed: ["InvokableType"])
        self.addSystemClass(named: "DiscreteType",superclassesNamed: ["Object"])
        self.addSystemClass(named: "String",superclassesNamed: ["Object","DiscreteType"])
        self.addSystemClass(named: "Symbol",superclassesNamed: ["String"])
        self.addSystemClass(named: "Boolean",superclassesNamed:["Object"])
        self.addSystemClass(named: "Void",superclassesNamed:["Type"])
        self.addSystemClass(named: "Stream",superclassesNamed: ["Object"])
        self.addSystemClass(named: "ReadStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "WriteStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "File",superclassesNamed: ["Object"])
        self.addSystemClass(named: "ReadFile",superclassesNamed: ["ReadStream","File"])
        self.addSystemClass(named: "WriteFile",superclassesNamed: ["WriteStream","File"])
        self.addSystemClass(named: "ReadWriteFile",superclassesNamed: ["ReadFile","WriteFile"])
        self.addSystemClass(named: "Magnitude",superclassesNamed:["Object"])
        self.addSystemClass(named: "Number",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "FixedPointNumber",superclassesNamed:["Number","DiscreteType"])
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
        self.addSystemClass(named: "Class",superclassesNamed: ["Type"]).slot("name",self.stringType)
        self.addSystemClass(named: "Metaclass",superclassesNamed: ["Class"]).slot("name",self.stringType)
        self.addSystemClass(named: "EnumerationCase",superclassesNamed: ["Object"],generics: [.newTypeVariable(named: "Base")]).slot("name",self.stringType)
        self.addSystemClass(named: "Enumeration",superclassesNamed: ["Type"],generics: [.newTypeVariable(named: "Base")]).slot("name",self.stringType)
        self.addSystemClass(named: "Collection",superclassesNamed: ["Object"],generics: [.newTypeVariable(named: "Element")]).slot("count",self.integer64Type)
        self.addSystemClass(named: "Array",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Index")])
        self.addSystemClass(named: "Set",superclassesNamed: ["Collection"],generics: [])
        self.addSystemClass(named: "List",superclassesNamed: ["Collection"],generics: [])
        self.addSystemClass(named: "Dictionary",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Key")])
        self.addSystemClass(named: "Pointer",superclassesNamed: ["Object"],generics: [])
        self.addSystemClass(named: "BitSet",superclassesNamed: ["Collection"],generics: [.newTypeVariable(named: "Key")])
        self.addSystemAliasedType(named: "Byte",toTypeNamed: "UInteger8")
        self.addSystemAliasedType(named: "Character",toTypeNamed: "UInteger16")
        self.addSystemAliasedType(named: "Integer",toTypeNamed: "Integer64")
        self.addSystemAliasedType(named: "UInteger",toTypeNamed: "UInteger64")
        self.addSystemAliasedType(named: "Float",toTypeNamed: "Float64")
        
        self.addSystemEnumeration(named: "Month", cases: ["#January","#February","#March","#April","#May","#June","#July","#August","#September","#October","#November","#December"])
        
        self.addSystemConstant(named: "$today",ofTypeNamed: "Date")
        self.addSystemConstant(named: "$now",ofTypeNamed: "Time")
        self.addSystemConstant(named: "$pi",ofTypeNamed: "Float")
        self.addSystemConstant(named: "$e",ofTypeNamed: "Float")
        }
        
    public func initializeSystemMetaclasses()
        {
        self.addSystemAliasedType(named: "Buffer",toType: ArrayInstanceType(elementType: self.byteType, indexType: .integerType))
        for entry in self.symbolEntries.values
            {
            if let aClass = entry.node as? ClassType
                {
                let metaclass = MetaclassType(class: aClass)
                metaclass.setType(self.metaclassType)
                aClass.setType(metaclass)
                }
            else if let enumeration = entry.node as? EnumerationType
                {
                let metaclass = MetaclassType(class: self.enumerationType)
                metaclass.setType(self.metaclassType)
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
        self.addSystemMethod(named: "monthIndex").parameter(.dateType).returnType(.integerType)
        self.addSystemMethod(named: "day").parameter(.dateType).returnType(.integerType)
        self.addSystemMethod(named: "month").parameter(.dateType).returnType(.monthType)
        
        self.addSystemMethod(named: "hour").parameter(.timeType).returnType(.integerType)
        self.addSystemMethod(named: "minute").parameter(.timeType).returnType(.integerType)
        self.addSystemMethod(named: "second").parameter(.timeType).returnType(.integerType)
        self.addSystemMethod(named: "millisecond").parameter(.timeType).returnType(.integerType)
        
        self.addSystemMethod(named: "year").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "monthIndex").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "day").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "month").parameter(.dateTimeType).returnType(.monthType)
        
        self.addSystemMethod(named: "hour").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "minute").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "second").parameter(.dateTimeType).returnType(.integerType)
        self.addSystemMethod(named: "millisecond").parameter(.dateTimeType).returnType(.integerType)
        
        self.addSystemMethod(named: "sin").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "cos").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "tan").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "asin").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "acos").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "atan").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "log").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ln").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exp").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "log2").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ln2").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exp2").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "log10").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "ln10").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exp10").parameter(.floatType).returnType(.floatType)
        
        self.addSystemMethod(named: "mantissa").parameter(.floatType).returnType(.floatType)
        self.addSystemMethod(named: "exponent").parameter(.floatType).returnType(.floatType)
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
        
        self.addSystemMethod(named: "open").parameter("fileNamed",.stringType).returnType(.fileType)
        self.addSystemMethod(named: "close").parameter("file",.fileType).returnType(.booleanType)
        self.addSystemMethod(named: "write").parameter("string",.stringType).parameter("to",fileType).returnType(.integerType)
        self.addSystemMethod(named: "write").parameter("integer",.integerType).parameter("to",.fileType).returnType(.integerType)
        self.addSystemMethod(named: "write").parameter("float",.floatType).parameter("to",.fileType).returnType(.integerType)
        self.addSystemMethod(named: "write").parameter("buffer",.bufferType).parameter("to",.fileType).returnType(.integerType)
        self.addSystemMethod(named: "read").parameter("integerFrom",.fileType).returnType(.integerType)
        self.addSystemMethod(named: "read").parameter("floatFrom",.fileType).returnType(.floatType)
        self.addSystemMethod(named: "read").parameter("stringFrom",.fileType).parameter("ofLength",.integerType).returnType(.stringType)
        self.addSystemMethod(named: "read").parameter("bufferFrom",.fileType).parameter("ofLength",.integerType).returnType(.bufferType)
        }
        
    public func dumpMethods()
        {
        for entry in self.symbolEntries.values
            {
            for method in entry.methods
                {
                print(method.description)
                }
            }
        }
        
    @discardableResult
    private func addSubType(named name: String,baseType: ArgonType,minimum: ValueBox,maximum: ValueBox) -> ArgonType
        {
        fatalError()
        }
        
    @discardableResult
    private func addSystemClass(named name: String,superclassesNamed: Array<String>,generics: ArgonTypes = []) -> ClassType
        {
        let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! ClassType}
        let aClass = ClassType(name: name,superclasses: classes,generics: generics)
        self.addNode(aClass)
        aClass.isSystemNode = true
        return(aClass)
        }
        
    @discardableResult
    private func addSystemEnumeration(named name: String,cases: Symbols,generics: ArgonTypes = []) -> EnumerationType
        {
        var actualCases = EnumerationCases()
        var index = 0
        let aClass = EnumerationType(name: name)
        for aCase in cases
            {
            actualCases.append(EnumerationCase(name: aCase,enumeration: aClass, instanceValue: .integer(Argon.Integer(index))))
            index += 1
            }
        self.addNode(aClass)
        aClass.isSystemNode = true
        return(aClass)
        }
        
    private func addGenericSystemClass(named name: String,superclassesNamed: Array<String>,generics: Array<String>)
        {
        let generics = generics.map{self.lookupNode(atName: $0) as! ArgonType}
        let classes = superclassesNamed.map{self.lookupNode(atName: $0) as! ClassType}
        let aClass = ClassType(name: name,superclasses: classes,generics: generics)
        aClass.isSystemNode = true
        self.addNode(aClass)
        }
        
    private func addSystemAliasedType(named name: String,toTypeNamed typeName: String)
        {
        let baseType = self.lookupNode(atName: typeName) as! ArgonType
        let typeAlias = AliasedType(name: name,baseType: baseType)
        typeAlias.isSystemNode = true
        self.addNode(typeAlias)
        }
        
    private func addSystemAliasedType(named name: String,toType type: ArgonType)
        {
        let typeAlias = AliasedType(name: name,baseType: type)
        typeAlias.isSystemNode = true
        self.addNode(typeAlias)
        }
        
    private func addSystemConstant(named name: String,ofTypeNamed typeName: String)
        {
        let baseType = self.lookupNode(atName: typeName) as! ArgonType
        let constant = Constant(name: name,type: baseType,expression: nil)
        constant.isSystemNode = true
        self.addNode(constant)
        }
        
        
    public func addSystemMethod(named: String) -> MethodType
        {
        let method = MethodType(name: named)
        method.isSystemNode = true
        self.addNode(method)
        return(method)
        }
        
    public override func lookupNode(atName someName: String) -> SyntaxTreeNode?
        {
        if let entry = self.symbolEntries[someName]
            {
            return(entry.node)
            }
        return(nil)
        }
        
    public override func lookupMethods(atName someName: String) -> Methods
        {
        var methods = Methods()
        if let entry = self.symbolEntries[someName]
            {
            methods.append(contentsOf: entry.methods)
            }
        return(methods)
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
        
    public override func accept(visitor: Visitor)
        {
        }
    }
