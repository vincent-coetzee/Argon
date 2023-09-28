//
//  TypeConstructor.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/09/2023.
//

import Foundation

public class TypeConstructor: ArgonType
    {
    public override var baseType: ArgonType
        {
        self.constructedType.typeValue.baseType
        }
        
    public enum ConstructedType
        {
        public var typeValue: ArgonType
            {
            switch(self)
                {
                case .class(let someClass):
                    return(someClass)
                case .tuple(let tuple):
                    return(tuple)
                case .enumeration(let enumeration):
                    return(enumeration)
                }
            }
            
        public var constructedTypeType: ArgonType
            {
            switch(self)
                {
                case .class:
                    return(ArgonType.classType)
                case .tuple:
                    return(ArgonType.tupleType)
                case .enumeration:
                    return(ArgonType.enumerationType)
                }
            }
            
        case `class`(ClassType)
        case tuple(TupleType)
        case enumeration(EnumerationType)
        
        func cloneInstance() -> ArgonType
            {
            switch(self)
                {
                case .class(let someClass):
                    return(someClass.clone())
                case .tuple(let tuple):
                    return(tuple.clone())
                case .enumeration(let enumeration):
                    return(enumeration.clone())
                }
            }
        }
        
    private let constructedType: ConstructedType
    private var typeParameters: TypeParameters!
    
    public init(name: String,constructedType: ConstructedType)
        {
        self.constructedType = constructedType
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.constructedType = coder.decodeConstructedType(forKey: "constructedType")
        self.typeParameters = coder.decodeObject(forKey: "typeParameters") as? TypeParameters
        super.init(coder: coder)
        }
        
    public override func setTypeParameters(_ parameters: TypeParameters)
        {
        self.typeParameters = parameters
        }
        
    public override func constructType(from types: ArgonTypes) throws -> ArgonType
        {
        guard !self.typeParameters.isEmpty else
            {
            return(self.constructedType.typeValue)
            }
        let newType = self.constructedType.cloneInstance()
        guard self.typeParameters.count == types.count else
            {
            throw(CompilerError(code: .typeParameterMismatch, message: "Expected \(self.typeParameters.count) types but found \(types.count)."))
            }
        var genericTypes = ArgonTypes()
        for (parameter,typeValue) in zip(self.typeParameters,types)
            {
            newType.setSymbol(typeValue,atName: parameter.name)
            newType.addGenericType(typeValue)
            }
        newType.symbolType = self.constructedType.constructedTypeType
        return(newType)
        }
    }
    
extension NSCoder
    {
    public func encode(_ type: TypeConstructor.ConstructedType,forKey key: String)
        {
        switch(type)
            {
            case .class(let someClass):
                self.encode(0,forKey: key + "_index")
                self.encode(someClass,forKey: key + "_class")
            case .tuple(let someTuple):
                self.encode(1,forKey: key + "_index")
                self.encode(someTuple,forKey: key + "_tuple")
            case .enumeration(let someEnumeration):
                self.encode(2,forKey: key + "_index")
                self.encode(someEnumeration,forKey: key + "_enumeration")
            }
        }
        
    public func decodeConstructedType(forKey key: String) -> TypeConstructor.ConstructedType
        {
        switch(self.decodeInteger(forKey: key + "_index"))
            {
            case(0):
                return(.class(self.decodeObject(forKey: key + "_class") as! ClassType))
            case(1):
                return(.tuple(self.decodeObject(forKey: key + "_tuple") as! TupleType))
            case(2):
                return(.enumeration(self.decodeObject(forKey: key + "_enumeration") as! EnumerationType))
            default:
                fatalError("This should NEVER happen.")
            }
        }
    }

    
//In parseType, lookup the type if it's found register it ( to make sure it's canonicalised ) and use it
//If not found then generated a TypeVariable with that name and return that.
//Last step in every parseType is to instanciate(with: Types) -> Type,TypeConstructor return a
//structured type generated from either a Class, an Enumeraiton, or a TupleType according to what the type
//of the parentType was in the TypeConstructor - not sure yet what the InstanciatedType should be/look like,
//perhaps make ClassType, EnumerationType, and TupleType sublcasses of StructuredType which has generics/types or something
//the genericTypes link somehow to the TypeVariable they fit into and the genericTypes can be eithe ConcretTypes ( maybe make that the superclass
//of Enumeration,Class,Tuple types which is result of instanciation ) or TypeVariables. Neeed semantic checks on the SamanticChecker. We only need
//a single method to parse typeconstructors not one for Areray, Set etc. Should be able to slim parseType down considerably.
//
//ParseType also parses SubTypes and canoncialises them and returns them ( that's how we parse the index type of an array for example )
//
//
//StrcturedType ( types ) ===> instanciate(with: Types) -> Just return self
//    TypeConstructor ===> instamciate(with: Types) -> create Class,Enumration,Tuple according to parent type, set types, register and return
//        MetaclassType <- Array,Set,List,BitSet,Dictionary,Pointer -> Instanciate returns a ClassType, Metaclass has an instanceType that will be what is produced when instanciated
////            EnumerationMetaclassType -> Instamcitae an EnumeraionType
////            TupleMetaclassType ->Instamciate a TupleType
////            CallableMetaclass
////                MetyhodMetaclass
////                FunctionMetaclass
//    ConcreteType instanciate(with: -> ConcreteType
//        ClassType
//            EnumerationType
//            TupleType
//            CallableType
//                FunctionType
//                MEthodType
//        InvocationType
//    TypeVariable <- clone
//    GenericType - contains a type variable and a concret class that it maps to + clone
//    
//Lookups in parseType reverse up the parent chain
//Lookups in ConcreteTypes moves up parent ( i.e. slots + case + tupleEntry lookup in local scope then upwards ) <- SymbolTable in ConcreteType and TypeConstrucor ( lookup in types as well )
//
//
//
//Values:
//    SIGN BIT    4 TAG BITS     TYPE
//    ===============================
//            1   0000     Integer
//            0   0001     Object
//            0   0010     Tuple
//            0   0100     Boolean
//            0   1000     String
//            0   0011     Float16
//            0   0110     Float32
//            0   1001     Float64
//            0   1010     Emnumeration
//            0   0101     Pointer/Address
//            0   1011     Array
//            0   0111     Bits
//            0   1110     Symbol
//            0   1111     Forwarded
//            
//            
//Object Structure
//
//            Header 64 Bits           Sign ( 1 bit )      0                                                                                      1
//                                     Tag ( 4 bits )       0000                                                                                  5
//                                     SizeInWords ( 36 bits )  000 00000000 00000000 00000000 000000000 0000                                    41
//                                     HasBytes ( 1 bit )                                                    0                                   42
//                                     FlipCount ( 8 bits = 256 )                                             000 00000                          50
//                                     IsForwarded ( 1 bit )                                                           0                         51
//                                     Kind ( 8 bits = 256 )                                                            00 000000                59
//                                     Reserved ( 5 bits )                                                                       00              64
//                                     
//            Class Pointer                                00000000 00000000 00000000 00000000 000000000 00000000 00000000 00000000
//            Slot 0                                       00000000 00000000 00000000 00000000 000000000 00000000 00000000 00000000
//            
//            Slot N                                       00000000 00000000 00000000 00000000 000000000 00000000 00000000 00000000
//            Bytes
//                        
