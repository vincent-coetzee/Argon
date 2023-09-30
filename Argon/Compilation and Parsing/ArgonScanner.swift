//
//  ArgonTokenStream.swift
//  Argon
//
//  Created by Vincent Coetzee on 25/08/2023.
//

import Foundation

public class ArgonScanner
    {
    public var atEnd: Bool
        {
        self.offset >= self.sourceCharacterCount
        }

    private let source:String
    private var offset = 0
    private var startOffset = 0
    private var sourceCharacterCount: Int
    private var sourceIndex: String.Index
    private var sourceLine: Int = 1
    private let operatorCharacters = CharacterSet(charactersIn: "!$%^&*-+=:;|<>?/.,~@")
    private let brackets = CharacterSet(charactersIn: "()[]{}")
    private let decimalCharacters = CharacterSet(charactersIn: "0123456789_")
    private let binaryCharacters = CharacterSet(charactersIn: "01_")
    private let octalCharacters = CharacterSet(charactersIn: "01234567_")
    private let hexadecimalCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef_")
    private let identifierStartCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: "\\"))
    private let identifierCharacters = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet(charactersIn: "\\_"))
    private let identifierEndCharacters = CharacterSet(charactersIn: "!?")
    private let symbolCharacters = CharacterSet.letters.union(.decimalDigits).union(CharacterSet(charactersIn: "-_"))
    private let pathCharacters = CharacterSet.letters.union(.decimalDigits).union(CharacterSet(charactersIn: "-_/~"))
    private let identifier1Pattern = try! NSRegularExpression(pattern: "[a-zA-Z]{1}[a-zA-Z0-9_]*[\\?!]?")
    private let identifier2Pattern = try! NSRegularExpression(pattern: "(/[a-zA-Z]{1}[a-zA-Z0-9_]*)+[\\?!]?")
    private let identifier3Pattern = try! NSRegularExpression(pattern: "//[a-zA-Z]{1}[a-zA-Z0-9_]*(/[a-zA-Z]{1}[a-zA-Z0-9_]*)*[\\?!]?")
    public var currentCharacter = Unicode.Scalar(0)!
    public let bracketMatcher = BracketMatcher()
    
    public init(source: String)
        {
        self.source = source
        self.sourceIndex = self.source.startIndex
        self.sourceCharacterCount = self.source.count
        self.nextCharacter()
        }

    public func sourcePrefix(length: Int) -> String
        {
        let beginIndex = self.source.index(before: self.sourceIndex)
        let endIndex = self.source.index(beginIndex,offsetBy: length)
        return(String(self.source[beginIndex..<endIndex]))
        }

    @discardableResult
    public func nextDirtyCharacter() -> Unicode.Scalar
        {
        if self.offset >= self.sourceCharacterCount
            {
            self.currentCharacter = Unicode.Scalar(0)
            return(self.currentCharacter)
            }
        self.currentCharacter = self.source.unicodeScalars[self.sourceIndex]
        self.offset += 1
        self.sourceIndex = self.source.index(after: self.sourceIndex)
        if self.currentCharacter.isNewLine
            {
            self.sourceLine += 1
            }
        return(self.currentCharacter)
        }
        
    @discardableResult
    public func nextCharacter() -> Unicode.Scalar
        {
        if self.offset >= self.sourceCharacterCount
            {
            self.currentCharacter = Unicode.Scalar(0)
            return(self.currentCharacter)
            }
        self.currentCharacter = self.source.unicodeScalars[self.sourceIndex]
        self.offset += 1
        self.sourceIndex = self.source.index(after: self.sourceIndex)
        if self.currentCharacter.isNewLine
            {
            self.sourceLine += 1
            return(self.nextCharacter())
            }
        return(self.currentCharacter)
        }

    public func scanUntilEndOfLine() -> String
        {
        self.nextDirtyCharacter()
        self.nextDirtyCharacter()
        var string = ";;"
        while self.currentCharacter.isNotNewLine && self.currentCharacter.isNotEOF
            {
            string += String(self.currentCharacter)
            self.nextDirtyCharacter()
            }
        if self.currentCharacter.isNewLine
            {
            self.nextCharacter()
            }
        return(string)
        }
        
    public func scanUntilRightParenthesis() -> String
        {
        self.nextDirtyCharacter()
        var string = ""
        while self.currentCharacter.isNotNewLine && self.currentCharacter.isNotEOF && self.currentCharacter != ")"
            {
            string += String(self.currentCharacter)
            self.nextDirtyCharacter()
            }
        if self.currentCharacter.isNewLine
            {
            self.nextCharacter()
            }
        return(string)
        }
        
    public func scanUntilEndOfMultilineComment() -> String
        {
        self.nextDirtyCharacter()
        self.nextDirtyCharacter()
        var string = "/*"
        while self.sourcePrefix(length: 2) != "*/" && self.currentCharacter.isNotEOF
            {
            string += String(self.currentCharacter)
            self.nextDirtyCharacter()
            }
        string.append("*/")
        self.nextCharacter()
        self.nextCharacter()
        return(string)
        }
        
    public func allTokens() -> Tokens
        {
        var tokens = Tokens()
        while self.currentCharacter.isNotEOF && !self.atEnd
            {
            let someTokens = self.scanTokens()
            tokens.append(contentsOf: someTokens)
            for token in someTokens
                {
                bracketMatcher.processToken(token)
                print(token)
                }
            }
        return(tokens)
        }
    
    private func scanTokens() -> Tokens
        {
        if self.atEnd
            {
            return([EndToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: "")])
            }
        self.startOffset = self.offset - 1
        if CharacterSet.whitespacesAndNewlines.contains(self.currentCharacter)
            {
            self.scanWhitespace()
            return(self.scanTokens())
            }
        let prefix = self.sourcePrefix(length: 2)
        if prefix == "@("
            {
            return(self.scanDateOrTime())
            }
        else if prefix == ";;"
            {
            return(self.scanComment())
            }
        else if self.brackets.contains(self.currentCharacter)
            {
            return(self.scanBracket())
            }
        else if CharacterSet.decimalDigits.contains(self.currentCharacter)
            {
            return(self.scanNumber())
            }
        else if self.currentCharacter == Unicode.Scalar("\"")
            {
            return(self.scanString())
            }
        else if self.currentCharacter == Unicode.Scalar("#")
            {
            return(self.scanAtom())
            }
        else if self.operatorCharacters.contains(self.currentCharacter)
            {
            return(self.scanOperator())
            }
        else if self.identifierStartCharacters.contains(self.currentCharacter)
            {
            return(self.scanIdentifier())
            }
        let character = self.currentCharacter
        self.nextCharacter()
        return([ErrorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: "Unknown character '\(character)'")])
        }
        
    private func scanDateOrTime() -> Tokens
        {
        self.nextCharacter()
        self.nextCharacter()
        var string = String()
        while self.currentCharacter != ")" && self.currentCharacter.isNotEOF
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        if self.currentCharacter == ")"
            {
            self.nextCharacter()
            }
        return([CalendricalToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanBracket() -> Tokens
        {
        let character = self.currentCharacter
        self.nextCharacter()
        return([OperatorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + 1), string: String(character))])
        }
        
    private func scanIdentifier() -> Tokens
        {
        var string = String(self.currentCharacter)
        self.nextCharacter()
        while self.identifierCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        if self.identifierEndCharacters.contains(self.currentCharacter)
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        let location = Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count)
        if KeywordToken.isKeyword(string)
            {
            return([KeywordToken(location: location,string: string)])
            }
        return([IdentifierToken(location: location, string: string)])
        }
        
    private func scanOperator() -> Tokens
        {
        var string = String()
        while self.operatorCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        return([OperatorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanAtom() -> Tokens
        {
        self.nextCharacter()
        var string = "#"
        while self.symbolCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        return([AtomToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanString() -> Tokens
        {
        self.nextCharacter()
        var string = ""
        while self.currentCharacter != Unicode.Scalar("\"") && self.currentCharacter.isNotEOF
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        if self.currentCharacter == Unicode.Scalar("\"")
            {
            self.nextCharacter()
            }
        return([StringToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanNumber() -> Tokens
        {
        if self.currentCharacter == Unicode.Scalar("0")
            {
            self.nextCharacter()
            if self.currentCharacter == Unicode.Scalar("B")
                {
                self.nextCharacter()
                return(self.scanBinaryNumber())
                }
            else if self.currentCharacter == Unicode.Scalar("O")
                {
                self.nextCharacter()
                return(self.scanOctalNumber())
                }
            else if self.currentCharacter == Unicode.Scalar("X")
                {
                self.nextCharacter()
                return(self.scanHexadecimalNumber())
                }
            }
        return(self.scanDecimalNumber())
        }

    private func scanBinaryNumber() -> Tokens
        {
        var string = String()
        while self.binaryCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            if self.currentCharacter != Unicode.Scalar("_")
                {
                string.append(String(self.currentCharacter))
                }
            self.nextCharacter()
            }
        if let integer = Int(string,radix: 2)
            {
            let number = "\(integer)"
            return([IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: number)])
            }
        return([ErrorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count), code: .invalidBinaryNumber, message: "The binary number can not be represented by an Argon Integer.")])
        }
        
    private func scanOctalNumber() -> Tokens
        {
        var string = String()
        while self.octalCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            if self.currentCharacter != Unicode.Scalar("_")
                {
                string.append(String(self.currentCharacter))
                }
            self.nextCharacter()
            }
        if let integer = Int(string,radix: 8)
            {
            let number = "\(integer)"
            return([IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: number)])
            }
        return([ErrorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count), code: .invalidOctalNumber, message: "The octal number can not be represented by an Argon Integer.")])
        }
        
    private func scanHexadecimalNumber() -> Tokens
        {
        var string = String()
        while self.hexadecimalCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            if self.currentCharacter != Unicode.Scalar("_")
                {
                string.append(String(self.currentCharacter))
                }
            self.nextCharacter()
            }
        if let integer = Int(string,radix: 16)
            {
            let number = "\(integer)"
            return([IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: number)])
            }
        return([ErrorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count), code: .invalidHexadecimalNumber, message: "The hexadecimal number can not be represented by an Argon Integer.")])
        }
        
    private func scanDecimalNumber() -> Tokens
        {
        var string = String()
        while self.decimalCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            if self.currentCharacter != Unicode.Scalar("_")
                {
                string.append(String(self.currentCharacter))
                }
            self.nextCharacter()
            }
        if self.sourcePrefix(length: 2) == ".."
            {
            return([IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
            }
        if self.currentCharacter == Unicode.Scalar(".")
            {
            string.append(".")
            self.nextCharacter()
            while self.decimalCharacters.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
                {
                if self.currentCharacter != Unicode.Scalar("_")
                    {
                    string.append(String(self.currentCharacter))
                    }
                self.nextCharacter()
                }
            return([FloatToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
            }
        return([IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanComment() -> Tokens
        {
        return(self.scanSinglelineComment())
        }
        
    private func scanMultilineComment() -> Tokens
        {
        let string = self.scanUntilEndOfMultilineComment()
        return([CommentToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanSinglelineComment() -> Tokens
        {
        let string = self.scanUntilEndOfLine()
        return([CommentToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.startOffset + string.count),string: string)])
        }
        
    private func scanWhitespace()
        {
        while CharacterSet.whitespacesAndNewlines.contains(self.currentCharacter) && self.currentCharacter.isNotEOF
            {
            self.nextCharacter()
            }
        }
    }
