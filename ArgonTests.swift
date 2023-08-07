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
    public static func runTests()
        {
        self.testIdentifiers()
        self.testAddingNodes()
        self.testInitialization()
        self.testMacroExpansion()
        self.testTokens()
        self.testProjectEntries()
        self.testRootModule()
        self.makeTestParseTree()
        }
        
    public static func testInitialization()
        {
        let _ = ArgonModule.shared
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
        let freezing = EnumerationCase(name: "#freezing", associatedTypes: [],instanceValue: .none)
        let sunny = EnumerationCase(name: "#sunny", associatedTypes: [],instanceValue: .none)
        let rainy = EnumerationCase(name: "#rainy", associatedTypes: [],instanceValue: .none)
        let windy = EnumerationCase(name: "#windy", associatedTypes: [],instanceValue: .none)
        let cloudy = EnumerationCase(name: "#cloudy", associatedTypes: [],instanceValue: .none)
        //
        // Define an enumeration with cases
        //
        let enumeration = EnumerationType(name: "NodeType",cases: [freezing,sunny,rainy,windy,cloudy],rawType: ArgonModule.stringType)
        thirdInnerModule.addNode(enumeration)
        let lookupEnumeration = outerModule.lookupNode(atIdentifier: Identifier(string: "//OuterModule/FirstInnerModule/SecondInnerModule/ThirdInnerModule/NodeType"))
        assert(lookupEnumeration == enumeration,"Looked up enumeration should be the same as the original enumeration and it is not")
        let newClass = ClassType(name: "NewClass")
        let identifier = Identifier(string: "//OuterModule/FirstInnerModule/SecondInnerModule/NewClass")
        secondInnerModule.addNode(newClass, atIdentifier: identifier)
        let lookupClass = secondInnerModule.lookupNode(atIdentifier: identifier)
        assert(lookupClass == newClass,"NewClass and Looked Up Class should be the same but are not")
        }
        
    private static func makeTestParseTree() -> Module
        {
        let rootModule = RootModule.newRootModule()
        let module = Module(name: "SomeModule")
        rootModule.addNode(module)
        let innerModule = Module(name: "WeatherType")
        //
        // Define cases for an enumeration
        //
        let freezing = EnumerationCase(name: "#freezing",associatedTypes: [],instanceValue: .none)
        let sunny = EnumerationCase(name: "#sunny",associatedTypes: [],instanceValue: .none)
        let rainy = EnumerationCase(name: "#rainy",associatedTypes: [],instanceValue: .none)
        let windy = EnumerationCase(name: "#windy",associatedTypes: [],instanceValue: .none)
        let cloudy = EnumerationCase(name: "#cloudy",associatedTypes: [],instanceValue: .none)
        //
        // Define an enumeration with cases
        //
        let enumeration = EnumerationType(name: "NodeType",cases: [freezing,sunny,rainy,windy,cloudy],rawType: ArgonModule.stringType)
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
        // Define cases for WeatherStationType
        //
        let manned = EnumerationCase(name: "#manned",associatedTypes: [],instanceValue: .none)
        let unmanned = EnumerationCase(name: "#unmanned",associatedTypes: [],instanceValue: .none)
        //
        // Define WeatherStationType enumeration
        //
        let weatherStationType = EnumerationType(name: "WeatherStationType",cases: [manned,unmanned],rawType: ArgonModule.integerType)
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
                LET thisValue = -> ,
                $someMacro(this is some text,this is even more text, and the last lot of text)
                LET someValue = MAKE(\\Module1\\Module2\\Module3\\AClass),
                ENUMERATION SomeEnum::Integer
                    {
                    #someCase = 1
                    }
                LET someByteValue = §127
                }
            """
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
        sourceFile.source = source
        let scanner = ArgonScanner(source: source,sourceKey: 0)
        let tokens = scanner.allTokens()
        for token in tokens
            {
            print(token.location,terminator: " ")
            print(token)
            }
        }
        
    public static func testProjectEntries()
        {
        let entry1 = SourceFileNode(name: "",path: Path(Path.root))
        let entry2 = SourceFileNode(name: "",path: Path(Path.root))
        let project = SourceProjectNode(name: "",path: Path(Path.root))
        let data = try? NSKeyedArchiver.archivedData(withRootObject: project, requiringSecureCoding: false)
        if data.isNil
            {
            fatalError("Encoding of project failed")
            }
        else
            {
            let newProject = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!)
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
//        RootModule.initializeModule()
//        RootModule.rootModule.dump(indent:"")
//        RootModule.rootModule.argonModule.dump(indent: "")
        }
    }
