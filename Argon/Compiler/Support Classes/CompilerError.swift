//
//  CompilerError.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class CompilerError:Error,Equatable
    {
    public static func ==(lhs:CompilerError,rhs:CompilerError) -> Bool
        {
        return(lhs.code == rhs.code && lhs.location == rhs.location)
        }
        
    let code:SystemError
    let location:SourceLocation
    var hint:String = ""
    
    init(error:SystemError,location:SourceLocation,hint:String)
        {
        self.code = error
        self.location = location
        self.hint = hint
        }
        
    init(_ error:SystemError,_ location:SourceLocation)
        {
        self.code = error
        self.location = location
        }
    }
    
public enum SystemError:Equatable,Error
    {
    case unknownError
    case invalidCharacter(Swift.Character)
    case invalidSymbolCharacter(Swift.Character)
    case packageNameExpected
    case leftBraceExpected
    case rightBraceExpected
    case leftParExpected
    case rightParExpected
    case leftBrocketExpected
    case rightBrocketExpected
    case leftBracketExpected
    case rightBracketExpected
    case packageLevelKeywordExpected
    case packageDeclarationExpected
    case genericTypeNameExpected
    case gluonExpected
    case classReferenceExpected
    case classNameExpected
    case integerNumberExpected
    case duplicateClassDefinition(String)
    case slotExpected
    case slotNameExpected
    case virtualSlotMustDefineReadBlock(String)
    case newValueNameExpected
    case assignExpected
    case slotRequiresInitialValueOrTypeClass
    case virtualSlotReaderMustReturnValue
    case enumerationNameExpected
    case stopPrefixExpectedOnEnumerationCaseName
    case enumerationCaseNameExpected
    case referenceComponentExpected
    case expressionExpected
    case undefinedValue(String)
    case tagExpectedInTupleDeclaration
    case tagExpectedInClosureWithClause
    case tagExpectedBeforeParameterArgument
    case identifierExpected
    case rightBracketExpectedAfterSubscript
    case variableMustContainExecutable
    case enumerationCaseExpected
    case nameComponentExpected
    case enumerationExpected
    case commaExpected
    case typeExpected
    case isExpected
    case aliasNameExpected
    case literalValueExpected
    case dictionaryExpected
    case listExpected
    case setExpected
    case methodNameExpected
    case multiMethodNeedsDefinitionBeforeInstance(String)
    case hashStringExpected
    case usingExpected
    case signalParameterNameExpected
    case inductionVariableNameExpected
    case inExpected
    case whileExpectedAtEndOfDoStatement
    case variableNameExpected
    case variableRequiresInitialValueOrTypeClass
    case tagExpectedInParameter
    case typeNameExpected
    case slotKeywordExpected
    case readOnlySlotRequiresInitialValue
    case couldNotLoadSource(String)
    case slotReadOnlyConflictsWithVirtual
    case internalInconsistencyError
    case directoryDoesNotExist(String)
    case resolveElementCountMustBeEven
    case virtualSlotCanNotHaveInitialValue
    case readExpected
    case writeExpected
    case symbolNotFound(String)
    case moduleExpected
    case moduleElementDeclarationExpected
    case keywordExpected
    case notImplemented(String)
    case doubleLeftBraceExpected
    case fromExpected
    case toExpected
    case byExpected
    case colonExpected
    case whileExpected
    case macroTextExpected
    case classLiteralExpected
    case stringLiteralOrVariableExpected
    case dateComponentSeparatorExpected
    case timeComponentSeparatorExpected
    case dateOrTimeExpressionExpected
    case typeCanNotBeReduced(Type)
    case fullOrHalfRangeExpected
    case tagExpected
    case classElementExpected
    case valueElementExpected
    case nameCanNotBeFound(Name)
    case rightArrowExpected
    case properFunctionNameExpected
    case typeMismatch(Type,Type)
    case canNotCastPointerToClass(Class)
    case invalidExpression
    case invalidTermInExpression
    case invalidArrayIndexType(String)
    case invalidSlotFieldHashIndex
    case selectRequiresAtLeastOneWhenClause
    case writeFailedWithLessBytesWritten(Int,Int,Int32)
    case readFailedWithLessBytesWritten(Int,Int,Int32)
    case fileErrorOnOpenFile(String,Int32)
    case fileErrorOnCloseFile(String,Int32)
    case readFailedWithLessBytesRead(Int,Int,Int32)
    case readIncomingObjectDidNotMatchExpectedObject(String)
    case objectIdentityErrorObjectWithIdNotFound
    case objectKindNotKnown
    case plusOrIntegerLiteralExpectedInBitSetField
    case makerForBitSetShouldHaveBeenAutoDeclared
    case typeSpecializationExpected
    }
