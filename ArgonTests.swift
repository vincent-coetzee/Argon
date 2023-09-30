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
        let _ = ArgonModule()
//        self.testDateTimeScanning()
        self.testSymbolTree()
        self.testRootModule()
//        self.testSymbolTables()
        self.testTypeHashing()
//        self.testIdentity()
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
        }
        
    public static func testSymbolTree()
        {
        let tree = SymbolTreeNode(key: "\\")
        tree.insert(symbol: Module(name: "ModuleA"))
        tree.insert(symbol: MultimethodType(name: "methodA"))
        let class1 = ClassType(name: "ClassA")
        let newNode = tree.insert(symbol: class1,at: Identifier(string: "\\\\Module1\\Module2\\Module3\\ClassA"))
        let symbol1 = newNode.lookupSymbol(at: "ClassA")
        assert(symbol1 == class1,"symbol1 != class1 but it should be.")
        print("Path of \\\\Module1\\Module2\\Module3 is \(newNode.path.description)")
        }
        
    public static func testIdentity()
        {
        let typeA = PrimitiveType(name: "Integer", superclasses: [ArgonModule.shared.numberType as! ClassType])
        let typeB = AliasedType(name: "Integer64", baseType: typeA)
        assert(typeA != typeB,"TypeA is equal to typeB and should not be.")
        let hashA = typeA.typeHash
        let hashB = typeB.typeHash
        assert(hashA != hashB,"typeA.typeHash == typeB.typeHash and should not be.")
        let typeC = AliasedType(name: "BigInteger",baseType: typeB)
        assert(typeA.baseType == typeC.baseType,"typeA.baseType != typeA.baseType and should be.")
        let typeD = PrimitiveType(name: "Integer",superclasses: [ArgonModule.shared.numberType as! ClassType])
        assert(typeD == typeA,"typeA != typeD and should be.")
        assert(typeA.isEquivalent(to: typeD),"typeA is not equivalent to typeD and should be.")
        let typeE = ClassType(name: "ClassE",slots: [Slot(name: "integerSlot", type: .integerType),Slot(name: "stringSlot",type: .stringType)],genericTypes: [.integerType,.floatType])
        let typeF = ClassType(name: "ClassF",slots: [Slot(name: "integerSlot", type: .integerType),Slot(name: "stringSlot",type: .stringType)],genericTypes: [.integerType,.floatType])
        let result1 = TypeRegistry.registerType(typeE)
        let result2 = TypeRegistry.registerType(typeF)
        assert(!(result1 === result2),"register(TypeE) is not identical to register(TypeF) and should be.")
        let slotE1 = typeE.lookupSymbol(atName: "integerSlot") as! Slot
        let slotE2 = typeF.lookupSymbol(atName: "integerSlot") as! Slot
        assert(slotE1.identifier != slotE2.identifier,"slotE1.identifier == slotE2.identifier and it should not be.")
        }
        
    public static func testAddingNodes()
        {
        let outerModule = Module(name: "OuterModule")
        RootModule.shared.addSymbol(outerModule)
        let firstInnerModule = Module(name: "FirstInnerModule")
        outerModule.addSymbol(firstInnerModule)
        let secondInnerModule = Module(name: "SecondInnerModule")
        firstInnerModule.addSymbol(secondInnerModule)
        let thirdInnerModule = Module(name: "ThirdInnerModule")
        secondInnerModule.addSymbol(thirdInnerModule)
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
        thirdInnerModule.addSymbol(enumeration)
        let lookupEnumeration = outerModule.lookupSymbol(atIdentifier: Identifier(string: "\\\\OuterModule\\FirstInnerModule\\SecondInnerModule\\ThirdInnerModule\\NodeType"))
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
        let module = Module(name: "SomeModule")
        RootModule.shared.addSymbol(module)
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
        module.addSymbol(innerModule)
        innerModule.addSymbol(enumeration)
        //
        // Define slots for Location class
        //
        let latitude = Slot(name: "Latitude",type: ArgonModule.floatType)
        let longitude = Slot(name: "longitude",type: ArgonModule.floatType)
        //
        // Define Location class
        //
        let locationClass = ClassType(name: "Location",slots: [latitude,longitude])
        innerModule.addSymbol(locationClass)
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
        innerModule.addSymbol(weatherStationType)
        //
        // Define slots for WeatherStation class
        //
        let nameSlot = Slot(name: "location", type: locationClass)
        let typeSlot = Slot(name: "stationType",type: weatherStationType)
        let onlineSlot = Slot(name: "isOnline",type: ArgonModule.booleanType)
        let temperatureSlot = Slot(name: "temperature",type: ArgonModule.floatType)
        let weatherStationClass = ClassType(name: "WeatherStation",slots: [nameSlot,typeSlot,onlineSlot,temperatureSlot],superclasses: [ArgonModule.objectType as! ClassType])
        module.addSymbol(weatherStationClass)
        print("Identifier for enumeration = \(enumeration.identifier)")
        let integerType = innerModule.lookupSymbol(atName: "Integer")
        let stringType = innerModule.lookupSymbol(atName: "String")
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
                \\\\This\\is\\a\\path
                LET binary = 0B110110111
                LET octal = 0O7733657
                LET hex = 0XA0B1EEF9
                LET overflow = 0XFFFFFFFFFFFFFFFFFFFFFFFFFF
                MACRO someMacro(a1,a2,a3)
                    $
                    this is some `a1 and some more `a2
                    $
                  
                ;;
                ;; This is a comment that stays on a line
                ;; This comment
                ;;  stretches across
                ;;  several
                ;;  lines
                ;;
                LET thisValue = $Z -> ,
                LET someValue = MAKE(\\\\Module1\\Module2\\Module3\\AClass),
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
        let _ = ArgonModule()
        assert(RootModule.shared.lookupMethod(atName: "string").isNotNil,"There should be a string multimethod but there is not.")
        }
    }
