//
//  ArgonTests.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/01/2023.
//

import Foundation
import Path

public struct ArgonTests
    {
    private static var rootModule: RootModule!
    
    public static func runTests()
        {
//        self.testDateTimeScanning()
        self.testRootModule()
//        self.testSymbolTables()
        self.testTypeHashing()
        self.testIdentity()
        self.testIdentifiers()
        self.testAddingNodes()
        self.testInitialization()
        self.testMacroExpansion()
        self.testTokens()
        self.testProjectEntries()
        self.makeTestParseTree()
        }
        
    public static func testDateTimeScanning()
        {
//        var string = "@(2/12/2009)"
//        var scanner = ArgonScanner(source: string)
//        assert(scanner.tokens.isNotNil,"Tokens is nil and should not be.")
//        assert(scanner.tokens!.count == 2,"There should be two tokens and there is not.")
//        assert(scanner.tokens![0].isDateValue,"Token should be date token but is not")
//        assert(scanner.tokens![0].dateValue == Argon.Date(day: 2,month: 12,year: 2009),"Date should be 02/12/2009 but is not.")
//        string = "@(02:10:43:0000)"
//        scanner = ArgonScanner(source: string)
//        assert(scanner.tokens.isNotNil,"Tokens is nil and should not be.")
//        assert(scanner.tokens!.count == 2,"There should be two tokens and there is not.")
//        assert(scanner.tokens![0].isTimeValue,"Token should be date token but is not")
//        assert(scanner.tokens![0].timeValue == Argon.Time(hour: 2,minute: 10,second: 43),"Time should be 02:12:43 but is not.")
        }
        
//    public static func testSymbolTables()
//        {
//        let symbolTable = SymbolTable()
//        let module =  Module(name: "OuterModule")
//        symbolTable.addNode(module)
//        assert(module == symbolTable.lookupNode(atName: "OuterModule") as? Module,"module should be same as OuterModule but is not.")
//        let method = MethodType(name: "someMethod")
//        symbolTable.addNode(method)
//        assert(method == symbolTable.lookupMethods(atName: "someMethod")[0],"Method should be equal to looked up method but is not.")
//        assert(symbolTable.lookupMethods(atName: "someMethodOrOther").count == 0,"Looked up methods should be empty but is not.")
//        self.rootModule.addNode(module)
//        let integer = module.lookupNode(atName: "Integer") as? TypeNode
//        assert(integer == ArgonModule.shared.integerType,"Integer should be the same as the looked up one but is not.")
//        let string = module.lookupNode(atName: "String") as? TypeNode
//        assert(string == ArgonModule.shared.stringType,"String should be the same as the looked up one but is not.")
//        }
        
    public static func testInitialization()
        {
        let _ = ArgonModule.shared
        }
        
    public static func testTypeHashing()
        {
        let typeA = ArrayInstanceType(elementType: ArgonModule.integerType, indexType: ArgonModule.uIntegerType)
        let typeB = ArrayInstanceType(elementType: ArgonModule.stringType, indexType: ArgonModule.uIntegerType)
        let typeC = ArrayInstanceType(elementType: ArgonModule.integerType, indexType: ArgonModule.uIntegerType)
        let aliasedTypeA = AliasedType(name: "AliasedTypeA", baseType: typeA)
        assert(typeA.isIdentical(to: aliasedTypeA.baseType),"TypeA is not identical to AliasedTypeA.baseType and should be.")
        assert(typeA.isIdentical(to: typeA),"TypeA is not identical to TypeA and should be.")
        assert(!typeA.isIdentical(to: typeB),"TypeA is identical to TypeB and should not be.")
        assert(typeA.typeHash == typeC.typeHash,"TypeA.typeHash != TypeC.typeHash and should be.")
        assert(typeA.typeHash == typeA.typeHash,"TypeA.typeHash != TypeA.typeHash and should be.")
        assert(typeA.typeHash != typeB.typeHash,"TypeA.typeHash == TypeB.typeHash and should be.")
        assert(typeA.typeHash == aliasedTypeA.typeHash,"TypeA.typeHash != AliasedTypeA.typeHash and should be.")
        }
        
    public static func testIdentity()
        {
//        let typeA = TypeNode(name: "TypeA")
//        let typeB = TypeNode(name: "TypeB")
//        let typeC = TypeNode(name: "TypeC")
//        let typeD = TypeNode(name: "TypeD")
//        let module1 = Module(name: "Module1")
//        let module2 = Module(name: "Module2")
//        module1.addNode(module2)
//        module2.addNode(typeA)
//        module2.addNode(typeB)
//        print(typeA.mangledName)
//        let methodA = MethodType(name: "someMethod")
//        methodA.setReturnType(typeB)
//        methodA.addParameter(Parameter(definedByPosition: false, externalName: "externalNameA", internalName: "internalNameA", type: typeA))
//        methodA.addParameter(Parameter(definedByPosition: false, externalName: "externalNameB", internalName: "internalNameB", type: typeB))
//        module2.addNode(methodA)
//        print(methodA.mangledName)
//        let enumeration = EnumerationType(name: "SomeEnumeration")
//        let arrayType = ArrayTypeInstance(elementType: typeA, indexType: Argon.ArrayIndex.enumeration(enumeration))
//        let methodB = MethodType(name: "methodB")
//        methodB.setReturnType(arrayType)
//        methodB.addParameter(Parameter(definedByPosition: false, externalName: "externalNameA", internalName: "internalNameA", type: arrayType))
//        methodB.addParameter(Parameter(definedByPosition: false, externalName: "externalNameB", internalName: "internalNameB", type: enumeration))
//        module2.addNode(methodB)
//        print(methodB.mangledName)
        }
        
    public static func testAddingNodes()
        {
        let rootModule = RootModule.newRootModule()
        let outerModule = Module(name: "OuterModule")
        rootModule.addNode(outerModule)
        let firstInnerModule = Module(name: "FirstInnerModule")
        outerModule.addNode(firstInnerModule)
        let secondInnerModule = Module(name: "SecondInnerModule")
        firstInnerModule.addNode(secondInnerModule)
        let thirdInnerModule = Module(name: "ThirdInnerModule")
        secondInnerModule.addNode(thirdInnerModule)
        //
        // Define cases for an enumeration
        //
        let enumeration = EnumerationType(name: "NodeType",rawType: ArgonModule.stringType)
        let freezing = EnumerationCase(name: "#freezing",enumeration: enumeration, associatedTypes: [],instanceValue: .none)
        let sunny = EnumerationCase(name: "#sunny",enumeration: enumeration, associatedTypes: [],instanceValue: .none)
        let rainy = EnumerationCase(name: "#rainy",enumeration: enumeration, associatedTypes: [],instanceValue: .none)
        let windy = EnumerationCase(name: "#windy",enumeration: enumeration, associatedTypes: [],instanceValue: .none)
        let cloudy = EnumerationCase(name: "#cloudy",enumeration: enumeration, associatedTypes: [],instanceValue: .none)
        enumeration.setCases([freezing,sunny,rainy,windy,cloudy])
        //
        // Define an enumeration with cases
        //
        thirdInnerModule.addNode(enumeration)
        let lookupEnumeration = outerModule.lookupNode(atIdentifier: Identifier(string: "//OuterModule/FirstInnerModule/SecondInnerModule/ThirdInnerModule/NodeType"))
        assert(lookupEnumeration == enumeration,"Looked up enumeration should be the same as the original enumeration and it is not")
//        let newClass = ClassType(name: "NewClass")
//        let identifier = Identifier(string: "//OuterModule/FirstInnerModule/SecondInnerModule/NewClass")
//        secondInnerModule.addNode(newClass, atIdentifier: identifier)
//        let lookupClass = secondInnerModule.lookupNode(atIdentifier: identifier)
//        assert(lookupClass == newClass,"NewClass and Looked Up Class should be the same but are not")
        }
        
    @discardableResult
    private static func makeTestParseTree() -> Module
        {
        let rootModule = RootModule.newRootModule()
        let module = Module(name: "SomeModule")
        rootModule.addNode(module)
        let innerModule = Module(name: "WeatherType")
        //
        // Define an enumeration with cases
        //
        let enumeration = EnumerationType(name: "NodeType",rawType: ArgonModule.stringType)
        //
        // Define cases for an enumeration
        //
        let freezing = EnumerationCase(name: "#freezing",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
        let sunny = EnumerationCase(name: "#sunny",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
        let rainy = EnumerationCase(name: "#rainy",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
        let windy = EnumerationCase(name: "#windy",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
        let cloudy = EnumerationCase(name: "#cloudy",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
        enumeration.setCases([freezing,sunny,rainy,windy,cloudy])
        //
        // Add enumeration to inner module and inner module to base module
        //
        module.addNode(innerModule)
        innerModule.addNode(enumeration)
        //
        // Define slots for Location class
        //
        let latitude = Slot(name: "Latitude",type: ArgonModule.floatType)
        let longitude = Slot(name: "longitude",type: ArgonModule.floatType)
        //
        // Define Location class
        //
        let locationClass = ClassType(name: "Location",slots: [latitude,longitude])
        innerModule.addNode(locationClass)
        //
        // Define WeatherStationType enumeration
        //
        let weatherStationType = EnumerationType(name: "WeatherStationType",rawType: ArgonModule.integerType)
        //
        // Define cases for WeatherStationType
        //
        let manned = EnumerationCase(name: "#manned",enumeration: weatherStationType,associatedTypes: [],instanceValue: .none)
        let unmanned = EnumerationCase(name: "#unmanned",enumeration: weatherStationType,associatedTypes: [],instanceValue: .none)
        weatherStationType.setCases([unmanned,manned])
        innerModule.addNode(weatherStationType)
        //
        // Define slots for WeatherStation class
        //
        let nameSlot = Slot(name: "location", type: locationClass)
        let typeSlot = Slot(name: "stationType",type: weatherStationType)
        let onlineSlot = Slot(name: "isOnline",type: ArgonModule.booleanType)
        let temperatureSlot = Slot(name: "temperature",type: ArgonModule.floatType)
        let weatherStationClass = ClassType(name: "WeatherStation",slots: [nameSlot,typeSlot,onlineSlot,temperatureSlot],superclasses: [ArgonModule.objectClass])
        module.addNode(weatherStationClass)
        print("Identifier for enumeration = \(enumeration.identifier)")
        let integerType = innerModule.lookupNode(atName: "Integer")
        let stringType = innerModule.lookupNode(atName: "String")
        assert(integerType == ArgonModule.integerType,"integerType != ArgonModule.integerType and should be")
        assert(stringType == ArgonModule.stringType,"stringType != ArgonModule.stringType and should be")
        return(module)
        }
        
    private static func testMacroExpansion()
        {
//        let source =
//        """
//            MODULE Test
//                {
//                #someSymbolOrOther #anotherSymbol
//                CLASS \\SomeClass\\SomeTopClass
//                    {
//                    SLOT someSlot = "" #yetAnotherSymbol
//                    SLOT floatSlot = 12.567
//                    SLOT integerSlot = 5964
//                    }
//                MACRO someMacro(a1,a2,a3)
//                    $
//                    this is some `a1 and some more `a2
//                    $
//
//                // This is a comment that stays on a line
//                /*  This comment
//                    stretches across
//                    several
//                    lines
//                */
//                LET thisValue = -> ,
//                $someMacro(this is some text,this is even more text, and the last lot of text)
//                LET someValue = MAKE(\\Module1\\Module2\\Module3\\AClass),
//                ENUMERATION SomeEnum::Integer
//                    {
//                    #someCase = 1
//                    }
//                LET someByteValue = §127
//                }
//            """
        }
        
    private static func testTokens()
        {
        let source =
        """
            MODULE Test
                {
                -> ,
                #someSymbolOrOther #anotherSymbol
                CLASS \\SomeClass\\SomeTopClass
                    {
                    SLOT someSlot = "" #yetAnotherSymbol
                    SLOT floatSlot = 12.567
                    SLOT integerSlot = 5964
                    }
                :(//This/is/a/path)
                MACRO someMacro(a1,a2,a3)
                    $
                    this is some `a1 and some more `a2
                    $
                    
                // This is a comment that stays on a line
                /*  This comment
                    stretches across
                    several
                    lines
                */
                LET thisValue = $Z -> ,
                LET someValue = MAKE(\\Module1\\Module2\\Module3\\AClass),
                ENUMERATION SomeEnum::Integer
                    {
                    #someCase = 1
                    }
                LET someByteValue = §127
                }
            """
        KeywordToken.initKeywords()
        let sourceFile = SourceFileNode(name: "",path: Path(Path.root))
        sourceFile.setSource(source)
        let scanner = ArgonScanner(source: source)
        let tokens = scanner.allTokens()
        for token in tokens
            {
            print(token.location,terminator: " ")
            print(token)
            }
        }
        
    public static func testProjectEntries()
        {
//        let entry1 = SourceFileNode(name: "",path: Path(Path.root))
//        let entry2 = SourceFileNode(name: "",path: Path(Path.root))
        let project = SourceProjectNode(name: "",path: Path(Path.root))
        let data = try? NSKeyedArchiver.archivedData(withRootObject: project, requiringSecureCoding: false)
        if data.isNil
            {
            fatalError("Encoding of project failed")
            }
        else
            {
            let newProject = NSKeyedUnarchiver.unarchiveObject(with: data!) as? SourceProjectNode
            if newProject.isNil
                {
                fatalError("Decoding of project failed")
                }
            }
        }
        
    public static func testIdentifiers()
        {
        let identifier1 = Identifier(string: "//one/two/three")
        let identifier2 = Identifier(string: "//one/two/three")
        if identifier1 != identifier2
            {
            print("\(identifier1) != \(identifier2) and it should be.")
            }
        let identifierA = Identifier(string: "/one/two/three")
        if identifier1 == identifierA
            {
            print("\(identifier1) == \(identifierA) and it should not be.")
            }
        var first = identifier1.firstPart
        if first != "//"
            {
            print("\(identifier1.firstPart) != // and it should be")
            }
        first = identifierA.firstPart
        if first == "//"
            {
            print("\(identifierA.firstPart) == // and it should not be.")
            }
        let remainder = identifier1.remainingPart
        let new1 = Identifier(string: "/one/two/three")
        if remainder != new1
            {
            print("remainder of \(identifier1) != \(new1) and it should be")
            }
        let empty = Identifier(string: "")
        if !empty.isEmpty
            {
            print("\(empty) isEmpty == false and it should not be.")
            }
        if identifier1.isEmpty
            {
            print("\(identifier1).isEmpty and it should not be")
            }
        if identifier1.count != 4
            {
            print("\(identifier1).count != 4 and it should be.")
            }
        }
        
    public static func testRootModule()
        {
        self.rootModule = RootModule.newRootModule()
        let methods = self.rootModule.lookupMethods(atName: "string")
        assert(methods.count == 6,"count(string methods) should be 6 but is not.")
        }
    }
