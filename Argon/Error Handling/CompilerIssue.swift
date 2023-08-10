//
//  CompilerError.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/12/2022.
//

import Foundation

public enum ErrorCode: Int
    {
    case assignExpected
    case argumentNameExpected
    
    case constantMustBeInitialised
    case classNameExpected
    case classExpectedButOtherSymbolFound
    case colonExpected
    case commaExpected
    case couldNotReadFile
    case couldNotWriteFile
    
    case discreteTypeExpected
    
    case enumerationCaseExpected
    
    case fileDataIsCorrupt
    
    case invalidCharacterSequence
    case intoExpected
    case identifierExpected
    case identifierAlreadyDefined
    case invalidExpression
    case instanceOfEnumerationBaseExpected
    case integerExpected
    case integerValueExpected
    case internalParameterNameExpected
    case initialModuleDeclarationNotFound
    case invalidFileType
    case invalidLowerBound
    case invalidEnumerationCase
    case invalidTypeVariables
    case invalidGenericArguments
    case isExpected
    
    case lValueExpectedOnLeft
    case leftParenthesisExpected
    case leftBraceExpected
    case leftBrocketExpected
    case leftBracketExpected
    
    case moduleEntryExpected
    case moduleExpected
    case moduleNameExpected
    case mustInheritFromEnumerationBase
    
    case none

    case pathExpected
    
    case rangeOperatorExpected
    case returnExpectedInReadBlock
    case rightParenthesisExpected
    case rightBraceExpected
    case rightBracketExpected
    case rightBrocketExpected
    case readBlockExpectedForVirtualSlot
    case readOrWriteExpected
    
    case scopeOperatorExpected
    case singleIdentifierExpected
    case slotExpectedAfterRead
    case superclassIdentifierExpected
    case superclassExpected
    case symbolExpected
    case nodeAlreadyDefined
    
    case typeOrAssignmentExpected

    case undefinedSymbol
    case undefinedType
    case undefinedClass
    case unmadeAlreadyDefined
    case usingGenericTypesOnNonGenericType
    
    case vitualSlotMustSpecifyType
    case virtualSlotNotAllowedInitialExpression
    
    case whenExpected
    case whileExpectedAfterRepeatBlock
    case writeBlockExpectedForVirtualSlot
    }
    
public class CompilerIssue: NSObject,NSCoding,Error
    {
    public let code: ErrorCode
    public let message: String?
    public var location: Location
    
    public var isFatalError: Bool
        {
        false
        }
        
    public var isWarning: Bool
        {
        false
        }
        
    public var isError: Bool
        {
        return(false)
        }
        
    public init(code: ErrorCode,message: String?,location: Location = .zero)
        {
        self.code = code
        self.message = message
        self.location = location
        }
        
    public required init(coder: NSCoder)
        {
        self.code = ErrorCode(rawValue: coder.decodeInteger(forKey: "code"))!
        self.message = coder.decodeObject(forKey: "message") as? String
        self.location = coder.decodeLocation(forKey: "location")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.code.rawValue,forKey: "code")
        coder.encode(self.message,forKey: "message")
        coder.encode(self.location,forKey: "location")
        }
    }
