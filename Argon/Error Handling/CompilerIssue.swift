//
//  CompilerError.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/12/2022.
//

import Foundation

public enum IssueCode: String
    {
    public var message: String
        {
        self.rawValue
        }
        
    case assignExpected                                             = "'=' expected."
    case argumentNameExpected                                       = "argument name expected."
    case atomExpected                                               = "atom expected."
    
    case constantMustBeInitialised                                  = "a constant must be initialised."
    case classNameExpected                                          = "class name expected."
    case classExpectedButOtherSymbolFound                           = "class expected but other symbol encountered."
    case colonExpected                                              = "':' expected."
    case commaExpected                                              = "',' expected."
    case couldNotReadFile                                           = "could not read file."
    case couldNotWriteFile                                          = "could not write file."
    
    case discreteClassExpected                                      = "discrete class expected."
    case deformAlreadyDefined                                       = "'DEFORM' already defined."
    
    case enumerationCaseExpected                                    = "enumeration case expected."
    
    case fileDataIsCorrupt                                          = "file data is corrupt."
    
    case invalidCharacterSequence                                   = "invalid character sequence."
    case intoExpected                                               = "'INTO' expected."
    case identifierExpected                                         = "identifier expected."
    case identifierAlreadyDefined                                   = "identifier already defined."
    case invalidExpression                                          = "invalid expression."
    case instanceOfDiscreteTypeExpected                             = "instance of DiscreteType expected."
    case integerExpected                                            = "Integer expected."
    case integerValueExpected                                       = "integer value expected."
    case inExpected                                                 = "'IN' expected."
    case internalParameterNameExpected                              = "internal parameter name expected."
    case initialModuleDeclarationNotFound                           = "initial module definition not found."
    case invalidFileType                                            = "invalid file type."
    case invalidLowerBound                                          = "invalid lower bound."
    case invalidEnumerationCase                                     = "invalid enumeration case."
    case invalidGenericArguments                                    = "invalid generic arguments."
    case invalidAssignmentExpression                                = "invalid assignment expression."
    case isExpected                                                 = "'IS' expected."
    case integerUpperBoundExpectedAfterIntegerLowerBound            = "integer upper bound expected after integer lower bound."
    case identifierUpperBoundExpectedAfterIdentifierLowerBound      = "identifier upper bound expected after identifier lower bound."
    case integerOrIdentifierExpected                                = "integer or identifier expected."
    
    case lValueExpectedOnLeft                                       = "lvalue expected on left."
    case leftParenthesisExpected                                    = "'(' expected."
    case leftBraceExpected                                          = "'{' expected."
    case leftBrocketExpected                                        = "'<' expected."
    case leftBracketExpected                                        = "'[' expected."
    
    case moduleEntryExpected                                        = "module entry expected."
    case moduleExpected                                             = "'MODULE' expected."
    case moduleNameExpected                                         = "module name expected."
    case mustInheritFromDiscreteType                                = "must inherit from DiscreteType."
    case multipleMainMethodsFound                                   = "multiple 'main' methods found."
    case methodWithDuplicateSignature                               = "Duplicate methods with same signature"
    
    case none                                                       = "none"
    case nodeAlreadyDefined                                         = "node already defined."
                
    case pathExpected                                               = "path expected."
    case primitiveTypeNotAGenericType                               = "A primitive type can not be used as a generic type."
    
    case rangeOperatorExpected                                      = "'..' expected."
    case returnExpectedInReadBlock                                  = "'RETURN' expected in READ block."
    case rightParenthesisExpected                                   = "')' expected."
    case rightBraceExpected                                         = "'}' expected."
    case rightBracketExpected                                       = "']' expected."
    case rightBrocketExpected                                       = "'>' expected."
    case readBlockExpectedForVirtualSlot                            = "'READ' block expected for virtual slot."
    case readOrWriteExpected                                        = "'READ' or 'WRITE' expected."
    
    case scopeOperatorExpected                                      = "'::' expected."
    case singleIdentifierExpected                                   = "single word identifier expected."
    case slotExpectedAfterRead                                      = "'SLOT' expected after READ keyword."
    case superclassIdentifierExpected                               = "superclass identifier expected."
    case superclassExpected                                         = "superclass expected."
    case statementExpected                                          = "statement expected."
    case semicolonExpected                                          = "';' expected."
    
    case textExpectedInSection                                      = "Text expected in section."
    case typeVariableGenericMismatch                                = "Type variable / generic mismatch."
    case typeParameterMismatch                                      = "Type parameter mismatch."
    case typeUndefined                                              = "Type is undefined."
    
    case undefinedSymbol                                            = "undefined symbol."
    case undefinedClass                                             = "undefined class."
    case usingGenericClassesOnNonGenericClass                       = "generic classes used on non generic class."
    
    case vitualSlotMustSpecifyType                                  = "virtual slot must specify type."
    case virtualSlotNotAllowedInitialExpression                     = "virtual slot not allowed initial value."
    
    case whenExpected                                               = "'WHEN' expected."
    case whileExpectedAfterRepeatBlock                              = "'WHILE' expected after 'REPEAT' block."
    case writeBlockExpectedForVirtualSlot                           = "'WRITE' block expected for virtual slot."
    }
    
public class CompilerIssue: NSObject,NSCoding,Error,NSCopying
    {
    public var message: String
        {
        self._message.isNil ? self.code.message : self._message!
        }
        
    public let code: IssueCode
    private let _message: String?
    public var location: Location
        
    public var isWarning: Bool
        {
        false
        }
        
    public var isError: Bool
        {
        return(false)
        }
        
    public init(code: IssueCode,message: String?,location: Location = .zero)
        {
        self.code = code
        self._message = message
        self.location = location
        }
        
    public required init(coder: NSCoder)
        {
        self.code = IssueCode(rawValue: coder.decodeObject(forKey: "code") as! String)!
        self._message = coder.decodeObject(forKey: "message") as? String
        self.location = coder.decodeLocation(forKey: "location")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.code.rawValue,forKey: "code")
        coder.encode(self._message,forKey: "message")
        coder.encode(self.location,forKey: "location")
        }
        
    public func copy(with zone: NSZone? = nil) -> Any
        {
        CompilerIssue(code: self.code,message: self.message,location: self.location)
        }
    }

public class CompilerWarning: CompilerIssue
    {
    public override var isWarning: Bool
        {
        true
        }
    }
    
public class CompilerError: CompilerIssue
    {
    public override var isError: Bool
        {
        true
        }
    }

public typealias CompilerIssues = Array<CompilerIssue>
