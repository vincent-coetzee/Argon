//
//  LexicalItem.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation
import AppKit

public typealias Tokens = Array<Token>

public enum TokenType: Int
    {
    case andAssign
    case andAndAssign
    case assign
    
    case Boolean
    case Byte
    case booleanNot
    case booleanAnd
    case booleanOr
    case booleanAndAssign
    case booleanOrAssign
    case booleanNotAssign
    
    case Character
    case CLASS
    case colon
    case comment
    case CONSTANT
    case comma
    
    case DYNAMIC
    case decrement
    case divide
    case divideAssign
    
    case ELSE
    case ENUMERATION
    case end
    case ENTRY
    case error
    case equals
    case EXIT
    
    case Float
    case FOR
    case FORK
    case FROM
    case FUNCTION
    
    case greaterThan
    case greaterThanEquals
    
    case HANDLE
    
    case identifier
    case IF
    case IMPORT
    case integer
    case INTO
    case increment
    
    case keyword
    case KEY
    
    case lessThan
    case lessThanEquals
    case leftBrace
    case leftBracket
    case leftBrocket
    case leftParenthesis
    case LET
    case literalByte
    case literalBoolean
    case literalCharacter
    case literalDate
    case literalDateTime
    case literalFloat
    case literalInteger
    case literalString
    case literalSymbol
    case literalTime
    case literalEnumerationCase
    case LOOP
    case logicalEquals
    case logicalNot
    case logicalOr
    case logicalAnd
    case logicalXor
    case logicalAndAssign
    case logicalNotAssign
    case logicalOrAssign
    case logicalXorAssign
    
    case MACRO
    case MAKE
    case MADE
    case METHOD
    case MODULE
    case minus
    case minusAssign
    case modulus
    case modulusAssign
    
    case none
    case notAssign
    case notEquals
    
    case `operator`
    case OTHERWISE
    case orOrAssign
    case orAssign
    
    case path
    case percent
    case plus
    case plusAssign
    case power
    
    case rightArrow
    case rightBrace
    case rightBracket
    case rightBrocket
    case rightParenthesis
    case READ
    case REPEAT
    case RETURN
    
    case SELECT
    case separator
    case SLOT
    case SIGNAL
    case String
    case scope
    case shiftLeft
    case shiftRight
    case shiftLeftAssign
    case shiftRightAssign
    
    case text
    case ternary
    case THEN
    case TIMES
    case TYPE
    case times
    case timesAssign
    case timesTimes
    
    case USES
    case UNMADE
    
    case VIRTUAL
    
    case WHEN
    case WHILE
    case WRAPPER
    case WRITE
    }

public class Token: NSObject,NSCoding
    {
    public var precedence: Int
        {
        fatalError("Precedence called on Token")
        }
        
    public var pathValue: String
        {
        fatalError("This should not be called on Token")
        }
        
    public var range: NSRange
        {
        self.location.range
        }
        
    public var tokenType: TokenType
        {
        .none
        }
        
    public override var description: String
        {
        "\(self.tokenName): \(self.matchString)"
        }
        
    public var styleElement: StyleElement
        {
        fatalError()
        }
        
    public var isElse: Bool
        {
        false
        }
        
    public var isDefault: Bool
        {
        false
        }
        
    public var isRightArrow: Bool
        {
        false
        }
        
    public var isFork: Bool
        {
        false
        }
        
    public var isLeftParenthesis: Bool
        {
        false
        }
        
    public var isMade: Bool
        {
        false
        }
        
    public var isUnmade: Bool
        {
        false
        }
        
    public var tokenName: String
        {
        "Token"
        }
        
    public var isMinus: Bool
        {
        false
        }
        
    public var isLeftBrocket: Bool
        {
        false
        }
        
    public var isRightBrocket: Bool
        {
        false
        }
        
    public var isRead: Bool
        {
        false
        }
        
    public var isInto: Bool
        {
        false
        }
        
    public var isWhile: Bool
        {
        false
        }
        
    public var isRangeOperator: Bool
        {
        false
        }
        
    public var isInteger: Bool
        {
        false
        }
        
    public var integerValue: Argon.Integer
        {
        fatalError()
        }
        
    public var isIntegerValue: Bool
        {
        false
        }
        
    public var isWrite: Bool
        {
        false
        }
        
    public var isWhen: Bool
        {
        false
        }
        
    public var isSlot: Bool
        {
        false
        }
        
    public var isDynamic: Bool
        {
        false
        }
        
    public var isVirtual: Bool
        {
        false
        }
        
    public var isSymbolValue: Bool
        {
        false
        }
        
    public var isOperand: Bool
        {
        false
        }
        
    public var isSlotRelatedKeyword: Bool
        {
        false
        }
        
    public var isEnd: Bool
        {
        false
        }
        
    public var isColon: Bool
        {
        false
        }
        
    public var isRightBracket: Bool
        {
        false
        }
        
    public var isOperator: Bool
        {
        false
        }
        
    public var isPathValue: Bool
        {
        false
        }
        
    public var isKeyed: Bool
        {
        false
        }
        
    public var isKey: Bool
        {
        false
        }
        
    public var dateTimeValue: Argon.DateTime
        {
        fatalError("This should have been invoked on Token")
        }
        
    public var timeValue: Argon.Time
        {
        fatalError("This should have been invoked on Token")
        }
        
    public var symbolValue: Argon.Symbol
        {
        fatalError("This should not have been invoked on Token")
        }
        
    public var valueBox: ValueBox
        {
        fatalError("valueBox called on Token and should not be.")
        }
        
    public var dateValue: Argon.Date
        {
        fatalError("dateValue called on Token and should not be")
        }
        
    public var isExpressionRelatedToken: Bool
        {
        false
        }
        
    public let location: Location
    public var matchString: String = ""
    public var issues = CompilerIssues()
    
    public required init(coder: NSCoder)
        {
        self.location = coder.decodeLocation(forKey: "location")
        self.matchString = coder.decodeObject(forKey: "matchString") as! String
        self.issues = coder.decodeObject(forKey: "issues") as! CompilerIssues
        super.init()
        }
        
    init(location: Location)
        {
        self.location = location
        }
        
    required init(location: Location,string: String)
        {
        self.location = location
        self.matchString = string
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.location,forKey: "location")
        coder.encode(self.matchString,forKey: "matchString")
        coder.encode(self.issues,forKey: "issues")
        }
        
    public var isRightParenthesis: Bool
        {
        false
        }
        
    public var isLeftBrace: Bool
        {
        return(false)
        }
        
    public var isLeftBracket: Bool
        {
        return(false)
        }
        
    public var isRightBrace: Bool
        {
        return(false)
        }
        
    public var isModule: Bool
        {
        return(false)
        }
        
    public var isIdentifier: Bool
        {
        return(false)
        }
        
    public var isImport: Bool
        {
        false
        }
        
    public var isScope: Bool
        {
        false
        }
        
    public var isAssign: Bool
        {
        false
        }
        
    public var isEquals: Bool
        {
        false
        }
        
    public var isComma: Bool
        {
        false
        }
        
    public var isStringValue: Bool
        {
        false
        }
        
    public var isInstanceOfEnumerationBase: Bool
        {
        self.isSymbolValue || self.isStringValue || self.isIntegerValue
        }
        
    public var isKeyword: Bool
        {
        return(false)
        }
        
    public var identifier: Identifier
        {
        fatalError("Should not be called on this type of token.")
        }
    }
