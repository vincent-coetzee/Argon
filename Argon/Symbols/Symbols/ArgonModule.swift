//
//  ArgonModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/01/2023.
//

import Foundation
        
public class ArgonModule: ModuleType
    {
    public private(set) static var shared: ArgonModule!
        
    public override var argonModule: ArgonModule
        {
        self
        }
        
    public override var isArgonModule: Bool
        {
        true
        }
        
    private static let _errorType = ErrorType(name: "Error")
    
    public init()
        {
        super.init(name: "Argon")
        Self.shared = self
        RootModule.initializeRootModule(argonModule: self)
        self.initializeSystemClasses()
        self.initializeSystemMethods()
        self.initializeSystemMetaclasses()
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
    
    public required init(name: String,genericTypes: ArgonTypes)
        {
        super.init(name: name)
        self.setGenericTypes(genericTypes)
        }
    //
    //
    //
    // Covenience methods for accessing system types from
    // external to this module.
    //
    //
    //
    public var errorType: ArgonType
        {
        Self._errorType
        }
        
    public var discreteType: ClassType
        {
        return(self.lookupType(atName: "DiscreteType") as! ClassType)
        }
        
    public var enumerationType: ClassType
        {
        return(self.lookupType(atName: "Enumeration") as! ClassType)
        }
        
    public var objectType: ClassType
        {
        return(self.lookupType(atName: "Object") as! ClassType)
        }
        
    public var floatType: ArgonType
        {
        return(self.lookupType(atName: "Float")!)
        }
        
    public var atomType: ArgonType
        {
        return(self.lookupType(atName: "Atom")!)
        }
        
    public var dateType: ArgonType
        {
        return(self.lookupType(atName: "Date")!)
        }
        
    public var timeType: ArgonType
        {
        return(self.lookupType(atName: "Time")!)
        }
        
    public var dateTimeType: ArgonType
        {
        return(self.lookupType(atName: "DateTime")!)
        }
        
    public var stringType: ArgonType
        {
        return(self.lookupType(atName: "String")!)
        }
        
    public var booleanType: ArgonType
        {
        return(self.lookupType(atName: "Boolean")!)
        }
        
    public var byteType: ArgonType
        {
        return(self.lookupType(atName: "Byte")!)
        }
        
    public var characterType: ArgonType
        {
        return(self.lookupType(atName: "Character")!)
        }
        
    public var metaclassType: ArgonType
        {
        return(self.lookupType(atName: "Metaclass")!)
        }
        
    public var classType: ArgonType
        {
        return(self.lookupType(atName: "Class")!)
        }
        
    public var integerType: ArgonType
        {
        return(self.lookupType(atName: "Integer")!)
        }
        
    public var integer8Type: ArgonType
        {
        return(self.lookupType(atName: "Integer8")!)
        }
        
    public var integer16Type: ArgonType
        {
        return(self.lookupType(atName: "Integer16")!)
        }
        
    public var integer32Type: ArgonType
        {
        return(self.lookupType(atName: "Integer32")!)
        }
        
    public var integer64Type: ArgonType
        {
        return(self.lookupType(atName: "Integer64")!)
        }
        
    public var uIntegerType: ArgonType
        {
        return(self.lookupType(atName: "UInteger")!)
        }
        
    public var uInteger8Type: ArgonType
        {
        return(self.lookupType(atName: "UInteger8")!)
        }
        
    public var uInteger16Type: ArgonType
        {
        return(self.lookupType(atName: "UInteger16")!)
        }
        
    public var uInteger32Type: ArgonType
        {
        return(self.lookupType(atName: "UInteger32")!)
        }
        
    public var uInteger64Type: ArgonType
        {
        return(self.lookupType(atName: "UInteger64")!)
        }
        
    public var monthType: ArgonType
        {
        return(self.lookupType(atName: "Month")!)
        }
        
    public var voidType: PrimitiveType
        {
        return(self.lookupType(atName: "Void") as! PrimitiveType)
        }
        
    public var fileType: ClassType
        {
        return(self.lookupType(atName: "File") as! ClassType)
        }
        
    public var bufferType: ArgonType
        {
        return(self.lookupType(atName: "Buffer")!)
        }
        
    public var typeType: ArgonType
        {
        return(self.lookupType(atName: "Type")!)
        }
        
    public var dateOffsetType: ArgonType
        {
        return(self.lookupType(atName: "DateOffset")!)
        }
        
    public var timeOffsetType: ArgonType
        {
        return(self.lookupType(atName: "TimeOffset")!)
        }
        
    public var primitiveType: ArgonType
        {
        return(self.lookupType(atName: "Primitive")!)
        }
        
    public var tupleType: ArgonType
        {
        return(self.lookupType(atName: "Tuple")!)
        }
        
    public var numberType: ArgonType
        {
        return(self.lookupType(atName: "Number")!)
        }
        
    public var slotType: ArgonType
        {
        return(self.lookupType(atName: "Slot")!)
        }
        
    public var constantType: ArgonType
        {
        return(self.lookupType(atName: "Constant")!)
        }
        
    public var moduleType: ArgonType
        {
        return(self.lookupType(atName: "Module")!)
        }
        
    //
    //
    //
    // MARK: Standard Type Initialisation
    //
    // The standard system types are declared and loaded into
    // the Argon module for use by the compiler and the developer's
    // code. These types are used to provide access to basic state and
    // functionality for the compiler.
    //
    //
    //
    private func initializeSystemClasses()
        {
        let theObjectType = self.addSystemClass(named: "Object",superclassesNamed: [])
        theObjectType.classFlags.insert(.root)
//        self.addSystemClass(named: "Type",superclassesNamed: ["Object"])
        self.addSystemClass(named: "Class",superclassesNamed: ["Object"])
        self.addSystemClass(named: "Tuple",superclassesNamed: ["Class"])
        self.addSystemClass(named: "Module",superclassesNamed: ["Class"])
        self.addSystemClass(named: "Metaclass",superclassesNamed: ["Class"])
        self.addSystemClass(named: "Primitive",superclassesNamed: ["Class"])
        self.addSystemClass(named: "Invokable",superclassesNamed: ["Class"])
        self.addSystemClass(named: "Function",superclassesNamed: ["Invokable"])
        self.addSystemClass(named: "Method",superclassesNamed: ["Invokable"])
        self.addSystemClass(named: "Multimethod",superclassesNamed: ["Invokable"])
        self.addSystemClass(named: "Discrete",superclassesNamed: ["Object"])
        self.addSystemClass(named: "String",superclassesNamed: ["Object","Discrete"])
        self.addSystemClass(named: "Atom",superclassesNamed: ["Object"])
        self.addSystemClass(named: "Boolean",superclassesNamed:["Object"])
        self.addSystemClass(named: "True",superclassesNamed:["Boolean"])
        self.addSystemClass(named: "False",superclassesNamed:["Boolean"])
        self.addPrimitiveType(named: "Void",superclassesNamed:["Type"])
        self.addSystemClass(named: "Stream",superclassesNamed: ["Object"])
        self.addSystemClass(named: "ReadStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "WriteStream",superclassesNamed: ["Stream"])
        self.addSystemClass(named: "File",superclassesNamed: ["Object"])
        self.addSystemClass(named: "ReadFile",superclassesNamed: ["ReadStream","File"])
        self.addSystemClass(named: "WriteFile",superclassesNamed: ["WriteStream","File"])
        self.addSystemClass(named: "ReadWriteFile",superclassesNamed: ["ReadFile","WriteFile"])
        self.addSystemClass(named: "Magnitude",superclassesNamed:["Object"])
        self.addSystemClass(named: "Number",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "FixedPointNumber",superclassesNamed:["Number","Discrete"])
        self.addSystemClass(named: "FloatingPointNumber",superclassesNamed:["Number"])
        self.addPrimitiveType(named: "Integer8",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "Integer16",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "Integer32",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "Integer64",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "UInteger8",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "UInteger16",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "UInteger32",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "UInteger64",superclassesNamed:["FixedPointNumber"])
        self.addPrimitiveType(named: "Float16",superclassesNamed:["FloatingPointNumber"])
        self.addPrimitiveType(named: "Float32",superclassesNamed:["FloatingPointNumber"])
        self.addPrimitiveType(named: "Float64",superclassesNamed:["FloatingPointNumber"])
        self.addSystemClass(named: "Date",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "Time",superclassesNamed:["Magnitude"])
        self.addSystemClass(named: "DateTime",superclassesNamed:["Date","Time"])
        self.addSystemClass(named: "Slot",superclassesNamed: ["Object"]).slot("name",self.stringType)
        self.addSystemClass(named: "Constant",superclassesNamed: ["Slot"])
        self.addSystemClass(named: "EnumerationCase",superclassesNamed: ["Object"],genericTypes: [.newTypeVariable(named: "Base")]).slot("name",self.stringType)
        self.addSystemClass(named: "Enumeration",superclassesNamed: ["Class"],genericTypes: [.newTypeVariable(named: "Base")])
        self.addSystemClass(named: "Collection",superclassesNamed: ["Object"],genericTypes: [.newTypeVariable(named: "Element")]).slot("count",self.integer64Type).slot("size",self.integer64Type)
        self.addSystemTypeConstructor(named: "Array",superclassesNamed: ["Collection"],typeParameters: "Element","Index")
        self.addSystemTypeConstructor(named: "Vector",superclassesNamed: ["Collection"],typeParameters: "Element","Index")
        self.addSystemTypeConstructor(named: "Set",superclassesNamed: ["Collection"],typeParameters: "Element")
        self.addSystemTypeConstructor(named: "List",superclassesNamed: ["Collection"],typeParameters: "Element")
        self.addSystemTypeConstructor(named: "Dictionary",superclassesNamed: ["Collection"],typeParameters: "Key","Element")
        self.addSystemTypeConstructor(named: "Pointer",superclassesNamed: ["Object"],typeParameters: "Element")
        self.addSystemTypeConstructor(named: "BitSet",superclassesNamed: ["Collection"],typeParameters: "Key","Element")
        self.addSystemTypeConstructor(named: "Buffer",superclassesNamed: ["Collection"],typeParameters: "Element")
        self.addSystemAliasedType(named: "Byte",toTypeNamed: "UInteger8")
        self.addSystemAliasedType(named: "Character",toTypeNamed: "UInteger16")
        self.addSystemAliasedType(named: "Integer",toTypeNamed: "Integer64")
        self.addSystemAliasedType(named: "UInteger",toTypeNamed: "UInteger64")
        self.addSystemAliasedType(named: "Float",toTypeNamed: "Float64")
        self.lookupType(atName: "Class")?.slot("name",.stringType).slot("bitWidth",.integerType).slot("strideBitWidth",.integerType).intrinsicSlot("hasBits",.booleanType).slot("sizeInBytes",.integerType)
        theObjectType.slot("class",.classType).slot("hash",.integerType).intrinsicSlot("flipCount",.integerType)
        //
        // Date and Time related types
        //
        self.addSystemEnumeration(named: "Month", cases: ["#January","#February","#March","#April","#May","#June","#July","#August","#September","#October","#November","#December"])
        var enumeration = self.addSystemEnumeration(named: "DateOffset", cases: ["#days","#months","#years"])
        enumeration.setAssociatedTypes(forAtom: "#days",.integerType).setAssociatedTypes(forAtom: "#months",.integerType).setAssociatedTypes(forAtom: "#years",.integerType)
        enumeration = self.addSystemEnumeration(named: "TimeOffset", cases: ["#hours","#minutes","#seconds","#milliseconds","#microseconds"])
        enumeration.setAssociatedTypes(forAtom: "#hours",.integerType).setAssociatedTypes(forAtom: "#minutes",.integerType).setAssociatedTypes(forAtom: "#seconds",.integerType).setAssociatedTypes(forAtom: "#milliseconds",.integerType).setAssociatedTypes(forAtom: "#microseconds",.integerType)
        //
        // System constants
        //
        self.addSystemConstant(named: "$today",ofTypeNamed: "Date")
        self.addSystemConstant(named: "$now",ofTypeNamed: "Time")
        self.addSystemConstant(named: "$pi",ofTypeNamed: "Float")
        self.addSystemConstant(named: "$e",ofTypeNamed: "Float")
        }
        
    public func initializeSystemMetaclasses()
        {
        for someClass in self.allClassTypes
            {
            someClass.symbolType = MetaclassType(forClass: someClass)
            someClass.symbolType.symbolType = someClass
            }
        }
        
    //
    // MARK: Placeholder and intrinsic methods for the ASL.
    //
    // Define placeholder methods for the thousands of system defined methods in the Argon Standard Library ( the ASL )
    // Some of these are placeholders in that they provide an interface for the methods that are actually defined
    // in the ASL others are marked as "intrinsic" methods whihc means the compiler inlines them and replaces them
    // with machine code that is generated on the fly by the compiler. Intrinsic methods contain instructions on
    // how the method must be compiler away.
    //
    //
    //
    public func initializeSystemMethods()
        {
        self.addSystemOperator(notation: .infix,named: "+").parameter(.stringType).parameter(.stringType).returnType(.stringType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.integerType).parameter(.integerType).returnType(.integerType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.floatType).parameter(.floatType).returnType(.floatType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.dateType).parameter(.dateOffsetType).returnType(.dateType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.timeType).parameter(.timeOffsetType).returnType(.dateType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.dateType).parameter(.dateOffsetType).returnType(.dateType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.dateTimeType).parameter(.timeOffsetType).returnType(.dateTimeType)
        self.addSystemOperator(notation: .infix,named: "+").parameter(.dateTimeType).parameter(.dateOffsetType).returnType(.dateTimeType)
        
        self.addSystemOperator(notation: .infix,named: "-").parameter(.stringType).parameter(.stringType).returnType(.stringType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.integerType).parameter(.integerType).returnType(.integerType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.floatType).parameter(.floatType).returnType(.floatType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.dateType).parameter(.dateOffsetType).returnType(.dateType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.timeType).parameter(.timeOffsetType).returnType(.dateType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.dateType).parameter(.dateOffsetType).returnType(.dateType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.dateTimeType).parameter(.timeOffsetType).returnType(.dateTimeType)
        self.addSystemOperator(notation: .infix,named: "-").parameter(.dateTimeType).parameter(.dateOffsetType).returnType(.dateTimeType)
        
        self.addSystemOperator(notation: .infix,named: "*").parameter(.integerType).parameter(.integerType).returnType(.integerType)
        self.addSystemOperator(notation: .infix,named: "*").parameter(.floatType).parameter(.floatType).returnType(.floatType)
        
        self.addSystemOperator(notation: .infix,named: "/").parameter(.integerType).parameter(.integerType).returnType(.integerType)
        self.addSystemOperator(notation: .infix,named: "/").parameter(.floatType).parameter(.floatType).returnType(.floatType)
        
        self.addSystemOperator(notation: .infix,named: "%").parameter(.integerType).parameter(.integerType).returnType(.integerType)
        
        self.addSystemOperator(notation: .infix,named: "**").parameter(.integerType).parameter(.integerType).returnType(.integerType)
        self.addSystemOperator(notation: .infix,named: "**").parameter(.floatType).parameter(.floatType).returnType(.floatType)
                
        self.addSystemMethod(named: "string").parameter(.integerType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.uIntegerType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.characterType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.byteType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.booleanType).returnType(.stringType)
        self.addSystemMethod(named: "string").parameter(.atomType).returnType(.stringType)
        
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
        self.addSystemMethod(named: "integer").parameter(.atomType).returnType(.integerType)

        self.addSystemMethod(named: "character").parameter(.integerType).returnType(.characterType)
        self.addSystemMethod(named: "character").parameter(.byteType).returnType(.characterType)
        self.addSystemMethod(named: "character").parameter(.uIntegerType).returnType(.characterType)

        self.addSystemMethod(named: "byte").parameter(.integerType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.stringType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.uIntegerType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.characterType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.booleanType).returnType(.byteType)
        self.addSystemMethod(named: "byte").parameter(.atomType).returnType(.byteType)

        self.addSystemMethod(named: "uInteger").parameter(.stringType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.integerType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.characterType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.byteType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.atomType).returnType(.uIntegerType)
        self.addSystemMethod(named: "uInteger").parameter(.booleanType).returnType(.uIntegerType)

        self.addSystemMethod(named: "boolean").parameter(.atomType).returnType(.booleanType)

        self.addSystemMethod(named: "atom").parameter(.integerType).returnType(.atomType)
        self.addSystemMethod(named: "atom").parameter(.uIntegerType).returnType(.atomType)
        self.addSystemMethod(named: "atom").parameter(.stringType).returnType(.atomType)
        self.addSystemMethod(named: "atom").parameter(.characterType).returnType(.atomType)
        self.addSystemMethod(named: "atom").parameter(.booleanType).returnType(.atomType)
        self.addSystemMethod(named: "atom").parameter(.byteType).returnType(.atomType)
        
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
        
//    public func dumpMethods()
//        {
//        for symbol in self.symbols
//            {
//            if symbol.isMethod
//                {
//                print(symbol.description)
//                }
//            }
//        }
        
    @discardableResult
    private func addSubType(named name: String,baseType: ArgonType,minimum: ValueBox,maximum: ValueBox) -> ArgonType
        {
        fatalError()
        }
        
    @discardableResult
    private func addSystemClass(named name: String,superclassesNamed: Array<String>,genericTypes: ArgonTypes = []) -> ClassType
        {
        let classes = superclassesNamed.map{self.lookupSymbol(atName: $0) as! ClassType}
        let aClass = ClassType(name: name,superclasses: classes,genericTypes: genericTypes)
        self.addSymbol(aClass)
        aClass.isSystemNode = true
        return(aClass)
        }
        
    @discardableResult
    private func addPrimitiveType(named name: String,superclassesNamed: Array<String>) -> PrimitiveType
        {
        let classes = superclassesNamed.compactMap{self.lookupSymbol(atName: $0)}.map{$0.baseType as! ClassType}
        let aType = PrimitiveType(name: name,superclasses: classes)
        self.addSymbol(aType)
        aType.isSystemNode = true
        return(aType)
        }
        
//    @discardableResult
//    private func addSystemMetaclass(named name: String,superclassesNamed: Array<String>,genericTypes: ArgonTypes = []) -> ClassType
//        {
//        let classes = superclassesNamed.map{self.lookupSymbol(atName: $0) as! ClassType}
//        let theClass = self.lookupSymbol(atName: name) as! ClassType
//        let metaclass = MetaclassType(name: name,superclasses: classes,genericTypes: genericTypes)
//        self.addSymbol(metaclass)
//        metaclass.isSystemNode = true
//        return(metaclass)
//        }
  
    @discardableResult
    private func addSystemTypeConstructor(named name: String,superclassesNamed: Array<String>,typeParameters: String...) -> ClassType
        {
        let classes = superclassesNamed.map{self.lookupSymbol(atName: $0) as! ClassType}
        let someClass = ClassType(name: name,superclasses: classes)
        let constructor = someClass.typeConstructor()
        constructor.setTypeParameters(typeParameters.map{TypeParameter(name: $0,scope: someClass)})
        self.addSymbol(constructor)
        someClass.isSystemNode = true
        return(someClass)
        }
        
    @discardableResult
    private func addSystemEnumeration(named name: String,cases: Atoms,generics: ArgonTypes = []) -> EnumerationType
        {
        var actualCases = EnumerationCases()
        var index = 0
        let aClass = EnumerationType(name: name)
        for aCase in cases
            {
            actualCases.append(EnumerationCase(name: aCase,enumeration: aClass, instanceValue: .integer(Argon.Integer(index))))
            index += 1
            }
        self.addSymbol(aClass)
        aClass.isSystemNode = true
        return(aClass)
        }
        
    private func addGenericSystemClass(named name: String,superclassesNamed: Array<String>,generics: Array<String>)
        {
        let generics = generics.map{self.lookupType(atName: $0)!}
        let classes = superclassesNamed.map{self.lookupType(atName: $0) as! ClassType}
        let aClass = ClassType(name: name,superclasses: classes,genericTypes: generics)
        aClass.isSystemNode = true
        self.addSymbol(aClass)
        }
        
    private func addSystemAliasedType(named name: String,toTypeNamed typeName: String)
        {
        let baseType = self.lookupType(atName: typeName)!
        let typeAlias = AliasedType(name: name,baseType: baseType)
        typeAlias.isSystemNode = true
        self.addSymbol(typeAlias)
        }
        
    private func addSystemAliasedType(named name: String,toType type: ArgonType)
        {
        let typeAlias = AliasedType(name: name,baseType: type)
        typeAlias.isSystemNode = true
        self.addSymbol(typeAlias)
        }
        
    private func addSystemConstant(named name: String,ofTypeNamed typeName: String)
        {
        let baseType = self.lookupType(atName: typeName)!
        let constant = Constant(name: name,type: baseType,expression: nil)
        constant.isSystemNode = true
        constant.symbolType = self.constantType
        self.addSymbol(constant)
        }
        
        
    public func addSystemMethod(named: String) -> MethodType
        {
        let method = MethodType(name: named)
        method.isSystemNode = true
        self.addSymbol(method)
        return(method)
        }
        
    public func addSystemOperator(notation: OperatorNotation,named: String) -> MethodType
        {
        let method = MethodType(name: named)
        method.operatorNotation = notation
        method.isOperator = true
        method.isSystemNode = true
        self.addSymbol(method)
        return(method)
        }
        
    public func isSystemClass(named: String) -> Bool
        {
        if let aClass = self.lookupType(atName: named)
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
        if let enumeration = self.lookupType(atName: named)
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
        if let type = self.lookupType(atName: named)
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
