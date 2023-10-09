//
//  KeywordToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/12/2022.
//

import Foundation

fileprivate let _Keywords = ["CLASS","CONSTANT","DEFORM","DYNAMIC","ELSE","ENTRY","ENUMERATION","EXIT",
                            "FALSE","FOR","FROM","FREE","FORM","FUNCTION","IF","IN","HANDLE","IMPORT",
                            "IS","KEY","LET","LOOP","MAKE","METHOD","MODULE","OTHERWISE","POOL","READ","REPEAT",
                            "RETURN","SECTION","SELECT","SLOT","SIGNAL","THEN","TIMES","TRUE","TYPE","USES",
                            "VIRTUAL","WHEN","WHILE","WITH","WRAPPER","WRITE"]
                            
public class KeywordToken: Token
    {
    public static func isSectionKeyword(_ string: String) -> Bool
        {
        string == "SECTION"
        }
        
    public override var styleElement: StyleElement
        {
        .colorKeyword
        }
        
    public override var isWhen: Bool
        {
        self.matchString == "WHEN"
        }
        
    public override var isKeyed: Bool
        {
        self.matchString == "KEYED"
        }
        
    public override var isKey: Bool
        {
        self.matchString == "KEY"
        }
        
    public override var isRead: Bool
        {
        self.matchString == "READ"
        }
        
    public override var isInteger: Bool
        {
        self.matchString == "Integer"
        }
        
    public override var isWrite: Bool
        {
        self.matchString == "WRITE"
        }
        
    public override var isSlot: Bool
        {
        self.matchString == "SLOT"
        }
        
    public override var isWith: Bool
        {
        self.matchString == "WITH"
        }
        
    public override var isFork: Bool
        {
        self.matchString == "FORK"
        }
        
    public override var isElse: Bool
        {
        self.matchString == "ELSE"
        }
        
    public override var isDynamic: Bool
        {
        self.matchString == "DYNAMIC"
        }
        
    public override var isWhile: Bool
        {
        self.matchString == "WHILE"
        }
        
    public override var isForm: Bool
        {
        self.matchString == "FORM"
        }
        
    public override var isDeform: Bool
        {
        self.matchString == "DEFORM"
        }
        
    public override var isDefault: Bool
        {
        self.matchString == "DEFAULT"
        }
        
    public override var isVirtual: Bool
        {
        self.matchString == "VIRTUAL"
        }
        
    public override var isTrue: Bool
        {
        self.matchString == "TRUE"
        }
        
    public override var isFalse: Bool
        {
        self.matchString == "FALSE"
        }
        
    public override var isBooleanValue: Bool
        {
        self.matchString == "TRUE" || self.matchString == "FALSE"
        }
        
    public override var isStatic: Bool
        {
        self.matchString == "STATIC"
        }
        
    public override var isSlotRelatedKeyword: Bool
        {
        self.matchString == "SLOT" || self.matchString == "READ" || self.matchString == "WRITE" || self.matchString == "DYNAMIC" || self.matchString == "VIRTUAL"
        }
        
    private static var keywords = Dictionary<String,String>()
    
    public override var tokenType: TokenType
        {
        switch(self.matchString)
            {
            case "STATIC":
                return(.STATIC)
            case "ENTRY":
                return(.ENTRY)
            case "EXIT":
                return(.EXIT)
            case "CLASS":
                return(.CLASS)
            case "CONSTANT":
                return(.CONSTANT)
            case "KEY":
                return(.KEY)
            case "DYNAMIC":
                return(.DYNAMIC)
            case "ELSE":
                return(.ELSE)
            case "ENUMERATION":
                return(.ENUMERATION)
            case "FOR":
                return(.FOR)
            case "FORK":
                return(.FORK)
            case "FROM":
                return(.FROM)
            case "FUNCTION":
                return(.FUNCTION)
            case "IF":
                return(.IF)
            case "LOOP":
                return(.LOOP)
            case "IN":
                return(.IN)
            case "IS":
                return(.IS)
            case "HANDLE":
                return(.HANDLE)
            case "IMPORT":
                return(.IMPORT)
            case "INTO":
                return(.INTO)
            case "LET":
                return(.LET)
            case "MAKE":
                return(.MAKE)
            case "METHOD":
                return(.METHOD)
            case "MODULE":
                return(.MODULE)
            case "OTHERWISE":
                return(.OTHERWISE)
            case "POOL":
                return(.POOL)
            case "READ":
                return(.READ)
            case "REPEAT":
                return(.REPEAT)
            case "RETURN":
                return(.RETURN)
            case "SELECT":
                return(.SELECT)
            case "SECTION":
                return(.SECTION)
            case "SLOT":
                return(.SLOT)
            case "SIGNAL":
                return(.SIGNAL)
            case "THEN":
                return(.THEN)
            case "TIMES":
                return(.TIMES)
            case "TYPE":
                return(.TYPE)
            case "USES":
                return(.USES)
            case "VIRTUAL":
                return(.VIRTUAL)
            case "WHEN":
                return(.WHEN)
            case "WHILE":
                return(.WHILE)
            case "WRAPPER":
                return(.WRAPPER)
            case "WRITE":
                return(.WRITE)
            case "TRUE":
                return(.literalBoolean)
            case "FALSE":
                return(.literalBoolean)
            default:
                fatalError()
            }
        }
        
    public override var isIs: Bool
        {
        self.matchString == "IS"
        }
        
    public override var tokenName: String
        {
        "KeywordToken"
        }
        
    public static func initKeywords()
        {
        for string in _Keywords
            {
            self.keywords[string] = string
            }
        }
        
    public override var isImport: Bool
        {
        self.matchString == "IMPORT"
        }
        
    public override var isKeyword: Bool
        {
        return(true)
        }
        
    public static func isKeyword(_ string: String) -> Bool
        {
        return(self.keywords[string].isNotNil)
        }
        
    public override var isModule: Bool
        {
        return(self.matchString == "MODULE")
        }
        
    public override var valueBox: ValueBox
        {
        switch(self.matchString)
            {
            case "FALSE":
                return(.boolean(false))
            case "TRUE":
                return(.boolean(true))
            default:
                fatalError("valueBox should not have been called on KeywordToken.")
            }
        }
    }
