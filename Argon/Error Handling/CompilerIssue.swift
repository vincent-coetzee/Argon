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
    
    case constantMustBeInitialised
    case classNameExpected
    case classExpectedButOtherSymbolFound
    case colonExpected
    case couldNotReadFile
    case couldNotWriteFile
    
    case fileDataIsCorrupt
    
    case invalidCharacterSequence
    case intoExpected
    case identifierExpected
    case invalidExpression
    case internalParameterNameExpected
    case initialModuleDeclarationNotFound
    case invalidFileType
    
    case lValueExpectedOnLeft
    case leftParenthesisExpected
    case leftBraceExpected
    
    case moduleEntryExpected
    case moduleExpected

    case none

    case rightParenthesisExpected
    case rightBraceExpected
    case rightBracketExpected
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
